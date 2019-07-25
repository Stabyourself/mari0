panel = class:new()

function panel:init(x, y, t)
	self.cox = x+1
	self.coy = y+1
	
	self.dir = "right"
	self.out = false
	self.input1state = "off"
	
	--Input list
	self.t = {unpack(t)}
	table.remove(self.t, 1)
	table.remove(self.t, 1)
	--Dir
	if #self.t > 0 then
		self.dir = self.t[1]
		table.remove(self.t, 1)
	end
	--Start white
	if #self.t > 0 then
		self.out = self.t[1] == "true"
		table.remove(self.t, 1)
	end
	
	if self.dir == "left" then
		self.r = 0
	elseif self.dir == "top" then
		self.r = math.pi/2
	elseif self.dir == "right" then
		self.r = math.pi
	elseif self.dir == "bottom" then
		self.r = math.pi*1.5
	end
	
	self:link()
	self:updatestuff()
end

function panel:link()
	while #self.t > 3 do
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.t[3]) == v.cox and tonumber(self.t[4]) == v.coy then
					v:addoutput(self, self.t[2])
				end
			end
		end
		table.remove(self.t, 1)
		table.remove(self.t, 1)
		table.remove(self.t, 1)
		table.remove(self.t, 1)
	end
end

function panel:draw()
	local quad = 2
	if self.out then
		quad = 1
	end
	
	love.graphics.drawq(panelimg, panelquad[quad], math.floor((self.cox-1-xscroll+.5)*16*scale), math.floor((self.coy-1-yscroll)*16*scale), self.r, scale, scale, 8, 8)
end

function panel:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self.out = true
		elseif t == "off" and self.input1state == "on" then
			self.out = false
		elseif t == "toggle" then
			self.out = not self.out
		end
		
		self.input1state = t
		
		self:updatestuff()
	end
end
	
function panel:updatestuff()
	map[self.cox][self.coy]["portaloverride"][self.dir] = self.out
	
	if self.out == false and tilequads[map[self.cox][self.coy][1]].portalable == false then
		for i, v in pairs(portals) do
			--Get the extra block of each portal
			local portal1xplus, portal1yplus, portal2xplus, portal2yplus = 0, 0, 0, 0
			if v.facing1 == "up" then
				portal1xplus = 1
			elseif v.facing1 == "right" then
				portal1yplus = 1
			elseif v.facing1 == "down" then
				portal1xplus = -1
			elseif v.facing1 == "left" then
				portal1yplus = -1
			end
			
			if v.facing2 == "up" then
				portal2xplus = 1
			elseif v.facing2 == "right" then
				portal2yplus = 1
			elseif v.facing2 == "down" then
				portal2xplus = -1
			elseif v.facing2 == "left" then
				portal2yplus = -1
			end
			
			if v.x1 ~= false then
				if (self.cox == v.x1 or self.cox == v.x1+portal1xplus) and (self.coy == v.y1 or self.coy == v.y1+portal1yplus) then--and (facing == nil or v.facing1 == facing) then
					v:removeportals(1)
				end
			end
		
			if v.x2 ~= false then
				if (self.cox == v.x2 or self.cox == v.x2+portal2xplus) and (self.coy == v.y2 or self.coy == v.y2+portal2yplus) then--and (facing == nil or v.facing2 == facing) then
					v:removeportals(2)
				end
			end
		end
	end
end