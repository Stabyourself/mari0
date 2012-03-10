castlefire = class:new()

function castlefire:init(x, y, length, dir)
	self.x = x
	self.y = y+1/16
	self.length = length or 6
	self.dir = dir or "cw"
	self.quadi = 1
	self.child = {}
	for i = 1, self.length do
		local temp = castlefirefire:new()
		table.insert(objects["castlefirefire"], temp)
		table.insert(self.child, temp)
	end
	self.angle = 0
	self.timer = 0
	self.timer2 = 0
	
	self:updatepos()
	self:updatequad()
end

function castlefire:update(dt)
	self.timer = self.timer + dt
	
	while self.timer > castlefiredelay do
		self.timer = self.timer - castlefiredelay
		if self.dir == "cw" then
			self.angle = self.angle + castlefireangleadd
			self.angle = math.mod(self.angle, 360)
		else
			self.angle = self.angle - castlefireangleadd
			while self.angle < 0 do
				self.angle = self.angle + 360
			end
		end
		
		self:updatepos()
	end
	
	self.timer2 = self.timer2 + dt
	while self.timer2 > castlefireanimationdelay do
		self.timer2 = self.timer2 - castlefireanimationdelay
		self.quadi = self.quadi + 1
		if self.quadi > 4 then
			self.quadi = 1
		end
		self:updatequad()
	end
end

function castlefire:updatepos()
	local x = self.x-.5
	local y = self.y-.5
	
	for i = 1, self.length do
		local xadd = math.cos(math.rad(self.angle))*(i-1)*0.5
		local yadd = math.sin(math.rad(self.angle))*(i-1)*0.5
		
		self.child[i].x = x+xadd-0.25
		self.child[i].y = y+yadd-0.25
	end
end

function castlefire:updatequad()	
	for i = 1, self.length do
		self.child[i].quad = fireballquad[self.quadi]
	end
end



--------------

castlefirefire = class:new()

function castlefirefire:init()
	--PHYSICS STUFF
	self.y = 0
	self.x = 0
	self.width = 8/16
	self.height = 8/16
	self.active = true
	self.static = true
	self.category = 23
	
	self.mask = {	true,
					true, false, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true,
					true, true, true, true, true}
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = fireballimg
	self.quad = fireballquad[1]
	self.offsetX = 4
	self.offsetY = 4
	self.quadcenterX = 4
	self.quadcenterY = 4
end