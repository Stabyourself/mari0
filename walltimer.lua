walltimer = class:new()

function walltimer:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	
	self.outtable = {}
	self.lighted = false
	self.time = 1
	self.quad = 1
	
	self.input1state = "off"
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)	
	--TIME
	if #self.r > 0 and self.r[1] ~= "link" then
		self.time = timerfunction(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
	
	self.timer = self.time
end

function walltimer:link()
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

function walltimer:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end

function walltimer:update(dt)
	if self.lighted then
		self.quad = 2
	elseif self.timer == self.time then
		self.quad = 1
	else
		self.timer = self.timer + dt
		local div = self.time/10
		for i = 1, 9 do
			if i == math.floor(self.timer*(1/div)) then
				self.quad = i+1
			end
		end
		
		if self.timer >= self.time then
			self:out("off")
			self.timer = self.time
		end
	end
end

function walltimer:draw()
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.drawq(walltimerimg, walltimerquad[self.quad], math.floor((self.x-1-xscroll)*16*scale), ((self.y-yscroll-1)*16-8)*scale, 0, scale, scale)
end

function walltimer:out(t)
	for i = 1, #self.outtable do
		if self.outtable[i][1].input then
			self.outtable[i][1]:input(t, self.outtable[i][2])
		end
	end
end

function walltimer:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self:out("on")
			self.timer = self.time
			self.lighted = true
			self.quad = 2
		elseif t == "off" and self.input1state == "on" then
			self.lighted = false
			self.timer = 0
		elseif t == "toggle" then
			self.timer = 0
			self.quad = 2
			self.lighted = false
			self:out("on")
		end
		
		self.input1state = t
	end
end