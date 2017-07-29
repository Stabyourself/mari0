magic = class:new()

function magic:init()
	self.lifetime = 0.5
	self.t = 0
	self.x = math.floor(7+math.random()*188)*scale
	self.y = math.floor(88+math.random()*12)*scale
	self.color = {202+(math.random()-.7)*50, 170+(math.random()-.7)*50, 209+(math.random()-.7)*50}
end

function magic:update(dt)
	self.t = self.t + dt
	if self.t >= self.lifetime then
		return true
	end
end

function magic:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.drawq(magicimg, magicquad[math.floor(self.t/self.lifetime*6)+1], self.x, self.y, 0, scale, scale, 5, 5)
end