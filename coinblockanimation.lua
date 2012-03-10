coinblockanimation = class:new()

function coinblockanimation:init(x, y)
	self.x = x
	self.y = y
	
	self.timer = 0
	self.frame = 1
end

function coinblockanimation:update(dt)
	self.timer = self.timer + dt
	while self.timer > coinblockdelay do
		self.frame = self.frame + 1
		self.timer = self.timer - coinblockdelay
	end
	
	if self.frame >= 31 then
		addpoints(-200, self.x, self.y)
		return true
	end
	
	return false
end