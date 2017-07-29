actionblock = class:new()

function actionblock:init(x, y)
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1
	self.speedx = 0
	self.speedy = 0
	self.width = 1
	self.height = 1
	self.active = true
	self.static = true
	self.category = 2
	self.mask = {true}
	
	self.state = "off"
	self.outtable = {}
	self.timer = blockbouncetime
end

function actionblock:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end

function actionblock:update(dt)
	if self.timer < blockbouncetime then
		self.timer = math.min(blockbouncetime, self.timer + dt)
	end
end

function actionblock:draw()
	local bounceyoffset = 0
	if self.timer < blockbouncetime then
		if self.timer < blockbouncetime/2 then
			bounceyoffset = self.timer / (blockbouncetime/2) * blockbounceheight
		else
			bounceyoffset = (2 - self.timer / (blockbouncetime/2)) * blockbounceheight
		end
	end
	
	local q = 1
	if self.state == "on" then
		q = 2
	end
	love.graphics.drawq(actionblockimg, wallindicatorquad[q], math.floor((self.x-xscroll)*16*scale), math.floor((self.y-.5-yscroll-bounceyoffset)*16*scale), 0, scale, scale)
end

function actionblock:floorcollide(a, b, c, d)
	if self.state == "off" then
		self.state = "on"
	else
		self.state = "off"
	end
	if self.timer == blockbouncetime then
		self.timer = 0
	end
	
	self:out(self.state)
end

function actionblock:out(t)
	for i = 1, #self.outtable do
		if self.outtable[i][1].input then
			self.outtable[i][1]:input(t, self.outtable[i][2])
		end
	end
end