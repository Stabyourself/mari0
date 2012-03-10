seesaw = class:new()

--settings for the types
seesawtype = {}
seesawtype[1] = {7,4,6,3}
seesawtype[2] = {4,2,6,3}
seesawtype[3] = {7,3,6,3}
seesawtype[4] = {8,3,7,3}
seesawtype[5] = {5,3,7,3}
seesawtype[6] = {6,3,7,3}
seesawtype[7] = {4,3,7,1.5}
seesawtype[8] = {3,3,7,1.5}
seesawtype[9] = {3,4,7,1.5}


function seesaw:init(x, y, t)
	self.x = x
	self.y = y
	
	if t == nil then
		t = 1
	end
	
	self.range = seesawtype[t][1]
	self.dist1 = seesawtype[t][2]
	self.dist2 = seesawtype[t][3]
	
	self.lcount = 0
	self.rcount = 0
	self.falloff = false
	
	self.leftplatform = seesawplatform:new(self.x, self.y+self.dist1, seesawtype[t][4], self, "left")
	self.rightplatform = seesawplatform:new(self.x+self.range, self.y+self.dist2, seesawtype[t][4], self, "right")
	
	table.insert(objects["seesawplatform"], self.leftplatform)
	table.insert(objects["seesawplatform"], self.rightplatform)
end

function seesaw:update(dt)
	if self.falloff then
		self.leftplatform.speedy = self.leftplatform.speedy + seesawgravity*dt
		self.rightplatform.speedy = self.rightplatform.speedy + seesawgravity*dt
	else
		local speed = self.lcount - self.rcount
		
		self.leftplatform.speedy = self.leftplatform.speedy + speed*seesawspeed*dt
		self.rightplatform.speedy = self.rightplatform.speedy - speed*seesawspeed*dt
		
		if self.leftplatform.speedy > 0 and speed <= 0 then
			self.leftplatform.speedy = self.leftplatform.speedy - seesawfriction*dt
			if speed == 0 and self.leftplatform.speedy < 0 then
				self.leftplatform.speedy = 0
			end
		elseif self.leftplatform.speedy < 0 and speed >= 0 then
			self.leftplatform.speedy = self.leftplatform.speedy + seesawfriction*dt
		end
	
		if self.rightplatform.speedy > 0 and speed >= 0 then
			self.rightplatform.speedy = self.rightplatform.speedy - seesawfriction*dt
			if speed == 0 and self.rightplatform.speedy < 0 then
				self.leftplatform.speedy = 0
			end
		elseif self.rightplatform.speedy < 0 and speed <= 0 then
			self.rightplatform.speedy = self.rightplatform.speedy + seesawfriction*dt
		end
		
		--check if falloff
		if self.leftplatform.y-self.y <= 0 then
			if self.rcount ~= 0 then
				self:fallingoff("right")
			else
				self.leftplatform.y = self.y
				self.rightplatform.y = self.y+self.dist1+self.dist2-2-2/16
			end
		end
		
		if self.rightplatform.y-self.y <= 0 then
			if self.lcount ~= 0 then
				self:fallingoff("left")
			else
				self.rightplatform.y = self.y
				self.leftplatform.y = self.y+self.dist1+self.dist2-2-2/16
			end
		end
	end
end

function seesaw:fallingoff(side)
	self.falloffside = side
	self.falloff = true
	self.leftplatform.speedy = 0
	self.rightplatform.speedy = 0
end

function seesaw:draw()
	--left
	love.graphics.drawq(seesawimg, seesawquad[1], math.floor((self.x-1-xscroll)*16*scale), (self.y-1.5)*16*scale, 0, scale, scale)
	
	if self.falloff == false and self.leftplatform.y-self.y >= 0 then
		love.graphics.setScissor((self.x-1-xscroll)*16*scale, (self.y-0.5)*16*scale, 16*scale, math.floor((self.leftplatform.y-self.y)*16*scale))
		for i = 1, math.ceil(self.leftplatform.y-self.y) do
			love.graphics.drawq(seesawimg, seesawquad[3], math.floor((self.x-1-xscroll)*16*scale), (self.y+i-1.5)*16*scale, 0, scale, scale)
		end
		love.graphics.setScissor()
	else
		if self.falloffside == "left" then
			for i = 1, self.dist1+self.dist2-2 do
				love.graphics.drawq(seesawimg, seesawquad[3], math.floor((self.x-1-xscroll)*16*scale), (self.y+i-1.5)*16*scale, 0, scale, scale)
			end
		end
	end
		
	
	--middle
	for i = 1, self.range-1 do
		love.graphics.drawq(seesawimg, seesawquad[4], math.floor((self.x-1+i-xscroll)*16*scale), (self.y-1.5)*16*scale, 0, scale, scale)
	end
		
	--right
	love.graphics.drawq(seesawimg, seesawquad[2], math.floor((self.x-1+self.range-xscroll)*16*scale), (self.y-1.5)*16*scale, 0, scale, scale)
	
	if self.falloff == false and self.rightplatform.y-self.y >= 0 then
		love.graphics.setScissor((self.x-1+self.range-xscroll)*16*scale, (self.y-0.5)*16*scale, 16*scale, math.floor((self.rightplatform.y-self.y)*16*scale))
		for i = 1, math.ceil(self.rightplatform.y-self.y) do
			love.graphics.drawq(seesawimg, seesawquad[3], math.floor((self.x+self.range-1-xscroll)*16*scale), (self.y+i-1.5)*16*scale, 0, scale, scale)
		end
		love.graphics.setScissor()
	else
		if self.falloffside == "right" then
			for i = 1, self.dist1+self.dist2-2 do
				love.graphics.drawq(seesawimg, seesawquad[3], math.floor((self.x+self.range-1-xscroll)*16*scale), (self.y+i-1.5)*16*scale, 0, scale, scale)
			end
		end
	end
end

function seesaw:callbackleft(i)
	self.lcount = i
end

function seesaw:callbackright(i)
	self.rcount = i
end