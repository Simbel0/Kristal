local RadialDistort, super = Class(Object)

function RadialDistort:init(x, y, time)
    super.init(self)
	
	self.distort_x = x
	self.distort_y = y
	self:setLayer(WORLD_LAYERS["top"])
	self:setParallax(0,0)
	
	self.shader = Assets.getShader("distortiondonut")
	self.timer = 0
	self.time_percent = 0
	self.duration = time or 2
	
	self.ring_start = 1
	self.ring_width = 50
	self.ring_strength = 1
	self.screenshot = love.graphics.newImage(SCREEN_CANVAS:newImageData())
end

function RadialDistort:update()
    super.update(self)
	
	self.timer = self.timer + DT
	self.time_percent = Utils.lerp(0, 1, self.timer/self.duration)
	
	if self.time_percent > 0.5 then
		self.alpha = self.alpha - 0.03 * DTMULT
	end
	
	if self.time_percent >= 1 then
		self:remove()
	end
	
	local time = Utils.ease(0, 1, self.time_percent, "out-quad")
	self.ring_start = MathUtils.lerp(1, 900, time)
	self.ring_width = MathUtils.lerp(50, 300, time)
	self.ring_strength = MathUtils.lerp(1, 0, time)
end

function RadialDistort:draw()
    super.draw(self)
    local distort_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	local last_shader = love.graphics.setShader()
	love.graphics.setShader(self.shader)
	self.shader:send("distort_pos", {self.distort_x, self.distort_y})
	--self.shader:send("time", self.time_percent * SCREEN_WIDTH)
	self.shader:send("donut", {self.ring_start, self.ring_width, self.ring_strength})
	Draw.draw(self.screenshot, 0, 0, 0)
	love.graphics.setShader(last_shader)
	Draw.popCanvas(true)
	Draw.draw(distort_canvas, 0, 0, 0)
end

return RadialDistort