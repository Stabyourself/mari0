regiontrigger = class:new()

function regiontrigger:init(x, y, r)
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
	
	self.out = "off"
end

function regiontrigger:update(dt)
	local col = checkrect(self.regionX, self.regionY, self.regionwidth, self.regionheight, self.checktable)
	
	if self.out == "off" and #col > 0 then
		self.out = "on"
		for i = 1, #self.outtable do
			if self.outtable[i][1].input then
				self.outtable[i][1]:input(self.out, self.outtable[i][2])
			end
		end
	elseif self.out == "on" and #col == 0 then
		self.out = "off"
		for i = 1, #self.outtable do
			if self.outtable[i][1].input then
				self.outtable[i][1]:input(self.out, self.outtable[i][2])
			end
		end
	end
end

function regiontrigger:draw()
	
end

function regiontrigger:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end