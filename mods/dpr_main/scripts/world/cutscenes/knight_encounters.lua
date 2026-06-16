return {
	cliffside = function(cutscene)
		cutscene:fadeOut(0)
		local hero = cutscene:getCharacter("hero")
		local susie = cutscene:getCharacter("susie")
		cutscene:detachFollowers()

		hero.y = hero.y - 25
		susie.y = susie.y + 20
		susie.x = susie.x + 5

		cutscene:during(function()
			if hero.x <= 600 then
				hero.x = hero.x + 600
				susie.x = susie.x + 600
				cutscene:attachCameraImmediate()
			end
			cutscene:forEachPartyCharacter(function(_,chara)
				chara:move(-1, 0, Game.world.player:getBaseWalkSpeed())
			end)
		end)

		cutscene:wait(cutscene:fadeIn(5))
		cutscene:wait(2)

		cutscene:text("* So uh...[wait:5] Susie,[wait:3] was it?", "neutral_closed_b", hero)
		cutscene:text("* What's up?", "small_smile", susie)
		cutscene:text("* You did mention that you've been chasing the Knight before, right?", "neutral_closed_b", hero)
		cutscene:text("* That's right.", "neutral_side", susie)
		cutscene:text("* But you never went into great details about all of this.", "neutral_opened_b", hero)
		cutscene:text("* Like what happened for the situation to derail to such a point?", "neutral_closed", hero)
		cutscene:text("* Oh you don't know?", "surprise", susie)
		cutscene:text("* ...[wait:5]No?", "annoyed", hero)
		cutscene:text("* Your \"lore board\" was so full of stuff I assumed you knew everything.", "nervous", susie)
		cutscene:text("* [speed:0.3]...", "really", hero)
		cutscene:text("* You know what,[wait:3] that's a fair assumption.", "smug", hero)
		cutscene:text("* But that's not true.[wait:5] I know many things about this world...", "neutral_closed_b", hero)
		cutscene:text("* But I don't know much about how far you guys went...", "neutral_opened", hero)
		cutscene:text("* before everything went wrong.", "neutral_closed", hero)
		cutscene:text("* Oh yeah,[wait:3] that makes sense.[wait:5] I think.", "nervous_side", susie)
		cutscene:text("* Well uh,[wait:3] if I have to consider a specific moment...", "neutral", susie)
		cutscene:text("* It would be our final confrontation in the Church.", "neutral_side", susie)
		cutscene:text("* The Church,[wait:3] huh?[wait:5] Feels symbolic.", "smug", hero)
		cutscene:text("* Mind telling me exactly what happened?", "neutral_smile", hero)
		cutscene:text("* Sure...[wait:5] My memories might be a bit hazy though...", "nervous", susie)
		cutscene:text("* Don't worry,[wait:3] I'm actually very good at understanding the past.", "happy", hero)
		cutscene:text("* Even from fragmented recollections.", "smug", hero)
		cutscene:text("* I don't think I get it but okay.", "sus_nervous", susie)
		cutscene:text("* So when me,[wait:3] Kris and Ralsei reached the top of the Dark World...", "smile", susie)

		Game.world.music:fade(0, 2)
		cutscene:wait(cutscene:fadeOut(2))
		cutscene:text("* (As Susie starts retelling her story, you close your eyes and focus on the past...)")
	end
}