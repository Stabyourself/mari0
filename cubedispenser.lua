cubedispenser = class:new()

function cubedispenser:init(x, y, r)
	--PHYSICS STUFF
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1
	self.speedy = 0
	self.speedx = 0
	self.width = 2
	self.height = 2
	self.static = true
	self.active = true
	self.category = 7
	self.mask = {true, false, false, false, false, false, false, false, true}
	
	self.r = r
	self.timer = cubedispensertime
	self.inputactive = false
	self.boxexists = false
	self.box = nil
end

function cubedispenser:input(t)
	if t == "on" or t == "toggle" then
		if self.boxexists then
			self.boxexists = false
			self:removebox()
		end
		
		if self.timer == cubedispensertime then
			self.timer = 0
		end
	end
end

function cubedispenser:link()
	self.outtable = {}
	if #self.r > 2 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[4]) == v.cox and tonumber(self.r[5]) == v.coy then
					v:addoutput(self)
					if entityquads[map[v.cox][v.coy][2]].t == "box" then
						self.boxexists = true
					end
				end
			end
		end
	end
end

function cubedispenser:update(dt)
	if self.timer < cubedispensertime then
		self.timer = self.timer + dt
		
		if self.timer > 0.1 and self.timer <= 0.4 and self.active == true then
			self.active = false
		elseif self.timer > 0.4 and self.timer <= 0.6 and self.active == false then
			self.active = true
		elseif self.timer > 0.6 and self.boxexists == false then
			local temp = box:new(self.cox+.5, self.coy)
			table.insert(objects["box"], temp)
			self.box = temp
			objects["box"][#objects["box"]]:addoutput(self)
			self.boxexists = true
		elseif self.timer > 1 then
			self.timer = 1
		end
	end
	return false
end

function cubedispenser:draw()
	love.graphics.draw(cubedispenserimg, math.floor((self.cox-xscroll-1)*16*scale), (self.coy-1.5)*16*scale, 0, scale, scale, 0, 0)
end

function cubedispenser:removebox()
	if self.box then
		self.box.userect.delete = true
		self.box.destroying = true
	end
end