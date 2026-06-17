local Zone, super = Class(Event, "collapsingstaircasezone")

function Zone:init(data)
    super.init(self, data)

    print("Collapsing Staircase Zone is here")
    print(data.width, data.height, self.layer)

    local properties = data.properties or {}

    self.frames = Assets.getFrames(properties.texture or "world/events/fallingtiles")
end

function Zone:onAdd(parent)
	super.onAdd(self, parent)
	self:setFlag("dontload_tiles", {})

    for x = 0, self.width-40, Game.world.map.tile_width do
    	for y = 0, self.height-40, Game.world.map.tile_height do
    		if self:canLoad(x, y) then
    			Game.world:spawnObject(CollapsingTile(self.x + x, self.y + y, self.frames, self), 0.4)
    		end
    	end
    end
end

function Zone:canLoad(x, y)
	local tab = self:getFlag("dontload_tiles")
	print(Utils.dump(tab))
	return tab[x.."-"..y] == nil
end

function Zone:forbidLoad(x, y)
	self:getFlag("dontload_tiles")[x.."-"..y] = true
end

return Zone