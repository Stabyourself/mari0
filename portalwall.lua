portalwall = class:new()

function portalwall:init(x, y, width, height)
	self.x = x
	self.y = y	
	self.width = width
	self.height = height
	self.static = true
	self.active = true
	self.category = 12
	self.mask = {true}
end

function portalwall:draw()--debug
	love.graphics.setColor(255, 0, 0)
	love.graphics.setPointSize(5)
	if self.width ~= 0 or self.height ~= 0 then
		love.graphics.line((self.x-xscroll)*16*scale, (self.y-.5-yscroll)*16*scale, (self.x-xscroll)*16*scale+self.width*16*scale, (self.y-.5-yscroll)*16*scale+self.height*16*scale)
	else
		love.graphics.point((self.x-xscroll)*16*scale, (self.y-.5-yscroll)*16*scale)
	end
end