tile = class:new()

function tile:init(x, y)
	self.cox = x+1
	self.coy = y+1
	self.x = x
	self.y = y
	self.speedx = 0
	self.speedy = 0
	self.width = 1
	self.height = 1
	self.active = true
	self.static = true
	self.category = 2
	self.mask = {true}
end