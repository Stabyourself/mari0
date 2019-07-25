pushbutton = class:new()

function pushbutton:init(x, y, r)
	self.cox = x
	self.coy = y
	self.dir = "left"
	self.base = "down"
	
	self.out = false
	self.outtable = {}	
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--DIRECTION
	if #self.r > 0 and self.r[1] ~= "link" then
		self.dir = self.r[1]
		table.remove(self.r, 1)
	end
	--BASE
	if #self.r > 0 and self.r[1] ~= "link" then
		self.base = self.r[1]
		table.remove(self.r, 1)
	end

	adduserect(x-11/16, y-11/16, 6/16, 6/16, self)
	
	self.timer = pushbuttontime
end

function pushbutton:update(dt)
	if self.timer < pushbuttontime then
		self.timer = self.timer + dt
		if self.timer >= pushbuttontime then
			self.pusheddown = false
			self.timer = pushbuttontime
		end
	end
end

function pushbutton:draw()
	local quad = 1
	if self.pusheddown then
		quad = 2
	end
	
	local horscale = scale
	if self.dir == "right" then
		horscale = -scale
	end
	
	local r = 0
	if self.base == "left" then
		r = math.pi/2
	elseif self.base == "up" then
		r = math.pi
	elseif self.base == "right" then
		r = math.pi*1.5
	end
	
	love.graphics.drawq(pushbuttonimg, pushbuttonquad[quad], math.floor((self.cox-0.5-xscroll)*16*scale), (self.coy-yscroll-1)*16*scale, r, horscale, scale, 8, 8)
end

function pushbutton:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end

function pushbutton:used()
	if self.timer == pushbuttontime then
		self.pusheddown = true
		self.timer = 0
		for i = 1, #self.outtable do
			if self.outtable[i][1].input then
				self.outtable[i][1]:input("toggle", self.outtable[i][2])
			end
		end
	end
end