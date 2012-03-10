plant = class:new()

function plant:init(x, y)
	self.cox = x
	self.coy = y
	
	self.timer = 0
	
	self.x = x-8/16
	self.y = y+9/16
	self.starty = self.y
	self.width = 16/16
	self.height = 14/16
	
	self.static = true
	self.active = true
	
	self.destroy = false
	
	self.category = 29
	
	self.mask = {true}
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = plantimg
	self.quad = plantquads[spriteset][1]
	self.offsetX = 0
	self.offsetY = 17
	self.quadcenterX = 0
	self.quadcenterY = 0
	
	self.customscissor = {x-1, y-2, 2, 2}
	
	self.quadnum = 1
	self.timer1 = 0
	self.timer2 = plantouttime+1.5
end

function plant:update(dt)
	self.timer1 = self.timer1 + dt
	while self.timer1 > plantanimationdelay do
		self.timer1 = self.timer1 - plantanimationdelay
		if self.quadnum == 1 then
			self.quadnum = 2
		else
			self.quadnum = 1
		end
		self.quad = plantquads[spriteset][self.quadnum]
	end
	
	self.timer2 = self.timer2 + dt
	if self.timer2 < plantouttime then
		self.y = self.y - plantmovespeed*dt
		if self.y < self.starty - plantmovedist then
			self.y = self.starty - plantmovedist
		end
	elseif self.timer2 < plantouttime+plantintime then
		self.y = self.y + plantmovespeed*dt
		if self.y > self.starty then
			self.y = self.starty
		end
	else
		for i = 1, players do
			local v = objects["player"][i]
			if inrange(v.x+v.width/2, self.x+self.width/2-3, self.x+self.width/2+3) then --no player near
				return
			end
		end
		self.timer2 = 0
	end
	
	return self.destroy
end

function plant:shotted()
	playsound(shotsound)
	self.destroy = true
	self.active = false
end