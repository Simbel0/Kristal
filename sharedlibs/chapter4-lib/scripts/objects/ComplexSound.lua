local ComplexSound, super = Class()

function ComplexSound:init(lifetime, killall, killind)
	
	self.killall = killall ~= nil and killall or true
	self.killind = killind ~= nil and killind or false

	self.timer = 0;

	self.array_max = 11 -- GML bs I guess
	for i=1,self.array_max do
	    self.snd[i] = nil;
	    self.pitch[i] = 1;
	    self.delay[i] = 0;
	    self.volume[i] = 1;
	    self.looprate[i] = -1;
	    self.play[i] = 0;
	    self.killsnd[i] = false;
	end

	self.mastertime = 0;
	self.lifetime = lifetime or -1

end

function ComplexSound:add(id, snd, pitch, volume, delay, looprate, killsnd)
	self.snd[id] = snd;
	self.pitch[id] = pitch or 1;
	self.delay[id] = delay or 0;
	self.volume[id] = volume or 1;
	self.looprate[id] = looprate or -1;
	self.killsnd[id] = killsnd or false;
end

local function array_lenght(array)
	local count = 0
	for i=1,11 do
		if self.snd[i] then
			count = count + 1
		end
	end

	return count
end

function ComplexSound:update()
	self.mastertime = self.mastertime + DTMULT
	self.timer = self.timer + DTMULT
	local count = array_lenght(self.snd)
end

return ComplexSound