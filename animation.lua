animation = class:new()

--[[ TRIGGERS:
mapload								when the map is loaded
timepassed:time						when <time> ms have passed
playerxgreater:x					when a player's x is greater than x
playerxless:x						when a player's x is less than x
animationtrigger:i					when animationtrigger with ID i is triggered
--]]

--[[ CONDITIONS:
noprevsublevel						doesn't if the level was changed from another sublevel
worldequals:i						only triggers if current world is i
levelequals:i						only triggers if current level is i
sublevelequals:i					only triggers if current sublevel is i
--]]

--[[ ACTIONS:
disablecontrols[:player]			disables player input and hides the portal line
enablecontrols[:player]				enables player input and shows portal line
sleep:time							waits for <time> secs
setcamerax:x							sets the camera xscroll to <x>
setcameray:y							sets the camera yscroll to <y>
pancameratox:x:time					pans the camera horizontally over <time> secs to <x>
pancameratoy:y:time					pans the camera vertically over <time> secs to <y>
disablescroll						disables autoscroll
enablescroll						enables autoscroll
setx[:player]:x						sets the x-position of player(s)
sety[:player]:y						sets the y-position of player(s)
playerwalk[:player]:direction		makes players walk into the given <direction>
playeranimationstop[:player]		stops whatever animation the player is in
disableanimation					disables this animation from triggering
enableanimation						enables this animation to trigger
playerjump[:player]					makes players jump (as high as possible)
playerstopjump[:player]				makes players abort the jump (for small jumps)
dialogbox:text[:speaker]			creates a dialogbox with <text> and <speaker>
removedialogbox						removes the dialogbox
playmusic:i							plays music <i>
screenshake:power					makes the screen shake with <power>
--]]

function animation:init(path, name)
	self.filepath = path
	self.name = name
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
	
	local animationjson = JSON:decode(s)

	for i, v in pairs(animationjson.triggers) do
		self:addtrigger(v)
	end
	
	for i, v in pairs(animationjson.conditions) do
		self:addcondition(v)
	end
	
	for i, v in pairs(animationjson.actions) do
		self:addaction(v)
	end
	
	--[[
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
	end --]]
end

function animation:addtrigger(v)
	table.insert(self.triggers, {unpack(v)})
	if v[1] == "mapload" then
		
	elseif v[1] == "timepassed" then
		self.timer = 0
	elseif v[1] == "playerx" then
	
	elseif v[1] == "animationtrigger" then
		if not animationtriggerfuncs[v[2] ] then
			animationtriggerfuncs[v[2] ] = {}
		end
		table.insert(animationtriggerfuncs[v[2] ], self)
	end
end

function animation:addcondition(v)
	table.insert(self.conditions, {unpack(v)})
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
		elseif v[1] == "playerxgreater" then
			local trig = false
			for i = 1, players do
				if objects["player"][i].x > tonumber(v[3]) then
					trig = true
				end
			end
			
			if trig then
				self:trigger()
			end
		elseif v[1] == "playerxless" then
			local trig = false
			for i = 1, players do
				if objects["player"][i].x < tonumber(v[3]) then
					trig = true
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
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][1].controlsenabled = false
					end
				else
					local p = objects["player"][tonumber(string.sub(v[2], -1))]
					if p then
						p.controlsenabled = false
					end
				end
			elseif v[1] == "enablecontrols" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][1].controlsenabled = true
					end
				else
					local p = objects["player"][tonumber(string.sub(v[2], -1))]
					if p then
						p.controlsenabled = true
					end
				end
			elseif v[1] == "sleep" then
				self.sleep = tonumber(v[2])
			elseif v[1] == "setcamerax" then
				xscroll = tonumber(v[2])
			elseif v[1] == "pancameratox" then
				autoscroll = false
				cameraxpan(tonumber(v[2]), tonumber(v[3]))
			elseif v[1] == "pancameratoy" then
				autoscroll = false
				cameraypan(tonumber(v[2]), tonumber(v[3]))
			elseif v[1] == "disablescroll" then
				autoscroll = false
			elseif v[1] == "enablescroll" then
				autoscroll = true
			elseif v[1] == "setx" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][i].x = tonumber(v[3])
					end
				else
					if objects["player"][tonumber(string.sub(v[3], -1))] then
						objects["player"][tonumber(string.sub(v[3], -1))].x = tonumber(v[4])
					end
				end
			elseif v[1] == "sety" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects[v[2]][i].y = tonumber(v[3])
					end
				else
					if objects["player"][tonumber(string.sub(v[3], -1))] then
						objects["player"][tonumber(string.sub(v[3], -1))].y = tonumber(v[4])
					end
				end
			elseif v[1] == "playerwalk" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][i]:animationwalk(v[3])
					end
				else
					if objects["player"][tonumber(string.sub(v[2], -1))] then
						objects["player"][tonumber(string.sub(v[2], -1))]:animationwalk(v[3])
					end
				end
			elseif v[1] == "playeranimationstop" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][i]:stopanimation()
					end
				else
					if objects["player"][tonumber(string.sub(v[2], -1))] then
						objects["player"][tonumber(string.sub(v[2], -1))]:stopanimation()
					end
				end
			elseif v[1] == "disableanimation" then
				self.enabled = false
			elseif v[1] == "enableanimation" then
				self.enabled = true
			elseif v[1] == "playerjump" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][i]:jump(true)
					end
				else
					if objects["player"][tonumber(string.sub(v[2], -1))] then
						objects["player"][tonumber(string.sub(v[2], -1))]:jump(true)
					end
				end
			elseif v[1] == "playerstopjump" then
				if v[2] == "everyone" then
					for i = 1, players do
						objects["player"][i]:stopjump(true)
					end
				else
					if objects["player"][tonumber(string.sub(v[2], -1))] then
						objects["player"][tonumber(string.sub(v[2], -1))]:stopjump()
					end
				end
			elseif v[1] == "dialogbox" then
				createdialogbox(v[2], v[3])
			elseif v[1] == "removedialogbox" then
				dialogboxes = {}
			
			elseif v[1] == "playmusic" then
				love.audio.stop()
				if v[2] then
					if musicname then
						music:stop(musicname)
					end
					musicname = v[2]
					playmusic()
				end
			elseif v[1] == "screenshake" then
				earthquake = tonumber(v[2]) or 1
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
					break
				end
			elseif v[1] == "sublevelequals" then
				if tonumber(v[2]) ~= tonumber(mariosublevel) then
					pass = false
					break
				end
			elseif v[1] == "levelequals" then
				if tonumber(v[2]) ~= tonumber(mariolevel) then
					pass = false
					break
				end
			elseif v[1] == "worldequals" then
				if tonumber(v[2]) ~= tonumber(marioworld) then
					pass = false
					break
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