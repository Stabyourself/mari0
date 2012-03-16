hammerbro = class:new()

function hammerbro:init(x, y)
	--PHYSICS STUFF
	self.startx = x
	self.starty = y
	self.x = x-6/16
	self.y = y-12/16
	self.speedy = 0
	self.speedx = -hammerbrospeed
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.category = 20
	self.mask = {true, false, false, false, false, true, false, false, false, true}
	self.autodelete = true
	self.gravity = 40
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = hammerbrosimg
	self.quad = hammerbrosquad[spriteset][1]
	self.offsetX = 6
	self.offsetY = 8
	self.quadcenterX = 8
	self.quadcenterY = 21
	
	self.rotation = 0 --for portals
	
	self.direction = "left"
	self.animationtimer = 0
	self.animationdirection = "left"
	
	self.falling = false
	
	self.quadi = 1
	self.timer = hammerbrotime[math.random(2)]
	self.timer2 = 0
	
	self.jumping = false
	
	self.shot = false
end

function hammerbro:update(dt)
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
	
	if self.shot then
		self.speedy = self.speedy + shotgravity*dt
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		
		--check if goomba offscreen
		if self.y > 18 then
			return true
		else
			return false
		end
		
	else
		if self.speedx < 0 then
			if self.x < self.startx-16/16 then
				self.speedx = hammerbrospeed
			end
		else
			if self.x > self.startx then
				self.speedx = -hammerbrospeed
			end
		end
		
		self.timer = self.timer - dt
		if self.timer <= 0 then
			self:throwhammer(self.direction)
			self.timer = hammerbrotime[math.random(2)]
		end
		
		self.timer2 = self.timer2 + dt
		if self.timer2 > hammerbrojumptime then
			self.timer2 = self.timer2 - hammerbrojumptime
			--decide whether up or down
			local dir
			if self.y > 12 then
				dir = "up"
			elseif self.y < 6 then
				dir = "down"
			else
				if math.random(2) == 1 then
					dir = "up"
				else
					dir = "down"
				end
			end
			
			if dir == "up" then
				self.speedy = -hammerbrojumpforce
				self.mask[2] = true
				self.jumping = "up"
			else
				self.speedy = -hammerbrojumpforcedown
				self.mask[2] = true
				self.jumping = "down"
				self.jumpingy = self.y
			end
		end
		
		if self.jumping then
			if self.jumping == "up" then
				if self.speedy > 0 then
					self.jumping = false
					self.mask[2] = false
				end
			elseif self.jumping == "down" then
				if self.y > self.jumpingy + 2 then
					self.jumping = false
					self.mask[2] = false
				end
			end
		end
		
		--turn around?
		--find nearest player
		closestplayer = 1
		for i = 2, players do
			local v = objects["player"][i]
			if math.abs(self.x - v.x) < math.abs(self.x - objects["player"][closestplayer].x) then
				closestplayer = i
			end
		end
		
		if self.direction == "left" and objects["player"][closestplayer].x > self.x then
			self.direction = "right"
			self.animationdirection = "right"
		elseif self.direction == "right" and objects["player"][closestplayer].x < self.x then
			self.direction = "left"
			self.animationdirection = "left"
		end
	
		self.animationtimer = self.animationtimer + dt
		while self.animationtimer > hammerbroanimationspeed do
			self.animationtimer = self.animationtimer - hammerbroanimationspeed
			self.quadi = self.quadi + 1
			if self.quadi == 3 then
				self.quadi = 1
			end
			if self.timer < hammerbropreparetime then
				self.quad = hammerbrosquad[spriteset][self.quadi+2]
			else
				self.quad = hammerbrosquad[spriteset][self.quadi]
			end
		end
		
		if self.speedx > hammerbrospeed then
			self.speedx = self.speedx - friction*dt
			if self.speedx < hammerbrospeed then
				self.speedx = hammerbrospeed
			end
		elseif self.speedx < -hammerbrospeed then
			self.speedx = self.speedx + friction*dt
			if self.speedx > hammerbrospeed then
				self.speedx = -hammerbrospeed
			end
		end
		
		return false
	end
end

function hammerbro:throwhammer(dir)
	table.insert(objects["hammer"], hammer:new(self.x, self.y, dir))
end

function hammerbro:stomp()--hehe hammerbro stomp
	self:shotted()
	self.speedy = 0
end

function hammerbro:shotted() --fireball, star, turtle
	playsound(shotsound)
	self.shot = true
	self.speedy = -shotjumpforce
	self.direction = dir or "right"
	self.active = false
	self.gravity = shotgravity
	self.speedx = 0
end

function hammerbro:leftcollide(a, b)
	self.speedx = goombaspeed
	
	if a == "koopa" then
		if b.small and b.speedx ~= 0 then
			self:shotted("right")
		end
	elseif a == "bulletbill" then
		self:shotted("right")
	elseif a == "hammer" and b.killstuff then
		self:shotted()
	end
	
	return false
end

function hammerbro:rightcollide(a, b)
	self.speedx = -goombaspeed
	
	if a == "koopa" then
		if b.small and b.speedx ~= 0 then
			self:shotted("left")
		end
	elseif a == "bulletbill" then
		self:shotted("left")
	elseif a == "hammer" and b.killstuff then
		self:shotted()
	end
	
	return false
end

function hammerbro:ceilcollide(a, b)
	if a == "player" or a == "box" then
		self:stomp()
	elseif a == "koopa" then
		if b.small and b.speedx ~= 0 then
			self:shotted("left")
		end
	elseif a == "bulletbill" then
		self:shotted("right")
	elseif a == "hammer" and b.killstuff then
		self:shotted()
	end
end

function hammerbro:startfall()
	
end

function hammerbro:floorcollide(a, b)
	if a == "bulletbill" then
		self:shotted("right")
	elseif a == "hammer" and b.killstuff then
		self:shotted()
	end
end

function hammerbro:emancipate(a)
	self:shotted()
end

function hammerbro:portaled()
	self.jumping = false
	self.mask[2] = false
end

-------------------------------
hammer = class:new()

function hammer:init(x, y, dir)
	--PHYSICS STUFF
	self.x = x
	self.y = y-16/16
	self.starty = self.y
	self.speedy = -hammerstarty
	self.speedx = -hammerspeed
	if dir == "right" then
		self.speedx = -self.speedx
	end
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.category = 14
	self.mask = {	true,
					true, false, false, false, true,
					true, true, true, true, true,
					true, false, true, true, true,
					true, true, true, false, true,
					true, true, true, true, true,
					true, true, true, true, true}
	self.emancipatecheck = true
	self.gravity = hammergravity
	self.autodelete = true
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = hammerimg
	self.quadi = 1
	self.quad = hammerquad[spriteset][1]
	self.offsetX = 6
	self.offsetY = 2
	self.quadcenterX = 8
	self.quadcenterY = 8
	
	self.rotation = 0 --for portals
	self.animationdirection = dir
	self.timer = 0
end

function hammer:update(dt)
	self.timer = self.timer + dt
	while self.timer > hammeranimationspeed do
		self.quadi = self.quadi + 1
		if self.quadi == 5 then
			self.quadi = 1
		end
		self.quad = hammerquad[spriteset][self.quadi]
		self.timer = self.timer - hammeranimationspeed
	end
	
	if self.mask[20] and self.y > self.starty + 1 then
		self.mask[20] = false
	end
end

function hammer:leftcollide()
	return false
end

function hammer:rightcollide()
	return false
end

function hammer:floorcollide()
	return false
end

function hammer:ceilcollide()
	return false
end

function hammer:portaled()
	self.killstuff = true
end