geldispenser = class:new()

function geldispenser:init(x, y, r)
	--PHYSICS STUFF
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1
	self.r = r
	self.speedy = 0
	self.speedx = 0
	self.width = 2
	self.height = 2
	self.static = true
	self.active = true
	self.category = 7
	self.mask = {true, false, false, false, false, false}
	
	self.dir = "down"
	self.id = 1
	self.timer = 0
	self.input1state = "off"
	
	self.dropping = true
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--DIR
	if #self.r > 0 then
		self.dir = self.r[1]
		table.remove(self.r, 1)
	end
	--ID
	if #self.r > 0 then
		self.id = tonumber(self.r[1])
		table.remove(self.r, 1)
	end
	--POWER
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == "true" then
			self.dropping = false
		end
		table.remove(self.r, 1)
	end
	
	self:link()
end

function geldispenser:link()
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

function geldispenser:update(dt)
	if self.dropping then
		self.timer = self.timer + dt
		
		while self.timer > geldispensespeed do
			self.timer = self.timer - geldispensespeed
			if self.dir == "down" then
				table.insert(objects["gel"], gel:new(self.x+1.5 + (math.random()-0.5)*1, self.y+12/16, self.id))
				objects["gel"][#objects["gel"]].speedy = 10
			elseif self.dir == "right" then
				table.insert(objects["gel"], gel:new(self.x+14/16, self.y+1.5 + (math.random()-0.5)*1, self.id))
				objects["gel"][#objects["gel"]].speedx = 20
				objects["gel"][#objects["gel"]].speedy = -4
			elseif self.dir == "left" then
				table.insert(objects["gel"], gel:new(self.x+30/16, self.y+1.5 + (math.random()-0.5)*1, self.id))
				objects["gel"][#objects["gel"]].speedx = -20
				objects["gel"][#objects["gel"]].speedy = -4
			elseif self.dir == "up" then
				table.insert(objects["gel"], gel:new(self.x+1.5 + (math.random()-0.5)*1, self.y+12/16, self.id))
				objects["gel"][#objects["gel"]].speedy = -30
			end
		end
	end
	
	return false
end

function geldispenser:draw()
	if self.dir == "down" then
		love.graphics.draw(geldispenserimg, math.floor((self.cox-xscroll-1)*16*scale), (self.coy-yscroll-1.5)*16*scale, 0, scale, scale, 0, 0)
	elseif self.dir == "right" then
		love.graphics.draw(geldispenserimg, math.floor((self.cox-xscroll-1)*16*scale), (self.coy-yscroll+.5)*16*scale, math.pi*1.5, scale, scale, 0, 0)
	elseif self.dir == "left" then
		love.graphics.draw(geldispenserimg, math.floor((self.cox-xscroll+1)*16*scale), (self.coy-yscroll-1.5)*16*scale, math.pi*0.5, scale, scale, 0, 0)
	elseif self.dir == "up" then
		love.graphics.draw(geldispenserimg, math.floor((self.cox-xscroll+1)*16*scale), (self.coy-yscroll+.5)*16*scale, math.pi, scale, scale, 0, 0)
	end
end

function geldispenser:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self.dropping = not self.dropping
		elseif t == "off" and self.input1state == "on" then
			self.dropping = not self.dropping
		elseif t == "toggle" then
			self.dropping = not self.dropping
		end
		
		self.input1state = t
	end
end