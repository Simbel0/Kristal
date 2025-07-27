local ralsei, super = Class("ralsei", true)

function ralsei:init(...)
	super.init(self, ...)

	self.offsets["up_shock"] = {-2, 3}
end

return ralsei