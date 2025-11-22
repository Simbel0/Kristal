local map, super = Class(Map)

function map:onEnter()
	if not Game:getFlag("flashback_prophecy_final") then
		self.hsv_fx = HSVShiftFX(true, 3000)
		self.hsv_fx.hue_start = 290
        self.hsv_fx.hue_target = 230
        self.hsv_fx.val_start = 0.8
        self.hsv_fx.val_target = 0.9
		self:getTileLayer("floorglow"):addFX(ProphecyShaderFX(1, {0, 0, 1}), "prop")
		self:getEvent(62):addFX(ProphecyShaderFX(0.5, {0, 0, 1}), "prop")
		self:getEvent(63):addFX(ProphecyShaderFX(0.5, {0, 0, 1}), "prop")

	    for _,glow in ipairs(Game.world.map:getEvents("roomglow")) do
			glow.actind = 1.05
		end
        --Game.world.stage:addFX(self.hsv_fx, "_hsv")

		Game.world:startCutscene("finalprophecy.ralsei")
		local x, y = self:getMarker("ralsei_marker")
		local ralsei = Game.world:spawnNPC("ralsei", x, y, {facing="right"})
		ralsei:setSprite("walk_unhappy")
	end
end

return map