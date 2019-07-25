laserdetector = class:new()

function laserdetector:init(x, y, r)
	self.cox = x
	self.coy = y
	self.dir = "right"
	
	self.drawable = false
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--DIRECTION
	if #self.r > 0 and self.r[1] ~= "link" then
		self.dir = self.r[1]
		table.remove(self.r, 1)
	end
	
	self.outtable = {}
	self.allowclear = true
	self.out = "off"
end

function laserdetector:update(dt)
	self.allowclear = true
	
	if self.out ~= self.prevout then
		self.prevout = self.out
		for i = 1, #self.outtable do
			if self.outtable[i][1].input then
				self.outtable[i][1]:input(self.out, self.outtable[i][2])
			end
		end
	end
end

function laserdetector:input(t)
	self.allowclear = false
	if t == "on" then
		self.out = "on"
	end
end

function laserdetector:draw()
	local rot = 0
	if self.dir == "down" then
		rot = math.pi/2
	elseif self.dir == "left" then
		rot = math.pi
	elseif self.dir == "up" then
		rot = math.pi*1.5
	end
	love.graphics.draw(laserdetectorimg, math.floor((self.cox-xscroll-0.5)*16*scale), (self.coy-yscroll-1)*16*scale, rot, scale, scale, 8, 8)
end

function laserdetector:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end

function laserdetector:clear()
	if self.allowclear then
		self.allowclear = false
		self.out = "off"
	end
end