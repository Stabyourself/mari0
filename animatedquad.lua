animatedquad = class:new()

function animatedquad:init(imgpath, s)
	self.image = love.graphics.newImage(imgpath)
	self.quadlist = {}
	for x = 1, math.floor(self.image:getWidth()/16) do
		table.insert(self.quadlist, love.graphics.newQuad((x-1)*16, 0, 16, 16, self.image:getWidth(), self.image:getHeight()))
	end
	self.quad = self.quadlist[1]
	self.quadi = 1
	self.properties = s
	self.delays = {}
	self.timer = 0
	self.spikes = {}
	
	local lines
	if string.find(s, "\r\n") then
		lines = s:split("\r\n")
	else
		lines = s:split("\n")
	end
	
	for i = 1, #lines do
		local s2 = lines[i]:split("=")
		
		local s3
		if string.find(s2[1], ":") then
			s3 = s2[1]:split(":")
		else
			s3 = {s2[1]}
		end
		
		if s3[1] == "spikes" then
			self[s3[1]][s3[2]] = s2[2] == ("true")
		elseif s3[1] == "delay" then
			local s4 = s2[2]:split(",")
			
			for j = 1, #s4 do
				self.delays[j] = tonumber(s4[j])/1000
			end
		else
			self[s3[1]] = (s2[2] == "true")
		end
	end
	
	for j = #self.delays+1, #self.quadlist do
		self.delays[j] = self.delays[#self.delays]
	end
end

function animatedquad:update(dt)
	self.timer = self.timer + dt
	while self.timer > self.delays[self.quadi] do
		self.timer = self.timer - self.delays[self.quadi]
		self.quadi = self.quadi + 1
		if self.quadi > #self.quadlist then
			self.quadi = 1
		end
		self.quad = self.quadlist[self.quadi]
	end
end