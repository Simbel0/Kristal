local map, super = Class(Map)

function map:onEnter()
	if not Game:getFlag("flashback_prophecy_final") then
		self.hsv_fx = HSVShiftFX(true, 3000)
		self.hsv_fx.hue_start = 290
        self.hsv_fx.hue_target = 230
        self.hsv_fx.val_start = 0.8
        self.hsv_fx.val_target = 0.9

        Game.world.stage:addFX(self.hsv_fx, "_hsv")

		Game.world:startCutscene("finalprophecy.ralsei")
		local x, y = self:getMarker("ralsei_marker")
		Game.world:spawnNPC("ralsei", x, y, {facing="right"})
	end
end

return map