laser = class:new()

function laser:init(x, y, dir, r)
	self.cox = x
	self.coy = y
	self.dir = dir
	self.r = r
	
	self.blocked = false
	self.lasertable = {}
	self.outtable = {}
	
	self.framestart = 0
	
	self.enabled = true
end

function laser:link()
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

function laser:input(t)
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
			
				local biggesty = 0
				local biggesti
			
				for j = 1, #rectcol, 2 do
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
				self:checktile(x, y)
			end
		elseif self.lasertable[i] == "right" then
			for x = self.lasertable[i+1], math.floor(self.lasertable[i+1]+self.lasertable[i+3])+1 do
				local y = self.lasertable[i+2]
				self:checktile(x, y)
			end
		elseif self.lasertable[i] == "up" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4]-1, -1 do
				local x = self.lasertable[i+1]
				self:checktile(x, y)
			end
		elseif self.lasertable[i] == "down" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4]+1 do
				local x = self.lasertable[i+1]
				self:checktile(x, y)
			end
		end
	end
	
	for i, v in pairs(self.outtable) do
		v:clear()
	end
end

function laser:checktile(x, y)
	--check if block is a detector
	for i, v in pairs(objects["laserdetector"]) do
		if x == v.cox and y == v.coy and (v.cox ~= self.r[4] or v.coy ~= self.r[5]) then
			table.insert(self.outtable, v)
			v:input("on")
		end
	end
end

function laser:draw()	
	for i = 1, #self.lasertable, 5 do
		if self.lasertable[i] == "left" then
			love.graphics.setScissor(math.floor((self.lasertable[i+1]+self.lasertable[i+3]-xscroll-1)*16*scale), (self.lasertable[i+2]-1.5)*16*scale, math.max((-self.lasertable[i+3]+1)*16*scale, 0), 16*scale)
			for x = self.lasertable[i+1], math.floor(self.lasertable[i+1]+self.lasertable[i+3])-1, -1 do
				love.graphics.draw(laserimg, math.floor((x-xscroll-1)*16*scale), (self.lasertable[i+2]-20/16)*16*scale, 0, scale, scale)
			end
		elseif self.lasertable[i] == "right" then
			love.graphics.setScissor(math.floor((self.lasertable[i+1]-xscroll-1)*16*scale), (self.lasertable[i+2]-1.5)*16*scale, math.max((self.lasertable[i+3]+1)*16*scale, 0), 16*scale)
			for x = self.lasertable[i+1], math.ceil(self.lasertable[i+1]+self.lasertable[i+3])+1 do
				love.graphics.draw(laserimg, math.floor((x-xscroll-1)*16*scale), (self.lasertable[i+2]-20/16)*16*scale, 0, scale, scale)
			end
		elseif self.lasertable[i] == "up" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4], -1 do
				love.graphics.draw(laserimg, math.floor((self.lasertable[i+1]-xscroll-5/16)*16*scale), (y-1)*16*scale, math.pi/2, scale, scale, 8, 1)
			end
		elseif self.lasertable[i] == "down" then
			for y = self.lasertable[i+2], self.lasertable[i+2]+self.lasertable[i+4] do
				love.graphics.draw(laserimg, math.floor((self.lasertable[i+1]-xscroll-5/16)*16*scale), (y-1)*16*scale, math.pi/2, scale, scale, 8, 1)
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

	love.graphics.draw(lasersideimg, math.floor((self.cox-xscroll-.5)*16*scale), (self.coy-1)*16*scale, rot, scale, scale, 8, 8)
end

function laser:updaterange()
	self.lasertable = {}
	if self.enabled == false then
		self:updateoutputs()
		return
	end
	
	local dir = self.dir
	local startx, starty = self.cox, self.coy
	local rangex, rangey = 0, 0
	local x, y = self.cox, self.coy
	
	local firstcheck = true
	local quit = false
	while x >= 1 and x <= mapwidth and y >= 1 and y <= 15 and tilequads[map[x][y][1]].collision == false and (x ~= startx or y ~= starty or dir ~= self.dir or firstcheck == true) and quit == false do
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
		local portalx, portaly, portalfacing, infacing = getPortal(x, y)
		
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