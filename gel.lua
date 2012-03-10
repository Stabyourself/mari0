gel = class:new()

function gel:init(x, y, id)
	self.id = id
	
	--PHYSICS STUFF
	self.x = x-14/16
	self.y = y-12/16
	self.speedy = 0
	self.speedx = 0
	self.width = 12/16
	self.height = 12/16
	self.static = false
	self.active = true
	self.category = 8
	self.mask = {false, false, true, true, true, true, true, true, false, false, true}
	self.gravity = 50
	self.autodelete = true
	self.timer = 0
	
	--IMAGE STUFF
	self.drawable = true
	self.quad = gelquad[math.random(3)]
	self.offsetX = 8
	self.offsetY = 0
	self.quadcenterX = 8
	self.quadcenterY = 8
	self.rotation = 0 --for portals
	if self.id == 1 then
		self.graphic = gel1img
	elseif self.id == 2 then
		self.graphic = gel2img
	elseif self.id == 3 then
		self.graphic = gel3img
	end
	
	self.destroy = false
end

function gel:update(dt)
	if self.speedy > gelmaxspeed then
		self.speedy = gelmaxspeed
	end
	
	self.rotation = 0
	
	self.timer = self.timer + dt
	if self.timer >= gellifetime then
		return true
	end
	
	return self.destroy
end

function gel:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	self.destroy = true
	if a == "tile" then
		local x, y = b.cox, b.coy
		
		if (inmap(x+1, y) and tilequads[map[x+1][y][1]].collision) or (inmap(x, y) and tilequads[map[x][y][1]].collision == false) then
			return
		end
		
		--see if adjsajcjet tile is a better fit
		if math.floor(self.y+self.height/2)+1 ~= y then
			if inmap(x, math.floor(self.y+self.height/2)+1) and tilequads[map[x][math.floor(self.y+self.height/2)+1][1]].collision then
				y = math.floor(self.y+self.height/2)+1
			end
		end
		
		map[x][y]["gels"]["right"] = self.id
	end
end

function gel:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	self.destroy = true
	if a == "tile" then
		local x, y = b.cox, b.coy
		
		if (inmap(x-1, y) and tilequads[map[x-1][y][1]].collision) or (inmap(x, y) and tilequads[map[x][y][1]].collision == false) then
			return
		end
		
		--see if adjsajcjet tile is a better fit
		if math.floor(self.y+self.height/2)+1 ~= y then
			if inmap(x, math.floor(self.y+self.height/2)+1) and tilequads[map[x][math.floor(self.y+self.height/2)+1][1]].collision then
				y = math.floor(self.y+self.height/2)+1
			end
		end
		
		map[x][y]["gels"]["left"] = self.id
	end
end

function gel:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	self.destroy = true
	if a == "tile" then
		local x, y = b.cox, b.coy
		
		if (inmap(x, y-1) and tilequads[map[x][y-1][1]].collision) or (inmap(x, y) and tilequads[map[x][y][1]].collision == false) then
			return
		end
		
		--see if adjsajcjet tile is a better fit
		if math.floor(self.x+self.width/2)+1 ~= x then
			if inmap(x, y) and tilequads[map[x][y][1]].collision then
				x = math.floor(self.x+self.width/2)+1
			end
		end
		
		if inmap(x, y) and tilequads[map[x][y][1]].collision then
			if map[x][y]["gels"]["top"] == self.id then
				if self.speedx > 0 then
					for cox = x+1, x+self.speedx*0.2 do
						if inmap(cox, y-1) and tilequads[map[cox][y][1]].collision == true and tilequads[map[cox][y-1][1]].collision == false then
							if map[cox][y]["gels"]["top"] ~= self.id then
								map[cox][y]["gels"]["top"] = self.id
								break
							end
						else
							break
						end
					end
				elseif self.speedx < 0 then
					for cox = x-1, x+self.speedx*0.2, -1 do
						if inmap(cox, y-1) and tilequads[map[cox][y][1]].collision and tilequads[map[cox][y-1][1]].collision == false then
							if map[cox][y]["gels"]["top"] ~= self.id then
								map[cox][y]["gels"]["top"] = self.id
								break
							end
						else
							break
						end
					end
				end
			else
				map[x][y]["gels"]["top"] = self.id
			end
		end
	end
end

function gel:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	self.destroy = true
	if a == "tile" then
		local x, y = b.cox, b.coy
		if not inmap(x, y+1) or tilequads[map[x][y+1][1]].collision == false then
			local x, y = b.cox, b.coy
			
			map[x][y]["gels"]["bottom"] = self.id
		end
	end
end

function gel:globalcollide(a, b)
	if a == "tile" then
		local x, y = b.cox, b.coy
		if tilequads[map[x][y][1]].invisible then
			return true
		end
	end
end