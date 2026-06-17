return function(cutscene)

	local function lengthdir_x(dist, angle) return dist *  math.cos(math.rad(angle)) end
	local function lengthdir_y(dist, angle) return dist * -math.sin(math.rad(angle)) end

	local function castRudeBuster(x, y, tx, ty)
		local done = false
		local after = function() done = true end

		Assets.playSound("rudebuster_swing")
		Game.world:spawnObject(RudeBusterBeam(false, x, y, tx, ty, after), WORLD_LAYERS["above_bullets"])

		cutscene:wait(function() return done end)
	end

	local kris = cutscene:getCharacter("kris")
	local susie = cutscene:getCharacter("susie")
	local ralsei = cutscene:getCharacter("ralsei")

	local knight = Game.world:spawnNPC("roaring_knight", 330, 1595)
	knight:setLayer(10)
	knight:setAnimation("looking")

	local rem = 1
	local function knightDodge()
		local wait = true
		knight:setAnimation({"ball_transition_reverse", 0.5, true, frames={"4-0"}})

		local x = knight.init_x + Utils.pick{40, 50, 60, 70} * rem
		local y = knight.init_y + Utils.pick{20, 30, 40} * Utils.randomSign()
		rem = rem * -1

		Assets.playSound("knight_teleport")
		Game.world.timer:tween(0.2, knight, {x=x, y=y}, nil, function()
			knight:setAnimation("ball_transition_pose")
			wait = false

			local old_callback = knight.sprite.anim_callback
			knight.sprite.anim_callback = function(...)
				if old_callback then
					old_callback(...)
				end

				for i=1,love.math.random(5, 10) do
					local after = AfterImage(knight.sprite, 0.8, 0.02)
					after:setPhysics({
						direction = math.rad(Utils.random(360)),
						speed = 2
					})
					Game.world:addChild(after)
				end
				knight:flash()
			end
		end)
		return function() return not wait end
	end

	local _, wait = cutscene:alert(susie, 1, {play_sound=false})

	cutscene:wait(wait)

	cutscene:wait(1) -- 60

	cutscene:setTextboxTop(true)
	susie:setAnimation({"point_up", 0.2, true})

	cutscene:text("* You...!", "disgust_c", susie)

	cutscene:wait(cutscene:panTo(knight.x, knight.y+80, 2))
	print(knight.y+80)

	cutscene:wait(1.5)

	for i=1,3 do
		local wait = knightDodge()
		castRudeBuster(susie.x, susie.y, knight.x-knight.width/2, knight.y-knight.height/2)
		cutscene:wait(wait)

		cutscene:wait(0.5)
	end
	cutscene:wait(0.3)

	Assets.playSound("knight_teleport")
	knight:setAnimation({"ball_fly", 0.2, true})
	Game.world.timer:tween(0.5, knight, {x=knight.init_x, y=knight.init_y}, nil, function()
		knight:setAnimation({"ball_transition_down", 1/15, false})
	end)
	cutscene:wait(1)

	knight:setAnimation({"slosh_sword", 0.2, false, frames={"1-6"}})
	cutscene:wait((0.2*6))

	cutscene:detachFollowers()
	susie:resetSprite()
	susie:setPosition(295+25, Game.world.camera.y+SCREEN_HEIGHT)
	ralsei:setPosition(247+20, Game.world.camera.y+SCREEN_HEIGHT)
	kris:setPosition(350+15, Game.world.camera.y+SCREEN_HEIGHT)

	local wait = cutscene:walkTo(susie, susie.x, 1750, 1.3)
	cutscene:walkTo(ralsei, ralsei.x, 1765, 1.3)
	cutscene:walkTo(kris, kris.x, 1770, 1.3)

	cutscene:wait(0.3)

	knight:setAnimation({"slosh_sword", 0.1, false, frames={"7-12"}})

	cutscene:wait(wait)

	cutscene:setTextboxTop(false)
	susie:setAnimation({"point_up", 0.2, true})

	cutscene:text("* Nowhere to run this time,[wait:3] dumbass!", "daring_a", susie)
	susie:setSprite("shock_up")
	cutscene:text("* I dunno where you've put Toriel,[wait:3] but...[wait:5] it's over!", "exhausted_c", susie)
	susie:setAnimation({"point_up", 0.2, true})
	cutscene:text("* The Fountain's just past you,[wait:3] isn't it?", "angry_c", susie)

	knight:setAnimation({"down_look_back", 0.1, false})

	cutscene:wait(1.2)

	susie.sprite:pause()
	cutscene:text("* That means...[wait:5] we don't even have to beat you.", "bangs_neutral", susie)
	susie:resetSprite()
	cutscene:text("* All we have to do is get PAST you...[wait:5] and it's over.", "teeth", susie)
	cutscene:walkTo(susie, susie.x, susie.y-5, 0.1)
	knight:setAnimation({"down_look_forward", 0.1, false})
	cutscene:text("* ... You...", "bangs_neutral", susie)
	susie:setAnimation({"point_up", 0.2, true})
	cutscene:text("* You can't beat us in the Light World,[wait:3] can you?", "daring_a", susie)
	susie:setSprite("shock_up")
	cutscene:text("* That's...[wait:5] why you keep running,[wait:3] isn't it?", "daring_b", susie)

	cutscene:wait(1.5)

	local laugh = Assets.playSound("knight_laugh")
	laugh:setLooping(true)
	knight:setAnimation("laughing_anim")

	cutscene:wait(1)

	susie:setAnimation({"point_up", 0.2, true})
	cutscene:text("* Hey...[wait:5] hey,[wait:3] what's so funny?", "exhausted_c", susie)
	susie.sprite:pause()
	cutscene:text("* Kris,[wait:3] why...[wait:5] are they laughing...?", "exhausted_c", susie)
	susie:setSprite("shock_up")
	susie:shake()
	cutscene:text("* You're laughing 'cause you know I'm right,[wait:3] don't you!?", "daring_a", susie)
	Game.world.music:stop()
	susie:resetSprite()

	cutscene:wait(1)

	susie:setSprite("point_up_1")
	susie:shake()
	knight:setAnimation({"laugh_stop", 1, false})
	laugh:stop()

	cutscene:text("[speed:0.3]* You lose that Fountain,[wait:3] it's over!!", "daring_b", susie, {skip=false})
	cutscene:wait(0.5)

	knight:setAnimation({"throw_sword", 5/30, false, frames={"1-5"}})
	knight.sprite.afterimages = false
    knight.sprite.flying = false
    cutscene:wait(0.5)

    local fx = Sprite("effects/shock_fx", 9, -5)
    fx:setOrigin(0.5)
    ralsei:addChild(fx)
    fx:play(3/16, false, function() fx:remove() end)

	cutscene:wait((5/30)*5+0.25)

	cutscene:text("* Don't...", "frighten_b", ralsei)

	cutscene:wait(cutscene:walkTo(ralsei, ralsei.x, ralsei.y-28, 0.2))
	knight:setAnimation({"throw_sword", 3/30, false, frames={"5-12"}})
	knight.sprite.afterimages = false
    knight.sprite.flying = false
	cutscene:wait(1)

	ralsei:setSprite("up_shock")
	ralsei:shake()
	cutscene:text("* DON'T MAKE ANOTHER FOUNTAIN!!!", "frighten", ralsei)

	cutscene:wait(1)

	local steptimer = 0
	local cam_wait = true
	local start_cam_y = Game.world.camera.y
	cutscene:during(function()
		steptimer = steptimer + DTMULT
		local lerpval = -(math.cos((math.pi * steptimer) / 60) - 1) / 2;
		Game.world.camera.y = Utils.lerp(start_cam_y, start_cam_y - 660 - 320, lerpval, true)

		if steptimer >= 60 then
			steptimer = 0
			cam_wait = false
			return false
		end
	end)

	cutscene:wait(12/30)

	susie:setSprite("shock_up")
	ralsei:setSprite("shocked_behind")

	knight:setAnimation({"throw_sword", 3/30, false})
	knight.sprite.afterimages = false
    knight.sprite.flying = false
	knight.sprite:setFrame(14)
	knight.sprite:pause()
	Assets.playSound("knight_jump", 1, 0.4)
	local yoffset = -400 -- Why does this exists???
	Game.world.timer:tween(45/30, knight, {y=(knight.y-320)+yoffset})
	knight.rotation = math.rad(-20)
	knight.sprite.x = knight.sprite.x + 20

	local swords = {}

	local sword = Sprite(knight.sprite:getPath("sword_throw"), knight.x+120, knight.y+10)
	sword:setLayer(knight:getLayer()-0.05)
	sword:setScale(2)
	sword.swordid = 0
	Game.world:addChild(sword)
	table.insert(swords, sword)

	--scr_lerpvar("image_angle", image_angle, 720, 50, 1, "out");
	Game.world.timer:tween(50/30, sword, {rotation=math.rad(720)})

	local timer = 0
	local sword_flash = false
	Game.world.timer:after(5/30, function()
		sword_flash = true
	end)
	cutscene:during(function()
		if #swords == 0 then return false end
		if sword_flash then
			for i,sword in ipairs(swords) do
				if not sword.init then
					sword.init = true
				else
					local af = AfterImage(sword, 0.5, 0.04)
					Game.world:addChild(af)
				end
			end
		end
	end)


	wait = true
	cutscene:during(function()
		timer = timer + DTMULT

		if timer >= 25 and #swords == 1 then
			for i=-2,2 do
				if i ~= 0 then
					local sword = Sprite(knight.sprite:getPath("sword_throw"), knight.x+120, knight.y+10)
					sword:setLayer(knight:getLayer()-0.1)
					sword:setScale(2)
					sword.swordid = i
					Game.world:addChild(sword)
					table.insert(swords, sword)

					Game.world.timer:tween(25/30, sword, {rotation=math.rad(360 + (2 * i))})
				end
			end
		end

		for i,sword in ipairs(swords) do
			sword.x = knight.x - 30 + (sword.swordid * 40 * (math.max(timer - 25, 0) / 25)) + lengthdir_x(80, 90 + (180 * (timer / 50)))
            sword.y = (knight.y - 180) + (math.abs(sword.swordid) * 10 * (math.max(timer - 25, 0) / 25)) + lengthdir_y(140, -90 + (180 * (timer / 50)))
		end

		if timer >= 50 then
			timer = 0
			wait = false
			return false
		end
	end)

	cutscene:wait(function() return not wait end)

	local target_flash_active = true
	wait = true

	Game.world.timer:after(20/30, function()
		target_flash_active = false
	end)
	Game.world.timer:after(5/30, function()
		timer = 0
		wait = false
	end)

	local blazetimer = 0
	cutscene:during(function()
		if not target_flash_active then return false end

		blazetimer = blazetimer + DTMULT

		Assets.playSound("fountain_target")
		local fuck = Sprite("effects/make_fountain_flash", (knight.x - 260) + (blazetimer * 6 * 4), (knight.y - knight.height) - 20 + Utils.random(20))
		fuck:setScale(2)
		fuck:setLayer(0.21)
		Game.world:addChild(fuck)
		fuck:play(0.1, false, function(s) s:remove() end)
	end)

	cutscene:wait(function() return not wait end)

	-- I hate DTMULT
	local dtmult_modulo_divorce_helper = false
	local dtmult_modulo_divorce_helper_chargeshot = false
	local dtmult_modulo_divorce_helper_frame = false
	local dtmult_modulo_divorce_helper_pxwhite = false

	local wait = true
	cutscene:during(function()
		timer = timer + DTMULT

		if (timer >= 1 and timer < 2) and knight.sprite.frame ~= 15 then
			knight.sprite:setFrame(15)
		end

		--print(timer, Utils.round(timer)%2)
		if (Utils.round(timer)%2 == 1) and not dtmult_modulo_divorce_helper then
			dtmult_modulo_divorce_helper = true
			for i,sword in ipairs(swords) do
				--print(i, 5 + (2 * sword.swordid), timer)
				if 5 + (2 * sword.swordid) == Utils.round(timer) and not sword.letsgo then
					print("yeah for "..i.." at timer "..timer)
					--sword.physics.direction = math.rad(90)
					local xspd = lengthdir_x(1, math.deg(sword.rotation) - 90)
					local yspd = lengthdir_y(1, math.deg(sword.rotation) - 90)
					sword.physics.speed_x = -14 * xspd
					sword.physics.speed_y = -14 * yspd
					Game.world.timer:tween(12/30, sword.physics, {speed_x = 0, speed_y = 0})
					Game.world.timer:after(18/30, function()
						sword.physics.speed_x = 80 * xspd
						sword.physics.speed_y = 80 * yspd
					end)
					sword.letsgo = true
				end
			end
		elseif (Utils.round(timer)%2 ~= 1) and dtmult_modulo_divorce_helper then
			dtmult_modulo_divorce_helper = false
		end

		if ((timer >= 19 and timer <= 27) and (Utils.round(timer) % 2 == 1 and not dtmult_modulo_divorce_helper_chargeshot)) then
			dtmult_modulo_divorce_helper_chargeshot = true
			print("bang at timer "..timer)
            Assets.stopAndPlaySound("chargeshot_fire", 1, 1.4)
        elseif (Utils.round(timer)%2 ~= 1) and dtmult_modulo_divorce_helper_chargeshot then
			dtmult_modulo_divorce_helper_chargeshot = false
        end

        local advanceframe = {}

        advanceframe[5] = true;
        local delay = 16;
        advanceframe[2 + delay] = true;
        advanceframe[4 + delay] = true;
        advanceframe[6 + delay] = true;
        advanceframe[8 + delay] = true;

        if advanceframe[Utils.round(timer)] and not dtmult_modulo_divorce_helper_frame then
            knight.sprite:setFrame(knight.sprite.frame+1)
            advanceframe[Utils.round(timer)] = false
            dtmult_modulo_divorce_helper_frame = true
        else
        	dtmult_modulo_divorce_helper_frame = false
        end

        if (timer >= delay + 2 and timer <= delay + 10) and (Utils.round(timer) % 2 == 0 and not dtmult_modulo_divorce_helper_pxwhite) then
        	print("Create a rect")
        	local scale = 4
        	local idx = -(timer - delay - 6) / 2

        	local rect = Sprite("px_white", sword.x, knight.y - 600)
        	rect.scale_x = 20 * scale
        	rect.scale_y = 1000
        	rect.rotation = math.rad(-idx * 3) + math.rad(0)
        	rect.x = rect.x - (60 * idx)
        	rect.layer = swords[1]:getLayer()
        	Game.world.timer:tween(4/30, rect, {scale_x=0, x=rect.x + (10*scale)})
        	Game.world.timer:tween(8/30, rect, {alpha=0})
        	Game.world.timer:after(8/30, function() print("delete a rect") rect:remove() end)
        	Game.world:addChild(rect)
        elseif (Utils.round(timer) % 2 ~= 0 and dtmult_modulo_divorce_helper_pxwhite) then
        	dtmult_modulo_divorce_helper_pxwhite = false
        end

        if (timer >= (delay + 11)) then
            timer = 0
            wait = false
            return false
        end
	end)

	cutscene:wait(function() return not wait end)
	print("pass wait")

	print("There's "..#swords.." swords.")
	for i,sword in ipairs(swords) do
		print("Preparing sword "..i)
		Game.world.timer:tween(10/30, sword, {scale_x=1, scale_y=4})
		Game.world.timer:after(10/30, function()
			print("deletus swordus "..i)
			Utils.removeFromTable(swords, sword):remove()
			print("There's "..#swords.." swords left.")
		end)

		-- Why?? lmao
		local af = AfterImage(sword, 0.4, 0.04)
		Game.world:addChild(af)
	end

	wait = true
	cutscene:during(function()
		--print(#swords)
		if #swords == 0 then
			wait = false
			return false
		end
		timer = timer + DTMULT

		for i,sword in ipairs(swords) do
			local af = AfterImage(sword, 0.3 + ((0.4 * timer) / 10), 0.04)
			Game.world:addChild(af)
		end
	end)

	cutscene:wait(5/30)

	ralsei.y = ralsei.y+28
	cutscene:panTo(Game.world.camera.x, 1533, 10/30)

	cutscene:wait(function() return not wait end)

	local sound = Assets.playSound("thunder_boom", 1, 0.5)
	cutscene:during(function()
		local vol = sound:getVolume()
		if vol <= 0 then
			sound:stop()
			return false
		end
		vol = vol - 3/30
		sound:setVolume(vol)
	end)

	local fountain_flash = Sprite("tilesets/fountain_white", 128, 1639)
	fountain_flash:setScale(2)
	fountain_flash:setLayer(0.3)
	Game.world:addChild(fountain_flash)
	fountain_flash:fadeOutAndRemove(1)

	cutscene:wait(1.5)

	glow = RecolorFX(1, 1, 1, 1)
	for i, tile in ipairs(Game.world.map.events_by_layer["objects_tiles"]) do
		tile:addFX(glow, "fountain_glow")
	end
	Game.world:getEvent(14):addFX(glow, "fountain_glow")
	cutscene:during(function()
		local r, g, b, a = glow:getColor()
		print(r, g, b, a)
		if r <= 0.2 then
			glow:setColor(0.2, 0.2, 1, 1)
			return false
		end
		glow:setColor(r-DT, g-DT, b, a)
	end)

	kris:setLayer(0.5)
	susie:setLayer(0.5)
	ralsei:setLayer(0.5)
	Game.world:getEvent(16):setLayer(0.5)

	Assets.playSound("titan_wings", 1, 0.65)

	local fountain_burst_base = Sprite("world/events/titan_fountain_burst_base", 128, 1639)
	fountain_burst_base:setScale(2)
	fountain_burst_base:setLayer(0.4)
	Game.world:addChild(fountain_burst_base)
	fountain_burst_base:play(4/30, false)

	local fountain_burst = Sprite("world/events/titan_fountain_burst", 0, 1805)
	fountain_burst:setOrigin(0, 1)
	fountain_burst:setScale(2)
	fountain_burst:setLayer(0.4)
	Game.world:addChild(fountain_burst)
	fountain_burst:play(4/30, false, function() wait = false end)

	wait = true
	cutscene:wait(function() return not wait end)
	local make_snd = Assets.playSound("fountain_make", 1, 0.2)
	cutscene:during(function()
		if make_snd then
			local pitch = make_snd:getPitch()
			print(pitch)
			if pitch >= 0.8 then
				if FAST_FORWARD then
					make_snd:stop()
				end
				return false
			end
			make_snd:setPitch(pitch + (3/30))
		end
	end)

	local fountain_rings = Sprite("world/events/fountain_loop_rings", 128, 1639)
	fountain_rings:setScale(2)
	fountain_rings:setLayer(0.4)
	Game.world:addChild(fountain_rings)
	fountain_rings:play(4/30, true)

	fountain_burst:remove()

	fountain_burst_base:setAnimation({"world/events/titan_fountain_loop_base", 4/30, true})

	local y = 1710

	local fountain_parts = {}
	for i=0,10 do
		local y_pos = y - (i * (Assets.getTexture("world/events/titan_fountain_loop_1"):getHeight()*2))
		fountain_parts[i+1] = Sprite("world/events/titan_fountain_loop", 0, y_pos)
		fountain_parts[i+1]:setOrigin(0, 1)
		fountain_parts[i+1]:setScale(2)
		fountain_parts[i+1]:setLayer(0.5)
		Game.world:addChild(fountain_parts[i+1])
		fountain_parts[i+1]:play(2/30, true)
	end

--[[for (var i = 0; i < 4; i++)
    {
        var y_pos = fountain_marker.y - (sprite_get_height(spr_titan_fountain_loop) * 2) - (i * (sprite_get_height(spr_titan_fountain_loop) * 2));
        fountain_loop[i] = scr_dark_marker(0, y_pos, spr_titan_fountain_loop);
        fountain_loop[i].image_speed = 0.4;
    }]]

--[[var lerpval = -(cos((pi * steptimer) / 140) - 1) / 2;
    steptimer++;
    cameray_set(lerp(starting_y_pos - 660, starting_y_pos - 660 - 320 - 3500, lerpval));
    
    if (steptimer == 140)
    {
        steptimer = 0;
        stepcon = 0;
        roomglow.active = false;
        roomglow.glow = 1;
        roomglow.actind = 1;
    }]]

    cutscene:wait(2)

    knight.visible = false

    steptimer = 0
	cam_wait = true
	start_cam_y = Game.world.camera.y
	Game.world.camera.keep_in_bounds = false
	cutscene:during(function()
		steptimer = steptimer + DTMULT
		local lerpval = -(math.cos((math.pi * steptimer) / 140) - 1) / 2;
		Game.world.camera.y = Utils.lerp(start_cam_y, start_cam_y - 660 - 320 - 1500, lerpval, true)

		if steptimer >= 140 then
			steptimer = 0
			cam_wait = false
			return false
		end
	end)

	cutscene:wait(function() return not cam_wait end)

	print("cam_wait done")

	cutscene:wait(function() return not make_snd:isPlaying() end)
	print("sound done")

	cutscene:during(function()
		for i,v in ipairs(fountain_parts) do
			v.anim_delay = v.anim_delay + (0.001)*DTMULT
			if v.anim_delay >= (4/30) then
				v.anim_delay = (4/30)
				return false
			end
		end
	end)

	cutscene:wait(2)

	cutscene:text("[speed:0.3]* ...", "disgust_c", "susie")
	cutscene:text("[speed:0.3]* ...", "frighten_b", "ralsei")
	cutscene:text("[speed:0.5]* Nothing...[wait:4] is happening?", "concern_smile", "ralsei")

	kris:setPosition(380, 1770)
	susie:setPosition(315, 1760)
	ralsei:setPosition(250, 1765)

	steptimer = 0
	cam_wait = true
	start_cam_y = Game.world.camera.y
	Game.world.camera.keep_in_bounds = false
	cutscene:during(function()
		steptimer = steptimer + DTMULT
		local lerpval = -(math.cos((math.pi * steptimer) / 140) - 1) / 2;
		Game.world.camera.y = Utils.lerp(start_cam_y, start_cam_y + 660 + 320 + 1500, lerpval, true)

		if steptimer >= 140 then
			steptimer = 0
			cam_wait = false
			return false
		end
	end)

	cutscene:wait(function() return not cam_wait end)

	print("yeh")

	cutscene:wait(1)

	ralsei:resetSprite()

	cutscene:setTextboxTop(true)

	cutscene:text("[speed:0.5]* How...[wait:5] is this possible?", "frighten_b", "ralsei")
	cutscene:text("[speed:0.5]* The prophecy...[wait:5] It said that when too many fountains are opened...", "frighten_look_down", "ralsei")
	cutscene:text("[speed:0.5]* The Titans will...", "frighten_b", "ralsei")

	cutscene:wait(0.5)

	susie:resetSprite()

	cutscene:wait(0.5)

	knight.visible = true
	knight:setSprite("idle_overworld")
	knight:setLayer(0.3)
	knight.sprite.afterimages = true
	knight.sprite.flying = true
	knight.rotation = 0
	knight.sprite.x = knight.sprite.x - 20

	local wait_knight = cutscene:slideTo(knight, 535, 1590, 2, "inOutSine")
	cutscene:during(function()
		if wait_knight() then
			print("wait_knight done")
			knight:setLayer(0.6)
			return false
		end
	end)

	cutscene:text("* ...", "neutral_side", "susie")
	cutscene:text("* Heh.", "closed_grin", "susie")

	susie:setAnimation({"laugh_right", 1/6, true})
	local snd = Assets.playSound("suslaugh")
	snd:setLooping(false)

	cutscene:wait(function() return not snd:isPlaying() end)

	susie:resetSprite()
	cutscene:text("* I knew it.[wait:5] That prophecy means nothing.", "closed_grin", "susie")
	cutscene:text("* There's no such thing as a fate written in stone!", "daring_a", "susie")
	cutscene:text("* So that means...", "daring_b", "susie")

	cutscene:wait(wait_knight)

	cutscene:wait(cutscene:walkTo(susie, knight.x, susie.y, 1.5, "up"))

	knight:setSprite("turn_around_7")
	cutscene:look(ralsei, "right")
	susie:setAnimation({"point_up", 0.2, true})

	cutscene:text("* Why should we be scared of you?!", "daring_b", "susie")

	cutscene:wait(1.5)

	knight:setSprite("idle_overworld")

	cutscene:wait(1)

	knight:setAnimation({"ball_transition", 1/15, false, frames={"10-1"}, callback=function()
		knight:setAnimation({"ball_fly", 0.2, true})
	end})
	Assets.playSound("knight_teleport")

	cutscene:wait(((1/15)*10)+0.2)

	susie:setSprite("shock_up")
	susie:shake()
	ralsei:setSprite("shocked_behind")
	ralsei:shake()
	cutscene:alert(susie, 1, {play_sound=false})
	cutscene:wait(cutscene:slideTo(knight, knight.x, -20, 2, "inQuad"))

	Game.world.music:play("creepychase", 1, 1.15)

	cutscene:text("* Hey!![wait:3] Where do you think you're going?!", "daring_b", "susie")

	susie:resetSprite()
	cutscene:wait(cutscene:walkPath(susie, {
		{knight.x, susie.y},
		{593, 1712},
		{572, 1651},
		{550, 1637},
		{507, 1620},
		{440, 1600}
	}, {speed=10}))

	ralsei:resetSprite()
	cutscene:walkPath(ralsei, {
		{250, 1765},
		{60, 1722},
		{60, 1651},
		{80, 1642},
		{110, 1625},
		{140, 1620},
		{180, 1600}
	}, {speed=10})

	cutscene:text("* SU-SUSIE!![wait:3] WAIT!!!", "frighten", "ralsei")

	Game.world.camera.keep_in_bounds = true
	cutscene:wait(cutscene:attachCamera())

	Game:setPartyMembers("kris")

	susie:remove()
	ralsei:remove()
	knight:remove()

	local event = Game.world:spawnObject(Interactable(100, 1630, {450, 90}))
	event.text = {
		{"* (It's five dark fountains created at the same spot.)",
		 "* (It feels unnatural to look at.)"}
	}
	local transition = Game.world:spawnObject(Transition(175, 1540, {300, 90}))
	transition:setLayer(100000)
	transition.target = {
        map = "church_finalprophecy",
        marker = "entry",
        facing = "up"
    }
end