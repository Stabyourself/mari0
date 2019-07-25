animation = class:new()

--[[ TRIGGERS:
mapload								when the map is loaded
timepassed:time						when <time> ms have passed
--]]

--[[ CONDITIONS:
noprevsublevel						doesn't if the level was changed from another sublevel
--]]

--[[ ACTIONS:
disablecontrols[:player]			disables player input and hides the portal line
enablecontrols[:player]				enables player input and shows portal line
sleep:time							waits for <time> ms
camerax:x							sets the camera xscroll to <x>
cameray:y							sets the camera yscroll to <y>
cameraxpan:x:time					pans the camera horizontally over <time> ms to <x>
cameraypan:y:time					pans the camera vertically over <time> ms to <y>
disablescroll						disables autoscroll
enablescroll						enables autoscroll
setx[:player]:x						sets the x-position of player(s)
sety[:player]:y						sets the y-position of player(s)
playerwalk[:player]:direction		makes players walk into the given <direction>
disableanimation					disables this animation from triggering
enableanimation						enables this animation to trigger
playerjump[:player]					makes players jump (as high as possible)
playerstopjump[:player]				makes players abort the jump (for small jumps)
--]]

function animation:init(path)
	self.filepath = path
	self.raw = love.filesystem.read(self.filepath)
	
	self:decode(self.raw)
	
	self.firstupdate = true
	self.running = false
	self.sleep = 0
	self.enabled = true
end

function animation:decode(s)
	self.triggers = {}
	self.conditions = {}
	self.actions = {}

	local lines
	if string.find(s, "\r\n") then
		lines = s:split("\r\n")
	else
		lines = s:split("\n")
	end
	
	local line = 1
	
	while line <= #lines and not string.find(lines[line], "--triggers") do
		line = line + 1
	end
	
	while line <= #lines and not string.find(lines[line], "--conditions") do
		local v = lines[line]:split(":")
		--triggers
		self:addtrigger(v)
		
		line = line + 1
	end 
	
	while line <= #lines and not string.find(lines[line], "--actions") do
		local v = lines[line]:split(":")
		--conditions
		table.insert(self.conditions, {unpack(v)})
		
		line = line + 1
	end 
	
	while line <= #lines do
		local v = lines[line]:split(":")
		--actions
		self:addaction(v)
		
		line = line + 1
	end 
end

function animation:addtrigger(v)
	table.insert(self.triggers, {unpack(v)})
	if v[1] == "mapload" then
		
	elseif v[1] == "timepassed" then
		self.timer = 0
	end
end

function animation:addaction(v)
	table.insert(self.actions, {unpack(v)})
end

function animation:update(dt)
	--check my triggers for triggering, yo
	for i, v in pairs(self.triggers) do
		if v[1] == "mapload" then
			if self.firstupdate then
				self:trigger()
			end
		elseif v[1] == "timepassed" then
			self.timer = self.timer + dt
			if self.timer >= tonumber(v[2]) and self.timer - dt < tonumber(v[2]) then
				self:trigger()
			end
		elseif v[1] == "playerx" then
			local trig = false
			for i = 1, players do
				if v[2] == "greater" then
					if objects["player"][i].x > tonumber(v[3]) then
						trig = true
					end
				else
					if objects["player"][i].x < tonumber(v[3]) then
						trig = true
					end
				end
			end
			
			if trig then
				self:trigger()
			end
		end
	end
	
	self.firstupdate = false
	
	if self.running then
		if self.sleep > 0 then
			self.sleep = math.max(0, self.sleep - dt)
		end
		
		while self.sleep == 0 and self.currentaction <= #self.actions do
			local v = self.actions[self.currentaction]
			
			if v[1] == "disablecontrols" then
				if #v == 1 then
					for i = 1, players do
						objects["player"][1].controlsenabled = false
					end
				else
					local p = objects["player"][tonumber(v[2])]
					if p then
						p.controlsenabled = false
					end
				end
			elseif v[1] == "enablecontrols" then
				if #v == 1 then
					for i = 1, players do
						objects["player"][1].controlsenabled = true
					end
				else
					local p = objects["player"][tonumber(v[2])]
					if p then
						p.controlsenabled = true
					end
				end
			elseif v[1] == "sleep" then
				self.sleep = tonumber(v[2])/1000
			elseif v[1] == "camerax" then
				xscroll = tonumber(v[2])
			elseif v[1] == "cameraxpan" then
				autoscroll = false
				cameraxpan(tonumber(v[2]), tonumber(v[3]))
			elseif v[1] == "cameraypan" then
				autoscroll = false
				cameraypan(tonumber(v[2]), tonumber(v[3]))
			elseif v[1] == "disablescroll" then
				autoscroll = false
			elseif v[1] == "enablescroll" then
				autoscroll = true
			elseif v[1] == "setx" then
				if #v == 3 then
					for i = 1, players do
						objects[v[2]][i].x = tonumber(v[3])
					end
				else
					objects[v[2]][tonumber(v[3])].x = tonumber(v[4])
				end
			elseif v[1] == "sety" then
				if #v == 3 then
					for i = 1, players do
						objects[v[2]][i].y = tonumber(v[3])
					end
				else
					objects[v[2]][tonumber(v[3])].y = tonumber(v[4])
				end
			elseif v[1] == "playerwalk" then
				if #v == 2 then
					for i = 1, players do
						objects["player"][i]:animationwalk(v[2])
					end
				else
					objects["player"][tonumber(v[2])]:animationwalk(v[3])
				end
			elseif v[1] == "playeranimationstop" then
				if #v == 1 then
					for i = 1, players do
						objects["player"][i]:stopanimation()
					end
				else
					objects["player"][tonumber(v[2])]:stopanimation()
				end
			elseif v[1] == "disableanimation" then
				self.enabled = false
			elseif v[1] == "enableanimation" then
				self.enabled = true
			elseif v[1] == "playerjump" then
				if #v == 1 then
					for i = 1, players do
						objects["player"][i]:jump(true)
					end
				else
					objects["player"][tonumber(v[2])]:jump()
				end
			elseif v[1] == "playerstopjump" then
				if #v == 1 then
					for i = 1, players do
						objects["player"][i]:stopjump(true)
					end
				else
					objects["player"][tonumber(v[2])]:stopjump()
				end
			end
			
			self.currentaction = self.currentaction + 1
		end
		
		if self.currentaction > #self.actions then
			self.running = false
		end
	end
end

function animation:trigger()
	if self.enabled then
		--check conditions
		local pass = true
		
		for i, v in pairs(self.conditions) do
			if v[1] == "noprevsublevel" then
				if prevsublevel then
					pass = false
				end
			end
		end
		
		if pass then
			self.running = true
			self.currentaction = 1
			self.sleep = 0
		end
	end
end

function animation:draw()

end