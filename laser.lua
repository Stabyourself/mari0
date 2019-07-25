laser = class:new()

function laser:init(x, y, r)
	self.cox = x
	self.coy = y
	
	self.blocked = false
	self.lasertable = {}
	self.outtable = {}
	
	self.framestart = 0
	
	self.power = true
	self.input1state = "off"
	
	self.dir = "right"
	
	--Input list
	self.input1state = "off"
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
		if self.r[1] == "true" then
			self.power = false
		end
		table.remove(self.r, 1)
	end
end

function laser:link()
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

function laser:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self.power = not self.power
		elseif t == "off" and self.input1state == "on" then
			self.power = not self.power
		elseif t == "toggle" then
			self.power = not self.power
		end
		self:updaterange()
		
		self.input1state = t
	end
end

function laser:update(dt)
	if self.framestart < 2 then
		self.framestart = self.framestart + 1
		return
	end
	local x, y, width, height
	local col = false
	
	for i = 1, #self.lasertable, 5 do
		if self.lasertable[i] == "left" then
			
			x = self.lasertable[i+1]-1+self.lasertable[i+3]
			y = self.lasertable[i+2]-0.5625
			width = -self.lasertable[i+3]+1
			height = 2/16
			
			local rectcol = checkrect(x, y, width, height, {"player", "box", "goomba", "koopa"})
			
			if #rectcol > 0 then
				col = true
				self.blocked = true
			
				local biggestx = -1
				local biggesti
			
				for j = 1, #rectcol, 2 do
					if objects[rectcol[j]][rectcol[j+1]].x > biggestx then
						biggestx = objects[rectcol[j]][rectcol[j+1]].x
						biggesti = j
					end
				end
				
				obj = objects[rectcol[biggesti]][rectcol[biggesti+1]]
				
				if obj.laser then
					obj:laser("right")
				end
				
				local newtable = {}
				for k = 1, i*5 do
					table.insert(newtable, self.lasertable[k])
				end
				
				newtable[i+3] = obj.x - newtable[i+1] + obj.width+1
				
				self.lasertable = newtable
				
				self:updateoutputs()
				break
			end
			
		elseif self.lasertable[i] == "right" then
			
			x = self.lasertable[i+1]-1
			y = self.lasertable[i+2]-0.5625
			width = self.lasertable[i+3]+1
			height = 2/16
			
			local rectcol = checkrect(x, y, width, height, {"player", "box", "goomba", "koopa"})
			
			if #rectcol > 0 then
				col = true
				self.blocked = true
			
				local smallestx = mapwidth+1
				local smallesti
			
				for j = 1, #rectcol, 2 do
					if objects[rectcol[j]][rectcol[j+1]].x < smallestx then
						smallestx = objects[rectcol[j]][rectcol[j+1]].x
						smallesti = j
					end
				end
				
				obj = objects[rectcol[smallesti]][rectcol[smallesti+1]]
				
				if obj.laser then
					obj:laser("left")
				end
				
				local newtable = {}
				for k = 1, i*5 do
					table.insert(newtable, self.lasertable[k])
				end
				
				newtable[i+3] = obj.x - newtable[i+1]
				
				self.lasertable = newtable
				
				self:updateoutputs()
				break
			end
			
		elseif self.lasertable[i] == "up" then
			
			x = self.lasertable[i+1]-0.5625
			y = self.lasertable[i+2]+self.lasertable[i+4]-1
			width = 2/16
			height = -self.lasertable[i+4]+1
			
			local rectcol = checkrect(x, y, width, height, {"player", "box", "goomba", "koopa"})
			
			if #rectcol > 0 then
				col = true
				self.blocked = true
			
				local biggesty = objects[rectcol[1]][rectcol[2]].y
				local biggesti = 1
			
				for j = 3, #rectcol, 2 do
					if objects[rectcol[j]][rectcol[j+1]].y > biggesty then
						biggesty = objects[rectcol[j]][rectcol[j+1]].y
						biggesti = j
					end
				end
				
				obj = objects[rectcol[biggesti]][rectcol[biggesti+1]]
				
				if obj.laser then
					obj:laser("down")
				end
				
				local newtable = {}
				for k = 1, i*5 do
					table.insert(newtable, self.lasertable[k])
				end
				
				newtable[i+4] = obj.y - newtable[i+2]+1
				
				self.lasertable = newtable
				
				self:updateoutputs()
				break
			end
			
		elseif self.lasertable[i] == "down" then
			
			x = self.lasertable[i+1]-0.5625
			y = self.lasertable[i+2]-1
			width = 2/16
			height = self.lasertable[i+4]+1
			
			local rectcol = checkrect(x, y, width, height, {"player", "box", "goomba", "koopa"})
			
			if #rectcol > 0 then
				col = true
				self.blocked = true
			
				local smallesty = 16
				local smallesti
			
				for j = 1, #rectcol, 2 do
					if objects[rectcol[j]][rectcol[j+1]].y < smallesty then
						smallesty = objects[rectcol[j]][rectcol[j+1]].y
						smallesti = j
					end
				end
				
				obj = objects[rectcol[smallesti]][rectcol[smallesti+1]]
				
				if obj.laser then
					obj:laser("up")
				end
				
				local newtable = {}
				for k = 1, i*5 do
					table.insert(newtable, self.lasertable[k])
				end
				
				newtable[i+4] = obj.y - newtable[i+2] + 1 - obj.height+1-1
				
				self.lasertable = newtable
				
				self:updateoutputs()
				break
			end
		end
	end
	
	self:updateoutputs()
	
	if col == false and self.blocked == true then
		self.blocked = false
		self:updaterange()
	end
end

function laser:updateoutputs()
	for i = 1, #self.lasertable, 5 do
		if self.lasertable[i] == "left" then
			for x = self.lasertable[i+1], math.ceil(self.lasertable[i+1]+self.lasertable[i+3])-1, -1 do
				local y = self.lasertable[i+2]
				self:checktile(x, y, "left")
			end
		elseif self.lasertable[i] == "right" then
			for x = self.lasertable[i+1], math.floor(self.lasertable[i+1]+self.lasertable[i+3])+1 do
				local y = self.lasertable[i+2]
				self:checktile(x, y, "right")
			end
		elseif self.lasertable[i] == "up" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4]-1, -1 do
				local x = self.lasertable[i+1]
				self:checktile(x, y, "up")
			end
		elseif self.lasertable[i] == "down" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4]+1 do
				local x = self.lasertable[i+1]
				self:checktile(x, y, "down")
			end
		end
	end
	
	for i, v in pairs(self.outtable) do
		v:clear()
	end
end

function laser:checktile(x, y, dir)
	--check if block is a detector
	for i, v in pairs(objects["laserdetector"]) do
		if (dir == "left" and v.dir == "right") or (dir == "right" and v.dir == "left") or (dir == "up" and v.dir == "down") or (dir == "down" and v.dir == "up") then
			if x == v.cox and y == v.coy and (v.cox ~= self.r[4] or v.coy ~= self.r[5]) then
				table.insert(self.outtable, v)
				v:input("on")
			end
		end
	end
end

function laser:draw()	
	for i = 1, #self.lasertable, 5 do
		if self.lasertable[i] == "left" then
			if self.lasertable[i+3] < 1 then
				love.graphics.setScissor(math.floor((self.lasertable[i+1]+self.lasertable[i+3]-xscroll-1)*16*scale), (self.lasertable[i+2]-yscroll-1.5)*16*scale, (-self.lasertable[i+3]+1)*16*scale, 16*scale)
				local b = 0
				for x = self.lasertable[i+1], math.floor(self.lasertable[i+1]+self.lasertable[i+3])-1, -1 do
					b = b + 1
					love.graphics.draw(laserimg, math.floor((x-xscroll-1)*16*scale), (self.lasertable[i+2]-yscroll-20/16)*16*scale, 0, scale, scale)
				end
				print(b)
			end
		elseif self.lasertable[i] == "right" then
			if self.lasertable[i+3] > -1 then
				love.graphics.setScissor(math.floor((self.lasertable[i+1]-xscroll-1)*16*scale), (self.lasertable[i+2]-yscroll-1.5)*16*scale, (self.lasertable[i+3]+1)*16*scale, 16*scale)
					local b = 0
				for x = self.lasertable[i+1], math.ceil(self.lasertable[i+1]+self.lasertable[i+3])+1 do
					b = b + 1
					love.graphics.draw(laserimg, math.floor((x-xscroll-1)*16*scale), (self.lasertable[i+2]-yscroll-20/16)*16*scale, 0, scale, scale)
				end
				print(b)
			end
		elseif self.lasertable[i] == "up" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4], -1 do
				love.graphics.draw(laserimg, math.floor((self.lasertable[i+1]-xscroll-5/16)*16*scale), (y-yscroll-1)*16*scale, math.pi/2, scale, scale, 8, 1)
			end
		elseif self.lasertable[i] == "down" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4] do
				love.graphics.draw(laserimg, math.floor((self.lasertable[i+1]-xscroll-5/16)*16*scale), (y-yscroll-1)*16*scale, math.pi/2, scale, scale, 8, 1)
			end
		end
		
		love.graphics.setScissor()
	end
	
	local rot = 0
	if self.dir == "up" then
		rot = math.pi*1.5
	elseif self.dir == "down" then
		rot = math.pi*0.5
	elseif self.dir == "left" then
		rot = math.pi
	end

	love.graphics.draw(lasersideimg, math.floor((self.cox-xscroll-.5)*16*scale), (self.coy-yscroll-1)*16*scale, rot, scale, scale, 8, 8)
end

function laser:updaterange()
	self.lasertable = {}
	if self.power == false then
		self:updateoutputs()
		return
	end
	
	local dir = self.dir
	local startx, starty = self.cox, self.coy
	local rangex, rangey = 0, 0
	local x, y = self.cox, self.coy
	
	local firstcheck = true
	local quit = false
	while x >= 1 and x <= mapwidth and y >= 1 and y <= mapheight and (tilequads[map[x][y][1]].collision == false or tilequads[map[x][y][1]].grate) and (x ~= startx or y ~= starty or dir ~= self.dir or firstcheck == true) and quit == false do
		firstcheck = false
		
		if dir == "right" then
			x = x + 1
			rangex = rangex + 1
		elseif dir == "left" then
			x = x - 1
			rangex = rangex - 1
		elseif dir == "up" then
			y = y - 1
			rangey = rangey - 1
		elseif dir == "down" then
			y = y + 1
			rangey = rangey + 1
		end
		
		--check if current block is a portal
		local opp = "left"
		if dir == "left" then
			opp = "right"
		elseif dir == "up" then
			opp = "down"
		elseif dir == "down" then
			opp = "up"
		end
		
		local portalx, portaly, portalfacing, infacing = getPortal(x, y, opp)
		
		if portalx ~= false and ((dir == "left" and infacing == "right") or (dir == "right" and infacing == "left") or (dir == "up" and infacing == "down") or (dir == "down" and infacing == "up")) then
			
			if dir == "right" then
				x = x - 1
				rangex = rangex - 1
			elseif dir == "left" then
				x = x + 1
				rangex = rangex + 1
			elseif dir == "up" then
				y = y + 1
				rangey = rangey + 1
			elseif dir == "down" then
				y = y - 1
				rangey = rangey - 1
			end
			
			table.insert(self.lasertable, dir)
			table.insert(self.lasertable, x-rangex)
			table.insert(self.lasertable, y-rangey)
			table.insert(self.lasertable, rangex)
			table.insert(self.lasertable, rangey)
			
			x, y = portalx, portaly
			dir = portalfacing
			
			rangex, rangey = 0, 0
			
			if dir == "right" then
				x = portalx + 1
			elseif dir == "left" then
				x = portalx - 1
				rangex = 0
			elseif dir == "up" then
				y = portaly - 1
			elseif dir == "down" then
				y = portaly + 1
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
		
	if dir == "right" then
		x = x - 1
		rangex = rangex - 1
	elseif dir == "left" then
		x = x + 1
		rangex = rangex + 1
	elseif dir == "up" then
		y = y + 1
		rangey = rangey + 1
	elseif dir == "down" then
		y = y - 1
		rangey = rangey - 1
	end
	
	table.insert(self.lasertable, dir)
	table.insert(self.lasertable, x-rangex)
	table.insert(self.lasertable, y-rangey)
	table.insert(self.lasertable, rangex)
	table.insert(self.lasertable, rangey)
	
	self:update()
end