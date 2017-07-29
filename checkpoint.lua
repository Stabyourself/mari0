checkpoint = class:new()

function checkpoint:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	
	self.r = {unpack(r)}
	
	self.all = true
	self.p = {false, false, false, false}
	self.rest = false
	self.visible = false
	
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	--Check all
	if #self.r > 0 and self.r[1] ~= "link" then
		self.all = self.r[1] == "true"
		table.remove(self.r, 1)
	end
	
	--p1-4
	for i = 1, 4 do
		if #self.r > 0 and self.r[1] ~= "link" then
			self.p[i] = self.r[1] == "true"
			table.remove(self.r, 1)
		end
	end
	
	--rest
	if #self.r > 0 and self.r[1] ~= "link" then
		self.rest = self.r[1] == "true"
		table.remove(self.r, 1)
	end
	
	--visible
	if #self.r > 0 and self.r[1] ~= "link" then
		self.visible = self.r[1] == "true"
		table.remove(self.r, 1)
	end
	
	--REGION
	if #self.r > 0 then
		local s = self.r[1]:split(":")
		self.regionX, self.regionY, self.regionwidth, self.regionheight = s[2], s[3], tonumber(s[4]), tonumber(s[5])
		if string.sub(self.regionX, 1, 1) == "m" then
			self.regionX = -tonumber(string.sub(self.regionX, 2))
		end
		if string.sub(self.regionY, 1, 1) == "m" then
			self.regionY = -tonumber(string.sub(self.regionY, 2))
		end
		
		self.regionX = tonumber(self.regionX) + self.x - 1
		self.regionY = tonumber(self.regionY) + self.y - 1
		table.remove(self.r, 1)
	end
	
	self.input1state = "off"
end

function checkpoint:update()
	local col = checkrect(self.regionX, self.regionY, self.regionwidth, self.regionheight, {"player"})
	
	if #col > 0 then
		self:trigger()
	end
end

function checkpoint:link()
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

function checkpoint:input(t, input)
	if input == "trigger" then
		if t == "on" and self.input1state == "off" then
			self:trigger()
		elseif t == "toggle" then
			self:trigger()
		end
		
		self.input1state = t
	end
end

function checkpoint:trigger()
	local modtable = {}
	if self.all then
		table.insert(modtable, 1)
		table.insert(modtable, 2)
		table.insert(modtable, 3)
		table.insert(modtable, 4)
		table.insert(modtable, 5)
	else
		for i = 1, 4 do
			if self.p[i] then
				table.insert(modtable, i)
			end
		end
		
		if self.rest then
			table.insert(modtable, 5)
		end
	end
	
	for i, v in pairs(modtable) do
		checkpointx[v] = self.x
		checkpointy[v] = self.y
	end
	
	checkpointsub = mariosublevel
end