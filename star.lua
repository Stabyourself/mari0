star = class:new()

function star:init(x, y)
	--PHYSICS STUFF
	self.x = x-6/16
	self.y = y-11/16
	self.speedy = 0
	self.speedx = 0
	self.width = 12/16
	self.height = 12/16
	self.static = true
	self.active = true
	self.category = 6
	self.mask = {	true,
					false, false, true, true, true,
					false, true, false, true, true,
					false, true, true, false, true,
					true, true, false, true, true,
					false, true, true, false, false,
					true, false, true, true, true}
	self.destroy = false
	self.gravity = 40
	self.autodelete = true
	
	--IMAGE STUFF
	self.drawable = false
	self.graphic = starimg
	self.quad = starquad[1]
	self.offsetX = 7
	self.offsetY = 3
	self.quadcenterX = 9
	self.quadcenterY = 8
	
	self.rotation = 0 --for portals
	self.uptimer = 0
	self.timer = 0
	self.quadi = 1
	
	self.falling = false
end

function star:update(dt)
	--rotate back to 0 (portals)
	self.rotation = math.mod(self.rotation, math.pi*2)
	if self.rotation > 0 then
		self.rotation = self.rotation - portalrotationalignmentspeed*dt
		if self.rotation < 0 then
			self.rotation = 0
		end
	elseif self.rotation < 0 then
		self.rotation = self.rotation + portalrotationalignmentspeed*dt
		if self.rotation > 0 then
			self.rotation = 0
		end
	end
	
	if self.uptimer < mushroomtime then
		self.uptimer = self.uptimer + dt
		self.y = self.y - dt*(1/mushroomtime)
		self.speedx = mushroomspeed
	else
		if self.static == true then
			self.static = false
			self.active = true
			self.drawable = true
			self.speedy = -starjumpforce/2
		end
	end
	
	--animate
	self.timer = self.timer + dt
	while self.timer > staranimationdelay do
		self.quadi = self.quadi + 1
		if self.quadi == 5 then
			self.quadi = 1
		end
		self.quad = starquad[self.quadi]
		self.timer = self.timer - staranimationdelay
	end
	
	if self.destroy then
		return true
	else
		return false
	end
end

function star:draw()
	if self.drawable == false then
		--Draw it coming out of the block.
		love.graphics.drawq(self.graphic, self.quad, math.floor(((self.x-xscroll)*16+self.offsetX)*scale), math.floor((self.y*16-self.offsetY)*scale), 0, scale, scale, self.quadcenterX, self.quadcenterY)
	end
end

function star:leftcollide(a, b)
	self.speedx = mushroomspeed
	
	if a == "player" then
		b:star()
		self.destroy = true
	end
	
	return false
end

function star:rightcollide(a, b)
	self.speedx = -mushroomspeed
	
	if a == "player" then
		b:star()
		self.destroy = true
	end
	
	return false
end

function star:floorcollide(a, b)
	if self.active and a == "player" then
		b:star()
		self.destroy = true
	end	
	
	self.speedy = -starjumpforce
	return false
end

function star:ceilcollide(a, b)
	if self.active and a == "player" then
		b:star()
		self.destroy = true
	end
end

function star:jump(x)
	self.falling = true
	self.speedy = -mushroomjumpforce
	if self.x+self.width/2 < x-0.5 then
		self.speedx = -mushroomspeed
	elseif self.x+self.width/2 > x-0.5 then
		self.speedx = mushroomspeed
	end
end