squid = class:new()

function squid:init(x, y, color)
	self.x = x-1+2/16
	self.y = y-1+4/16
	self.width = 12/16
	self.height = 12/16
	self.rotation = 0 --for portals
	
	self.speedy = 0
	self.speedx = 0
	
	self.active = true
	self.static = false
	self.autodelete = true
	self.gravity = 0
	self.category = 30
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = squidimg
	self.quad = squidquad[1]
	self.offsetX = 6
	self.offsetY = 3
	self.quadcenterX = 8
	self.quadcenterY = 8
	
	self.mask = {	true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true}
	
	self.direction = "left"
	
	self.timer = 0
	self.state = "idle"
	
	self.shot = false
end

function squid:update(dt)
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
		--get nearest player
		closestplayer = 1
		for i = 2, players do
			local v = objects["player"][i]
			if math.abs(self.x - v.x) < math.abs(self.x - objects["player"][closestplayer].x) then
				closestplayer = i
			end
		end
		
		if self.state == "idle" then
			self.speedy = squidfallspeed
			
			--get if change state to upward
			if (self.y+self.speedy*dt) + self.height + 0.0625 >= (objects["player"][closestplayer].y - (24/16 - objects["player"][closestplayer].height)) then
				self.state = "upward"
				self.upx = self.x
				self.speedx = 0
				self.speedy = 0
				
				--get if to change direction
				if true then--math.random(2) == 1 then
					if self.direction == "right" then
						if self.x > objects["player"][closestplayer].x then
							self.direction = "left"
						end
					else
						if self.x < objects["player"][closestplayer].x then
							self.direction = "right"
						end
					end
				end
			end
			
		elseif self.state == "upward" then
			if self.direction == "right" then
				self.speedx = self.speedx + squidacceleration*dt
				if self.speedx > squidxspeed then
					self.speedx = squidxspeed
				end
			else
				self.speedx = self.speedx - squidacceleration*dt
				if self.speedx < -squidxspeed then
					self.speedx = -squidxspeed
				end
			end
			
			self.speedy = self.speedy - squidacceleration*dt
			
			if self.speedy < -squidupspeed then
				self.speedy = -squidupspeed
			end
			
			if math.abs(self.x - self.upx) >= 2 then
				self.state = "downward"
				self.quad = squidquad[2]
				self.downy = self.y
				self.speedx = 0
			end
			
		elseif self.state == "downward" then
			self.speedy = squidfallspeed
			if self.y > self.downy + squiddowndistance then
				self.state = "idle"
				self.quad = squidquad[1]
			end
		end
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		
		return false
	end
end

function squid:shotted(dir) --fireball, star, turtle
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

function squid:rightcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function squid:leftcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function squid:ceilcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function squid:floorcollide(a, b)
	if self:globalcollide() then
		return false
	end
	
end

function squid:globalcollide(a, b)
	return true	
end