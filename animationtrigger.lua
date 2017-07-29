animationtrigger = class:new()

function animationtrigger:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	
	self.checktable = "all"
	self.outtable = {}
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	--IDENTIFIER
	if #self.r > 0 and self.r[1] ~= "link" then
		self.id = tostring(self.r[1])
		table.remove(self.r, 1)
	end
	
	--PLAYER ONLY
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == "true" then
			self.checktable = {"player"}
		end
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
	
	self.allowfire = "off"
end

function animationtrigger:update(dt)
	local col = checkrect(self.regionX, self.regionY, self.regionwidth, self.regionheight, self.checktable)
	
	if #col > 0 then
		if self.allowfire then
			if not animationtriggerfuncs[self.id] then
				return
			end
			
			for i = 1, #animationtriggerfuncs[self.id] do
				animationtriggerfuncs[self.id][i]:trigger()
			end
			self.allowfire = false
		end
	else
		self.allowfire = true
	end
end

function animationtrigger:draw()
	
end