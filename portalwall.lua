portalwall = class:new()

function portalwall:init(x, y, width, height)
	self.x = x
	self.y = y	
	self.width = width
	self.height = height
	self.static = true
	self.active = true
	self.category = 12
	self.mask = {true}
end