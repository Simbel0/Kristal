---@class ChaserEnemy : ChaserEnemy
local Camera, super = HookSystem.hookScript(Camera)

function Camera:init(parent, x, y, width, height, keep_in_bounds)
    self.parent = parent

    self.x = x or 0
    self.y = y or 0
    self.width = width or SCREEN_WIDTH
    self.height = height or SCREEN_HEIGHT

    self.state_manager = StateManager("ATTACHED", self, true)
    self.state_manager:addState("STATIC")
    self.state_manager:addState("ATTACHED", {enter = self.beginAttached, update = self.updateAttached, leave = self.endAttached})
    self.state_manager:addState("PAN", {update = self.updatePanning})

    -- Camera modifiers (position, offset, bounds - smoothly transitioned between)
    self.mods = {
        x =      {value = 0,   state = "INACTIVE", x = true,  y = false},
        y =      {value = 0,   state = "INACTIVE", x = false, y = true },
        ox =     {value = 0,   state = "INACTIVE", x = true,  y = false},
        oy =     {value = 0,   state = "INACTIVE", x = false, y = true },
        bounds = {value = nil, state = "INACTIVE", x = true,  y = true }
    }
    -- Order camera modifiers are processed in
    self.mod_order = {"x", "y", "ox", "oy", "bounds"}
    -- Whether modifiers have been updated this frame
    self.updated_mods = false

    -- Default modifier approach speed and time
    self.default_approach_speed = 16
    self.default_approach_time = 0.25
    -- Current modifier approach settings
    self.lerper = {
        type = "speed",
        speed = self.default_approach_speed,
        time = self.default_approach_time,
        timer = 0, start_x = nil, start_y = nil
    }

    -- Camera target
    self.target = nil
    -- Optional function to get the camera target, if not set explicitly
    self.target_getter = nil

    -- Whether the camera is attached to the target
    self.attached_x = true
    self.attached_y = true

    -- Camera offset
    self.ox = 0
    self.oy = 0

    -- Camera zoom
    self.zoom_x = 1
    self.zoom_y = 1

    -- Camera rotation
    self.rotation = 0

    -- Camera shake
    self.shake_x = 0
    self.shake_y = 0
    -- Camera shake friction (How much the shake decreases)
    self.shake_friction = 0
    -- Camera shake timer (used to invert the shake)
    self.shake_timer = 0

    -- Camera bounds (for clamping)
    self.bounds = nil
    -- Whether the camera should stay in bounds
    self.keep_in_bounds = keep_in_bounds ~= false

    -- Camera pan target (for automatic panning)
    self.pan_target = nil

	self.nudge_x = 0
	self.nudge_y = 0
	
    -- Update position
    self:keepInBounds()
end

---@param ox number
---@param oy number
function Camera:setNudge(nx, ny)
    self.nudge_x = nx
    self.nudge_y = ny
end

---@return number x, number y
function Camera:getTargetPosition()
    local x, y = self.x + self.nudge_x, self.y + self.nudge_y

    local target = self:getTarget()
    if target and target:isCameraAttachable() then
        local ox, oy = target:getCameraOriginExact()
        x, y = target:getRelativePos(ox, oy, self.parent)
		x = x + self.nudge_x
		y = y + self.nudge_y
    end

    local min_x, min_y = self:getMinPosition()
    local max_x, max_y = self:getMaxPosition()

    x = Utils.clamp(x, min_x, max_x)
    y = Utils.clamp(y, min_y, max_y)

    return x, y
end

return Camera