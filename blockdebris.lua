blockdebris = class:new()

function blockdebris:init(x, y, speedx, speedy)
	self.x = x
	self.y = y
	self.speedx = speedx
	self.speedy = speedy
	
	self.timer = 0
	self.frame = 1
end

function blockdebris:update(dt)
	self.timer = self.timer + dt
	while self.timer > blockdebrisanimationtime do
		self.timer = self.timer - blockdebrisanimationtime
		if self.frame == 1 then
			self.frame = 2
		else
			self.frame = 1
		end
	end
	
	self.speedy = self.speedy + blockdebrisgravity*dt
	
	self.x = self.x + self.speedx*dt
	self.y = self.y + self.speedy*dt
	
	
	if self.y > 15 then
		return true
	end
	
	return false
end

function blockdebris:draw()
	love.graphics.drawq(blockdebrisimage, blockdebrisquads[spriteset][self.frame], math.floor((self.x-xscroll)*16*scale), math.floor((self.y-.5)*16*scale), 0, scale, scale, 4, 4)
end