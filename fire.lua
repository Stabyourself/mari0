fire = class:new()

function fire:init(x, y)
	--PHYSICS STUFF
	if objects["bowser"][1] then --make bowser fire this
		self.y = objects["bowser"][1].y+0.25
		self.x = objects["bowser"][1].x-0.750
		
		--get goal Y
		self.targety = objects["bowser"][1].starty-math.random(3)+2/16
		self.source = "bowser"
	else
		self.y = y-1+1/16
		self.targety = self.y
		self.x = x+6/16
		self.source = "none"
	end
	
	self.speedy = 0
	self.speedx = -firespeed
	
	self.width = 24/16
	self.height = 8/16
	self.active = true
	self.static = true
	self.autodelete = true
	self.gravity = 0
	self.category = 17
	
	self.mask = {	true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true}
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = fireimg
	self.quad = firequad[1]
	self.offsetX = 0
	self.offsetY = 8
	self.quadcenterX = 0
	self.quadcenterY = 0
	
	self.rotation = 0 --for portals
	self.timer = 0
	self.quadi = 1
	
	playsound(firesound)
end

function fire:update(dt)
	--animate
	self.timer = self.timer + dt
	while self.timer > fireanimationdelay do
		if self.quadi == 2 then
			self.quadi = 1
		else
			self.quadi = 2
		end
		
		self.quad = firequad[self.quadi]
		self.timer = self.timer - fireanimationdelay
	end
	
	self.x = self.x + self.speedx*dt
	
	if self.y > self.targety then
		self.y = self.y - fireverspeed*dt
		if self.y < self.targety then
			self.y = self.targety
		end
	elseif self.y < self.targety then
		self.y = self.y + fireverspeed*dt
		if self.y > self.targety then
			self.y = self.targety
		end
	end
end

function fire:leftcollide(a, b)
	return false
end

function fire:rightcollide(a, b)
	return false
end

function fire:floorcollide(a, b)
	return false
end

function fire:ceilcollide(a, b)
	return false
end