upfire = class:new()

function upfire:init(x, y, r)
	--PHYSICS STUFF
	self.cox = x
	self.coy = y
	self.y = self.coy
	self.x = x-14/16
	
	self.speedy = 0
	self.speedx = 0
	
	self.width = 12/16
	self.height = 12/16
	self.active = true
	self.static = true
	self.drawme = true
	self.gravity = 0
	
	self.jumpheight = 8
	
	self.delay = 0.5
	self.delayrandom = 0
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
	
	--Input list
	self.input1state = "off"
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--HEIGHT
	if #self.r > 0 and self.r[1] ~= "link" then
		self.jumpheight = upfireheightfunction(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
	--WAIT
	if #self.r > 0 and self.r[1] ~= "link" then
		self.startdelay = upfirewaitfunction(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
	--Random add
	if #self.r > 0 and self.r[1] ~= "link" then
		self.delayrandom = upfirerandomfunction(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
	
	self.delay = self.startdelay + self.delayrandom*math.random()
	
	self.force = math.sqrt(2*upfiregravity*(self.jumpheight+1))
end

function upfire:update(dt)
	--animate
	if self.y > self.coy and self.speedy > 0 then
		self.timer = self.timer + dt
		self.drawme = false
		self.active = false
		while self.timer > self.delay do
			self.drawme = true
			self.active = true
			self.y = self.coy
			self.speedy = -self.force
			self.y = self.coy
			self.delay = self.startdelay + self.delayrandom*math.random()
			self.timer = self.timer - self.delay
		end
	end
	
	self.speedy = self.speedy + upfiregravity*dt
	self.y = self.y + self.speedy*dt
	
	return false
end

function upfire:draw()
	if self.drawme then
		local verscale = scale
		if self.speedy > 0 then
			verscale = -scale
		end
		love.graphics.draw(upfireimg, (self.x-xscroll-2/16)*16*scale, (self.y-yscroll-.5+6/16)*16*scale, 0, scale, verscale, 0, 8)
	end
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