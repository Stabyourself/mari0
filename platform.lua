platform = class:new()

function platform:init(x, y, dir, size)
	--PHYSICS STUFF
	self.size = size or 2
	if (self.size ~= math.floor(self.size)) then
		self.x = x-self.size/2-0.5
	else
		self.x = x-1
	end	
	self.y = y-15/16
	self.startx = self.x
	self.starty = self.y
	self.speedx = 0 --!
	self.speedy = 0
	self.width = self.size
	self.height = 8/16
	self.static = true
	self.active = true
	self.category = 15
	self.mask = {true}
	self.gravity = 0
	
	--IMAGE STUFF
	self.drawable = false
	
	self.rotation = 0
	
	self.dir = dir --(Right, up, Justup, Justdown, justright(bonus stage), fall)
	self.timer = 0
	
	if self.dir == "justup" then
		self.speedy = -platformjustspeed
	elseif self.dir == "justdown" then
		self.speedy = platformjustspeed
	end
end

function platform:func(i) -- 0-1 in please
	return (-math.cos(i*math.pi*2)+1)/2
end

function platform:update(dt)
	if self.dir == "right" or self.dir == "up" then
		self.timer = self.timer + dt
		
		if self.dir == "right" then
			while self.timer > platformhortime do
				self.timer = self.timer - platformhortime
			end
			local newx = (self.startx) - self:func(self.timer/platformhortime)*platformhordistance
			self.speedx = (newx-self.x)/dt
		end
		
		if self.dir == "up" then
			while self.timer > platformvertime do
				self.timer = self.timer - platformvertime
			end
			local newy = self:func(self.timer/platformvertime)*platformverdistance + (self.starty-15/16)
			self.speedy = (newy-self.y)/dt
		end
	end
	
	if self.dir == "right" or self.dir == "justright" then
		self.x = self.x + self.speedx*dt
		local checktable = {}
		for i, v in pairs(enemies) do
			if objects[v] and underwater == false then
				table.insert(checktable, v)
			end
		end
		table.insert(checktable, "player")
		
		for i, v in pairs(checktable) do
			for j, w in pairs(objects[v]) do
				if inrange(w.x, self.x-w.width, self.x+self.width) then
					if w.y == self.y - w.height then
						if #checkrect(w.x+self.speedx*dt, w.y, w.width, w.height, {"exclude", w}, true) == 0 then
							w.x = w.x + self.speedx*dt
						end
					end
				end
			end
		end
	elseif self.dir == "up" or self.dir == "justup" or self.dir == "justdown" then
		if self.dir == "justup" then
			self.speedy = -platformjustspeed
		end
	
		local checktable = {}
		for i, v in pairs(enemies) do
			if objects[v] and underwater == false then
				table.insert(checktable, v)
			end
		end
		table.insert(checktable, "player")
		
		for i, v in pairs(checktable) do
			for j, w in pairs(objects[v]) do
				if not w.jumping and inrange(w.x, self.x-w.width, self.x+self.width) then
					if inrange(w.y, self.y - w.height - 0.1, self.y - w.height + 0.1) then
						w.y = self.y - w.height + self.speedy*dt
					end
				end
			end
		end
		
		self.y = self.y + self.speedy*dt
	elseif self.dir == "fall" then
		local checktable = {}
		for i, v in pairs(enemies) do
			if objects[v] and underwater == false then
				table.insert(checktable, v)
			end
		end
		table.insert(checktable, "player")
		
		local numberofobjects = 0
		for i, v in pairs(checktable) do
			for j, w in pairs(objects[v]) do
				if not w.jumping and inrange(w.x, self.x-w.width, self.x+self.width) then
					if inrange(w.y, self.y - w.height - 0.1, self.y - w.height + 0.1) then
						numberofobjects = numberofobjects + 1
						if #checkrect(w.x, w.y, w.width, w.height, {"exclude", w}) == 0 then
							w.y = self.y - w.height + self.speedy*dt
						end
					end
				end
			end
		end
		
		self.speedy = numberofobjects*4
		
		self.y = self.y + self.speedy*dt
	end
	
	if self.dir == "justup" and self.y < -1 then
		return true
	elseif (self.dir == "justdown" or self.dir == "fall") and self.y > 16 then
		return true
	end
	
	return false
end

function platform:draw()
	for i = 1, self.size do
		if self.dir ~= "justright" then
			love.graphics.draw(platformimg, math.floor((self.x+i-1-xscroll)*16*scale), math.floor((self.y-8/16)*16*scale), 0, scale, scale)
		else
			love.graphics.draw(platformbonusimg, math.floor((self.x+i-1-xscroll)*16*scale), math.floor((self.y-8/16)*16*scale), 0, scale, scale)
		end
	end
	
	if math.ceil(self.size) ~= self.size then --draw 1 more on the rightest
		love.graphics.draw(platformimg, math.floor((self.x+self.size-1-xscroll)*16*scale), math.floor((self.y-8/16)*16*scale), 0, scale, scale)
	end
end

function platform:rightcollide(a, b)
	return false
end

function platform:leftcollide(a, b)
	return false
end

function platform:ceilcollide(a, b)
	if self.dir == "justright" then
		self.speedx = platformbonusspeed
	end
	return false
end

function platform:floorcollide(a, b)
	return false
end

function platform:passivecollide(a, b)
	return false
end