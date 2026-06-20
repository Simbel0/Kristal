return function(_, chara)
	local prophecy
	local maxdistance = math.huge
	for i, event in ipairs(Game.world.stage:getObjects(Event)) do
		if (event.id and event.id:lower() == "prophecy") and event.parent --[[???]] then
			local dist = MathUtils.dist(chara.x, chara.y, event.x, event.y)
			if dist < maxdistance then
				prophecy = event
				maxdistance = dist
			end
		end
	end

	prophecy:breakProphecy(1)
end