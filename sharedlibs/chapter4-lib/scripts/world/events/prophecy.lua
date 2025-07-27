---@class Event.prophecy : Event
local event, super = Class(Event, "prophecy")

function event:init(data)
    super.init(self, data)
    self.container = Object(self.width/2,0)
    self:addChild(self.container)
    local properties = data and data.properties or {}
    if properties.texture then
        self:setSprite(properties.texture)
    end
    if properties.alwaysvisible then
        self.afx = self:addFX(AlphaFX(0))
    end
    if properties.text then
        self:setText(properties.text)
    end
    self.text_offset_x = properties.toff_x or 0
    self.text_offset_y = properties.toff_y or 0
end

function event:getSortPosition()
    return self.x,self.y
end

function event:setSprite(texture)
    if self.sprite then self.sprite:remove() end
    if not texture then return end
    self.sprite = Sprite(texture)
    self.sprite:setOrigin(0.5,1)
    self.container:addChild(self.sprite)
    self.sprite:setScale(2)
    self.sprite:addFX(ProphecyScrollFX())
    self.sprite:addFX(ProphecyEchoFX())
end

function event:setText(text)
    if self.text then self.text:remove() end
    if not text then return end
    self.text = Text(nil, self.text_offset_x, -self.height, {auto_size = true})
    self.text.font = "legend"
    self.text.font_size = 32
    self.text:setText(text)
    self.text.align = "right"
    self.text:setOrigin(0.5, 1)

    self.text:addFX(ProphecyScrollFX())
    self.container:addChild(self.text)
end

function event:getRealWidth()
    local width = 0

    if self.sprite then
        width = width + self.sprite:getScaledWidth()
    end

    if self.text then
        local text_w, _ = self.text:getScaledSize()

        width = width + text_w + self.text_offset_x
    end

    return width
end

function event:getRealHeight()
    local height = 0

    if self.sprite then
        height = height + self.sprite:getScaledHeight()
    end

    if self.text then
        local _, text_h = self.text:getScaledSize()

        height = height + text_h + self.text_offset_y
    end

    return height
end

function event:breakProphecy()
    local sprites = Assets.getFrames("prophecy/prophecy_shatter")
    if #sprites == 0 then return end

    local delaytime = 30/30

    local broken_container = Object(self.x-199, self.y-self:getRealHeight())
    broken_container:setScaleOrigin(0.5, 0.5)
    broken_container:setLayer(self:getLayer())
    self.parent:addChild(broken_container)

    broken_container.timer = Timer()
    broken_container:addChild(broken_container.timer)

    local timer = broken_container.timer
    for _, texture in ipairs(sprites) do
        local s = Sprite(texture)
        s:setScale(2)
        broken_container:addChild(s)

        s.alpha = 0.8;
        s:setPhysics({
            speed = 2,
            friction = 0.05,
            direction = math.rad(Utils.random(360))
        })
        s:setGraphics({
            fade_to = 0,
            fade = 0.01
        })
    end

    broken_container:setScale(
        self:getRealWidth() / (sprites[1]:getWidth()*2),
        self:getRealHeight() / (sprites[1]:getHeight()*2)
    )
    broken_container.timer:after(120/30, function()
        broken_container:remove()
    end)

    Assets.playSound("glassbreak", 0.4, 0.6)
    Assets.playSound("sparkle_glock", 0.5, 0.8)
    Assets.playSound("sparkle_glock", 0.5, 0.71)
    Assets.playSound("punchmed", 0.95, 0.7)

    self:remove()
end

function event:update()
    super.update(self)
    self.container.y = Utils.wave(Kristal.getTime()*2, -10, 10)
    if self.sprite and self.text then
        self.text.y = -self.sprite:getScaledHeight() + self.text_offset_y
    else
        self.text.y = self.text_offset_y
    end
    if self.afx then
        Object.startCache()
        if self:collidesWith(self.world.player) then
            self.afx.alpha = Utils.approach(self.afx.alpha, 1, DT*4)
        else
            self.afx.alpha = Utils.approach(self.afx.alpha, 0, DT*2)
        end
        Object.endCache()
    end
end

return event