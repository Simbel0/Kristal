local Map, super = Class(Map)

function Map:onEnter()
	Game.world:startCutscene("knight_encounters.cliffside")
end

return Map