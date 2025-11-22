local map, super = Class(Map)

function map:onEnter()
	Game.world.camera:setNudge(0, 80)
	for _,v in ipairs(Game.stage:getObjects(Follower)) do
		v.follow_delay = FOLLOW_DELAY-0.1
	end
end

function map:onExit()
	Game.world.camera:setNudge(0, 0)
end

function map:draw()
	super.draw(self)
    local darken_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("fill",0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
    love.graphics.setBlendMode("alpha")
    Draw.popCanvas(true)
	
	local mask_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT, { keep_transform = false })
    love.graphics.clear()
    for _, obj in ipairs(Game.world.children) do
        if obj:includes(Character) then
            self:drawCharacter(obj)
        end
    end
    Draw.popCanvas(true)
	
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.setColor(1,1,1)
    Draw.draw(darken_canvas, Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2)
    love.graphics.setBlendMode("alpha")
    Draw.draw(mask_canvas, Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2, 0, 1, 1)
end

function map:drawCharacter(chara)
    love.graphics.push()
	local x, y = Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2
	love.graphics.translate(-x, -y)
	local color = COLORS["gray"]
	if Game:getPartyMember(chara.party) then
		color = chara.actor.church_highlight_color or COLORS["gray"]
	end
    local shader = Kristal.Shaders["AddColor"]
    love.graphics.stencil((function()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		love.graphics.translate(0, 2)
		chara:fullDraw()
        love.graphics.setShader()
    end), "replace", 1)
    love.graphics.setStencilTest("less", 1)
    love.graphics.setShader(shader)
    shader:send("inputcolor", color)
    shader:send("amount", 0.2)
	love.graphics.translate(0, -2)
	chara:fullDraw()
	love.graphics.setStencilTest()
    love.graphics.setShader()
	
    love.graphics.pop()
end

return map