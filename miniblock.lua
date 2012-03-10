miniblock = class:new()

function miniblock:init(x, y, i)
	self.x = x+math.random()*0.8-0.4
	self.y = y
	self.i = i
	self.speedy = -10
	
	self.timer = math.pi*1.5
end

function miniblock:update(dt)
	self.speedy = self.speedy + yacceleration*dt
	--check for collision
	local x = math.floor(self.x)+1
	local y = math.floor(self.y+self.speedy*dt)+1
	
	if inmap(x, y) and self.speedy > 0 and tilequads[map[x][y][1]].collision then
		self.y = math.ceil(self.y)
		self.speedy = 0
		self.timer = self.timer + dt*3
	end
	
	if self.timer > 5 then
		--check for player pickup
		for i = 1, players do
			local x = objects["player"][i].x+objects["player"][i].width
			local y = objects["player"][i].y+objects["player"][i].height
			
			if math.abs(self.x-x) + math.abs(self.y-y) < 1 then
				if collectblock(self.i) then
					return true
				end
			end
		end
	end
	
	self.y = self.y + self.speedy*dt
	
	if self.y > 16 then
		return true
	end
	
	return false
end

function miniblock:draw()
	local img = customtilesimg
	if self.i <= smbtilecount then
		img = smbtilesimg
	elseif self.i <= smbtilecount+portaltilecount then
		img = portaltilesimg
	end
	
	local yadd = math.sin(self.timer)*0.1+0.15
	love.graphics.drawq(img, tilequads[self.i].quad, math.floor((self.x-xscroll)*16*scale), math.floor((self.y-.5-yadd)*16*scale), 0, scale/2, scale/2, 8, 16)
end