funnel = class:new()

function funnel:init(x, y, r)
	self.cox = x
	self.coy = y
	self.dir = "right"
	self.r = {unpack(r)}
	self.reverse = 1
	self.power = true
	self.firstupdate = true
	self.input1state = "off"
	self.input2state = "off"
	self.quad = 1
	
	self.timer = 0
	self.timer2 = 0
	
	self.objtable = {"player", "goomba", "box", "koopa", "gel"}
	
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	self.speed = funnelspeed
	
	--Input list
	--DIRECTION
	if #self.r > 0 and self.r[1] ~= "link" then
		self.dir = self.r[1]
		table.remove(self.r, 1)
	end
	
	--SPEED
	if #self.r > 0 and self.r[1] ~= "link" and tonumber(self.r[1]) then
		self.speed = tonumber(self.r[1])
		table.remove(self.r, 1)
	end
	
	--DIRECTION
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == "true" then
			self.reverse = -1
		end
		table.remove(self.r, 1)
	end
	
	--POWER
	if #self.r > 0 and self.r[1] ~= "link" then
		if self.r[1] == "true" then
			self.power = false
		end
		table.remove(self.r, 1)
	end
	self:updaterange()
	
	self.animationtime = 3/self.speed-1/16
end

function funnel:link()
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

function funnel:update(dt)	
	if self.power then
		self.timer = self.timer + dt
		if self.timer > self.animationtime then
			self.timer = math.mod(self.timer, self.animationtime)
		end
		
		self.timer2 = self.timer2 + dt
		while self.timer2 > excursionbaseanimationtime do
			self.timer2 = self.timer2 - excursionbaseanimationtime
			if self.reverse == 1 then
				self.quad = self.quad + 1
				if self.quad > 8 then
					self.quad = 1
				end
			else
				self.quad = self.quad - 1
				if self.quad < 1 then
					self.quad = 8
				end
			end		
		end

		local x, y, width, height
		
		for i, v in pairs(self.funneltable) do
			if v.dir == "right" then
				x = v.x-1
				y = v.y-1
				width = v.rangex
				height = 2
			elseif v.dir == "left" then
				x = v.x+v.rangex
				y = v.y-1
				width = -v.rangex
				height = 2
			elseif v.dir == "up" then
				x = v.x-1
				y = v.y+v.rangey
				width = 2
				height = -v.rangey
			else
				x = v.x-1
				y = v.y-1
				width = 2
				height = v.rangey
			end
			
			if v.dir == "right" or v.dir == "left" then
				if v.timer < math.abs(v.rangex) then
					v.timer = v.timer + dt*funnelbuildupspeed
					if v.timer > math.abs(v.rangex) then
						v.timer = math.abs(v.rangex)
					end
				end
			else
				if v.timer < math.abs(v.rangey) then
					v.timer = v.timer + dt*funnelbuildupspeed
					if v.timer > math.abs(v.rangey) then
						v.timer = math.abs(v.rangey)
					end
				end
			end
			
			local rectcol = checkrect(x, y, width, height, self.objtable)
			
			for i = 1, #rectcol, 2 do
				local w = objects[rectcol[i]][rectcol[i+1]]
				w.speedx = 0
				w.speedy = 0
				
				if v.dir == "right" then
					w.speedx = self.speed*self.reverse
					
					local diff = (w.y+w.height/2)-y-1
					w.speedy = -diff*funnelforce
					
					if rectcol[i] == "player" then
						if downkey(rectcol[i+1]) then
							w.speedy = funnelmovespeed
						elseif upkey(rectcol[i+1]) then
							w.speedy = w.speedy-funnelmovespeed
						end
					end
					
				elseif v.dir == "left" then
					w.speedx = -self.speed*self.reverse
					
					local diff = (w.y+w.height/2)-y-1
					w.speedy = -diff*funnelforce
					
					if rectcol[i] == "player" then
						if downkey(rectcol[i+1]) then
							w.speedy = funnelmovespeed
						elseif upkey(rectcol[i+1]) then
							w.speedy = w.speedy-funnelmovespeed
						end
					end
					
				elseif v.dir == "up" then
					w.speedy = -self.speed*self.reverse
					
					local diff = (w.x+w.width/2)-x-1
					w.speedx = -diff*funnelforce
					
					if rectcol[i] == "player" then
						if leftkey(rectcol[i+1]) then
							w.speedx = -funnelmovespeed
						elseif rightkey(rectcol[i+1]) then
							w.speedx = funnelmovespeed
						end
					end
					
				else
					w.speedy = self.speed*self.reverse
					
					local diff = (w.x+w.width/2)-x-1
					w.speedx = -diff*funnelforce
					
					if rectcol[i] == "player" then
						if leftkey(rectcol[i+1]) then
							w.speedx = -funnelmovespeed
						elseif rightkey(rectcol[i+1]) then
							w.speedx = funnelmovespeed
						end
					end
				end
				
				w.funnel = true
				w.gravity = 0
				w.gravitydirection = math.pi/2
			end
		end
	end
end

function funnel:draw()
	love.graphics.setColor(255, 255, 255)
	
	if self.power then
		local img
		if self.reverse == 1 then
			img = excursionfunnelimg
		else
			img = excursionfunnel2img
		end
		
		for i, v in pairs(self.funneltable) do
			if v.dir == "right" then
				local progress = v.timer/v.rangex
				if self.reverse == 1 then
					love.graphics.setScissor((v.x-xscroll-1)*16*scale, (v.y-yscroll-1.5)*16*scale, v.rangex*progress*16*scale, 2*16*scale)
				else
					love.graphics.setScissor((v.x-xscroll-1+(v.rangex*(1-progress)))*16*scale, (v.y-yscroll-1.5)*16*scale, v.rangex*progress*16*scale, 2*16*scale)
				end
				
				for j = 0, math.ceil(v.rangex/3)+1 do
					local x = math.floor((v.x-xscroll-1+(j-1)*3+self.timer/self.animationtime*3*self.reverse)*16*scale)
					
					love.graphics.draw(img, x, math.floor((v.y-yscroll-1.5)*16*scale), 0, scale, scale)
				end
				
				love.graphics.setScissor()
			elseif v.dir == "left" then
				local progress = v.timer/-v.rangex
				if self.reverse == 1 then
					love.graphics.setScissor((v.x+v.rangex-xscroll-v.rangex*(1-progress))*16*scale, (v.y-yscroll-1.5)*16*scale, -v.rangex*progress*16*scale, 2*16*scale)
				else
					love.graphics.setScissor((v.x+v.rangex-xscroll)*16*scale, (v.y-yscroll-1.5)*16*scale, -v.rangex*progress*16*scale, 2*16*scale)
				end
				
				for j = 0, math.ceil(-v.rangex/3)+1 do
					local x = math.floor((v.x+v.rangex-xscroll+(j-1)*3-self.timer/self.animationtime*3*self.reverse)*16*scale)
					
					love.graphics.draw(img, x, math.floor((v.y-yscroll-1.5)*16*scale), 0, scale, scale)
				end
				
				love.graphics.setScissor()
			elseif v.dir == "up" then
				local progress = v.timer/-v.rangey
				if self.reverse == 1 then
					love.graphics.setScissor((v.x-xscroll-1)*16*scale, (v.y+v.rangey-yscroll-.5-v.rangey*(1-progress))*16*scale, 2*16*scale, -v.rangey*progress*16*scale)
				else
					love.graphics.setScissor((v.x-xscroll-1)*16*scale, (v.y+v.rangey-yscroll-.5)*16*scale, 2*16*scale, -v.rangey*progress*16*scale)
				end
				
				for j = 0, math.ceil(-v.rangey/3)+1 do
					local y = math.floor((v.y+v.rangey-yscroll-.5+(j-1)*3-self.timer/self.animationtime*3*self.reverse)*16*scale)
					
					love.graphics.draw(img, math.floor((v.x-xscroll+1)*16*scale), y, math.pi/2, scale, scale)
				end
				
				love.graphics.setScissor()
			else
				local progress = v.timer/v.rangey
				if self.reverse == 1 then
					love.graphics.setScissor((v.x-xscroll-1)*16*scale, (v.y-yscroll-1.5)*16*scale, 2*16*scale, v.rangey*progress*16*scale)
				else
					love.graphics.setScissor((v.x-xscroll-1)*16*scale, (v.y-yscroll-1.5+v.rangey*(1-progress))*16*scale, 2*16*scale, v.rangey*progress*16*scale)
				end
				
				
				for j = 0, math.ceil(v.rangey/3)+1 do
					local y = math.floor((v.y-yscroll-1.5+(j-1)*3+self.timer/self.animationtime*3*self.reverse)*16*scale)
					
					love.graphics.draw(img, math.floor((v.x-xscroll+1)*16*scale), y, math.pi/2, scale, scale)
				end
				
				love.graphics.setScissor()
			end
		end
	end
	
	love.graphics.setColor(255, 255, 255)
	if self.dir == "right" then
		love.graphics.drawq(excursionbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll-1)*16*scale), math.floor((self.coy-yscroll-1.5)*16*scale), 0, scale, scale)
	elseif self.dir == "left" then
		love.graphics.drawq(excursionbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll)*16*scale), math.floor((self.coy-yscroll+.5)*16*scale), math.pi, scale, scale)
	elseif self.dir == "up" then
		love.graphics.drawq(excursionbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll-1)*16*scale), math.floor((self.coy-yscroll-.5)*16*scale), -math.pi/2, scale, scale)
	elseif self.dir == "down" then
		love.graphics.drawq(excursionbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll+1)*16*scale), math.floor((self.coy-yscroll-1.5)*16*scale), math.pi/2, scale, scale)
	end
end

function funnel:updaterange()
	self.funneltable = {}
	
	local dir = self.dir
	local startx, starty = self.cox, self.coy
	local rangex, rangey = 0, 0
	local x, y = self.cox, self.coy
	
	local firstcheck = true
	local quit = false
	local collision = false
	
	while x >= 1 and x <= mapwidth and y >= 1 and y <= mapheight and not collision and (x ~= startx or y ~= starty or dir ~= self.dir or firstcheck == true) and quit == false do
		firstcheck = false
		
		if dir == "right" then
			x = x + 1
			rangex = rangex + 1
		elseif dir == "left" then
			x = x - 1
			rangex = rangex - 1
		elseif dir == "up" then
			y = y - 1
			rangey = rangey - 1
		elseif dir == "down" then
			y = y + 1
			rangey = rangey + 1
		end
		
		--check if current block is a portal
		local opp = "left"
		if dir == "left" then
			opp = "right"
		elseif dir == "up" then
			opp = "down"
		elseif dir == "down" then
			opp = "up"
		end
		
		local portalx, portaly, portalfacing, infacing, portalrealx, portalrealy, portal2realx, portal2realy = getPortal(x, y, opp)
		
		if portalx ~= false and ((dir == "left" and infacing == "right") or (dir == "right" and infacing == "left") or (dir == "up" and infacing == "down") or (dir == "down" and infacing == "up")) then
			--check if complete entry
			local pass = true
			if dir == "right" then
				if y ~= portal2realy-1 then
					pass = false
				end
			elseif dir == "left" then
				if y ~= portal2realy then
					pass = false
				end
			elseif dir == "up" then
				if x ~= portal2realx-1 then
					pass = false
				end
			elseif dir == "down" then
				if x ~= portal2realx then
					pass = false
				end
			end
			
			if pass then
				local dummy = {dir=dir, x=x-rangex, y=y-rangey, rangex=rangex, rangey=rangey, timer=0}
				
				table.insert(self.funneltable, dummy)
				
				x, y = portalrealx, portalrealy
			
				dir = portalfacing
				
				if dir == "down" then
					x = x-1
				elseif dir == "left" then
					y = y-1
				end
				
				rangex, rangey = 0, 0
				
				if dir == "right" then
					x = portalx + 1
				elseif dir == "left" then
					x = portalx - 1
					rangex = 0
				elseif dir == "up" then
					y = portaly - 1
				elseif dir == "down" then
					y = portaly + 1
				end
			end
		end
		
		--doors
		for i, v in pairs(objects["door"]) do
			if v.active then
				local secondx, secondy = x, y
				if dir == "right" then
					secondy = secondy + 1
				elseif dir == "left" then
					secondy = secondy + 1
				elseif dir == "up" then
					secondx = secondx + 1
				elseif dir == "down" then
					secondx = secondx + 1
				end
				if v.dir == "ver" then
					if (x == v.cox or secondx == v.cox) and ((y == v.coy or y == v.coy-1) or (secondy == v.coy or secondy == v.coy-1)) then
						quit = true
					end
				elseif v.dir == "hor" then
					if (y == v.coy or secondy == v.coy) and ((x == v.cox or x == v.cox+1) or (secondx == v.cox or secondx == v.cox+1)) then
						quit = true
					end
				end
			end
		end
		
		--get collision for next while
		if dir == "up" or dir == "down" then
			if not inmap(x+1, y) or (tilequads[map[x][y][1]].collision and tilequads[map[x][y][1]].grate == false) or
			(tilequads[map[x+1][y][1]].collision and tilequads[map[x+1][y][1]].grate == false) then
				collision = true
			end
		else
			if not inmap(x, y+1) or (tilequads[map[x][y][1]].collision and tilequads[map[x][y][1]].grate == false) or
			(tilequads[map[x][y+1][1]].collision and tilequads[map[x][y+1][1]].grate == false) then
				collision = true
			end
		end
	end
	
	if rangex ~= 0 or rangey ~= 0 then
		local dummy = {dir=dir, x=x-rangex, y=y-rangey, rangex=rangex, rangey=rangey, timer=0}
		
		table.insert(self.funneltable, dummy)
		
		if not self.lastblock or (self.lastblock[1] == x+rangex and self.lastblock[2] == y+rangey) then
			for i, v in pairs(self.funneltable) do
				v.timer = math.abs(v.rangex)+math.abs(v.rangey)
			end
		end	
		
		self.lastblock = {x+rangex, y+rangey}
	end
end

function funnel:input(t, input)
	if input == "reverse" then
		if t == "on" and self.input1state == "off" then
			self.reverse = -self.reverse
		elseif t == "off" and self.input1state == "on" then
			self.reverse = -self.reverse
		elseif t == "toggle" then
			self.reverse = -self.reverse
		end
		
		self.input1state = t
		
		for i, v in pairs(self.funneltable) do
			v.timer = 0
		end
	elseif input == "power" then
		if t == "on" and self.input2state == "off" then
			self.power = not self.power
		elseif t == "off" and self.input2state == "on" then
			self.power = not self.power
		elseif t == "toggle" then
			self.power = not self.power
		end
		
		self.input2state = t
	end
end