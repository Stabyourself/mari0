regiondrag = class:new()

regiondragboxwidth = 3

function regiondrag:init(x, y, width, height)
	self.x = x-1
	self.y = y-1
	self.width = width or 1
	self.height = height or 1
	
	self.grabbed = 0
end

function regiondrag:update(dt)
	if self.grabbed ~= 0 then
		local mx, my = love.mouse.getPosition()
		local oldx, oldy, oldwidth, oldheight, oldgrabbed = self.x, self.y, self.width, self.height, self.grabbed
		local tx, ty = getMouseTile(mx-.5*16*scale, my)
		
		--X
		
		if self.grabbed == 1 or self.grabbed == 3 then
			if tx < self.x then
				self.width = self.x-tx+self.width
				self.x = tx
			elseif tx > self.x then
				if tx > self.x+self.width then
					self.grabbed = self.grabbed + 1
					self.x = self.x+self.width
					self.width = tx-self.x
				else
					self.width = self.x-tx+self.width
					self.x = tx
				end
			end
		
		elseif self.grabbed == 2 or self.grabbed == 4 then
			if tx > self.x+self.width then
				self.width = tx-self.x
			elseif tx < self.x+self.width then
				if tx <= self.x then
					self.grabbed = self.grabbed - 1
					self.width = self.x-tx
					self.x = tx
				else
					self.width = tx-self.x
				end
			end
		end
		
		--Y
		
		if self.grabbed == 1 or self.grabbed == 2 then
			if ty < self.y then
				self.height = self.y-ty+self.height
				self.y = ty
			elseif ty > self.y then
				if ty > self.y+self.height then
					self.grabbed = self.grabbed + 2
					self.y = self.y+self.height
					self.height = ty-self.y
				else
					self.height = self.y-ty+self.height
					self.y = ty
				end
			end
		
		elseif self.grabbed == 3 or self.grabbed == 4 then
			if ty > self.y+self.height then
				self.height = ty-self.y
			elseif ty < self.y+self.height then
				if ty <= self.y then
					self.grabbed = self.grabbed - 2
					self.height = self.y-ty
					self.y = ty
				else
					self.height = ty-self.y
				end
			end
		end
		
		if self.grabbed == 5 then
			self.x, self.y = self.movestartx+round((mx-self.movex)/16/scale), self.movestarty+round((my-self.movey)/16/scale)
		end
		
		if self.width == 0 or self.height == 0 then
			self.x, self.y, self.width, self.height, self.grabbed = oldx, oldy, oldwidth, oldheight, oldgrabbed
		end
	end
end

function regiondrag:draw()
	local high = 0
	if self:inhighlight(love.mouse.getX(), love.mouse.getY(), 5) and self.grabbed == 0 then
		high = 5
	end
	for i = 1, 4 do
		if self:inhighlight(love.mouse.getX(), love.mouse.getY(), i) then
			high = i
			break
		end
	end
	
	if high == 5 or self.grabbed == 5 then
		love.graphics.setColor(255, 255, 255, 100)
	else
		love.graphics.setColor(255, 127, 39, 100)
	end
	love.graphics.rectangle("fill", (self.x-xscroll)*16*scale, (self.y-yscroll-.5)*16*scale, self.width*16*scale, self.height*16*scale)
	
	--edges
	
	for i = 1, 4 do
		local x, y
		
		if i == self.grabbed or (self.grabbed == 0 and high == i) then
			love.graphics.setColor(255, 255, 255, 200)
		else
			love.graphics.setColor(222, 97, 29, 200)
		end
		
		if i == 1 then
			x = (self.x-xscroll)*16*scale
			y = (self.y-yscroll-.5)*16*scale
		elseif i == 2 then
			x = (self.x-xscroll+self.width)*16*scale
			y = (self.y-yscroll-.5)*16*scale
		elseif i == 3 then
			x = (self.x-xscroll)*16*scale
			y = (self.y-yscroll-.5+self.height)*16*scale
		elseif i == 4 then
			x = (self.x-xscroll+self.width)*16*scale
			y = (self.y-yscroll-.5+self.height)*16*scale
		end
		
		love.graphics.rectangle("fill", x-regiondragboxwidth*scale, y-regiondragboxwidth*scale, regiondragboxwidth*2*scale, regiondragboxwidth*2*scale)	
	end
end

function regiondrag:mousepressed(x, y, button)
	for i = 1, 5 do
		if self:inhighlight(love.mouse.getX(), love.mouse.getY(), i) then
			self.grabbed = i
			break
		end
	end
	
	if self.grabbed == 5 then
		self.movex = x
		self.movey = y
		self.movestartx = self.x
		self.movestarty = self.y
	elseif self.grabbed == 0 then
		return true
	end
end

function regiondrag:mousereleased(x, y, button)
	self.grabbed = 0
end

function regiondrag:inhighlight(x, y, i)
	if i == 1 then
		vx = (self.x-xscroll)*16*scale
		vy = (self.y-yscroll-.5)*16*scale
	elseif i == 2 then
		vx = (self.x-xscroll+self.width)*16*scale
		vy = (self.y-yscroll-.5)*16*scale
	elseif i == 3 then
		vx = (self.x-xscroll)*16*scale
		vy = (self.y-yscroll-.5+self.height)*16*scale
	elseif i == 4 then
		vx = (self.x-xscroll+self.width)*16*scale
		vy = (self.y-yscroll-.5+self.height)*16*scale
	elseif i == 5 then
		return x >= (self.x-xscroll)*16*scale and x < (self.x-xscroll+self.width)*16*scale and y >= (self.y-yscroll-.5)*16*scale and y < (self.y-yscroll-.5+self.height)*16*scale
	end
	
	return x >= vx-regiondragboxwidth*scale and x < vx+regiondragboxwidth*scale and y >= vy-regiondragboxwidth*scale and y < vy+regiondragboxwidth*scale
end