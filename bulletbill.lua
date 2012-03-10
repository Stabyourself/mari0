rocketlauncher = class:new()

function rocketlauncher:init(x, y)
	self.x = x
	self.y = y
	self.id = id
	self:randomtime()
	self.timer = self.time-0.5
	self.autodelete = true
end

function rocketlauncher:update(dt)
	self.timer = self.timer + dt
	if self.timer > self.time and self.x > splitxscroll[1] and self.x < splitxscroll[1]+width+2 then
		if self:fire() then
			self.timer = 0
			self:randomtime()
		end
	end
end

function rocketlauncher:fire()
	if #objects["bulletbill"] >= maximumbulletbills then
		return false
	end
	
	--get nearest player
	local pl = 1
	for i = 2, players do
		if math.abs(objects["player"][i].x + 14/16 - self.x) < math.abs(objects["player"][pl].x + 14/16 - self.x) then
			pl = i
		end
	end
	
	if objects["player"][pl].x + 14/16 > self.x + bulletbillrange then
		table.insert(objects["bulletbill"], bulletbill:new(self.x, self.y, "right"))
		return true
	elseif objects["player"][pl].x + 14/16 < self.x - bulletbillrange then
		table.insert(objects["bulletbill"], bulletbill:new(self.x, self.y, "left"))
		return true
	end
end

function rocketlauncher:randomtime()
	local rand = math.random(bulletbilltimemin*10, bulletbilltimemax*10)/10
	self.time = rand
end

----------------------
bulletbill = class:new()
function bulletbill:init(x, y, dir)
	self.startx = x-14/16
	--PHYSICS STUFF
	self.x = self.startx
	self.y = y-14/16
	self.speedy = 0
	if dir == "left" then
		self.speedx = -bulletbillspeed
		self.customscissor = {self.x-18/16, self.y-2/16, 1, 1}
	else
		self.speedx = bulletbillspeed
		self.customscissor = {self.x+14/16, self.y-2/16, 1, 1}
	end
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.gravity = 0
	self.rotation = 0
	self.autodelete = true
	self.timer = 0
	
	--IMAGE STUFF
	self.drawable = true
	self.quad = bulletbillquad[spriteset]
	self.offsetX = 6
	self.offsetY = 2
	self.quadcenterX = 8
	self.quadcenterY = 8
	self.graphic = bulletbillimg
	
	self.category = 11
	self.animationdirection = dir
	
	self.mask = {	true, 
					true, false, false, false, true,
					true, true, true, true, true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true}
					
	self.shot = false
	
	playsound(bulletbillsound)
end

function bulletbill:update(dt)
	if self.x < self.startx - 1 or self.x > self.startx + 1 then
		self.customscissor = nil
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
		self.timer = self.timer + dt
		if self.timer >= bulletbilllifetime then
			return true
		end
	
		if self.rotation ~= 0 then
			if math.abs(math.abs(self.rotation)-math.pi/2) < 0.1 then
				self.rotation = -math.pi/2
			else
				self.rotation = 0
			end
		end
		
		if self.speedx < 0 then
			self.animationdirection = "left"
		elseif self.speedx > 0 then
			self.animationdirection = "right"
		elseif self.speedy < 0 then
			self.animationdirection = "right"
		elseif self.speedy > 0 then
			self.animationdirection = "left"
		end
	end
end

function bulletbill:stomp(dir) --fireball, star, turtle
	self.shot = true
	self.speedy = 0
	self.direction = dir or "right"
	self.active = false
	self.gravity = shotgravity
	if self.direction == "left" then
		self.speedx = -shotspeedx
	else
		self.speedx = shotspeedx
	end
end

function bulletbill:shotted(dir)
	self:stomp(dir)
end

function bulletbill:rightcollide(a, b)
	self:globalcollide(a, b)
	return false
end

function bulletbill:leftcollide(a, b)
	self:globalcollide(a, b)
	return false
end

function bulletbill:ceilcollide(a, b)
	self:globalcollide(a, b)
	if a == "player" or a == "box" then
		self:stomp()
	end
	return false
end

function bulletbill:floorcollide(a, b)
	self:globalcollide(a, b)
	return false
end

function bulletbill:globalcollide(a, b)
	if self.killstuff then
		if a == "goomba" or a == "koopa" then
			b:shotted("left")
			return true
		end
	else
		return true
	end
end

function bulletbill:portaled()
	self.killstuff = true
end