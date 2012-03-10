pushbutton = class:new()

function pushbutton:init(x, y, dir)
	self.cox = x
	self.coy = y
	self.dir = dir
	
	self.out = false
	self.outtable = {}	

	adduserect(x-10/16, y-12/16, 4/16, 12/16, self)
	
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
	
	love.graphics.drawq(pushbuttonimg, pushbuttonquad[quad], math.floor((self.cox-0.5-xscroll)*16*scale), (self.coy-1.5)*16*scale, 0, horscale, scale, 8)
end

function pushbutton:addoutput(a)
	table.insert(self.outtable, a)
end

function pushbutton:used()
	if self.timer == pushbuttontime then
		self.pusheddown = true
		self.timer = 0
		for i = 1, #self.outtable do
			if self.outtable[i].input then
				self.outtable[i]:input("toggle")
			end
		end
	end
end