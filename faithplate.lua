faithplate = class:new()

function faithplate:init(x, y, r)
	self.cox = x
	self.coy = y
	
	self.x = x-1
	self.y = y-1
	self.width = 2
	self.height = 0.125
	self.active = true
	self.static = true
	self.category = 26
	
	self.power = true
	
	self.mask = {true}
	
	self.animationtimer = 1
	
	self.includetable = {"player", "box", "goomba"}
	
	self.xspeed = 0
	self.yspeed = 20
	
	self.input1state = "off"
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--Xspeed
	if #self.r > 0 then
		self.xspeed = faithplatexfunction(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
	--Yspeed
	if #self.r > 0 then
		self.yspeed = faithplateyfunction(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
	--POWER
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == "true" then
			self.power = false
		end
		table.remove(self.r, 1)
	end
	
	--determine rough direction
	if self.yspeed > math.abs(self.xspeed)*2 then
		self.dir = "up"
	elseif self.xspeed > 0 then
		self.dir = "right"
	else
		self.dir = "left"
	end
end

function faithplate:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self.power = not self.power
		elseif t == "off" and self.input1state == "on" then
			self.power = not self.power
		elseif t == "toggle" then
			self.power = not self.power
		end
		
		self.input1state = t
	end
end

function faithplate:link()
	while #self.r > 3 do
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[3]) == v.cox and tonumber(self.r[4]) == v.coy then
					v:addoutput(self, self.r[2])
				end
			end
		end
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
	end
end

function faithplate:update(dt)
	if self.animationtimer < 1 then
		self.animationtimer = self.animationtimer + dt / faithplatetime
	end
	
	if self.power then
		local intable = checkrect(self.x+.5, self.y-0.125, 1, 0.125, self.includetable)
		
		for i = 1, #intable, 2 do
			if objects[intable[i]][intable[i+1]].speedy >= 0 then
				objects[intable[i]][intable[i+1]].speedy = -self.yspeed
				objects[intable[i]][intable[i+1]].speedx = self.xspeed
				
				objects[intable[i]][intable[i+1]].x = self.x+1-objects[intable[i]][intable[i+1]].width/2
				
				
				if objects[intable[i]][intable[i+1]].faithplate then
					objects[intable[i]][intable[i+1]]:faithplate(self.dir)
				end
				
				self.animationtimer = 0
			end
		end
	end
end

function faithplate:draw()
	local quad = 2
	if self.power then
		quad = 1
	end
	
	love.graphics.setScissor(math.floor((self.cox-1-xscroll)*16*scale), (self.coy-yscroll-4)*16*scale, 32*scale, (2.5+2/16)*16*scale)
	
	love.graphics.setColor(unpack(background))
	love.graphics.rectangle("fill", math.floor((self.cox-1-xscroll)*16*scale), (self.coy-yscroll-1.5)*16*scale, 32*scale, 2*scale)
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
				
			love.graphics.drawq(faithplateplateimg, faithplatequad[quad], math.floor((self.cox+1-xscroll)*16*scale), (self.coy-yscroll-1.5)*16*scale, rot, scale, scale, 32)
		elseif self.dir == "left" then
			local rot = 0
			if self.animationtimer < 0.1 then
				rot = math.pi/4*(self.animationtimer/0.1)
			elseif self.animationtimer < 0.3 then
				rot = math.pi/4
			else
				rot = math.pi/4*(1 - (self.animationtimer-0.3)/0.7)
			end
			
			love.graphics.drawq(faithplateplateimg, faithplatequad[quad], math.floor((self.cox-1-xscroll)*16*scale), (self.coy-yscroll-1.5)*16*scale, -rot, -scale, scale, 32)
		elseif self.dir == "up" then
			local ymod = 0
			if self.animationtimer < 0.1 then
				ymod = .5*(self.animationtimer/0.1)
			elseif self.animationtimer < 0.3 then
				ymod = .5
			else
				ymod = .5*(1 - (self.animationtimer-0.3)/0.7)
			end
			
			love.graphics.drawq(faithplateplateimg, faithplatequad[quad], math.floor((self.cox-1-xscroll)*16*scale), (self.coy-yscroll-1.5-ymod)*16*scale, 0, scale, scale)
		end
	else
		if self.dir ~= "left" then
			love.graphics.drawq(faithplateplateimg, faithplatequad[quad], math.floor((self.cox-1-xscroll)*16*scale), (self.coy-yscroll-1.5)*16*scale, 0, scale, scale)
		else
			love.graphics.drawq(faithplateplateimg, faithplatequad[quad], math.floor((self.cox+1-xscroll)*16*scale), (self.coy-yscroll-1.5)*16*scale, 0, -scale, scale)
		end
	end
	
	love.graphics.setScissor()
end