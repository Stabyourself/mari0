lightbridge = class:new()

function lightbridge:init(x, y, dir, r)
	self.cox = x
	self.coy = y
	self.dir = dir
	self.r = r
	
	self.childtable = {}
	
	self.enabled = true
	self:updaterange()
end

function lightbridge:link()
	self.outtable = {}
	if #self.r > 2 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[4]) == v.cox and tonumber(self.r[5]) == v.coy then
					v:addoutput(self)
					self.enabled = false
				end
			end
		end
	end
end

function lightbridge:input(t)
	if t == "on" then
		self.enabled = true
		self:updaterange()
	elseif t == "off" then
		self.enabled = false
		self:updaterange()
	else
		self.enabled = not self.enabled
		self:updaterange()
	end
end

function lightbridge:update(dt)
	
end

function lightbridge:draw()
	local rot = 0
	if self.dir == "up" then
		rot = math.pi*1.5
	elseif self.dir == "down" then
		rot = math.pi*0.5
	elseif self.dir == "left" then
		rot = math.pi
	end

	love.graphics.draw(lightbridgesideimg, math.floor((self.cox-xscroll-.5)*16*scale), (self.coy-1)*16*scale, rot, scale, scale, 8, 8)
end

function lightbridge:updaterange()
	for i, v in pairs(self.childtable) do
		v.destroy = true
	end
	self.childtable = {}
	
	if self.enabled == false then
		return
	end
	
	local dir = self.dir
	local startx, starty = self.cox, self.coy
	local x, y = self.cox, self.coy
	
	local firstcheck = true
	local quit = false
	while x >= 1 and x <= mapwidth and y >= 1 and y <= 15 and tilequads[map[x][y][1]].collision == false and (x ~= startx or y ~= starty or dir ~= self.dir or firstcheck == true) and quit == false do
		firstcheck = false
		
		if dir == "right" then
			x = x + 1
			table.insert(objects["lightbridgebody"], lightbridgebody:new(self, x-1, y, "hor"))
		elseif dir == "left" then
			x = x - 1
			table.insert(objects["lightbridgebody"], lightbridgebody:new(self, x+1, y, "hor"))
		elseif dir == "up" then
			y = y - 1
			table.insert(objects["lightbridgebody"], lightbridgebody:new(self, x, y+1, "ver"))
		elseif dir == "down" then
			y = y + 1
			table.insert(objects["lightbridgebody"], lightbridgebody:new(self, x, y-1, "ver"))
		end
		
		--check if current block is a portal
		local portalx, portaly, portalfacing, infacing = getPortal(x, y)
		if portalx ~= false and ((dir == "left" and infacing == "right") or (dir == "right" and infacing == "left") or (dir == "up" and infacing == "down") or (dir == "down" and infacing == "up")) then
			x, y = portalx, portaly
			dir = portalfacing
			
			if dir == "right" then
				x = x + 1
			elseif dir == "left" then
				x = x - 1
			elseif dir == "up" then
				y = y - 1
			elseif dir == "down" then
				y = y + 1
			end
		end
		
		--doors
		for i, v in pairs(objects["door"]) do
			if v.active then
				if v.dir == "ver" then
					if x == v.cox and (y == v.coy or y == v.coy-1) then
						quit = true
					end
				elseif v.dir == "hor" then
					if y == v.coy and (x == v.cox or x == v.cox+1) then
						quit = true
					end
				end
			end
		end
	end
end

function lightbridge:addChild(t)
	table.insert(self.childtable, t)
end

------------------------------------

lightbridgebody = class:new()

function lightbridgebody:init(parent, x, y, dir)
	parent:addChild(self)
	self.cox = x
	self.coy = y
	self.dir = dir

	--PHYSICS STUFF
	if dir == "hor" then
		self.x = x-1
		self.y = y-9/16
		self.width = 1
		self.height = 1/8
	else
		self.x = x-9/16
		self.y = y-1
		self.width= 1/8
		self.height = 1
	end
	self.static = true
	self.active = true
	self.category = 28
	
	self.mask = {true}
	
	self:pushstuff()
end

function lightbridgebody:pushstuff()
	local col = checkrect(self.x, self.y, self.width, self.height, {"box", "player"})
	for i = 1, #col, 2 do
		local v = objects[col[i]][col[i+1]]
		if self.dir == "ver" then
			if v.speedx >= 0 then
				if #checkrect(self.x + self.width, v.y, v.width, v.height, {"exclude", v}, true) > 0 then
					v.x = self.x - v.width
				else
					v.x = self.x + self.width
				end
			else
				if #checkrect(self.x - v.width, v.y, v.width, v.height, {"exclude", v}, true) > 0 then
					v.x = self.x + self.width
				else
					v.x = self.x - v.width
				end
			end
		elseif self.dir == "hor" then
			if v.speedy <= 0 then
				if #checkrect(v.x, self.y - v.height, v.width, v.height, {"exclude", v}, true) > 0 then
					v.y = self.y + self.height
				else
					v.y = self.y - v.height
				end
			else
				if #checkrect(v.x, self.y + self.height, v.width, v.height, {"exclude", v}, true) > 0 then
					v.y = self.y - v.height
				else
					v.y = self.y + self.height
				end
			end
		end
	end
end

function lightbridgebody:update(dt)
	if self.destroy then
		return true
	else
		return false
	end
end

function lightbridgebody:draw()
	love.graphics.setColor(255, 255, 255)
	
	if self.dir == "hor" then
		love.graphics.draw(lightbridgeimg, math.floor((self.cox-xscroll-1)*16*scale), (self.coy-20/16)*16*scale, 0, scale, scale)
	else
		love.graphics.draw(lightbridgeimg, math.floor((self.cox-xscroll-5/16)*16*scale), (self.coy-1)*16*scale, math.pi/2, scale, scale, 8, 1)
	end
end