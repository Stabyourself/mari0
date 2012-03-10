bowser = class:new()

function bowser:init(x, y, i)
	--PHYSICS STUFF
	self.x = x+4
	self.y = y-27/16
	self.level = i or marioworld
	self.startx = x+12
	self.starty = y
	self.speedy = 0
	self.speedx = 0
	self.width = 30/16
	self.height = 28/16
	self.static = false
	self.active = true
	self.emancipatecheck = true
	self.category = 16
	
	self.mask = {	true,
					false, false, false, false, true,
					false, true, false, true, false,
					false, false, true, true, false,
					true, true, false, false, true,
					false, true, true, false, false,
					true, false, true, true, true}
	
	self.gravity = bowsergravity
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = bowserimg
	self.quad = bowserquad[1][1]
	self.walkframe = 1
	self.offsetX = 14
	self.offsetY = -2
	self.quadcenterX = 16
	self.quadcenterY = 12
	
	self.rotation = 0 --for portals
	self.jump = false
	
	self.animationtimer = 0
	self.animationdirection = "right"
	self.fireframe = 1
	self.timer = 0
	self.hammertimer = 0
	self.hammertime = 1 --Stop!
	self.hammers = false
	if self.level >= 6 then
		self.hammers = true
	end
	
	self.hp = bowserhealth
	
	self.shot = false
	self.fall = false
	
	self:newtargetx("right")
end

function bowser:update(dt)
	if self.shot then
		self.speedy = self.speedy + shotgravity*dt
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		
		if self.speedy > bowserfallspeed then
			self.speedy = bowserfallspeed
		end
		
		return false
	else
		if self.speedy > bowserfallspeed then
			self.speedy = bowserfallspeed
		end

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
		
		if not self.fall then
			self.animationtimer = self.animationtimer + dt
			while self.animationtimer > bowseranimationspeed do
				self.animationtimer = self.animationtimer - bowseranimationspeed
				if self.walkframe == 1 then
					self.walkframe = 2
				else
					self.walkframe = 1
				end
			end
			
			if self.x < self.targetx then
				self.speedx = bowserspeedforwards
				if self.x+self.speedx*dt >= self.targetx then
					self:newtargetx("left")
				end
			else
				self.speedx = -bowserspeedforwards
				if self.x+self.speedx*dt <= self.targetx then
					self:newtargetx("right")
				end
			end
			
			--stop, hammertime
			if self.hammers and self.backwards == false then
				self.hammertimer = self.hammertimer + dt
				while self.hammertimer > self.hammertime do
					table.insert(objects["hammer"], hammer:new(self.x+4/16, self.y+.5, "left"))
					self.hammertimer = self.hammertimer - self.hammertime
					
					--new delay
					self.hammertime = bowserhammertable[math.random(#bowserhammertable)]
				end
			end
		end
		
		if self.backwards == false and firestarted and firetimer > firedelay-0.5 then
			self.fireframe = 2
			self.speedx = 0
		else
			self.fireframe = 1
		end
		
		self.quad = bowserquad[self.fireframe][self.walkframe]
		
		--left of player override
		if not self.fall then
			if objects["player"][getclosestplayer(self.x+15/16)].x > self.x+15/16 and self.jump == false then
				self.animationdirection = "left"
				self.speedx = bowserspeedbackwards
				self.backwards = true
			else
				self.backwards = false
				self.animationdirection = "right"
				self.timer = self.timer + dt
				if self.timer > bowserjumpdelay and self.jump == false then
					self.speedy = -bowserjumpforce
					self.jump = true
					self.timer = self.timer - bowserjumpdelay
				end
			end
		end
	end
	
	return false
end

function bowser:draw()
	--just for the hammers
	if not self.fall and not self.backwards then
		if self.hammertimer > self.hammertime - bowserhammerdrawtime then
			love.graphics.drawq(hammerimg, hammerquad[spriteset][1], math.floor((self.x-xscroll)*16*scale), (self.y-.5-11/16)*16*scale, 0, scale, scale)
		end
	end
end

function bowser:newtargetx(dir)
	if dir == "right" then
		self.targetx = self.startx-1-math.random(2)
	else
		self.targetx = self.startx-7-math.random(2)
	end
end

function bowser:shotted(dir)
	self.hp = self.hp - 1
	if self.hp == 0 then
		self:firedeath()
	end
end

function bowser:firedeath()
	playsound(shotsound)
	playsound(bowserfallsound)
	self.shot = true
	self.speedy = -shotjumpforce
	self.direction = dir or "right"
	self.active = false
	self.gravity = shotgravity
	self.speedx = 0
	
	addpoints(firepoints["bowser"], self.x+self.width/2, self.y)
	
	--image
	if marioworld <= 7 then
		self.graphic = decoysimg
		self.quad = decoysquad[marioworld]
	end
end

function bowser:leftcollide(a, b)
	if a == "player" then
		return false
	end
end

function bowser:rightcollide(a, b)
	if a == "player" then
		return false
	end
end

function bowser:ceilcollide(a, b)
	if a == "player" then
		return false
	end
end

function bowser:startfall()

end

function bowser:floorcollide(a, b)
	if self.jump then
		self.jump = false
		self.timer = 0
	end
	if a == "player" then
		return false
	end
end

function bowser:startfall()
	self.jump = true
end

function bowser:emancipate(a)

	self:shotted()
end