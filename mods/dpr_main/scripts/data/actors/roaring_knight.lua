local actor, super = Class(Actor, "roaring_knight")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Knight"

    -- Width and height for this actor, used to determine its center
    self.width = 52
    self.height = 65

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    --self.hitbox = {0, 0, 16, 16}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 1, 1}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "npcs/roaringknight"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle_overworld"

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        ["laughing_anim"] = {"laugh_body", 1, true},
        ["ball_transition_pose"] = {"ball_transition_pose", 1/30, false},
        ["looking"] = function(sprite, wait)
            --[[if not sprite.look_timer then
                sprite.look_timer = 0
            end]]

            sprite:setFrames(sprite:getPath("looking"), true)

            while true do
                --[[sprite.look_timer = sprite.look_timer + DTMULT
                local timer = sprite.look_timer
                local new_sprite

                if timer >= 93 then
                    sprite.look_timer = 0
                elseif timer >= 47 then
                    new_sprite = "looking_3"
                elseif timer >= 53 then
                    new_sprite = "looking_4"
                elseif timer >= 5 then
                    new_sprite = "looking_2"
                else
                    new_sprite = "looking_1"
                end

                if sprite.sprite ~= new_sprite then
                    sprite:setSprite(new_sprite)
                end

                print("[LOOKING ANIM]", timer)
                wait()]]

                sprite:setFrame(1)
                wait(4/30)
                sprite:setFrame(2)
                wait(1.4)
                sprite:setFrame(3)
                wait(0.2)
                sprite:setFrame(4)
                wait(4/3)
            end
        end
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["ball_transition_1"] = {16, 31.5},
        ["ball_transition_2"] = {16, 31.5},
        ["ball_transition_3"] = {16, 31.5},
        ["ball_transition_4"] = {16, 31.5},
        ["ball_transition_5"] = {16, 31.5},
        ["ball_transition_6"] = {13, 32.5},
        ["ball_transition_7"] = {4, 25},

        ["ball_transition_down_1"] = {13, 32.5},
        ["ball_transition_down_2"] = {4, 25},

        ["ball_transition_pose_1"] = {13, 32.5},
        ["ball_transition_pose_2"] = {4, 25},

        ["ball_transition_reverse"] = {20, 28.5},
        ["ball_fly"] = {20, 28.5}
    }
end

-- Function overrides go here

function actor:onSpriteInit(sprite)
    sprite.aimg_timer = 0
    sprite.expected_y = sprite.y
    sprite.afterimages = true
    sprite.flying = true

    sprite.anim_siner = 0
    sprite.anim_alpha = 1
end

function actor:onSpriteUpdate(sprite)
    if sprite.afterimages then
        sprite.aimg_timer = sprite.aimg_timer + DTMULT

        if sprite.aimg_timer >= 10 then
            sprite.aimg_timer = 0
            local aimg = AfterImage(sprite, 0.6, 0.01)
            aimg:setPhysics({
                speed_x = 1
            })
            Game.world:addChild(aimg)
        end
    end

    if sprite.flying then
        sprite.y = sprite.expected_y + (math.cos(Kristal.getTime() * 4) * 4);
    else
        sprite.y = sprite.expected_y
    end
end

function actor:onSetAnimation(sprite, anim, callback)
    if sprite.anim == "laughing_anim" or sprite.anim == "throw_sword" then
        sprite.afterimages = false
        sprite.flying = false
    else
        sprite.afterimages = true
        sprite.flying = true
    end
end

function actor:preSpriteDraw(sprite)
    if sprite.anim ~= "laughing_anim" then
        return false
    end

    local body = Assets.getFrames(sprite:getPath("laugh_body"))
    local mouth = Assets.getFrames(sprite:getPath("laugh_mouth"))

    sprite.anim_siner = sprite.anim_siner + 0.5*DTMULT
    sprite.anim_alpha = Utils.clamp(sprite.anim_alpha + Utils.randomSign()*DTMULT, 0.6, 1)

    local frame = sprite.anim_siner

    local kristal_offset_x_dont_ask = 16
    local kristal_offset_y_dont_ask = 13

    local r, g, b, a = sprite:getColor()
    Draw.setColor(r, g, b, a)
    Draw.draw(body[(math.floor(frame*0.3)%#body)+1], sprite.x + Utils.random(-1, 1)/2, sprite.y + Utils.random(-1, 1)/2)
    Draw.setColor(r, g, b, sprite.anim_alpha)
    Draw.draw(mouth[(math.floor(frame*0.7)%#mouth)+1], sprite.x + Utils.random(-2, 2)/2 + kristal_offset_x_dont_ask, sprite.y + Utils.random(-2, 5)/2 + kristal_offset_y_dont_ask)

    for i=1,5 do
        Draw.setColor(r, g, b, -0.3 + math.sin((sprite.anim_siner + (i * 4)) / 4))
        Draw.draw(mouth[(math.floor(frame*0.7)%#mouth)+1], sprite.x + (math.sin(((sprite.anim_siner * i) + (3.32 * i)) / 32) * 20 * i) + kristal_offset_x_dont_ask, sprite.y + (math.cos(((sprite.anim_siner * i) + (i * 2.1 * i)) /49) * 20 * i) + kristal_offset_y_dont_ask)
    end

    return true
end

return actor