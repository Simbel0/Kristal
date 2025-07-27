local TransitionFlame, super = Class(Event, "warpflame")

function TransitionFlame:init(data)
    print("TransitionFlame has been activated!")
    super.init(self, data)
    self:setOrigin(0.5, 0)

    local properties = data.properties or {}

    self.frames = Assets.getFrames(properties["texture"] or "world/events/gueiflame")
    self.frame = 1
    self.frame_timer = 0
    self.speed = 0.125

    self.collider = Hitbox(self, 5, 30, (19*2)-5, 30)
    self.debug_rect = {0, 0, 19*2, 30*2}

    self.siner = 0

    self:setColor(properties["color"] and Utils.parseColorProperty(properties["color"]) or COLORS.white)

    self.target = {
        map = properties.map,
        x = properties.x,
        y = properties.y,
        marker = properties.marker,
        facing = properties.facing,
    }

    self.text = Utils.parsePropertyMultiList("text", properties)

    self.choice_1 = properties["yeschoice"]
    self.choice_2 = properties["nochoice"]

    self.fade = properties["musicfade"]
end

function TransitionFlame:onInteract(player, dir)
    Game.world:startCutscene(function(cutscene)
        print(Utils.dump(self.text))
        if #self.text > 0 then
            for i,text in ipairs(self.text) do
                cutscene:text(text)
            end
        else
            cutscene:text("* A flame...[wait:4] It glows hesitently.")
        end
        local choices = {}
        table.insert(choices, self.choice_1 or "Go to\n"..(Registry.getMapData(self.target.map).name or Registry.getMapData(self.target.map).id))
        table.insert(choices, self.choice_2 or "Do not")
        if cutscene:choicer(choices) == 1 then
            Assets.playSound("ghostappear")

            cutscene:fadeOut(0.55, {global=false, color={self:getColor()}})
            cutscene:wait(0.25)
            cutscene:wait(cutscene:fadeOut(0.25, {global=false, color=COLORS.white, music=self.fade}))
            cutscene:wait(0.25*2)
            if self.target.marker then
                cutscene:wait(cutscene:loadMap(self.target.map, self.target.marker, self.target.facing, function() Game.fader.fade_color = COLORS.white end))
            else
                cutscene:wait(cutscene:loadMap(self.target.map, self.target.x, self.target.y, self.target.facing, function() Game.fader.fade_color = COLORS.white end))
            end
            Game.world.fader.alpha = 0
            Game.fader:fadeIn(nil, {color=COLORS.white, alpha=1})
        end
    end)
end

function TransitionFlame:update()

    self.frame_timer = self.frame_timer + (self.speed * DTMULT)

    self.frame = math.floor(self.frame_timer) + 1
    if self.frame > #self.frames then
        self.frame_timer = 0
        self.frame = 1
    end

    super.update(self)
end

function TransitionFlame:draw()
    --[[siner++;
    var mycol = image_blend;
    draw_sprite_ext(sprite_index, image_index, x + (sin((siner + 0) / 15) * 2), y + (cos((siner + 0) / 30) * 2), 2, 2, 0, image_blend, image_alpha * 0.5);
    draw_sprite_ext(sprite_index, image_index, x + (sin((siner + 8) / 15) * 2), y + (cos((siner + 8) / 30) * 2), 2, 2, 0, image_blend, image_alpha * 0.5);
    gpu_set_blendmode(bm_add);

    for (var i = 0; i < 3; i++)
        draw_sprite_ext(sprite_index, image_index + (0.5 * (i + 1)), x + (sin((siner + (i * 6)) / 15) * 2), y + (cos((siner + (i * 6)) / 30) * 2), 2, 2, 0, image_blend, image_alpha * 0.2);

    gpu_set_blendmode(bm_normal);]]

    self.siner = self.siner + DTMULT

    local r, g, b, a = self:getColor()
    Draw.setColor(r, g, b, a*0.5)
    Draw.draw(self.frames[self.frame], math.sin((self.siner + 0) / 15) * 2, math.cos((self.siner + 0) / 30) * 2, 0, 2)
    Draw.draw(self.frames[self.frame], math.sin((self.siner + 8) / 15) * 2, math.cos((self.siner + 8) / 30) * 2, 0, 2)

    local mode, alphamode = love.graphics.getBlendMode()
    love.graphics.setBlendMode("add")

    Draw.setColor(r, g, b, a*0.2)
    for i=0,2 do
        -- I think GameMaker do a floor rounding when image_index is a float??
        local offset_frame = math.floor(self.frame+(0.5*(i+1)))
        if offset_frame > #self.frames then
            offset_frame = 1
        end
        Draw.draw(self.frames[offset_frame], math.sin((self.siner + (i * 6)) / 15) * 2, math.cos((self.siner + (i * 6)) / 30) * 2, 0, 2)
    end
    love.graphics.setBlendMode(mode, alphamode)

    super.draw(self)
end

return TransitionFlame