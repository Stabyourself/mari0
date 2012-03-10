goomba = class:new()

function goomba:init(x, y, t)
	--PHYSICS STUFF
	self.x = x-6/16
	self.y = y-11/16
	self.speedy = 0
	self.speedx = -goombaspeed
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.category = 4
	
	self.mask = {	true, 
					false, false, false, false, true,
					false, true, false, true, false,
					false, false, true, false, false,
					true, true, false, false, false,
					false, true, true, false, false,
					true, false, true, true, true}
	
	self.emancipatecheck = true
	self.autodelete = true
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = goombaimage
	self.quad = goombaquad[spriteset][1]
	self.offsetX = 6
	self.offsetY = 3
	self.quadcenterX = 8
	self.quadcenterY = 8
	
	self.rotation = 0 --for portals
	
	self.direction = "left"
	self.animationtimer = 0
	self.t = t or "goomba"
	
	if self.t == "spikeyair" then
		self.air = true
		self.t = "spikey"
	end
	
	if self.t == "goomba" then
		self.animationdirection = "left"
	elseif self.t == "spikey" or self.t == "spikeyfall" then
		self.graphic = spikeyimg
		self.fall = true
		if self.t == "spikey" then
			self.quadi = 1
		else
			self.mask[21] = true
			self.starty = self.y
			self.gravity = 30
			self.speedy = -10
			self.quadi = 3
			self.speedx = 0
		end
		self.quad = spikeyquad[self.quadi]
	end
	
	self.falling = false
	
	self.dead = false
	self.deathtimer = 0
	
	self.shot = false
end

function goomba:update(dt)
	--rotate back to 0 (portals)
	if self.t == "spikeyfall" then
		self.rotation = 0
	else
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
	end
	
	if self.dead then
		self.deathtimer = self.deathtimer + dt
		if self.deathtimer > goombadeathtime then
			return true
		else
			return false
		end
		
	elseif self.shot then
		self.speedy = self.speedy + shotgravity*dt
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		
		return false
		
	else
		self.animationtimer = self.animationtimer + dt
		while self.animationtimer > goombaanimationspeed do
			self.animationtimer = self.animationtimer - goombaanimationspeed
			if self.t == "goomba" then
				if self.animationdirection == "left" then
					self.animationdirection = "right"
				else
					self.animationdirection = "left"
				end
			elseif self.t == "spikey" then
				if self.quadi == 1 then
					self.quadi = 2
				else
					self.quadi = 1
				end
				self.quad = spikeyquad[self.quadi]
			elseif self.t == "spikeyfall" then
				if self.quadi == 3 then
					self.quadi = 4
				else
					self.quadi = 3
				end
				self.quad = spikeyquad[self.quadi]
				
				if self.mask[21] and self.y > self.starty+2 then
					self.mask[21] = false
				end
			end
		end
		
		if self.t ~= "spikeyfall" then
			if self.speedx > 0 then
				if self.speedx > goombaspeed then
					self.speedx = self.speedx - friction*dt*2
					if self.speedx < goombaspeed then
						self.speedx = goombaspeed
					end
				elseif self.speedx < goombaspeed then
					self.speedx = self.speedx + friction*dt*2
					if self.speedx > goombaspeed then
						self.speedx = goombaspeed
					end
				end
			else
				if self.speedx < -goombaspeed then
					self.speedx = self.speedx + friction*dt*2
					if self.speedx > -goombaspeed then
						self.speedx = -goombaspeed
					end
				elseif self.speedx > -goombaspeed then
					self.speedx = self.speedx - friction*dt*2
					if self.speedx < -goombaspeed then
						self.speedx = -goombaspeed
					end
				end
			end
		end
		
		--check if goomba offscreen		
		return false
	end
end

function goomba:stomp()--hehe goomba stomp
	self.dead = true
	self.active = false
	self.quad = goombaquad[spriteset][2]
end

function goomba:shotted(dir) --fireball, star, turtle
	playsound(shotsound)
	self.shot = true
	self.speedy = -shotjumpforce
	self.direction = dir or "right"
	self.active = false
	self.gravity = shotgravity
	if self.direction == "left" then
		self.speedx = -shotspeedx
	else
		self.speedx = shotspeedx
	end
end

function goomba:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	self.speedx = goombaspeed
	
	if self.t == "spikey" then
		self.animationdirection = "left"
	end
	
	return false
end

function goomba:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	self.speedx = -goombaspeed
	
	if self.t == "spikey" then
		self.animationdirection = "right"
	end
	
	return false
end

function goomba:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function goomba:globalcollide(a, b)
	if a == "bulletbill" then
		if b.killstuff ~= false then
			return true
		end
	end
	
	if a == "fireball" or a == "player" then
		return true
	end
	
	if self.t == "spikeyfall" and a == "lakito" then
		return true
	end
end

function goomba:startfall()

end

function goomba:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	if self.t == "spikeyfall" then
		self.t = "spikey"
		self.fall = false
		self.quadi = 1
		self.quad = spikeyquad[self.quadi]
		self.gravity = nil
		local nearestplayer = 1
		local nearestplayerx = objects["player"][1].x
		for i = 2, players do
			local v = objects["player"][i]
			if math.abs(self.x - v.x) < nearestplayerx then
				nearestplayer = i
				nearestplayerx = v.x
			end
		end
		
		if self.x >= nearestplayerx then
			self.speedx = -goombaspeed
		else
			self.speedx = goombaspeed
			self.animationdirection = "left"
		end
	end
end

function goomba:passivecollide(a, b)
	self:leftcollide(a, b)
	return false
end

function goomba:emancipate(a)
	self:shotted()
end

function goomba:laser()
	self:shotted()
end