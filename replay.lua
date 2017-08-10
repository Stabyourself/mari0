replay = class:new()

--[[
    
	if j == 1 and firstreplayblue then
		self.colors = {{ 32,  56, 236}, {  0, 128, 136}, {252, 152,  56}}
	end
]]

function replay:init(replaydata)
    self.data = replaydata.data
	self.frames = replaydata.frames
	self.name = replaydata.name
	
	self.waited = 0
	self.i = 0
	
	self:tick()
end

function replay:tick()
	if self.i == #self.data then
		return
	end
	
	if self.i == 0 or type(self.data[self.i]) == "table" then
		self:next()
	else
		self.waited = self.waited + 1
		
		if self.waited >= self.data[self.i] then
			self:next()
		end
	end
end

function replay:next()
	self.i = self.i + 1
	
	if type(self.data[self.i]) == "table" then
		self.x = self.data[self.i].x or self.x
		self.y = self.data[self.i].y or self.y
		self.a = self.data[self.i].a or self.a
	end
end

function replay:draw()
end