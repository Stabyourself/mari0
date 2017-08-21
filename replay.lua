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
	
	self.x = -100
	self.y = -100
	self.a = 1

	self:reset()
end

function replay:reset()
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
			self.waited = 0
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

function replay:draw(replaySB)
	if self.x/16 > xscroll-1 and self.x/16 < xscroll+width then
		local quadOff = 0
		
		if ttstate == "playing" or ttstate == "endanimation" or ttstate == "entry" then --ghost
			quadOff = 12
		end
		
		replaySB:addq(replayQuads[self.a+1+quadOff], (self.x-5)*scale, (self.y-13)*scale, 0, scale, scale)
		
		return true
	end
end