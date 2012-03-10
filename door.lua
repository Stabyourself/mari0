door = class:new()

function door:init(x, y, r, dir)
	self.cox = x
	self.coy = y
	self.r = r
	self.dir = dir
	
	self.open = false
	self.timer = 0
	
	--PHYSICS STUFF
	if self.dir == "hor" then
		self.x = x-1
		self.y = y-12/16
		self.width = 32/16
		self.height = 8/16
	else
		self.x = x-12/16
		self.y = y-2
		self.width = 8/16
		self.height = 32/16
	end
	self.category = 25
	
	self.mask = {true}
		
	self.static = true
	self.active = true
	
	self.drawable = false
	self.firstupdate = true
end

function door:link()
	self.outtable = {}
	if #self.r > 2 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[4]) == v.cox and tonumber(self.r[5]) == v.coy then
					v:addoutput(self)
				end
			end
		end
	end
end

function door:update(dt)
	if self.firstupdate then
		self.firstupdate = false
		for i, v in pairs(objects["laser"]) do
			v:updaterange()
		end
		for i, v in pairs(objects["lightbridge"]) do
			v:updaterange()
		end
	end
		
	if self.open then
		if self.timer < 1 then
			self.timer = self.timer + doorspeed*dt
			if self.timer >= 1 then
				self.timer = 1
				self.active = false
				for i, v in pairs(objects["laser"]) do
					v:updaterange()
				end
				for i, v in pairs(objects["lightbridge"]) do
					v:updaterange()
				end
			end
		end
	else
		if self.timer > 0 then
			self.timer = self.timer - doorspeed*dt
			if self.timer <= 0 then
				self.timer = 0
			end
		end
	end
end

function door:draw()
	local ymod = 0
	local rot = math.pi/2
	if self.timer > 0.5 then
		ymod = (self.timer - 0.5) * 2
	else
		rot = self.timer * math.pi
	end
	
	if self.dir == "hor" then
		love.graphics.draw(doorpieceimg, math.floor((self.x+14/16-xscroll-ymod)*16*scale), (self.y-4/16)*16*scale, math.pi*.5, scale, scale, 4, 0)
		love.graphics.draw(doorpieceimg, math.floor((self.x+18/16-xscroll+ymod)*16*scale), (self.y-4/16)*16*scale, math.pi*1.5, scale, scale, 4, 0)
		love.graphics.draw(doorcenterimg, math.floor((self.x+16/16-xscroll-ymod)*16*scale), (self.y-4/16)*16*scale, math.pi*.5-rot, scale, scale, 4, 2)
		love.graphics.draw(doorcenterimg, math.floor((self.x+16/16-xscroll+ymod)*16*scale), (self.y-4/16)*16*scale, math.pi*1.5-rot, scale, scale, 4, 2)
	else
		love.graphics.draw(doorpieceimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y+6/16-ymod)*16*scale, math.pi, scale, scale, 4, 0)
		love.graphics.draw(doorpieceimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y+10/16+ymod)*16*scale, 0, scale, scale, 4, 0)
		love.graphics.draw(doorcenterimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y+8/16-ymod)*16*scale, rot, scale, scale, 4, 2)
		love.graphics.draw(doorcenterimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y+8/16+ymod)*16*scale, math.pi+rot, scale, scale, 4, 2)
	end
end

function door:pushstuff()
	local col = checkrect(self.x, self.y, self.width, self.height, "all")
	for i = 1, #col, 2 do
		local v = objects[col[i]][col[i+1]]
		if self.dir == "ver" then
			if v.speedx >= 0 then
				v.x = self.x - v.width
			else
				v.x = self.x + self.width
			end
		elseif self.dir == "hor" then
			if v.speedy >= 0 then
				v.y = self.y - v.height
			else
				v.y = self.y + self.height
			end
		end
	end
end

function door:input(t)
	local prev = self.open
	if t == "on" then
		self.open = true
		if self.timer == 1 then
			self.active = false
		end
	elseif t == "off" then
		self.open = false
		self.active = true
		self:pushstuff()
	elseif t == "toggle" then
		self.open = not self.open
		
		if self.open then
			if self.timer == 1 then
				self.active = false
			end
		else
			self.active = true
			self:pushstuff()
		end
	end
	
	if self.open ~= prev then
		for i, v in pairs(objects["laser"]) do
			v:updaterange()
		end
		for i, v in pairs(objects["lightbridge"]) do
			v:updaterange()
		end
	end
end