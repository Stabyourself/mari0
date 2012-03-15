mushroom = class:new()

function mushroom:init(x, y)
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
	self.autodelete = true
	
	--IMAGE STUFF
	self.drawable = false
	self.graphic = entitiesimg
	self.quad = entityquads[2].quad
	self.offsetX = 7
	self.offsetY = 3
	self.quadcenterX = 9
	self.quadcenterY = 8
	
	self.rotation = 0 --for portals
	self.uptimer = 0
	
	self.falling = false
end

function mushroom:update(dt)
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
		end
	end
	
	if self.destroy then
		return true
	else
		return false
	end
end

function mushroom:draw()
	if self.uptimer < mushroomtime and not self.destroy then
		--Draw it coming out of the block.
		love.graphics.drawq(entitiesimg, entityquads[2].quad, math.floor(((self.x-xscroll)*16+self.offsetX)*scale), math.floor((self.y*16-self.offsetY)*scale), 0, scale, scale, self.quadcenterX, self.quadcenterY)
	end
end

function mushroom:leftcollide(a, b)
	self.speedx = mushroomspeed
	
	if a == "player" then
		b:grow()
		self.active = false
		self.destroy = true
		self.drawable = false
	end
	
	return false
end

function mushroom:rightcollide(a, b)
	self.speedx = -mushroomspeed
	
	if a == "player" then
		b:grow()
		self.active = false
		self.destroy = true
		self.drawable = false
	end
	
	return false
end

function mushroom:floorcollide(a, b)
	if a == "player" then
		b:grow()
		self.active = false
		self.destroy = true
		self.drawable = false
	end	
end

function mushroom:ceilcollide(a, b)
	if a == "player" then
		b:grow()
		self.active = false
		self.destroy = true
		self.drawable = false
	end	
end

function mushroom:jump(x)
	self.falling = true
	self.speedy = -mushroomjumpforce
	if self.x+self.width/2 < x-0.5 then
		self.speedx = -mushroomspeed
	elseif self.x+self.width/2 > x-0.5 then
		self.speedx = mushroomspeed
	end
end