ceilblocker = class:new()

function ceilblocker:init(x)
	self.x = x-1
	self.y = -1000
	self.height = 1000
	self.width = 1
	self.static = true
	self.active = true
end