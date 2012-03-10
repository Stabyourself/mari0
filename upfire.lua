upfire = class:new()

function upfire:init(x, y)
	--PHYSICS STUFF
	self.cox = x
	self.coy = y
	self.y = 15
	self.x = x-14/16
	
	self.speedy = 0
	self.speedx = 0
	
	self.width = 12/16
	self.height = 12/16
	self.active = true
	self.static = true
	self.gravity = 0
	
	self.delay = 0
	self.category = 31
	
	self.mask = {	true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true}
	
	--IMAGE STUFF
	self.drawable = false
	
	self.rotation = 0 --for portals
	self.timer = 0
end

function upfire:update(dt)
	--animate
	if self.y > 15 and self.speedy > 0 then
		self.timer = self.timer + dt
		while self.timer > self.delay do
			self.y = self.coy + upfirestarty
			self.speedy = -upfireforce
			self.y = 15
			self.delay = math.random(0, 40)/10
			self.timer = self.timer - self.delay
		end
	end
	
	self.speedy = self.speedy + upfiregravity*dt
	self.y = self.y + self.speedy*dt
	
	return false
end

function upfire:draw()
	local verscale = scale
	if self.speedy > 0 then
		verscale = -scale
	end
	love.graphics.draw(upfireimg, (self.x-xscroll-2/16)*16*scale, (self.y-.5+6/16)*16*scale, 0, scale, verscale, 0, 8)
end

function upfire:leftcollide(a, b)
	return false
end

function upfire:rightcollide(a, b)
	return false
end

function upfire:floorcollide(a, b)
	return false
end

function upfire:ceilcollide(a, b)
	return false
end