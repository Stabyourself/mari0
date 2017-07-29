squarewave = class:new()

function squarewave:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	self.r = r
	
	self.outtable = {}
	
	self.timer = 0
	self.time1 = 1
	self.time2 = 1
	self.visible = false
	self.initial = true
	
	--Input list
	self.input1state = "off"
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--TIME1
	if #self.r > 0 and self.r[1] ~= "link" then
		self.time1 = self.r[1]
		table.remove(self.r, 1)
	end
	--TIME2
	if #self.r > 0 and self.r[1] ~= "link" then
		self.time2 = self.r[1]
		table.remove(self.r, 1)
	end
	--START
	if #self.r > 0 and self.r[1] ~= "link" then
		self.timer = self.r[1]*(self.time1+self.time2)
		table.remove(self.r, 1)
	end
	--VISIBLE
	if #self.r > 0 and self.r[1] ~= "link" then
		self.visible = (self.r[1] == "true")
		table.remove(self.r, 1)
	end
end

function squarewave:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end

function squarewave:update(dt)
	if self.initial then
		self.intial = false
		if self.timer > self.time1 then
			self:out("on")
		end
	end
	
	self.timer = self.timer + dt
	if self.timer - dt <= self.time1 and self.timer > self.time1 then
		self:out("on")
	end
	
	if self.timer - dt <= self.time2+self.time1 and self.timer > self.time2+self.time1 then
		self:out("off")
		self.timer = 0
	end
end

function squarewave:draw()
	if self.visible then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(squarewaveimg, math.floor((self.x-1-xscroll)*16*scale), ((self.y-yscroll-1)*16-8)*scale, 0, scale, scale)
	end
end

function squarewave:out(t)
	for i = 1, #self.outtable do
		if self.outtable[i][1].input then
			self.outtable[i][1]:input(t, self.outtable[i][2])
		end
	end
end