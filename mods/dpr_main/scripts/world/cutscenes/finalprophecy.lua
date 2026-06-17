return {
	ralsei = function(cutscene)
		--[[local hsvShifter = Game.world.stage.hsvShifter
        hsvShifter.hue_start = 290;
        hsvShifter.hue_target = 230;
        hsvShifter.val_start = 0.8;
        hsvShifter.val_target = 0.9;
        hsvShifter.heartbeat_mode = true;]]

        local kris = cutscene:getCharacter("kris")
        kris:setPosition(cutscene:getMarker("entry"))
        kris.y = kris.y + 100

        cutscene:detachCamera()
        Game.world.camera.keep_in_bounds = false
        Game.world.camera.x = kris.x
        Game.world.camera.y = 960

		local ralsei = cutscene:spawnNPC("ralsei", 215, 995)
		cutscene:walkTo(ralsei, 480, ralsei.y, 1.2, "up")

		Game.world.timer:after(0.8, function()
			cutscene:getEvent(23):breakProphecy()
		end)

		cutscene:wait(cutscene:walkTo(kris, kris.x, ralsei.y, 1.1, "right"))

		cutscene:wait(cutscene:panTo(360, Game.world.camera.y, 0.5))

		cutscene:wait(1)

		cutscene:text("* What...[wait:5] What is happening...", "frighten", "ralsei")
		cutscene:text("* The Prophecy...[wait:5] It's...", "frighten_b", "ralsei")

		cutscene:wait(0.5)

		cutscene:walkTo(ralsei, 860, ralsei.y, 1, "up")
		cutscene:text("* SUSIE,[wait:3] STOP!!!", "frighten", "ralsei")

		Game.world.camera.keep_in_bounds = true
		cutscene:wait(cutscene:attachCamera())
		ralsei:remove()
	end,
	breakprophecy = function(cutscene)
		local prophecy
		local maxdistance = math.huge
		for i, event in ipairs(Game.world.stage:getObjects(Event)) do
			if event.id == "prophecy" and event.parent then
				local dist = Utils.dist(Game.world.player.x, Game.world.player.y, event.x, event.y)
				print(i, dist, maxdistance)
				if dist < maxdistance then
					prophecy = event
					maxdistance = dist
				end
			end
		end

		prophecy:breakProphecy()
	end,
	final = function(cutscene)
		local kris = cutscene:getCharacter("kris")
		local ralsei = cutscene:getCharacter("ralsei")

		cutscene:detachCamera()
		cutscene:panTo(ralsei.x+10, ralsei.y)

		cutscene:wait(cutscene:walkTo(kris, ralsei.x-100, ralsei.y))

		cutscene:text("* SUSIE,[wait:3] BE CAREFUL!!", "frighten", "ralsei")

		Game.world.stage:removeFX("_hsv")
		Assets.playSound("glassbreak", 0.4, 0.6)
    	Assets.playSound("sparkle_glock", 0.5, 0.8)
    	Assets.playSound("sparkle_glock", 0.5, 0.71)
    	Assets.playSound("punchmed", 0.95, 0.7)

    	cutscene:wait(0.5)

    	local susie = cutscene:spawnNPC("susie", 3800, ralsei.y)
    	local knight = cutscene:spawnNPC("roaring_knight", 4200, susie.y)
    	susie:setSprite("battle/attackready_1")
    	knight:setAnimation({"droop", 1/2, true})

    	cutscene:wait(cutscene:panTo(4000, ralsei.y, 1.5))

    	cutscene:wait(0.5)

    	cutscene:text("* Looks like it's the end of the way.", "exhausted_a", "susie")
    	cutscene:text("* You may have beat us once,[wait:3] but you're done now!!", "daring_a", "susie")
    	cutscene:text("* I don't know what you were planning but it clearly failed.", "exhausted_b", "susie")
    	cutscene:text("* That prophecy isn't in your favor anymore,[wait:3] is it?", "daring_b", "susie")

    	cutscene:wait(1)

    	cutscene:text("* You still won't say anything,[wait:3] huh?", "exhausted_b", "susie")
    	cutscene:text("* In that case, I guess the best thing you can do right now...", "exhausted_b", "susie")
    	cutscene:text("* Is step down and let me kill you!", "exhausted_c", "susie", {auto=true, skip=false})

    	Game.world.music:stop()

    	local rect = Rectangle(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
    	rect:setParallax(0)
    	rect:setColor(0, 0, 0, 1)
    	rect.layer = 10000
    	Game.world:addChild(rect)
    	local slash = Sprite("roaringknight_slash", susie.x, susie.y)
    	slash:setScale(2)
    	slash:setOrigin(0.5)
    	slash.layer = 10001
    	Game.world:addChild(slash)

    	Assets.playSound("knight_cut", 4, 0.06)
	    Assets.playSound("knight_cut", 4, 0.1)
	    Assets.playSound("knight_cut", 4, 0.12)
	    Assets.playSound("knight_cut", 4, 0.18)
	    Assets.playSound("knight_cut", 4, 0.24)

	    cutscene:wait(2)

	    kris:setPosition(susie.x+30, susie.y+10)
	    kris:setSprite("battle/defend_6")

	    susie:setSprite("hurt_lookright")
	    susie.x = susie.x - 100

	    rect.alpha = 0
	    slash.alpha = 0

	    Assets.stopSound("knight_cut")

	    Assets.playSound("impact")
	    Assets.playSound("closet_impact", 1, 1)
	    Assets.playSound("closet_impact", 1, 0.5)
	    --Assets.playSound("bageldefeat", 0.8, 0.8)
	    Assets.playSound("damage")
	    --Assets.playSound("glassbreak", 0.8, 0.4)
	    --Assets.playSound("glassbreak", 0.6, 0.3)
	    Assets.playSound("sussurprise")

	    knight:setSprite("idle_overworld_sword")
	    
	    Game.world:shake(10)
	    kris:shake(10)

	    Game.world:addChild(DamageNumber("damage", Game.party[1].health-1, kris.x + 4, kris.y - 20, COLORS.red))

	    cutscene:wait(1)

	    cutscene:text("* KRIS?!![wait:5]\n* What the hell are you doing?!", "disgust_b", "susie")

	    Assets.playSound("knight_jump", 1, 0.8)
	    local sword = Sprite(knight.sprite:getPath("sword_throw"), kris.x-5, kris.y-60)
		sword:setScale(2)
		sword:setLayer(kris.layer+100)
		sword:setOrigin(0.5, 1)
		sword.alpha = 0
		sword:setGraphics({
			fade_to = 1,
			fade = 0.1
		})
		sword:setPhysics({
			speed_y = -10,
			friction = 0.5
		})
		Game.world:addChild(sword)

		cutscene:during(function()
			if sword then
				if sword.parent then
					local af = AfterImage(sword, 0.3, 0.04)
					Game.world:addChild(af)
				end
			end
		end)

		cutscene:wait(1)

		Assets.stopAndPlaySound("chargeshot_fire", 1, 1.4)
		sword:setPhysics({
			speed_y = 25,
			friction = -1
		})

		cutscene:wait(function()
			return sword.y > kris.y
		end)

		Assets.playSound("impact")
		Assets.playSound("damage")
		Game.world:addChild(DamageNumber("msg", "down", kris.x + 4, kris.y + 20))

		cutscene:slideTo(susie, susie.x-10, susie.y, 0.5, "outCubic")
		susie:shake()
		kris:shake(10)
		kris:setSprite("fell")
		cutscene:wait(cutscene:slideTo(kris, kris.x-30, kris.y+20, nil, "outCubic"))

		sword:remove()

		susie:setSprite("battle/rudebuster_03")
		Assets.playSound("weaponpull_fast", 0.4, 1)
		Assets.playSound("grab", 0.5, 0.8)
		Assets.playSound("grab", 0.5, 1)

		susie.x = susie.x + 15
		cutscene:wait(cutscene:slideTo(susie, susie.x+120, susie.y, 0.5, "outCubic"))
		cutscene:wait(0.5)

		cutscene:text("* You...[wait:10] YOU...", "bangs/shock", "susie", {auto=true, skip=false})

		Assets.playSound("knight_cut", 4, 0.06)
	    Assets.playSound("knight_cut", 4, 0.1)
	    Assets.playSound("knight_cut", 4, 0.12)
	    Assets.playSound("knight_cut", 4, 0.18)
	    Assets.playSound("knight_cut", 4, 0.24)

	    rect.alpha = 1
	    slash.alpha = 1

	    cutscene:wait(2.5)

	    rect.alpha = 0
	    slash.alpha = 0

	    Assets.stopSound("knight_cut")

	    Assets.playSound("impact")
	    Assets.playSound("closet_impact", 1, 1)
	    Assets.playSound("closet_impact", 1, 0.5)
	    Assets.playSound("bageldefeat", 0.8, 0.8)
	    Assets.playSound("damage")
	    Assets.playSound("glassbreak", 0.8, 0.4)
	    Assets.playSound("glassbreak", 0.6, 0.3)
	    Assets.playSound("sussurprise")
	    
	    Game.world:shake(10, 5)
	    susie:shake(10)

	    susie:setSprite("fell")
	    Game.world:addChild(DamageNumber("msg", "swoon", susie.x + 4, susie.y + 0))
	    cutscene:wait(cutscene:slideTo(susie, susie.x-50, susie.y-10, nil, "outCubic"))

	    cutscene:wait(3.5)

	    Game.world.music:play("knight_appears", 0, 1)
	    Game.world.music:fade(1)

	    cutscene:panTo(susie.x+30, Game.world.camera.y, 1.3)
	    cutscene:wait(cutscene:slideTo(knight, susie.x+90, susie.y-20, 1.5, "inOutBack"))

	    cutscene:wait(2)

	    Assets.playSound("knight_jump", 1, 0.8)
	    sword = Sprite(knight.sprite:getPath("sword_throw"), susie.x-5, susie.y-60)
		sword:setScale(2)
		sword:setLayer(susie.layer+10)
		sword:setOrigin(0.5, 1)
		sword.alpha = 0
		sword:setGraphics({
			fade_to = 1,
			fade = 0.1
		})
		sword:setPhysics({
			speed_y = -10,
			friction = 0.5
		})
		Game.world:addChild(sword)

		cutscene:wait(2.5)

		Assets.stopAndPlaySound("chargeshot_fire", 1, 1.4)
		sword:setPhysics({
			speed_y = 7,
			friction = -0.5
		})

		cutscene:wait(0.3)

		sword.physics.friction = 5

		Game.world.music:fade(0)
		cutscene:text("* WAIT!!!", nil, "ralsei")

		cutscene:wait(cutscene:walkTo(ralsei, susie.x-150, ralsei.y))

		cutscene:text("* I... I don't know what you want...", "angry_surprise", "ralsei")
		cutscene:text("* But I won't let you hurt my friends!", "brave_a", "ralsei")
		cutscene:look(ralsei, "up")
		cutscene:text("* Susie is right. The prophecy is not relailable anymore.", "small_smile_side", "ralsei")
		cutscene:text("* I don't know why you wanted to cause the Roaring...", "pensive", "ralsei")
		cutscene:look(ralsei, "right")
		cutscene:text("* But if it could happen, it would have already!", "brave_a", "ralsei")
		cutscene:text("* You will gain nothing from killing Susie or Kris!!", "angry", "ralsei")
		cutscene:text("* So... S-So...", "brave_look_down", "ralsei")
		cutscene:wait(0.3)
		ralsei:shake()
		Assets.playSound("wing")
		cutscene:text("* LEAVE US ALONE!!", "brave_a", "ralsei")

		cutscene:wait(3)

		sword:setGraphics({
			fade_to = 0,
			fade = 0.1
		})
		sword:setPhysics({
			speed_y = -10,
			friction = 0.5
		})

		cutscene:wait(cutscene:slideTo(knight, knight.x+50, knight.y))

		cutscene:wait(2)

		knight:setAnimation({"ball_transition", 1/15, false, frames={"10-1"}, callback=function()
			knight:setAnimation({"ball_fly", 0.2, true})
		end})
		Assets.playSound("knight_teleport")

		cutscene:wait(((1/15)*10)+0.2)

		cutscene:wait(cutscene:slideTo(knight, knight.x+SCREEN_WIDTH, knight.y, 2, "inQuad"))

		knight:remove()
		sword:remove()

		cutscene:wait(1)

		cutscene:panTo(kris.x+150, Game.world.camera.y)
		cutscene:wait(cutscene:walkTo(ralsei, ralsei.x+300, ralsei.y))

		cutscene:text("* It... It worked?")
		cutscene:text("* Did the Knight really just...")

		cutscene:look(ralsei, "left")

		cutscene:wait(0.5)

		cutscene:wait(cutscene:alert(ralsei, 1, {play_sound=false}))

		cutscene:text("* Kris! Susie!")

		Assets.playSound("spellcast")

		cutscene:wait(1)

		local function healEffect(chara)
			local flash_sprite = chara.sprite.texture
			local flash_offset = chara.sprite:getOffset()
			local flash = FlashFade(flash_sprite, flash_offset[1], flash_offset[2])
			flash.layer = 100
			chara:addChild(flash)
			Game.world.timer:every(1/30, function()
				for i = 1, 2 do
					local x = chara.x + ((love.math.random() * chara.width) - (chara.width / 2)) * 2
					local y = chara.y - (love.math.random() * chara.height) * 2
					local sparkle = HealSparkle(x, y)
					sparkle.color = {0,1,0}
					Game.world:spawnObject(sparkle, chara.layer + 0.1)
				end
			end, 4)
			Game.world:addChild(DamageNumber("msg", "up", chara.x + 4, chara.y + 0))
			Assets.playSound("power")
		end

		healEffect(kris)
		healEffect(susie)

		cutscene:wait(1)

		Assets.playSound("noise")
		kris:setSprite("battle/defeat")
		kris:shake()
		kris.y = kris.y - 5
		cutscene:wait(0.1)
		Assets.playSound("noise")
		susie:setSprite("battle/defeat")
		susie:shake()

		cutscene:wait(0.5)

		Assets.playSound("wing")
		kris:resetSprite()
		susie:resetSprite()

		cutscene:wait(2)
	end
}