local fountain_tall, super = Class(Event, "fountaintall")

function fountain_tall:init(data)
    super.init(self, data)

    self.base = Assets.getFrames("world/events/fountain_tall")
    self.loop = Assets.getFrames("world/events/fountain_tall_looping")

    if #self.base == 0 or #self.loop == 0 then
        print("fountaintall has no sprites?")
        self:remove()
        return
    end

    self.fountain_parts = {}

    local i = 0
    local map_size = 0
    local fountain_size = 256

    while map_size < Game.world.map.height*Game.world.map.tile_height do
        local tex = (i == 0 and self.base or self.loop)
        table.insert(self.fountain_parts, {
            textures = tex,
            frame = (i%#tex)+1,
            timer = 0,
            y = map_size
        })
        i = i + 1
        map_size = map_size + 256
    end
end

function fountain_tall:update()
    for i,part in ipairs(self.fountain_parts) do
        part.timer = part.timer + 0.1*DTMULT

        if part.timer >= 1 then
            part.timer = part.timer-1
            part.frame = part.frame+1
            if part.frame > #part.textures then
                part.frame = 1
            end
        end
    end
end

function fountain_tall:draw()
    super.draw(self)

    for i,part in ipairs(self.fountain_parts) do
        Draw.draw(part.textures[part.frame], -part.textures[part.frame]:getWidth(), -part.y, 0, 2)
    end
end

return fountain_tall