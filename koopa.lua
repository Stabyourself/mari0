koopa = class:new()

--combo: 500, 800, 1000, 2000, 4000, 5000

function koopa:init(x, y, t)
	--PHYSICS STUFF
	self.x = x-6/16
	self.y = y-11/16
	self.speedy = 0
	self.speedx = -koopaspeed
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.category = 5
	
	self.mask = {	true, 
					false, false, false, false, true,
					false, true, false, true, false,
					false, false, true, false, false,
					true, true, false, false, true,
					false, true, true, false, false,
					true, false, true, true, true}
	
	self.autodelete = true
	self.t = t
	self.flying = false
	self.startx = self.x
	self.starty = self.y
	self.quad = koopaquad[spriteset][1]
	self.combo = 1
	
	--IMAGE STUFF
	self.drawable = true
	if self.t == "red" then
		self.graphic = kooparedimage
	elseif self.t == "redflying" then
		self.graphic = kooparedimage
		self.flying = true
		self.gravity = 0
		self.quad = koopaquad[spriteset][4]
		self.speedx = 0
		self.timer = 0
	elseif self.t == "flying" then
		self.flying = true
		self.quad = koopaquad[spriteset][4]
		self.graphic = koopaimage
		self.gravity = koopaflyinggravity
	elseif self.t == "beetle" then
		self.graphic = beetleimage
	else
		self.graphic = koopaimage
	end
	self.offsetX = 6
	self.offsetY = 0
	self.quadcenterX = 8
	self.quadcenterY = 19
	
	self.rotation = 0
	self.direction = "left"
	self.animationdirection = "right"
	self.animationtimer = 0
	
	self.small = false
	self.moving = true
	
	self.falling = false
	
	self.shot = false
end	

function koopa:func(i) -- 0-1 in please
	return (-math.cos(i*math.pi*2)+1)/2
end

function koopa:update(dt)
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
		
		return false
		
	else
		if self.speedx > 0 then
			self.animationdirection = "left"
		else
			self.animationdirection = "right"
		end
		--red koopa turn around
		if self.falling == false and self.flying == false and (self.t == "red" or self.t == "redflying") and self.small == false then
			--check if nothing below
			local x = math.floor(self.x + self.width/2+1)
			local y = math.floor(self.y + self.height+1.5)
			if inmap(x, y) and tilequads[map[x][y][1]].collision == false and ((inmap(x+.5, y) and tilequads[map[math.ceil(x+.5)][y][1]].collision) or (inmap(x-.5, y) and tilequads[map[math.floor(x-.5)][y][1]].collision)) then
				if self.speedx < 0 then
					self.animationdirection = "left"
					self.x = x-self.width/2
				else
					self.animationdirection = "right"
					self.x = x-1-self.width/2
				end
				self.speedx = -self.speedx
			end
		end
	
		if self.flying == true and self.t == "redflying" then
			self.timer = self.timer + dt
			
			while self.timer > koopaflyingtime do
				self.timer = self.timer - koopaflyingtime
			end
			local newy = self:func(self.timer/koopaflyingtime)*koopaflyingdistance + self.starty
			self.y = newy
		end
	
		if self.small == false then
			self.animationtimer = self.animationtimer + dt
			while self.animationtimer > koopaanimationspeed do
				self.animationtimer = self.animationtimer - koopaanimationspeed
				if not self.flying then
					if self.quad == koopaquad[spriteset][1] then
						self.quad = koopaquad[spriteset][2]
					else
						self.quad = koopaquad[spriteset][1]
					end
				else
					if self.quad == koopaquad[spriteset][4] then
						self.quad = koopaquad[spriteset][5]
					else
						self.quad = koopaquad[spriteset][4]
					end
				end
			end
		end
		
		if self.t ~= "redflying" or self.flying == false then
			if self.small == false then
				if self.speedx > 0 then
					if self.speedx > koopaspeed then
						self.speedx = self.speedx - friction*dt*2
						if self.speedx < koopaspeed then
							self.speedx = koopaspeed
						end
					elseif self.speedx < koopaspeed then
						self.speedx = self.speedx + friction*dt*2
						if self.speedx > koopaspeed then
							self.speedx = koopaspeed
						end
					end
				else
					if self.speedx < -koopaspeed then
						self.speedx = self.speedx + friction*dt*2
						if self.speedx > -koopaspeed then
							self.speedx = -koopaspeed
						end
					elseif self.speedx > -koopaspeed then
						self.speedx = self.speedx - friction*dt*2
						if self.speedx < -koopaspeed then
							self.speedx = -koopaspeed
						end
					end
				end
			else
				if self.speedx > 0 then
					if self.speedx > koopasmallspeed then
						self.speedx = self.speedx - friction*dt*2
						if self.speedx < koopasmallspeed then
							self.speedx = koopasmallspeed
						end
					elseif self.speedx < koopasmallspeed then
						self.speedx = self.speedx + friction*dt*2
						if self.speedx > koopasmallspeed then
							self.speedx = koopasmallspeed
						end
					end
				elseif self.speedx < 0 then
					if self.speedx < -koopasmallspeed then
						self.speedx = self.speedx + friction*dt*2
						if self.speedx > -koopasmallspeed then
							self.speedx = -koopasmallspeed
						end
					elseif self.speedx > -koopasmallspeed then
						self.speedx = self.speedx - friction*dt*2
						if self.speedx < -koopasmallspeed then
							self.speedx = -koopasmallspeed
						end
					end
				end
			end
		end
		
		return false
	end
end

function koopa:stomp(x, b)
	if self.flying then
		self.flying = false
		self.quad = koopaquad[spriteset][1]
		if self.speedx == 0 then
			self.speedx = -koopaspeed
		end
		self.gravity = yacceleration
		return false
	elseif self.small == false then
		self.quadcenterY = 19
		self.offsetY = 0
		self.quad = koopaquad[spriteset][3]
		self.small = true
		self.mask = {false, false, false, false, false, true, false, false, false, true}
		self.speedx = 0
	elseif self.speedx == 0 then
		if self.x > x then
			self.speedx = koopasmallspeed
			self.x = x+12/16+koopasmallspeed*gdt
		else
			self.speedx = -koopasmallspeed
			self.x = x-self.width-koopasmallspeed*gdt
		end
	else
		self.speedx = 0
		self.combo = 1
	end
end

function koopa:shotted(dir) --fireball, star, turtle
	playsound(shotsound)
	self.shot = true
	self.small = true
	self.quad = koopaquad[spriteset][3]
	self.quadcenterY = 19
	self.offsetY = 0
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

function koopa:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	if a == "tile" or a == "portalwall" or a == "spring" then		
		if self.small then
			self.speedx = -self.speedx
			local x, y = b.cox, b.coy
			if a == "tile" then
				hitblock(x, y, {size=2})
			else
				playsound(blockhitsound)
			end
		end
	end
	
	if a ~= "tile" and a ~= "portalwall" and a ~= "platform" and self.small and self.speedx ~= 0 and a ~= "player" and a ~= "spring" then
		if b.shotted then
			if self.combo < #koopacombo then
				self.combo = self.combo + 1
				addpoints(koopacombo[self.combo], b.x, b.y)
			else
				for i = 1, players do
					if mariolivecount ~= false then
						mariolives[i] = mariolives[i]+1
						respawnplayers()
					end
				end
				table.insert(scrollingscores, scrollingscore:new("1up", b.x, b.y))
				playsound(oneupsound)
			end
			b:shotted("left")
		end
	end

	if self.small == false then
		self.animationdirection = "left"
		self.speedx = -self.speedx
	else
		return false
	end
end

function koopa:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end	
	if a == "tile" or a == "portalwall" or a == "spring" then		
		if self.small then
			self.speedx = -self.speedx
			local x, y = b.cox, b.coy
			if a == "tile" then
				hitblock(x, y, {size=2})
			else
				playsound(blockhitsound)
			end
		end
	end
	
	if a ~= "tile" and a ~= "portalwall" and a ~= "platform" and self.small and self.speedx ~= 0 and a ~= "player" and a ~= "spring" then
		if b.shotted then
			if self.combo < #koopacombo then
				self.combo = self.combo + 1
				addpoints(koopacombo[self.combo], b.x, b.y)
			else
				for i = 1, players do
					if mariolivecount ~= false then
						mariolives[i] = mariolives[i]+1
						respawnplayers()
					end
				end
				table.insert(scrollingscores, scrollingscore:new("1up", b.x, b.y))
				playsound(oneupsound)
			end
			b:shotted("right")
		end
	end

	if self.small == false then
		self.animationdirection = "right"
		self.speedx = -self.speedx
	else
		return false
	end
end

function koopa:passivecollide(a, b)
	self:leftcollide(a, b)
	return false
end

function koopa:globalcollide(a, b)
	if a == "bulletbill" then
		if b.killstuff ~= false then
			return true
		end
	end
	if a == "fireball" or a == "player" then
		return true
	end
end

function koopa:emancipate(a)
	self:shotted()
end

function koopa:floorcollide(a, b)
	self.falling = false
	if self.t == "flying" and self.flying then
		if self:globalcollide(a, b) then
			return false
		end
		self.speedy = -koopajumpforce
	end
end

function koopa:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function koopa:laser()
	self:shotted()
end

function koopa:startfall()
	self.falling = true
end