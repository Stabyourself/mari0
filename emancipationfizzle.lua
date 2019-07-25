emancipationfizzle = class:new()

function emancipationfizzle:init(x, y, speedx, speedy)
	self.x = x
	self.y = y
	self.r = math.random()*math.pi*2
	self.rotspeed = (math.random()-.5)*2
	self.speedx = speedx+(math.random()-.5)*1
	self.speedy = speedy+(math.random()-.5)*1
	
	self.timer = 0
end

function emancipationfizzle:update(dt)
	self.x = self.x + self.speedx*dt
	self.y = self.y + self.speedy*dt
	
	self.r = self.r + self.rotspeed*dt
	
	self.timer = self.timer + dt
	if self.timer > emancipationfizzletime then
		return true
	end	
	return false
end

function emancipationfizzle:draw()
	love.graphics.setColor(255*(1-self.timer/emancipationfizzletime), 255*(1-self.timer/emancipationfizzletime), 255*(1-self.timer/emancipationfizzletime), 255*(1-self.timer/emancipationfizzletime))
	love.graphics.draw(fizzleimg, (self.x-xscroll)*16*scale, (self.y-yscroll-.5)*16*scale, self.r, scale, scale, 2, 1)
end