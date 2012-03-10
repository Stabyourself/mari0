portalparticle = class:new()

function portalparticle:init(x, y, color, direction)
	self.x = x
	self.y = y
	self.timer = 0
	self.color = color
	self.direction = direction
	
	self.speedx, self.speedy = 0, 0
	if self.direction == "left" then
		self.speedx = -portalparticlespeed
	elseif self.direction == "right" then
		self.speedx = portalparticlespeed
	elseif self.direction == "up" then
		self.speedy = -portalparticlespeed
	elseif self.direction == "down" then
		self.speedy = portalparticlespeed
	end
end

function portalparticle:update(dt)
	self.timer = self.timer + dt
	self.x = self.x + self.speedx*dt
	self.y = self.y + self.speedy*dt
	
	self.speedx = self.speedx + math.random(-10, 10)/70
	self.speedy = self.speedy + math.random(-10, 10)/70
	
	if self.direction == "up" then
		if self.speedy > 0 then
			self.speedy = 0
		end
	end
	
	if self.timer > portalparticleduration then
		return true
	end
	
	return false
end

function portalparticle:draw()
	local r, g, b = unpack(self.color)
	local a = (1 - self.timer/portalparticleduration) * 255
	love.graphics.setColor(r, g, b, a)
	love.graphics.draw(portalparticleimg, math.floor((self.x-xscroll)*16*scale), math.floor((self.y-.5)*16*scale), 0, scale, scale, .5, .5)
end