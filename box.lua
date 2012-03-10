box = class:new()

function box:init(x, y)
	--PHYSICS STUFF
	self.cox = x
	self.coy = y
	self.x = x-14/16
	self.y = y-12/16
	self.speedy = 0
	self.speedx = 0
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.category = 9
	self.parent = nil
	self.portaloverride = true

	self.mask = {	true,
					false, false, false, false, false,
					false, true, false, true, true,
					false, false, true, false, false,
					true, true, false, false, true,
					false, true, true, false, false,
					true, false, true, true, true}
					
	self.emancipatecheck = true

	self.userect = adduserect(self.x, self.y, 12/16, 12/16, self)
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = boximage
	self.quad = boxquad
	self.offsetX = 6
	self.offsetY = 2
	self.quadcenterX = 6
	self.quadcenterY = 6
	
	self.rotation = 0 --for portals
	
	self.falling = false
	self.destroying = false
	self.outtable = {}
	self.portaledframe = false
end

function box:update(dt)
	local friction = boxfrictionair
	if self.falling == false then
		friction = boxfriction
	end
	
	if not self.pushed then
		if self.speedx > 0 then
			self.speedx = self.speedx - friction*dt
			if self.speedx < 0 then
				self.speedx = 0
			end
		else
			self.speedx = self.speedx + friction*dt
			if self.speedx > 0 then
				self.speedx = 0
			end
		end
	else
		self.pushed = false
	end
	
	--rotate back to 0 (portals)
	self.rotation = math.mod(self.rotation, math.pi*2)
	if self.rotation > 0 then
		self.rotation = self.rotation - portalrotationalignmentspeed*dt
		if self.rotation < 0 then
			self.rotation = 0
		end
	elseif self.rotation < 0 then
		self.rotation = self.rotation + portalrotationalignmentspeed*dt
		if self.rotation > 0 then
			self.rotation = 0
		end
	end
	
	if self.parent then
		local oldx = self.x
		local oldy = self.y
		
		self.x = self.parent.x+math.sin(-self.parent.pointingangle)*0.3
		self.y = self.parent.y-math.cos(-self.parent.pointingangle)*0.3
		
		if self.portaledframe == false then
			for h, u in pairs(emancipationgrills) do
				if u.dir == "hor" then
					if inrange(self.x+6/16, u.startx-1, u.endx, true) and inrange(u.y-14/16, oldy, self.y, true) then
						self:emancipate(h)
					end
				else
					if inrange(self.y+6/16, u.starty-1, u.endy, true) and inrange(u.x-14/16, oldx, self.x, true) then
						self:emancipate(h)
					end
				end
			end
		end
	end
	
	self.userect.x = self.x
	self.userect.y = self.y

	--check if offscreen
	if self.y > 17 then
		self:destroy()
	end
	
	self.portaledframe = false
	
	if self.destroying then
		return true
	else
		return false
	end
end

function box:leftcollide(a, b)
	if a == "button" then
		self.y = b.y - self.height
		self.x = b.x + b.width - 0.01
		if self.speedy > 0 then
			self.speedy = 0
		end
		return false
	elseif a == "player" then
		self.pushed = true
		return false
	end
end

function box:rightcollide(a, b)
	if a == "button" then
		self.y = b.y - self.height
		self.x = b.x - self.width+0.01
		if self.speedy > 0 then
			self.speedy = 0
		end
		return false
	elseif a == "player" then
		self.pushed = true
		return false
	end
end

function box:floorcollide(a, b)
	if self.falling then
		self.falling = false
	end
	
	if a == "goomba" or a == "bulletbill" then
		b:stomp()
		addpoints(200, self.x, self.y)
		playsound(stompsound)
		self.falling = true
		return false
	end
end

function box:passivecollide(a, b)
	if a == "player" then
		if self.x+self.width > b.x+b.width then
			self.x = b.x+b.width
		else
			self.x = b.x-self.width
		end
	end
end

function box:startfall()
	self.falling = true
end

function box:emancipate()
	if self.parent then
		self.parent:cubeemancipate()
	end
	self:destroy()
end

function box:destroy()
	self.userect.delete = true
	self.destroying = true
	
	for i = 1, #self.outtable do
		if self.outtable[i].input then
			self.outtable[i]:input("toggle")
		end
	end
end

function box:addoutput(a)
	table.insert(self.outtable, a)
end

function box:used(id)
	self.parent = objects["player"][id]
	self.active = false
	objects["player"][id]:pickupbox(self)
end

function box:dropped()
	self.parent = nil
	self.active = true
end

function box:portaled()
	self.portaledframe = true
end