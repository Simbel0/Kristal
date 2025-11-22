---@class FountainShadowFX : ShadowFX
---@overload fun(...) : FountainShadowFX
local MaskedChurchShadowFX, super = Class(ShadowFX)

function MaskedChurchShadowFX:init(priority)
    super.init(self, 0, nil, 0, priority)
end

function MaskedChurchShadowFX:draw(texture)
    local alpha = self:getAlpha()
	
    local sx, sy = self.parent:getFullScale()

    Draw.setColor(1, 1, 1)
    Draw.draw(texture)

    local ox, oy, ow, oh = self:getObjectBounds()

    Draw.setColor(0, 0, 0, alpha)
    local mask = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	local transformed = false
	for index, value in ipairs(Game.world.stage:getObjects(Object)) do
		if value.mask_shadow and self.parent.y < value.y then
			if not transformed then
				love.graphics.applyTransform(value.parent:getFullTransform())
				transformed = true
			end
			value:fullDraw(not self.draw_children)
		end
    end
    Draw.popCanvas()
    Draw.setColor(1, 1, 1, 1)
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
        Draw.draw(mask)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
	
    love.graphics.setStencilTest('less', 1)
    Draw.setColor(0, 0, 0, alpha)
    Draw.draw(texture, ox, oy+oh + (self.shadow_offset * sy), 0, 1, -self:getScale(), ox, oy+oh)
    love.graphics.setStencilTest()
end

return MaskedChurchShadowFX