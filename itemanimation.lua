itemanimation = class:new()

function itemanimation:init(x, y, i)
	self.x = x
	self.y = y
	self.i = i
	self.timer = 0
	
	self.v = enemiesdata[self.i]
end

function itemanimation:update(dt)
	self.timer = self.timer + dt
	if self.timer >= mushroomtime then
		table.insert(objects["enemy"], enemy:new(self.x, self.y-1, self.i, map[self.x][self.y]))
		return true
	end
end

function itemanimation:draw()
	local yoffset = self.timer/mushroomtime*1
	love.graphics.setScissor((self.x-xscroll-6)*16*scale, (self.y-yscroll-6.5)*16*scale, 176*scale, 80*scale)
	love.graphics.drawq(self.v.graphic, self.v.quad, math.floor(((self.x-xscroll-.5-self.v.width/2+(self.v.spawnoffsetx or 0))*16+self.v.offsetX)*scale), math.floor(((self.y-yscroll-yoffset-self.v.height+(self.v.spawnoffsety or 0))*16-self.v.offsetY)*scale), 0, scale, scale, self.v.quadcenterX, self.v.quadcenterY)
	love.graphics.setScissor()
end