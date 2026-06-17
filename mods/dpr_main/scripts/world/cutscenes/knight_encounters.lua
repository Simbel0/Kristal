return {
	cliffside = function(cutscene)
		cutscene:fadeOut(0)
		local hero = cutscene:getCharacter("hero")
		local susie = cutscene:getCharacter("susie")
		cutscene:detachFollowers()

		hero.y = hero.y - 25
		susie.y = susie.y + 20
		susie.x = susie.x + 5

		local party_walking = true
		cutscene:during(function()
			if not party_walking then return end
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
		party_walking = false
		cutscene:text("* (As Susie starts retelling her story, you close your eyes and focus on the past...)")

		cutscene:text("EVERYONE GET IN THE FLASHBACK WE'RE LEAVING THIS CLIFFSIDE NOW WHAT THE IMPOSSIBLE THIS ISN'T THE FLASHBACK NOOOO NOOOO CUTSCENE SKIPPIIIIIIIIIIING")

		--cutscene:wait(cutscene:fadeIn(4))

		local kris_past = Sprite("party/kris/dark/sword_run", 320, 155)
		kris_past:setParallax(0)
		kris_past:setScale(2)
		kris_past:setLayer(1)
		kris_past:play(1/7)
		kris_past:addFX(ColorMaskFX({0, 1, 1}), "color")
		kris_past.alpha = 0
		kris_past:setGraphics({
			fade_to = 1,
			fade =0.1
		})
		Game.stage:addChild(kris_past)

		local susie_past = Sprite("party/susie/dark/run_serious/right", 245, 155)
		susie_past:setParallax(0)
		susie_past:setScale(2)
		susie_past:setLayer(1)
		susie_past:play(1/7)
		susie_past:addFX(ColorMaskFX({1, 0, 1}), "color")
		susie_past.alpha = 0
		susie_past:setGraphics({
			fade_to = 1,
			fade =0.1
		})
		Game.stage:addChild(susie_past)

		local fountains_past = {}
		local function createFountain()
			local fountain = Sprite("world/cutscenes/cliffside/fountain_tall", MathUtils.random(SCREEN_WIDTH/2, SCREEN_WIDTH), MathUtils.random(50, 200))
			fountain:setOrigin(0.5, 1)
			fountain:setScale(2)
			fountain:play(1/7)
			fountain:setPhysics({
				speed_x = MathUtils.random(-4, -5)-((fountain.y/SCREEN_HEIGHT)*10)
			})
			fountain.alpha = 0
			fountain:setGraphics({
				fade_to = 1,
				fade =0.1
			})
			--fountain.layer = susie_past:getLayer()-1
			Game.stage:addChild(fountain)
			table.insert(fountains_past, fountain)
		end

		cutscene:text("* And after that, we chased the Knight everywhere it went.", nil, susie)
		local fountain_handler = Game.world.timer:everyInstant(0.8, createFountain)
		cutscene:during(function()
			if #fountains_past == 0 then return false end

			for i=#fountains_past, 1, -1 do
				if fountains_past[i].x <= -50 then
					fountains_past[i]:remove()
					table.remove(fountains_past, i)
				end
			end
		end)
		cutscene:text("* It started creating fountains left and right, sometimes multiple in a few hours...", nil, susie)
		cutscene:text("* We kept up as much as we could. After all, we were the heroes, y'know?", nil, susie)
		cutscene:text("* Who could stand against the Knight if not Kris and I?", nil, susie)
		Game.world.timer:cancel(fountain_handler)
		kris_past:setSprite("party/kris/dark/walk/right_1")
		susie_past:setAnimation({"party/susie/dark/walk/right", 1/5, true})
		local slideK = cutscene:slideTo(kris_past, 245, kris_past.y, 2)
		local slideS = cutscene:slideTo(susie_past, 325, susie_past.y, 2)
		cutscene:during(function()
			if slideS() then
				susie_past:setSprite("party/susie/dark/walk/right_1")
				return false
			end
		end)
		cutscene:text("* ...", nil, susie)
		cutscene:waitMultiple(slideK, slideS)
		cutscene:wait(0.5)
		Assets.playSound("weaponpull_fast")
		kris_past:setSprite("party/kris/dark/battle/attackready_1")
		cutscene:wait(1)
		cutscene:text("* Or so I thought.", nil, susie)
		Assets.playSound("laz_c_len")
		Assets.playSound("hurt")
		kris_past:remove()
		susie_past:remove()
		cutscene:wait(3)

		cutscene:text("* I barely remember anything after that.", nil, susie)
		cutscene:text("* But it feels like I kept thinking...", nil, susie)
		cutscene:text("* I thought about many things, like how we failed.", nil, susie)
		cutscene:text("* How Ralsei is still trapped in the hands of the Knight.", nil, susie)
		cutscene:text("* How Noelle and Berdly are probably in this mess too now.", nil, susie)
		cutscene:text("* How I failed him...", nil, susie)
		cutscene:text("* But most of all, I kept wondering...", nil, susie)
		cutscene:wait(1.5)
		cutscene:text("* [speed:0.9]Was Kris ever my friend?", nil, susie)

		local marker_x, marker_y = cutscene:getMarker("hide_knight")
		susie:setPosition(marker_x, susie.y)
		hero:setPosition(marker_x-50, hero.y)
		Game.world.camera.target = susie
		cutscene:attachCameraImmediate()
		cutscene:detachCamera()
		susie:setSprite("shock_up")
		cutscene:look(hero, "right")
		cutscene:fadeIn(0)
		local _, w = cutscene:alert(susie)
		cutscene:wait(w)
		cutscene:text("* Hero! Hide!")
		cutscene:text("* What...?")

		cutscene:look(hero, "up")
		cutscene:wait(0.2)
		_, w = cutscene:alert(hero)
		cutscene:wait(w)

		susie:resetSprite()
		cutscene:waitMultiple(
			cutscene:walkTo(susie, 216, 1100),
			cutscene:walkTo(hero, 280, 1100),
			cutscene:panTo(60, Game.world.camera.y)
		)
	end
}