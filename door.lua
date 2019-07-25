door = class:new()

function door:init(x, y, r)
	self.cox = x
	self.coy = y
	self.dir = "ver"
	
	self.open = false
	self.timer = 0
	
	self.input1state = "off"
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--DIRECTION
	if #self.r > 0 and self.r[1] ~= "link" then
		self.dir = self.r[1]
		table.remove(self.r, 1)
	end
	--POWER
	if #self.r > 0 and self.r[1] ~= "link" then
		self.open = (self.r[1] == "true")
		table.remove(self.r, 1)
	end
	--FORCE CLOSE (for the padawans)
	if #self.r > 0 and self.r[1] ~= "link" then
		self.forceclose = (self.r[1] == "true")
		table.remove(self.r, 1)
	end
	
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
	
	self:closeopen(self.open)
	self.targetopen = self.open
end

function door:link()
	while #self.r > 3 do
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[3]) == v.cox and tonumber(self.r[4]) == v.coy then
					v:addoutput(self, self.r[2])
				end
			end
		end
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
	end
end

function door:update(dt)	
	if self.targetopen ~= self.open then
		if self.forceclose then
			self:closeopen(self.targetopen)
		else
			if #checkrect(self.x, self.y, self.width, self.height, {"exclude", self}) == 0 then
				self:closeopen(self.targetopen)
			end
		end
	end
	
	if self.open then
		if self.timer < 1 then
			self.timer = self.timer + doorspeed*dt
			if self.timer >= 1 then
				self.timer = 1
				self.active = false
				updateranges()
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
		love.graphics.draw(doorpieceimg, math.floor((self.x+14/16-xscroll-ymod)*16*scale), (self.y-yscroll-4/16)*16*scale, math.pi*.5, scale, scale, 4, 0)
		love.graphics.draw(doorpieceimg, math.floor((self.x+18/16-xscroll+ymod)*16*scale), (self.y-yscroll-4/16)*16*scale, math.pi*1.5, scale, scale, 4, 0)
		love.graphics.draw(doorcenterimg, math.floor((self.x+16/16-xscroll-ymod)*16*scale), (self.y-yscroll-4/16)*16*scale, math.pi*.5-rot, scale, scale, 4, 2)
		love.graphics.draw(doorcenterimg, math.floor((self.x+16/16-xscroll+ymod)*16*scale), (self.y-yscroll-4/16)*16*scale, math.pi*1.5-rot, scale, scale, 4, 2)
	else
		love.graphics.draw(doorpieceimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y-yscroll+6/16-ymod)*16*scale, math.pi, scale, scale, 4, 0)
		love.graphics.draw(doorpieceimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y-yscroll+10/16+ymod)*16*scale, 0, scale, scale, 4, 0)
		love.graphics.draw(doorcenterimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y-yscroll+8/16-ymod)*16*scale, rot, scale, scale, 4, 2)
		love.graphics.draw(doorcenterimg, math.floor((self.x+0.25-xscroll)*16*scale), (self.y-yscroll+8/16+ymod)*16*scale, math.pi+rot, scale, scale, 4, 2)
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

function door:input(t, input)
	if input == "open" then
		if t == "on" and self.input1state == "off" then
			self.targetopen = not self.targetopen
		elseif t == "off" and self.input1state == "on" then
			self.targetopen = not self.targetopen
		elseif t == "toggle" then
			self.targetopen = not self.targetopen
		end
		
		self.input1state = t
	end
end

function door:closeopen(open)
	local prev = self.open
	self.open = open
	
	if self.open then
		if self.timer == 1 then
			self.active = false
		end
	else
		self.active = true
		self:pushstuff()
	end
	
	if self.open ~= prev then
		updateranges()
	end
end