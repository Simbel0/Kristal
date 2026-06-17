local CollapsingTile, super = Class(Object)

function CollapsingTile:init(x, y, textures, zone)
	super.init(self, x, y, Game.world.map.tile_width, Game.world.map.tile_height)

	self.zone = zone

	self.texture = textures[2]

	if x == 0 then
		self.texture = textures[1]
	elseif x == 400 then
		self.texture = textures[3]
	elseif love.math.random(20) == 1 then
		self.texture = textures[love.math.random(5, 7)]
	end

	self.texture_x = 0
	self.texture_y = 0

	self.con = 0
	self.timer = 0
	self.max_timer = 0
	self.vspeed = 0

	self:setHitbox(0, 0, self.width, self.height)
	self.collidable = false

	self.full_party = {}
end

function CollapsingTile:cacheParty()
	if Game.world == nil or Game.world.player == nil then return end
	self.full_party = {}

	table.insert(self.full_party, Game.world.player)
	for i,follow in ipairs(Game.world.followers) do
		table.insert(self.full_party, follow)
	end
end

function CollapsingTile:update()
	if #self.full_party == 0 then
		self:cacheParty()
		return
	end

	if self.con == 0 then
		local fall = true
		for i,member in ipairs(self.full_party) do
			if member.y > self.y then
				fall = false
				break
			end
		end

		if fall then
			self.con = -1
			self.collidable = true
			self.solid = true
			self.zone:forbidLoad(self.x, self.y)
			self.timer = love.math.random(1, 8)
		end
	elseif self.con == -1 then
		self.timer = self.timer - DTMULT
		if self.timer <= 0 then
			self.max_timer = love.math.random(30, 60)
			self.timer = self.max_timer
			self.con = 2
			Assets.playSound("impact", 1, Utils.random(0.3, 0.8))
			self.vspeed = Utils.pick{-1, -1, 0, 0, 0, 0, 0, 0, -2}

			Object.startCache()
			while self.solid and self:collidesWith(Game.world.player) do
				local x, y = Game.world.player:getPosition()
				Game.world.player:setPosition(x, y-2*DTMULT)
				Object.uncache(Game.world.player)
			end
			Object.endCache()
		end
	elseif self.con == 2 then
		self.timer = self.timer - DTMULT

		self.texture_y = self.texture_y + (1-self.vspeed)*DTMULT
		self.alpha = Utils.clampMap(self.timer, 0, self.max_timer, 0, 1)
		if self.timer <= 0 then
			self.con = 3
		end
	end
end

function CollapsingTile:draw()
	super.draw(self)
	Draw.draw(self.texture, self.texture_x, self.texture_y, 0, 2)

	if DEBUG_RENDER then
        self.collider:draw(self.collidable and COLORS.red or COLORS.blue)
    end
end

return CollapsingTile