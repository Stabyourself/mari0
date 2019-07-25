portal = class:new()

function portal:init(number, c1, c2)	
	self.number = number
	self.portal1color = c1 or {60, 188, 252}
	self.portal2color = c2 or {232, 130, 30}
	
	self.x1, self.y1, self.facing1, self.x2, self.y2, self.facing2 = false, false, false, false, false, false
end

function portal:createportal(i, cox, coy, side, tendency)
	if cox and tendency then	
		local otheri = 1
		if i == 1 then
			otheri = 2
		end
		
		moveoutportal(i)
	
		--remove the portal temporarily so that it doesn't obstruct itself
		local oldx, oldy, oldfacing
		if i == 1 then
			oldx, oldy, oldfacing = self.x1, self.y1, self.facing1
			self.x1, self.y1 = false, false
		else
			oldx, oldy, oldfacing = self.x2, self.y2, self.facing2
			self.x2, self.y2 = false, false
		end
		
		local newx, newy = getportalposition(i, cox, coy, side, tendency)
		
		if newx and (newx ~= oldx or newy ~= oldy or side ~= oldfacing) then
			if i == 1 then
				self.x1 = newx
				self.y1 = newy
				self.facing1 = side
			else
				self.x2 = newx
				self.y2 = newy
				self.facing2 = side
			end
	
			--physics
			--Recreate old hole
			if oldfacing == "up" then	
				modifyportaltiles(oldx, oldy, 1, 0, self, i, "add")
			elseif oldfacing == "down" then	
				modifyportaltiles(oldx, oldy, -1, 0, self, i, "add")
			elseif oldfacing == "left" then	
				modifyportaltiles(oldx, oldy, 0, -1, self, i, "add")
			elseif oldfacing == "right" then	
				modifyportaltiles(oldx, oldy, 0, 1, self, i, "add")
			end
			
			local otheri = 1
			if i == 1 then
				otheri = 2
			end
			
			if oldx == false then --Remove blocks from other portal
				local x, y, side
				if otheri == 1 then
					side = self.facing1
					x, y = self.x1, self.y1
				else
					side = self.facing2
					x, y = self.x2, self.y2
				end
					
				if side == "up" then
					modifyportaltiles(x, y, 1, 0, self, otheri, "remove")
				elseif side == "down" then
					modifyportaltiles(x, y, -1, 0, self, otheri, "remove")
				elseif side == "left" then
					modifyportaltiles(x, y, 0, -1, self, otheri, "remove")
				elseif side == "right" then
					modifyportaltiles(x, y, 0, 1, self, otheri, "remove")
				end
			end
			
			if i == 1 then
				playsound(portal1opensound)
			else
				playsound(portal2opensound)
			end
			
			modifyportalwalls()
			updateranges()
		else
			--recreate the temporarily removed portal
			self["x" .. i],  self["y" .. i] = oldx, oldy
		end
	end
end

function portal:removeportal(i)
	moveoutportal(i)
	local otheri = 1
	if i == 1 then
		otheri = 2
	end
	
	if self["x" .. i] then
		if self["facing" .. i] == "up" then	
			modifyportaltiles(self["x" .. i], self["y" .. i], 1, 0, self, i, "add")
		elseif self["facing" .. i] == "down" then	
			modifyportaltiles(self["x" .. i], self["y" .. i], -1, 0, self, i, "add")
		elseif self["facing" .. i] == "left" then	
			modifyportaltiles(self["x" .. i], self["y" .. i], 0, -1, self, i, "add")
		elseif self["facing" .. i] == "right" then	
			modifyportaltiles(self["x" .. i], self["y" .. i], 0, 1, self, i, "add")
		end
		
		if self["x" .. otheri] then
			if self["facing" .. otheri] == "up" then	
				modifyportaltiles(self["x" .. otheri], self["y" .. otheri], 1, 0, self, otheri, "add")
			elseif self["facing" .. otheri] == "down" then	
				modifyportaltiles(self["x" .. otheri], self["y" .. otheri], -1, 0, self, otheri, "add")
			elseif self["facing" .. otheri] == "left" then	
				modifyportaltiles(self["x" .. otheri], self["y" .. otheri], 0, -1, self, otheri, "add")
			elseif self["facing" .. otheri] == "right" then	
				modifyportaltiles(self["x" .. otheri], self["y" .. otheri], 0, 1, self, otheri, "add")
			end
		end
		
		self["x" .. i] = false
		self["y" .. i] = false
		self["facing" .. i] = false
		
		modifyportalwalls()
		updateranges()
	end
end