cubedispenser = class:new()

function cubedispenser:init(x, y, r)
	--PHYSICS STUFF
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1
	self.speedy = 0
	self.speedx = 0
	self.width = 2
	self.height = 2
	self.static = true
	self.active = true
	self.category = 7
	self.mask = {true, false, false, false, false, false, false, false, true}
	
	self.timer = cubedispensertime
	self.t = "box"
	
	--Input list
	self.input1state = "off"
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--POWER
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == "true" then
			self.timer = 0
		end
		table.remove(self.r, 1)
	end
	--TYPE
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == 1 then
			self.t = "box"
		elseif self.r[1] == 2 then
			self.t = "goomba"
		elseif self.r[1] == 3 then
			self.t = "koopa"
		end
		
		table.remove(self.r, 1)
	end
	
	self.inputactive = false
	self.boxexists = false
	self.box = nil
end

function cubedispenser:input(t, input)
	if input == "drop" then
		if (t == "on" and self.input1state == "off") or (t == "toggle" ) then
			if self.boxexists then
				self.boxexists = false
				self:removebox()
			end
			
			self.timer = 0
		end
	end
end

function cubedispenser:link()
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

function cubedispenser:update(dt)
	if self.timer < cubedispensertime then
		self.timer = self.timer + dt
		
		if self.timer > 0.6 and self.boxexists == false then
			local temp
			if self.t == "box" then
				temp = box:new(self.cox+.5, self.coy)
				temp:addoutput(self, "drop")
				table.insert(objects["box"], temp)
			elseif self.t == "goomba" then
				temp = goomba:new(self.cox, self.coy)
				temp:addoutput(self, "drop")
				table.insert(objects["goomba"], temp)
			elseif self.t == "koopa" then
				temp = koopa:new(self.cox, self.coy)
				temp:addoutput(self, "drop")
				table.insert(objects["koopa"], temp)
			end
			
			self.box = temp
			self.boxexists = true
		elseif self.timer > 1 then
			self.timer = 1
		end
	end
	return false
end

function cubedispenser:draw()
	love.graphics.draw(cubedispenserimg, math.floor((self.cox-xscroll-1)*16*scale), (self.coy-yscroll-1.5)*16*scale, 0, scale, scale, 0, 0)
end

function cubedispenser:removebox()
	if self.box then
		self.box:emancipate()
	end
end