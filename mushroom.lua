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
	self.gravitydirection = math.pi/2
	self.uptimer = 0
	
	self.falling = false
end

function mushroom:update(dt)
	self.rotation = unrotate(self.rotation, self.gravitydirection, dt)
	
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

function mushroom:eat(a, b, c, d, overwrite)
	if SERVER or CLIENT then
		if not b.remote then
			local um = usermessage:new( "net_mushroomeat", c .. "~" .. d)
			um:send()
		elseif not overwrite then
			return
		end
	end
	
	b:grow()
	self.active = false
	self.destroy = true
	self.drawable = false
end

function mushroom:draw()
	if self.uptimer < mushroomtime and not self.destroy then
		--Draw it coming out of the block.
		love.graphics.drawq(entitiesimg, entityquads[2].quad, math.floor(((self.x-xscroll)*16+self.offsetX)*scale), math.floor(((self.y-yscroll)*16-self.offsetY)*scale), 0, scale, scale, self.quadcenterX, self.quadcenterY)
	end
end

function mushroom:leftcollide(a, b, c, d)
	self.speedx = mushroomspeed
	
	if a == "player" then
		self:eat(a, b, c, d)
	end
	
	return false
end

function mushroom:rightcollide(a, b, c, d)
	self.speedx = -mushroomspeed
	
	if a == "player" then
		self:eat(a, b, c, d)
	end
	
	return false
end

function mushroom:floorcollide(a, b, c, d)
	if a == "player" then
		self:eat(a, b, c, d)
	end	
end

function mushroom:ceilcollide(a, b, c, d)
	if a == "player" then
		self:eat(a, b, c, d)
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