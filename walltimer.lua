walltimer = class:new()

function walltimer:init(x, y, t, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	self.r = r
	
	self.outtable = {}
	self.lighted = false
	self.time = t
	self.timer = self.time
	self.quad = 1
end

function walltimer:link()
	if #self.r > 3 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[5]) == v.cox and tonumber(self.r[6]) == v.coy then
					v:addoutput(self)
				end
			end
		end
	end
end

function walltimer:addoutput(a)
	table.insert(self.outtable, a)
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
	
	love.graphics.drawq(walltimerimg, walltimerquad[self.quad], math.floor((self.x-1-xscroll)*16*scale), ((self.y-1)*16-8)*scale, 0, scale, scale)
end

function walltimer:out(t)
	for i = 1, #self.outtable do
		if self.outtable[i].input then
			self.outtable[i]:input(t)
		end
	end
end

function walltimer:input(t)
	if t == "on" then
		self:out("on")
		self.timer = self.time
		self.lighted = true
		self.quad = 2
	elseif t == "off" then
		self.lighted = false
		self.timer = 0
	elseif t == "toggle" then
		self.timer = 0
		self.quad = 2
		self.lighted = false
		self:out("on")
	end
end