emancipationgrill = class:new()

function emancipationgrill:init(x, y, dir)
	self.x = x
	self.y = y
	self.dir = dir
	
	self.destroy = false
	if getTile(self.x, self.y) == true then
		self.destroy = true
	end
	
	for i, v in pairs(emancipationgrills) do
		local a, b = v:getTileInvolved(self.x, self.y)
		if a and b == self.dir then
			self.destroy = true
		end
	end
	
	self.particles = {}
	self.particles.i = {}
	self.particles.dir = {}
	self.particles.speed = {}
	self.particles.mod = {}
	
	self.involvedtiles = {}
	
	--find start and end
	if dir == "hor" then
		local curx = self.x
		while curx >= 1 and getTile(curx, self.y) == false do
			self.involvedtiles[curx] = self.y
			curx = curx - 1
		end
		self.startx = curx + 1
		
		local curx = self.x
		while curx <= mapwidth and getTile(curx, self.y) == false do
			self.involvedtiles[curx] = self.y
			curx = curx + 1
		end
		self.endx = curx - 1
		
		self.range = math.floor(((self.endx - self.startx + 1 + emanceimgwidth/16)*16)*scale)
	else
		local cury = self.y
		while cury >= 1 and getTile(self.x, cury) == false do
			self.involvedtiles[cury] = self.x
			cury = cury - 1
		end
		self.starty = cury + 1
		
		local cury = self.y
		while cury <= 15 and getTile(self.x, cury) == false do
			self.involvedtiles[cury] = self.x
			cury = cury + 1
		end
		self.endy = cury - 1
		
		self.range = math.floor(((self.endy - self.starty + 1 + emanceimgwidth/16)*16)*scale)
	end
	
	for i = 1, self.range/16/scale do
		table.insert(self.particles.i, math.random())
		table.insert(self.particles.speed, (1-emanceparticlespeedmod)+math.random()*emanceparticlespeedmod*2)
		if math.random(2) == 1 then
			table.insert(self.particles.dir, 1)
		else
			table.insert(self.particles.dir, -1)
		end
		table.insert(self.particles.mod, math.random(4)-2)
	end
end

function emancipationgrill:update(dt)
	if self.destroy then
		return true
	end

	for i, v in pairs(self.particles.i) do
		self.particles.i[i] = self.particles.i[i] + emanceparticlespeed/(self.range/16/scale)*dt*self.particles.speed[i]
		while self.particles.i[i] > 1 do
			self.particles.i[i] = self.particles.i[i]-1
			self.particles.speed[i] = (1-emanceparticlespeedmod)+math.random()*emanceparticlespeedmod*2
			if math.random(2) == 1 then
				self.particles.dir[i] = 1
			else
				self.particles.dir[i] = -1
			end
			self.particles.mod[i] = math.random(4)-2
		end
	end
end

function emancipationgrill:draw()
	if self.destroy == false then
		if self.dir == "hor" then
			parstartleft = math.floor((self.startx-1-xscroll)*16*scale)
			parstartright = math.floor((self.endx-1-xscroll)*16*scale)
			love.graphics.setScissor(parstartleft, ((self.y-1)*16-2)*scale, self.range - emanceimgwidth*scale, scale*4)
			
			love.graphics.setColor(unpack(emancelinecolor))
			love.graphics.rectangle("fill", math.floor((self.startx-1-xscroll)*16*scale), ((self.y-1)*16-2)*scale, self.range, scale*4)
			love.graphics.setColor(255, 255, 255)
			
			for i, v in pairs(self.particles.i) do
				local y = ((self.y-1)*16-self.particles.mod[i])*scale
				if self.particles.dir[i] == 1 then
					local x = parstartleft+self.range*v
					love.graphics.draw(emanceparticleimg, math.floor(x), y, math.pi/2, scale, scale)
				else
					local x = parstartright-self.range*v
					love.graphics.draw(emanceparticleimg, math.floor(x), y, -math.pi/2, scale, scale, 1)
				end
			end
			
			love.graphics.setScissor()
			
			--Sidethings
			love.graphics.draw(emancesideimg, parstartleft, ((self.y-1)*16-4)*scale, 0, scale, scale)
			love.graphics.draw(emancesideimg, parstartright+16*scale, ((self.y-1)*16+4)*scale, math.pi, scale, scale)
		else
			parstartup = math.floor((self.starty-1)*16*scale)
			parstartdown = math.floor((self.endy-1)*16*scale)
			love.graphics.setScissor(math.floor(((self.x-1-xscroll)*16+6)*scale), parstartup-8*scale, scale*4, self.range - emanceimgwidth*scale)
			
			love.graphics.setColor(unpack(emancelinecolor))
			love.graphics.rectangle("fill", math.floor(((self.x-1-xscroll)*16+6)*scale), parstartup-8*scale, scale*4, self.range - emanceimgwidth*scale)
			love.graphics.setColor(255, 255, 255)
			
			for i, v in pairs(self.particles.i) do
				local x = ((self.x-1-xscroll)*16-self.particles.mod[i]+9)*scale
				if self.particles.dir[i] == 1 then
					local y = parstartup+self.range*v
					love.graphics.draw(emanceparticleimg, math.floor(x), y, math.pi, scale, scale)
				else
					local y = parstartdown-self.range*v
					love.graphics.draw(emanceparticleimg, math.floor(x), y, 0, scale, scale, 1)
				end
			end
			
			love.graphics.setScissor()
			
			--Sidethings
			love.graphics.draw(emancesideimg, math.floor(((self.x-xscroll)*16-4)*scale), parstartup-8*scale, math.pi/2, scale, scale)
			love.graphics.draw(emancesideimg, math.floor(((self.x-xscroll)*16-12)*scale), parstartdown+8*scale, -math.pi/2, scale, scale)
		end
	end
end

function emancipationgrill:getTileInvolved(x, y)
	if self.dir == "hor" then
		if self.involvedtiles[x] == y then
			return true, "hor"
		else
			return false, "hor"
		end
	else
		if self.involvedtiles[y] == x then
			return true, "ver"
		else
			return false, "ver"
		end
	end
end