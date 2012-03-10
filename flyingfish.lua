flyingfish = class:new()

function flyingfish:init()
	self.y = 15
	self.x = math.random(math.floor(splitxscroll[1]), math.floor(splitxscroll[1])+width)
	self.width = 12/16
	self.height = 12/16
	self.rotation = 0 --for portals
	
	self.speedy = -flyingfishforce
	self.speedx = objects["player"][1].speedx + math.random(10)-5
	
	self.active = true
	self.static = false
	self.autodelete = true
	self.gravity = flyingfishgravity
	self.category = 27
	
	self.mask = {	true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true}
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = cheepcheepimg
	self.quad = cheepcheepquad[1][1]
	self.offsetX = 6
	self.offsetY = 3
	self.quadcenterX = 8
	self.quadcenterY = 8
	
	self.mask = {true, true}
	
	if self.speedx == 0 then
		self.speedx = 1
	end
	
	if self.speedx > 0 then
		self.animationdirection = "left"
	else
		self.animationdirection = "right"
	end
	self.animationtimer = 0
	
	self.shot = false
	
	--seems like they take the player's speed and add a random number from -x to x
	--height is always the same at about "2 pixels above middle of lower font row"
end

function flyingfish:update(dt)
	--rotate back to 0 (portals)
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
	
	if self.shot then
		self.speedy = self.speedy + shotgravity*dt
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		
		return false
		
	else
		self.animationtimer = self.animationtimer + dt
		while self.animationtimer > cheepanimationspeed do
			self.animationtimer = self.animationtimer - cheepanimationspeed
			if self.frame == 1 then
				self.frame = 2
			else
				self.frame = 1
			end
			self.quad = cheepcheepquad[1][self.frame]
		end
		
		return false
	end
end

function flyingfish:shotted(dir) --fireball, star, turtle
	playsound(shotsound)
	self.shot = true
	self.active = false
	self.gravity = shotgravity
	self.speedy = -shotjumpforce
	self.direction = dir or "right"
	if self.direction == "left" then
		self.speedx = -shotspeedx
	else
		self.speedx = shotspeedx
	end
end

function flyingfish:rightcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function flyingfish:leftcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function flyingfish:ceilcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function flyingfish:floorcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function flyingfish:globalcollide(a, b)
	return true	
end

function flyingfish:stomp()
	self:shotted()
end