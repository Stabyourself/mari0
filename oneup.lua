oneup = class:new()

function oneup:init(x, y)
	--PHYSICS STUFF
	self.x = x-6/16
	self.y = y-11/16
	self.speedy = 0
	self.speedx = 0
	self.width = 12/16
	self.height = 12/16
	self.static = true
	self.active = false
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
	self.quad = entityquads[3].quad
	self.offsetX = 7
	self.offsetY = 3
	self.quadcenterX = 9
	self.quadcenterY = 8
	
	self.rotation = 0 --for portals
	self.uptimer = 0
	
	self.falling = false
end

function oneup:update(dt)
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
		
		--check if offscreen
		if self.x < xscroll - width+3 or self.y > 18 then
			return true
		end
		
		if self.destroy then
			return true
		else
			return false
		end
	end
end

function oneup:draw()
	if self.drawable == false then
		--Draw it coming out of the block.
		love.graphics.drawq(entitiesimg, entityquads[3].quad, math.floor(((self.x-xscroll)*16+self.offsetX)*scale), math.floor((self.y*16-self.offsetY)*scale), 0, scale, scale, self.quadcenterX, self.quadcenterY)
	end
end

function oneup:leftcollide(a, b)
	self.speedx = mushroomspeed
	
	if a == "player" then
		givelive(b.playernumber, self)
	end
	
	return false
end

function oneup:rightcollide(a, b)
	self.speedx = -mushroomspeed
	
	if a == "player" then
		givelive(b.playernumber, self)
	end
	
	return false
end

function oneup:floorcollide(a, b)
	if a == "player" then
		givelive(b.playernumber, self)
	end	
end

function oneup:ceilcollide(a, b)
	if a == "player" then
		givelive(b.playernumber, self)
	end	
end

function givelive(id, t)
	if mariolivecount ~= false then
		for i = 1, players do
			mariolives[i] = mariolives[i]+1
			respawnplayers()
		end
	end
	t.destroy = true
	t.active = false
	table.insert(scrollingscores, scrollingscore:new("1up", t.x, t.y))
	playsound(oneupsound)
end	

function oneup:jump(x)
	self.falling = true
	self.speedy = -mushroomjumpforce
	if self.x+self.width/2 < x-0.5 then
		self.speedx = -mushroomspeed
	elseif self.x+self.width/2 > x-0.5 then
		self.speedx = mushroomspeed
	end
end