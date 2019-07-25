platformspawner = class:new()

function platformspawner:init(x, y, r)
	self.x = x
	self.y = y
	self.dir = "up"
	self.timer = 0
	self.size = 3
	self.spawndelay = platformspawndelay
	
	--Input list
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	--DIRECTION
	if #self.r > 0 then
		self.dir = self.r[1]
		table.remove(self.r, 1)
	end
	
	--SIZE
	if #self.r > 0 then
		self.size = tonumber(self.r[1])
		table.remove(self.r, 1)
	end
	
	--SPEED
	if #self.r > 0 then
		self.speed = self.r[1]
		table.remove(self.r, 1)
	end
	
	--SPAWNDELAY
	if #self.r > 0 then
		self.spawndelay = platformspawndelayfunc(tonumber(self.r[1]))
		table.remove(self.r, 1)
	end
end

function platformspawner:update(dt)
	self.timer = self.timer + dt
	if self.timer > self.spawndelay then
		if self.dir == "up" then
			table.insert(objects["platform"], platform:new(self.x, self.y+1, {0, 0, "justup", self.size, 0, 0, self.speed}))
		else
			table.insert(objects["platform"], platform:new(self.x, self.y-0.5, {0, 0, "justdown", self.size, 0, 0, self.speed}))
		end
		
		self.timer = self.timer - self.spawndelay
	end
	
	if self.x < xscroll - .5 then
		return true
	end
end