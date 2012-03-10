portalprojectile = class:new()

function portalprojectile:init(x, y, tx, ty, color, hit, payload)
	self.x = x
	self.y = y
	
	self.startx = x
	self.starty = y
	self.endx = tx
	self.endy = ty
	
	self.color = color
	self.hit = hit
	
	self.payload = payload
	self.payloaddelivered = false
	
	self.sinestart = math.random(math.pi*10)/10
	self.timer = 0.005
	self.length = math.sqrt((tx-x)^2 + (ty-y)^2)
	self.time = self.length/portalprojectilespeed
	self.angle = math.atan2(tx-x, ty-y)
	
	self.particles = {}
	self.lastparticle = math.floor(self.timer/portalprojectileparticledelay)
end

function portalprojectile:update(dt)
	self.timer = self.timer + dt

	if self.timer < self.time then
		self.x = self.startx + (self.endx-self.startx)*(self.timer/self.time)
		self.y = self.starty + (self.endy-self.starty)*(self.timer/self.time)
		
		local currentparticle = math.floor(self.timer/portalprojectileparticledelay)
		
		for i = self.lastparticle+1, currentparticle do
			local t = i*portalprojectileparticledelay
			local tx = self.startx + (self.endx-self.startx)*(t/self.time)
			local ty = self.starty + (self.endy-self.starty)*(t/self.time)
			
			--INNER LINE
			local r, g, b = unpack(self.color)			
			table.insert(self.particles, portalprojectileparticle:new(tx, ty, {r, g, b}))
			
			--OUTER LINES
			local r, g, b = unpack(self.color)
			r, g, b = r/2, g/2, b/2
			
			--Sine
			local x = tx + math.sin(self.angle+math.pi/2)*(math.sin(t*portalprojectilesinemul+self.sinestart))*portalprojectilesinesize
			local y = ty + math.cos(self.angle+math.pi/2)*(math.sin(t*portalprojectilesinemul+self.sinestart))*portalprojectilesinesize
			
			table.insert(self.particles, portalprojectileparticle:new(x, y, {r, g, b}))
			
			--Sine
			local x = tx + math.sin(self.angle-math.pi/2)*(math.sin(t*portalprojectilesinemul+self.sinestart))*portalprojectilesinesize
			local y = ty + math.cos(self.angle-math.pi/2)*(math.sin(t*portalprojectilesinemul+self.sinestart))*portalprojectilesinesize
			
			table.insert(self.particles, portalprojectileparticle:new(x, y, {r, g, b}))
		end
			
		self.lastparticle = currentparticle
	end	
	
	--Update particles
	local delete = {}
	
	for i, v in pairs(self.particles) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(self.particles, v)
	end
	
	if (self.timer >= self.time and self.timer-dt < self.time) or (self.time <= 0.005 and self.payloaddelivered == false) then
		createportal(unpack(self.payload))
		self.payloaddelivered = true
	end
	
	if self.timer >= self.time + portalprojectiledelay then
		return true
	end
	
	return false
end

function portalprojectile:draw()
	for i, v in pairs(self.particles) do
		v:draw()
	end
	
	if self.timer < self.time then
		love.graphics.setColor(unpack(self.color))
		
		love.graphics.draw(portalprojectileimg, math.floor((self.x-xscroll)*16*scale), math.floor((self.y-0.5)*16*scale), 0, scale, scale, 3, 3)
	end
end

portalprojectileparticle = class:new()

function portalprojectileparticle:init(x, y, color, r, g, b)
	self.x = x
	self.y = y
	self.color = color
	
	
	self.speedx = math.random(-10, 10)/70
	self.speedy = math.random(-10, 10)/70
	
	self.alpha = 150
	
	self.timer = 0
end

function portalprojectileparticle:update(dt)
	self.timer = self.timer + dt
	
	self.speedx = self.speedx + math.random(-10, 10)/70
	self.speedy = self.speedy + math.random(-10, 10)/70
	
	self.x = self.x + self.speedx*dt
	self.y = self.y + self.speedy*dt
	
	self.alpha = self.alpha - dt*300
	if self.alpha < 0 then
		self.alpha = 0
		return true
	end
end

function portalprojectileparticle:draw()
	local r, g, b = unpack(self.color)
	love.graphics.setColor(r, g, b, self.alpha)
	
	love.graphics.draw(portalprojectileparticleimg, math.floor((self.x-xscroll)*16*scale), math.floor((self.y-.5)*16*scale), 0, scale, scale, 2, 2)
end