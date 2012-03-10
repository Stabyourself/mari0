platformspawner = class:new()

function platformspawner:init(x, y, direction, size)
	self.x = x
	self.y = y
	self.direction = direction
	self.timer = 0
	
	self.size = size
end

function platformspawner:update(dt)
	self.timer = self.timer + dt
	if self.timer > platformspawndelay then
		if self.direction == "up" then
			table.insert(objects["platform"], platform:new(self.x, self.y+1, "justup", self.size))
		else
			table.insert(objects["platform"], platform:new(self.x, self.y-0.5, "justdown", self.size))
		end
		
		self.timer = self.timer - platformspawndelay
	end
	
	if self.x < xscroll - .5 then
		return true
	end
end