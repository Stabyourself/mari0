vine = class:new()

function vine:init(x, y, t)
	self.cox = x
	self.coy = y
	self.t = t
	
	if self.t == "start" then
		self.limit = 9+1/16
	else
		self.limit = -1
	end
	
	self.timer = 0
	
	self.width = 10/16
	self.height = 0
	
	self.x = x-0.5-self.width/2
	self.y = y-1
	
	self.static = true
	self.active = true
	
	self.category = 18
	
	self.mask = {true}
	
	testtimer = love.timer.getTime()
	
	--IMAGE STUFF
	self.drawable = false
end

function vine:update(dt)
	if self.y > self.limit then
		self.y = self.y - vinespeed*dt
		self.height = self.coy-self.y-1.7
		if self.y <= self.limit then
			self.y = self.limit
			self.height = self.coy-self.limit-1.7
		end
		self.height = math.max(self.height, 0)
	end
end

function vine:draw()
	love.graphics.setScissor(0, 0, width*16*scale, (self.coy-1.5)*16*scale)
	
	love.graphics.drawq(vineimg, vinequad[spriteset][1], math.floor((self.x-xscroll-1/16-((1-self.width)/2))*16*scale), (self.y-0.5-2/16)*16*scale, 0, scale, scale)
	for i = 1, math.ceil(self.height-14/16+.7) do
		love.graphics.drawq(vineimg, vinequad[spriteset][2], math.floor((self.x-xscroll-1/16-((1-self.width)/2))*16*scale), (self.y-0.5-2/16+i)*16*scale, 0, scale, scale)
	end
		
	
	love.graphics.setScissor()
end