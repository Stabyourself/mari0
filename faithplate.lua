faithplate = class:new()

function faithplate:init(x, y, dir)
	self.cox = x
	self.coy = y
	self.dir = dir
	
	self.x = x-1
	self.y = y-1
	self.width = 2
	self.height = 0.125
	self.active = true
	self.static = true
	self.category = 26
	
	self.mask = {true}
	
	self.animationtimer = 1
	
	self.includetable = {"player", "box", "goomba"}
end

function faithplate:update(dt)
	if self.animationtimer < 1 then
		self.animationtimer = self.animationtimer + dt / faithplatetime
	end

	local intable = checkrect(self.x+.5, self.y-0.125, 1, 0.125, self.includetable)
	
	for i = 1, #intable, 2 do
		if self.dir == "up" then
			objects[intable[i]][intable[i+1]].speedy = -40
		elseif self.dir == "right" then
			objects[intable[i]][intable[i+1]].speedy = -30
			objects[intable[i]][intable[i+1]].speedx = 30
		elseif self.dir == "left" then
			objects[intable[i]][intable[i+1]].speedy = -30
			objects[intable[i]][intable[i+1]].speedx = -30
		end
		
		if objects[intable[i]][intable[i+1]].faithplate then
			objects[intable[i]][intable[i+1]]:faithplate(self.dir)
		end
		
		self.animationtimer = 0
	end
end

function faithplate:draw()
	love.graphics.setScissor(math.floor((self.cox-1-xscroll)*16*scale), (self.coy-4)*16*scale, 32*scale, (2.5+2/16)*16*scale)
	
	love.graphics.setColor(unpack(backgroundcolor[background]))
	love.graphics.rectangle("fill", math.floor((self.cox-1-xscroll)*16*scale), (self.coy-1.5)*16*scale, 32*scale, 2*scale)
	love.graphics.setColor(255, 255, 255)

	if self.animationtimer < 1 then
		if self.dir == "right" then
			local rot = 0
			if self.animationtimer < 0.1 then
				rot = math.pi/4*(self.animationtimer/0.1)
			elseif self.animationtimer < 0.3 then
				rot = math.pi/4
			else
				rot = math.pi/4*(1 - (self.animationtimer-0.3)/0.7)
			end
				
			love.graphics.draw(faithplateplateimg, math.floor((self.cox+1-xscroll)*16*scale), (self.coy-1.5)*16*scale, rot, scale, scale, 32)
		elseif self.dir == "left" then
			local rot = 0
			if self.animationtimer < 0.1 then
				rot = math.pi/4*(self.animationtimer/0.1)
			elseif self.animationtimer < 0.3 then
				rot = math.pi/4
			else
				rot = math.pi/4*(1 - (self.animationtimer-0.3)/0.7)
			end
				
			love.graphics.draw(faithplateplateimg, math.floor((self.cox-1-xscroll)*16*scale), (self.coy-1.5)*16*scale, -rot, -scale, scale, 32)
		elseif self.dir == "up" then
			local ymod = 0
			if self.animationtimer < 0.1 then
				ymod = .5*(self.animationtimer/0.1)
			elseif self.animationtimer < 0.3 then
				ymod = .5
			else
				ymod = .5*(1 - (self.animationtimer-0.3)/0.7)
			end
			
			love.graphics.draw(faithplateplateimg, math.floor((self.cox-1-xscroll)*16*scale), (self.coy-1.5-ymod)*16*scale, 0, scale, scale)
		end
	else
		if self.dir ~= "left" then
			love.graphics.draw(faithplateplateimg, math.floor((self.cox-1-xscroll)*16*scale), (self.coy-1.5)*16*scale, 0, scale, scale)
		else
			love.graphics.draw(faithplateplateimg, math.floor((self.cox+1-xscroll)*16*scale), (self.coy-1.5)*16*scale, 0, -scale, scale)
		end
	end
	
	love.graphics.setScissor()
end