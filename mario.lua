mario = class:new()

function mario:init(x, y, i, animation, size, t)
	if (SERVER or CLIENT) and i ~= netplayernumber then
		self.remote = true
	end
	
	self.alwaysactive = true
	self.char = characters[mariocharacter[i]]
	
	if playertype == "minecraft" then
		self.char = characters.minecraft
	end
	
	self.playernumber = i or 1
	if bigmario then
		self.size = 1
	else
		self.size = size or 1
	end
	self.t = t or "portal"
	self.portalsavailable = {unpack(portalsavailable)}
	
	--PHYSICS STUFF
	self.speedx = 0
	self.speedy = 0
	self.x = x
	self.width = 12/16
	self.height = 12/16
	
	if bigmario then
		self.width = self.width*scalefactor
		self.height = self.height*scalefactor
	end
	
	self.lastground = {0, 0}
	
	self.y = y+1-self.height
	self.static = false
	self.active = true
	self.category = 3
	self.mask = {	true, 
					false, true, false, false, false,
					false, true, false, false, false,
					false, true, false, false, false,
					false, false, false, false, false,
					false, false, false, false, false,
					false, false, false, false, false}
					
	if playercollisions then
		self.mask[3] = false
	end
	
	self.emancipatecheck = true
	
	--IMAGE STUFF
	if self.portalsavailable[1] or self.portalsavailable[2] or not self.char.nogunanimations then
		self.smallgraphic = self.char.animations
		self.biggraphic = self.char.biganimations
	else
		self.smallgraphic = self.char.nogunanimations
		self.biggraphic = self.char.nogunbiganimations
	end
	
	self.drawable = true
	self.quad = self.char.idle[3]
	self.colors = mariocolors[self.playernumber]
	self.customscale = self.char.customscale
	if self.size == 1 then
		self.offsetX = self.char.smalloffsetX
		self.offsetY = self.char.smalloffsetY
		self.quadcenterX = self.char.smallquadcenterX
		self.quadcenterY = self.char.smallquadcenterY
		
		self.graphic = self.smallgraphic
	else
		self.graphic = self.biggraphic
		
		self.quadcenterY = self.char.bigquadcenterY
		self.quadcenterX = self.char.bigquadcenterX
		self.offsetY = self.char.bigoffsetY
		self.offsetX = self.char.bigoffsetX
		
		self.y = self.y - 12/16
		self.height = 24/16
		
		if self.size == 3 then
			self.colors = self.char.flowercolor or flowercolor
		end
	end
	
	if bigmario then
		self.offsetX = self.offsetX*scalefactor
		self.offsetY = self.offsetY*-scalefactor
	end
	
	--hat
	self.hats = mariohats[self.playernumber]
	self.drawhat = true
	
	--Change height according to hats
	
	--for i = 1, #self.hats do
		--self.height = self.height + (hat[self.hats[i]].height/16)
		--self.y = self.y - (hat[self.hats[i]].height/16)
		--self.offsetY = self.offsetY - hat[self.hats[i]].height
	--end
	
	self.customscissor = false
	
	if players == 1 and not arcade then
		self.portal1color = {60, 188, 252}
		self.portal2color = {232, 130, 30}
	else
		self.portal1color = portalcolor[self.playernumber][1]
		self.portal2color = portalcolor[self.playernumber][2]
	end
	
	if self.portalsavailable[1] then
		self.lastportal = 1
	elseif self.portalsavailable[2] then
		self.lastportal = 2
	end
	
	--OTHER STUFF!
	self.controlsenabled = true
	
	self.runframe = self.char.runframes
	self.jumpframe = 1
	self.swimframe = 1
	self.climbframe = 1
	self.runanimationprogress = 1
	self.jumpanimationprogress = 1
	self.swimanimationprogress = 1
	self.animationstate = "falling" --idle, running, jumping, falling, swimming, sliding, climbing, dead
	self.animationdirection = "right" --left, right. duh
	self.platform = false
	self.combo = 1
	if not portals[self.playernumber] then
		portals[self.playernumber] = portal:new(self.playernumber, self.portal1color, self.portal2color)
	end
	self.portal = portals[self.playernumber]
	self.rotation = 0 --for portals
	self.pointingangle = -math.pi/2
	self.animationdirection = "right"
	self.passivemoved = false
	self.ducking = false
	self.invincible = false
	self.rainboomallowed = true
	self.looktimer = 0
	self.raccoonstarttimer = 0
	self.raccoontimer = 0
	self.raccoonascendtimer = 0
	self.tailwagframe = 1
	self.tailwagtimer = 0
	
	self.gravitydirection = math.pi/2
	
	self.animation = animation or false --pipedown, piperight, pipeup, flag, vine, intermission
	self.animationx = false
	self.animationy = false
	self.animationtimer = 0
	
	self.falling = true
	self.jumping = false
	self.starred = false
	self.dead = false
	self.vine = false
	self.spring = false
	self.startimer = mariostarduration
	self.starblinktimer = mariostarblinkrate
	self.starcolori = 1
	self.fireballcount = 0
	self.fireanimationtimer = fireanimationtime
	
	self.mazevar = 0
	
	self.bubbletimer = 0
	self.bubbletime = bubblestime[math.random(#bubblestime)]
	
	self.underwater = underwater
	if self.underwater then
		self:dive(true)
	end
	
	if self.animation == "intermission" and editormode then
		self.animation = false
	end
	
	if mariolivecount ~= false and mariolives[self.playernumber] <= 0 then
		self.dead = true
		self.drawable = false
		self.active = false
		self.static = true
		self.controlsenabled = false
		self.animation = false
	end
	
	if self.animation == "pipeup" then
		self.controlsenabled = false
		self.active = false
		self.animationx = x
		self.animationy = y
		self.customscissor = {x-2.5, y-4, 6, 4}
		self.y = self.animationy + 20/16
		
		self.animationstate = "idle"
		self:setquad()
		
		if self.size > 1 then
			self.animationy = y - 12/16
		end
		
		if arcade and not arcadeplaying[self.playernumber] then
			self.y = self.animationy + 20/16 - pipeanimationdistancedown
			self.animation = false
		end
	elseif self.animation == "intermission" then
		self.controlsenabled = false
		self.active = true
		self.gravity = mariogravity
		self.animationstate = "running"
		self.speedx = 2.61
		self.pointingangle = -math.pi/2
		self.animationdirection = "right"
	elseif self.animation == "vinestart" then
		self.controlsenabled = false
		self.active = false
		self.pointingangle = -math.pi/2
		self.animationdirection = "right"
		self.climbframe = 2
		self.animationstate = "climbing"
		self:setquad()
		self.x = 4-3/16
		self.y = 15+0.4*(self.playernumber-1)
		self.vineanimationclimb = false
		self.vineanimationdropoff = false
		self.vinemovetimer = 0
		playsound("vine")
		
		if #objects["vine"] == 0 then
			table.insert(objects["vine"], vine:new(5, 16, "start"))
		end
	end
	
	self.lastx = false
	self.lasty = false
	self.lasta = false
	self.noChangeFrames = 0
	self.replayFrames = 0
	
	if not drawplayers then
		self.drawable = false
	end
	self:setquad()
end

function mario:adddata()
	if ttstate == "demo" or self.nomorereplays then
		return
	end
	
	if self.animation ~= "axe" then
		self.replayFrames = self.replayFrames + 1
	end
	
	local x = round(self.x*16)
	local y = round(self.y*16)
	
	--animationframe
	local a = 0
	if self.animationstate == "idle" then
		a = 0
	elseif self.animationstate == "running" or self.animationstate == "falling" then
		a = self.runframe
	elseif self.animationstate == "sliding" then
		a = 4
	elseif self.animationstate == "jumping" then
		a = 5
	end
	
	if self.animationdirection == "left" then
		a = a + 6
	end
	
	if x == self.lastx and y == self.lasty and a == self.lasta then
		self.noChangeFrames = self.noChangeFrames + 1
	else
		local frameData = {}
		
		if x ~= self.lastx then
			frameData.x = x
		end
		
		if y ~= self.lasty then
			frameData.y = y
		end
		
		if a ~= self.lasta then
			frameData.a = a
		end
		
		if self.noChangeFrames > 0 then
			table.insert(livereplaydata[self.playernumber], self.noChangeFrames)
			self.noChangeFrames = 0
		end
		
		table.insert(livereplaydata[self.playernumber], frameData)
		
		self.lastx = x
		self.lasty = y
		self.lasta = a
		
	end
end

function mario:update(dt)
	if replaysystem then
		livereplaydelay[self.playernumber] = livereplaydelay[self.playernumber] + dt
		while livereplaydelay[self.playernumber] >= 1/60 do
			self:adddata()
			livereplaydelay[self.playernumber] = livereplaydelay[self.playernumber] - 1/60
		end
	end
	
	self.passivemoved = false
	self.rotation = unrotate(self.rotation, self.gravitydirection, dt)
	
	--Tailwag!
	if self.char.raccoon and (self.tailwag or self.tailwagtimer > 0) then
		if self.tailwagtimer == 0 then
			self.tailwag = false
			playsound("tailwag")
		end
		self.tailwagtimer = self.tailwagtimer + dt
		while self.tailwagtimer > raccoontailwagdelay do
			self.tailwagframe = self.tailwagframe + 1
			self.tailwagtimer = self.tailwagtimer - raccoontailwagdelay
			if self.tailwagframe > 3 then
				self.tailwagframe = 1
				self.tailwagtimer = 0
			end
		end
	end
	
	--Spin!
	if self.char.raccoon and self.raccoonspinframe then
		if self.raccoonspintimer == 0 then
			playsound("tailwag")
		end
		self.raccoonspintimer = self.raccoonspintimer + dt
		while self.raccoonspintimer > raccoonspindelay and self.raccoonspinframe do
			self.raccoonspintimer = self.raccoonspintimer - raccoonspindelay
			self.raccoonspinframe = self.raccoonspinframe + 1
			if self.raccoonspinframe >= 4 then
				self.raccoonspinframe = false
			end
		end
	end
	
	if self.startimer < mariostarduration and not self.dead then
		self.startimer = self.startimer + dt
		self.starblinktimer = self.starblinktimer + dt
		
		local lmariostarblinkrate = mariostarblinkrate
		if self.startimer >= mariostarduration-mariostarrunout then
			lmariostarblinkrate = mariostarblinkrateslow
		end

		while self.starblinktimer > lmariostarblinkrate do
			self.starcolori = self.starcolori + 1
			if self.starcolori > 4 then
				self.starcolori = self.starcolori - 4
			end
			self.colors = starcolors[self.starcolori]
			
			self.starblinktimer = self.starblinktimer - lmariostarblinkrate
		end
		
		if self.startimer >= mariostarduration-mariostarrunout and self.startimer-dt < mariostarduration-mariostarrunout then
			--check if another starman is playing
			local starstill = false
			for i = 1, players do
				if i ~= self.playernumber and objects["player"][i].starred then
					starstill = true
				end
			end
			
			if not starstill and not levelfinished then
				playmusic()
				music:stop("starmusic.ogg")
			end
		end
		
		if self.startimer >= mariostarduration then
			if self.size == 3 then --flower colors
				self.colors = self.char.flowercolor or flowercolor
			else
				self.colors = mariocolors[self.playernumber]
			end
			self.starred = false
			self.startimer = mariostarduration
		end
	end
	
	if self.jumping then
		if self.underwater then
			self.gravity = uwyaccelerationjumping
		else
			self.gravity = yaccelerationjumping
		end
		
		if self.speedy > 0 then
			self.jumping = false
			self.falling = true
		end
	else
		if self.underwater then
			self.gravity = uwyacceleration
		else
			self.gravity = yacceleration
		end
	end
	
	if self.size ~= 1 then
		self.gravitydirection = math.pi/2
	end
	
	--ANIMATIONS
	if self.animation == "animationwalk" then
		if self.animationmisc == "right" then
			self.speedx = maxwalkspeed
		else
			self.speedx = -maxwalkspeed
		end
		self:runanimation(dt)
		return
	elseif self.animation == "pipedown" and self.animationy and self.animationx then
		self.animationtimer = self.animationtimer + dt
		if self.animationtimer < pipeanimationtime then
			self.y = self.animationy - 28/16 + self.animationtimer/pipeanimationtime*pipeanimationdistancedown
		else
			self.y = self.animationy - 28/16 + pipeanimationdistancedown
			
			if self.animationtimer >= pipeanimationtime+pipeanimationdelay then
				updatesizes()
				if type(self.animationmisc) == "number" then --sublevel
					levelscreen_load("sublevel", self.animationmisc)
				else --warpzone
					warpzone(self.animationmisc2, self.animationmisc3)
				end
			end
		end
		return
	elseif self.animation == "pipeup" and self.animationy and self.animationx then
		self.animationtimer = self.animationtimer + dt
		if self.animationtimer < pipeupdelay then
		
		elseif self.animationtimer < pipeanimationtime+pipeupdelay then
			self.y = self.animationy + 20/16 - (self.animationtimer-pipeupdelay)/pipeanimationtime*pipeanimationdistancedown
		else
			self.y = self.animationy + 20/16 - pipeanimationdistancedown
			
			if self.animationtimer >= pipeanimationtime then
				self.active = true
				self.controlsenabled = true
				self.animation = false
				self.customscissor = false
			end
		end
		return
	elseif self.animation == "piperight" and self.animationy and self.animationx then
		self.animationtimer = self.animationtimer + dt
		if self.animationtimer < pipeanimationtime then
			self.x = self.animationx - 28/16 + self.animationtimer/pipeanimationtime*pipeanimationdistanceright
			
			--Run animation
			if self.animationstate == "running" then
				self:runanimation(dt)
			end
			self:setquad()
		else
			self.x = self.animationx - 28/16 + pipeanimationdistanceright
			
			if self.animationtimer >= pipeanimationtime+pipeanimationdelay then
				updatesizes()
				if type(self.animationmisc) == "number" then --sublevel
					levelscreen_load("sublevel", self.animationmisc)
				else --warpzone
					warpzone(self.animationmisc2, self.animationmisc3)
				end
			end
		end
		return
	elseif self.animation == "flag" and flagx then
		if self.animationtimer < flagdescendtime then 	
			flagimgy = flagy-10+1/16 + flagydistance * (self.animationtimer/flagdescendtime)
			self.y = self.y + flagydistance/flagdescendtime * dt
			
			self.animationtimer = self.animationtimer + dt
				
			if self.y > flagy-9+4/16 + flagydistance-self.height then
				self.y = flagy-9+4/16 + flagydistance-self.height
				self.climbframe = 2
			else
				if math.mod(self.animationtimer, flagclimbframedelay*2) >= flagclimbframedelay then
					self.climbframe = 1
				else
					self.climbframe = 2
				end
			end
			
			self.animationstate = "climbing"
			self:setquad()
			
			if self.animationtimer >= flagdescendtime then
				flagimgy = flagy-10+1/16 + flagydistance
				self.pointingangle = math.pi/2
				self.animationdirection = "left"
				self.x = flagx + 6/16
			end
			return
		elseif self.animationtimer < flagdescendtime+flaganimationdelay then
			self.animationtimer = self.animationtimer + dt
			
			if self.animationtimer >= flagdescendtime+flaganimationdelay then
				self.active = true
				self.gravity = mariogravity
				self.animationstate = "running"
				self.speedx = 4.27
				self.pointingangle = -math.pi/2
				self.animationdirection = "right"
			end
		else
			self.animationtimer = self.animationtimer + dt
		end
		
		local add = 6
		
		if (self.x >= flagx + add or self.speedx < maxwalkspeed/2) and self.active then
			self.drawable = false
			self.active = false
			if mariotime > 0 then
				playsound("scorering")
				subtractscore = true
				subtracttimer = 0
			else
				castleflagmove = true
			end
		end
		
		if subtractscore == true and mariotime >= 0 then
			subtracttimer = subtracttimer + dt
			while subtracttimer > scoresubtractspeed do
				subtracttimer = subtracttimer - scoresubtractspeed
				if mariotime > 0 then
					mariotime = math.ceil(mariotime - 1)
					marioscore = marioscore + 50
				end
				
				if mariotime <= 0 then
					subtractscore = false
					soundlist["scorering"].source:stop()
					castleflagmove = true
					mariotime = 0
				end
			end
		end
		
		if castleflagmove then
			if self.animationtimer < castlemintime then
				castleflagtime = self.animationtimer
				return
			end
			castleflagy = castleflagy - castleflagspeed*dt
			
			if castleflagy <= 0 then
				castleflagy = 0
				castleflagmove = false
				firework = true
				castleflagtime = self.animationtimer
			end
		end
		
		if firework then
			local timedelta = self.animationtimer - castleflagtime
			for i = 1, fireworkcount do
				local fireworktime = i*fireworkdelay
				if timedelta >= fireworktime and timedelta - dt < fireworktime then
					table.insert(fireworks, fireworkboom:new(flagx+6, flagy-13))
				end
			end
			
			if timedelta > fireworkcount*fireworkdelay+endtime then
				nextlevel()
				return
			end
		end
		
		--500 points per firework, appear at 1 3 and 6 (Who came up with this?)
		
		--Run animation
		if self.animationstate == "running" then
			self:runanimation(dt)
			self:setquad()
		end
		return
	
	elseif self.animation == "axe" then
		self.animationtimer = self.animationtimer + dt
		
		if not bowserfall and self.animationtimer - dt < castleanimationchaindisappear and self.animationtimer >= castleanimationchaindisappear then
			bridgedisappear = true
		end
		
		if bridgedisappear then
			local v = objects["bowser"][1]
			if v then
				v.walkframe = round(math.mod(self.animationtimer, castleanimationbowserframedelay*2)*(1/(castleanimationbowserframedelay*2)))+1
			end
			self.animationtimer2 = self.animationtimer2 + dt
			while self.animationtimer2 > castleanimationbridgedisappeardelay do
				self.animationtimer2 = self.animationtimer2 - castleanimationbridgedisappeardelay
				if inmap(self.animationbridgex, self.animationbridgey) and map[self.animationbridgex][self.animationbridgey][1] == 11 then
					map[self.animationbridgex][self.animationbridgey][1] = 1
					objects["tile"][self.animationbridgex .. "-" .. self.animationbridgey] = nil
					if tilequads[map[self.animationbridgex][self.animationbridgey-1][1]].bridge then
						map[self.animationbridgex][self.animationbridgey-1][1] = 1
					end
					generatespritebatch()
					playsound("bridgebreak")
					self.animationbridgex = self.animationbridgex - 1
				else
					bowserfall = true
					bridgedisappear = false
				end
			end
		end
		
		if bowserfall then
			local v = objects["bowser"][1]
			if v and not v.fall then
				v.fall = true
				v.speedx = 0
				v.speedy = 0
				v.active = true
				v.gravity = 27.5
				playsound("bowserfall")
				self.animationtimer = 0
				return
			end
		end
		
		if bowserfall and self.animationtimer - dt < castleanimationmariomove and self.animationtimer >= castleanimationmariomove then
			self.active = true
			self.gravity = mariogravity
			self.animationstate = "running"
			self.speedx = 4.27
			self.pointingangle = -math.pi/2
			self.animationdirection = "right"
		
			love.audio.stop()
			playsound("castleend")
		end
		
		if self.speedx > 0 and self.x >= mapwidth - 8 then
			self.x = mapwidth - 8
			self.animationstate = "idle"
			self:setquad()
			self.speedx = 0
			self:adddata()
			self.nomorereplays = true
		end
		
		if levelfinishedmisc2 == 1 then
			if self.animationtimer - dt < castleanimationtextfirstline and self.animationtimer >= castleanimationtextfirstline then
				levelfinishedmisc = 1
			end
			
			if self.animationtimer - dt < castleanimationtextsecondline and self.animationtimer >= castleanimationtextsecondline then
				levelfinishedmisc = 2
				if ttrank <= 10 then
					highscoreentry()
				end
			end
		
			if self.animationtimer - dt < castleanimationnextlevel and self.animationtimer >= castleanimationnextlevel then
				if ttrank <= 10 then
					
				else
					self:savereplaydata()
					nextlevel()
				end
			end
		else
			if self.animationtimer - dt < endanimationtextfirstline and self.animationtimer >= endanimationtextfirstline then
				levelfinishedmisc = 1
			end
			
			if self.animationtimer - dt < endanimationtextsecondline and self.animationtimer >= endanimationtextsecondline then
				levelfinishedmisc = 2
				love.audio.stop()
				music:play("princessmusic.ogg")
			end
		
			if self.animationtimer - dt < endanimationtextthirdline and self.animationtimer >= endanimationtextthirdline then
				levelfinishedmisc = 3
			end
			
			if self.animationtimer - dt < endanimationtextfourthline and self.animationtimer >= endanimationtextfourthline then
				levelfinishedmisc = 4
			end
			
			if self.animationtimer - dt < endanimationtextfifthline and self.animationtimer >= endanimationtextfifthline then
				levelfinishedmisc = 5
			end
		
			if self.animationtimer - dt < endanimationend and self.animationtimer >= endanimationend then
				--endpressbutton = true
				arcade_reset = true
			end
		end
		
		--Run animation
		if self.animationstate == "running" and self.animationtimer >= castleanimationmariomove then
			self:runanimation(dt)
		end
		return
		
	elseif self.animation == "death" or self.animation == "deathpit" then
		self.animationtimer = self.animationtimer + dt
		self.animationstate = "dead"
		self:setquad()
		
		if self.animation == "death" then
			if self.animationtimer >= deathanimationjumptime then
				if self.animationtimer - dt < deathanimationjumptime then
					self.speedy = -deathanimationjumpforce
				end
				self.speedy = self.speedy + deathgravity*dt
				self.y = self.y + self.speedy*dt
			end
		end
		
		if self.animationtimer > deathtotaltime then
			if self.animationmisc == "everyonedead" then
				levelscreen_load("death")
			elseif not everyonedead then
				self:respawn()
			end
		end
		
		return
	elseif self.animation == "intermission" then
		--Run animation
		if self.animationstate == "running" then
			self:runanimation(dt)
		end
		
		return
		
	elseif self.animation == "vine" then
		self.y = self.y - vinemovespeed*dt
		
		self.vinemovetimer = self.vinemovetimer + dt
		
		self.climbframe = math.ceil(math.mod(self.vinemovetimer, vineframedelay*2)/vineframedelay)
		self.climbframe = math.max(self.climbframe, 1)
		self:setquad()
		
		if self.y < -4 then
			levelscreen_load("vine", self.animationmisc)
		end
		return
	elseif self.animation == "vinestart" then
		self.animationtimer = self.animationtimer + dt
		if self.vineanimationdropoff == false and self.animationtimer - dt <= vineanimationmariostart and self.animationtimer > vineanimationmariostart then
			self.vineanimationclimb = true
		end
		
		if self.vineanimationclimb then
			self.vinemovetimer = self.vinemovetimer + dt
			
			self.climbframe = math.ceil(math.mod(self.vinemovetimer, vineframedelay*2)/vineframedelay)
			self.climbframe = math.max(self.climbframe, 1)
			
			self.y = self.y - vinemovespeed*dt
			if self.y <= 15-vineanimationgrowheight+vineanimationstop+0.4*(self.playernumber-1) then
				self.vineanimationclimb = false
				self.vineanimationdropoff = true
				self.animationtimer = 0
				self.y = 15-vineanimationgrowheight+vineanimationstop+0.4*(self.playernumber-1)
				self.climbframe = 2
				self.pointingangle = math.pi/2
				self.animationdirection = "left"
				self.x = self.x+9/16
			end
			self:setquad()
		end
		
		if self.vineanimationdropoff and self.animationtimer - dt <= vineanimationdropdelay and self.animationtimer > vineanimationdropdelay then
			self.active = true
			self.controlsenabled = true
			self.x = self.x + 7/16
			self.animation = false
		end
		
		return
	
	elseif self.animation == "shrink" then
		self.animationtimer = self.animationtimer + dt
		--set frame lol
		local frame = math.ceil(math.mod(self.animationtimer, growframedelay*3)/shrinkframedelay)
		self:updateangle()
	
		if frame == 1 then
			self.graphic = self.biggraphic
			self:setquad("idle", 2)
			self.quadcenterY = self.char.shrinkquadcenterY
			self.quadcenterX = self.char.shrinkquadcenterX
			self.offsetY = self.char.bigoffsetY
			self.animationstate = "idle"
		else
			self.graphic = self.smallgraphic
			self.quadcenterX = self.char.smallquadcenterX
			self.offsetY = self.char.smalloffsetY
			if frame == 2 then
				self.animationstate = "grow"
				self:setquad("grow")
				self.quadcenterY = self.char.shrinkquadcenterY2
			else
				self.animationstate = "idle"
				self:setquad()
				self.quadcenterY = self.char.smallquadcenterY
			end
		end
		
		local invis = math.ceil(math.mod(self.animationtimer, invicibleblinktime*2)/invicibleblinktime)
		
		if invis == 1 then
			self.drawable = true
		else
			self.drawable = false
		end
		
		if self.animationtimer - dt < shrinktime and self.animationtimer > shrinktime then
			self:goinvincible()
		end
		return
	elseif self.animation == "invincible" then
		self.animationtimer = self.animationtimer + dt
		
		local invis = math.ceil(math.mod(self.animationtimer, invicibleblinktime*2)/invicibleblinktime)
		
		if invis == 1 then
			self.drawable = true
		else
			self.drawable = false
		end
		
		if self.animationtimer - dt < invincibletime and self.animationtimer > invincibletime then
			self.animation = false
			self.invincible = false
			self.drawable = true
		end
		
	elseif self.animation == "grow1" then
		self.animationtimer = self.animationtimer + dt
		--set frame lol
		local frame = math.ceil(math.mod(self.animationtimer, growframedelay*3)/growframedelay)
		self:updateangle()
		
		if frame == 3 then
			self.animationstate = "idle"
			self.graphic = self.biggraphic
			self:setquad("idle")
			self.quadcenterY = self.char.bigquadcenterY
			self.quadcenterX = self.char.bigquadcenterX
			self.offsetY = self.char.bigoffsetY
		else
			self.graphic = self.smallgraphic
			self.quadcenterX = self.char.smallquadcenterX
			self.offsetY = self.char.smalloffsetY
			if frame == 2 then
				self.animationstate = "grow"
				self:setquad("grow", 1)
				self.quadcenterY = self.char.growquadcenterY
			else
				self.animationstate = "idle"
				self:setquad(nil, 1)
				self.quadcenterY = self.char.growquadcenterY2
			end
		end
		
		if self.animationtimer - dt < growtime and self.animationtimer > growtime then
			self.animationstate = self.animationmisc
			self.animation = false
			noupdate = false
			self.quadcenterY = self.char.bigquadcenterY
			self.graphic = self.biggraphic
			self.animationtimer = 0
			self.quadcenterX = self.char.bigquadcenterX
			self.offsetY = self.char.bigoffsetY
		end
		return
		
	elseif self.animation == "grow2" then
		self.animationtimer = self.animationtimer + dt
		--set frame lol
		local frame = math.ceil(math.mod(self.animationtimer, growframedelay*3)/growframedelay)
		self:updateangle()
		self.colors = starcolors[frame]
		
		if self.animationtimer - dt < growtime and self.animationtimer > growtime then
			self.animation = false
			noupdate = false
			self.animationtimer = 0
			self.colors = self.char.flowercolor or flowercolor
		end
		return
	end
	
	if noupdate then
		return
	end
	
	if self.fireanimationtimer < fireanimationtime then
		self.fireanimationtimer = self.fireanimationtimer + dt
		if self.fireanimationtimer > fireanimationtime then
			self.fireanimationtimer = fireanimationtime
		end
	end
	
	--Funnels and fuck
	if self.funnel and not self.infunnel then
		self:enteredfunnel(true)
	end
	
	if self.infunnel and not self.funnel then
		self:enteredfunnel(false)
	end
	
	if self.funnel then
		self.animationstate = "jumping"
		self:setquad()
	end
	
	self.funnel = false
	
	--vine controls and shit
	if self.vine then
		self.gravity = 0
		self.animationstate = "climbing"
		if upkey(self.playernumber) then
			self.vinemovetimer = self.vinemovetimer + dt
			
			self.climbframe = math.ceil(math.mod(self.vinemovetimer, vineframedelay*2)/vineframedelay)
			self.climbframe = math.max(self.climbframe, 1)
			
			self.y = self.y-vinemovespeed*dt
			
			local t = checkrect(self.x, self.y, self.width, self.height, {"tile", "portalwall"})
			if #t ~= 0 then
				self.y = objects[t[1]][t[2]].y + objects[t[1]][t[2]].height
				self.climbframe = 2
			end
		elseif downkey(self.playernumber) then
			self.vinemovetimer = self.vinemovetimer + dt
			
			self.climbframe = math.ceil(math.mod(self.vinemovetimer, vineframedelaydown*2)/vineframedelaydown)
			self.climbframe = math.max(self.climbframe, 1)
			
			checkportalHOR(self, self.y+vinemovedownspeed*dt)
			
			self.y = self.y+vinemovedownspeed*dt
			
			local t = checkrect(self.x, self.y, self.width, self.height, {"tile", "portalwall"})
			if #t ~= 0 then
				self.y = objects[t[1]][t[2]].y - self.height
				self.climbframe = 2
			end
		else
			self.climbframe = 2
			self.vinemovetimer = 0
		end
			
		if self.y+self.height <= vineanimationstart then
			self:vineanimation()
		end
		
		--check if still on vine
		local t = checkrect(self.x, self.y, self.width, self.height, {"vine"})
		if #t == 0 then
			self:dropvine(self.vineside)
		end
		
		self:setquad()
		return
	end
	
	--springs
	if self.spring then
		self.x = self.springx
		self.springtimer = self.springtimer + dt
		self.y = self.springy - self.height - 31/16 + springytable[self.springb.frame]
		if self.springtimer > springtime then
			self:leavespring()
		end
		return
	end
	
	--coins
	if not editormode then
		local x = math.floor(self.x+self.width/2)+1
		local y = math.floor(self.y+self.height)+14/16
		if inmap(x, y) and coinmap[x][y] then
			collectcoin(x, y)
		end
		local y = math.floor(self.y+self.height/2)+1
		if inmap(x, y) and coinmap[x][y] then
			collectcoin(x, y)
		end
		if self.size > 1 then
			if inmap(x, y-1) and coinmap[x][y-1] then
				collectcoin(x, y-1)
			end
		end
	end
	
	--mazegate
	local x = math.floor(self.x+self.width/2)+1
	local y = math.floor(self.y+self.height/2)+1
	if inmap(x, y) and map[x][y][2] and entityquads[map[x][y][2]] and entityquads[map[x][y][2]].t == "mazegate" then
		if map[x][y][3] == self.mazevar + 1 then
			self.mazevar = self.mazevar + 1
		elseif map[x][y][3] == self.mazevar then
			
		else
			self.mazevar = 0
		end
	end
	
	--axe
	local x = math.floor(self.x+self.width/2)+1
	local y = math.floor(self.y+self.height/2)+1
	
	if axex and x == axex and y == axey then
		self:axe()
	end
	
	if self.controlsenabled then
		--check for pipe pipe pipe�
		if inmap(math.floor(self.x+30/16), math.floor(self.y+self.height+20/16)) and downkey(self.playernumber) and self.falling == false and self.jumping == false then
			local t2 = map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][2]
			if t2 and entityquads[t2] and entityquads[t2].t == "pipe" then
				self:pipe(math.floor(self.x+30/16), math.floor(self.y+self.height+20/16), "down", tonumber(map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][3]-1))
				return
			elseif t2 and entityquads[t2] and entityquads[t2].t == "warppipe" then
				self.animationmisc2 = tonumber(map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][3]) or 1
				self.animationmisc3 = tonumber(map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][4]) or 1
				
				self:pipe(math.floor(self.x+30/16), math.floor(self.y+self.height+20/16), "down", "pipe" .. map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][3])
				return
			end				
		end
	
		self:updateangle()
		
		if self.falling == false and self.jumping == false and self.size > 1 then
			if downkey(self.playernumber) then
				if self.ducking == false then
					self:duck(true)
				end
			else
				if self.ducking then
					self:duck(false)
				end
			end
		end
		
		if not underwater then
			local x = math.floor(self.x+self.width/2)+1
			local y = math.floor(self.y+self.height/2)+1
			
			if inmap(x, y) then
				if tilequads[map[x][y][1]].water then
					if not self.underwater then
						self:dive(true)
					end
				else
					if self.underwater then
						self:dive(false)
					end
				end
			end
		end
		
		if not self.underwater then
			self:movement(dt)
		else
			self:underwatermovement(dt)
		end
		
		--RACCOON STUFF
		if self.char.raccoon and self.size == 2 then
			if not self.falling and not self.jumping then
				if math.abs(self.speedx) >= maxwalkspeed and runkey(self.playernumber) and ((rightkey(self.playernumber) and not leftkey(self.playernumber)) or (not rightkey(self.playernumber) and leftkey(self.playernumber))) then
					if self.raccoonstarttimer < raccoonstarttime then
						self.raccoonstarttimer = self.raccoonstarttimer + dt
						if self.raccoonstarttimer >= raccoonstarttime then
							self.raccoonstarttimer = raccoonstarttime
							self.raccoonjump = true
							playsound("planemode")
						end
					end
				else
					self.raccoonjump = false
					self.raccoonstarttimer = 0
				end
			else
				self.raccoonstarttimer = math.max(0, self.raccoonstarttimer-dt)
			end
		end
		
		if not self.raccoonjump and self.raccoontimer == 0 and not soundlist["planemode"].source:isStopped() then
			soundlist["planemode"].source:stop()
		end
		
		if self.raccoonascendtimer > 0 then
			if self.raccoontimer > 0 then
				self.raccoonascendtimer = math.max(0, self.raccoonascendtimer-dt)
				self.speedy = -raccoonascendspeed
				self.falling = true
			else
				self.speedy = math.min(raccoondescendspeed, self.speedy)
				self.raccoonascendtimer = math.max(0, self.raccoonascendtimer-dt)
			end
		end
		
		if self.raccoontimer > 0 then
			self.raccoontimer = math.max(0, self.raccoontimer-dt)
			if self.raccoontimer == 0 then
				self.raccoonascendtimer = 0
			end
		end
		
		--DEATH BY PIT
		if self.gravitydirection > math.pi/4*1 and self.gravitydirection <= math.pi/4*3 then --down
			if self.y >= mapheight then
				self:die("pit")
			end
		elseif self.gravitydirection > math.pi/4*5 and self.gravitydirection <= math.pi/4*7 then --up
			if self.y <= -1 then
				self:die("pit")
			end
		end
		
		
		if flagx and not levelfinished and self.x+self.width >= flagx+6/16 and self.y > flagy-10.8 then
			self:flag()
		end
		
		if firestartx then
			if self.x >= firestartx - 1 then
				firestarted = true
			else
				--check for all players
				local disable = true
				for i = 1, players do
					if objects["player"][i].x >= firestartx - 1 then
						disable = false
					end
				end
				
				if disable then
					firestarted = false
				end
			end
		end
		
		if flyingfishstartx and self.x >= flyingfishstartx - 1 then
			flyingfishstarted = true
		end
			
		if flyingfishendx and self.x >= flyingfishendx - 1 then
			flyingfishstarted = false
		end
		
		if bulletbillstartx and self.x >= bulletbillstartx - 1 then
			bulletbillstarted = true
		end
		
		if bulletbillendx and self.x >= bulletbillendx - 1 then
			bulletbillstarted = false
		end
		
		if lakitoendx and self.x >= lakitoendx then
			lakitoend = true
		end
	else
		if not self.underwater then
			self:movement(dt)
		else
			self:underwatermovement(dt)
		end
	end
	
	--drains
	local x = math.floor(self.x+self.width/2)+1
	
	if inmap(x, mapheight) and map[x][mapheight][2] and entityquads[map[x][mapheight][2]] and entityquads[map[x][mapheight][2]].t == "drain" then
		if self.speedy < drainmax then
			self.speedy = math.min( drainmax, self.speedy + drainspeed*dt)
		end
	end
	
	self:setquad()
end

function mario:updateangle()
	if self.remote then
		return
	end
	--UPDATE THE PLAYER ANGLE
	if self.playernumber == mouseowner then
		local scale = scale
		if shaders and shaders.scale then scale = shaders.scale end
		self.pointingangle = math.atan2(self.x+6/16-xscroll-(mouse.getX()/16/scale), (self.y-yscroll+6/16-.5)-(mouse.getY()/16/scale))
	elseif #controls[self.playernumber]["aimx"] > 0 then
		local x, y
		
		local s = controls[self.playernumber]["aimx"]
		if s[1] == "joy" then
			x = -love.joystick.getAxis(s[2], s[4])
			if s[5] == "neg" then
				x = -x
			end
		end
		
		s = controls[self.playernumber]["aimy"]
		if s[1] == "joy" then
			y = -love.joystick.getAxis(s[2], s[4])
			if s[5] == "neg" then
				y = -y
			end
		end
		
		if not x or not y then
			return
		end
		
		if math.abs(x) > joystickaimdeadzone or math.abs(y) > joystickaimdeadzone then
			self.pointingangle = math.atan2(x, y)
			if self.pointingangle == 0 then
				self.pointingangle = 0 --this is really silly, but will crash the game if I don't do this. It's because it's -0 or something. I'm not good with computers.
			end
		end
	end
end

function mario:movement(dt)
	local maxrunspeed = maxrunspeed
	local maxwalkspeed = maxwalkspeed
	local runacceleration = runacceleration
	local walkacceleration = walkacceleration
	--Orange gel
	--not in air
	if self.falling == false and self.jumping == false then
		local orangegel = false
		local bluegel = false
		--On Tiles
		if math.mod(self.y+self.height, 1) == 0 then
			local x = round(self.x+self.width/2+.5)
			local y = self.y+self.height+1
			--x and y in map
			if inmap(x, y) then
				--top of block orange
				if map[x][y]["gels"]["top"] == 2 then
					orangegel = true
				elseif map[x][y]["gels"]["top"] == 1 then
					bluegel = true
				end
			end
		end
		
		--On Lightbridge
		local x = round(self.x+self.width/2+.5)
		local y = round(self.y+self.height+1)
		
		for i, v in pairs(objects["lightbridgebody"]) do
			if x == v.cox and y == v.coy and v.gels.top then
				orangegel = true
			end
		end
		
		if orangegel then
			maxrunspeed = gelmaxrunspeed
			maxwalkspeed = gelmaxwalkspeed
			runacceleration = gelrunacceleration
			walkacceleration = gelwalkacceleration
		elseif bluegel then
			if math.abs(self.speedx) > maxrunspeed*1.5 then
				self.speedy = -40
				self.falling = true
			end
		end
	end
	
	if self.animationstate == "running" then
		self:runanimation(dt)
	end
	
	if self.animationstate == "jumping" then
		self.jumpanimationprogress = self.jumpanimationprogress + dt*runanimationspeed
		while self.jumpanimationprogress > self.char.jumpframes+1 do
			self.jumpanimationprogress = self.jumpanimationprogress - self.char.jumpframes
		end
		self.jumpframe = math.floor(self.jumpanimationprogress)
	end
		
	--HORIZONTAL MOVEMENT
	if self.controlsenabled and runkey(self.playernumber) then --RUNNING
		if self.controlsenabled and rightkey(self.playernumber) then --MOVEMENT RIGHT
			if self.jumping or self.falling then --IN AIR
				if self.speedx < maxwalkspeed then
					if self.speedx < 0 then
						self.speedx = self.speedx + runaccelerationair*dt*airslidefactor
					else
						self.speedx = self.speedx + runaccelerationair*dt
					end
					
					if self.speedx > maxwalkspeed then
						self.speedx = maxwalkspeed
					end
				elseif self.speedx > maxwalkspeed and self.speedx < maxrunspeed then
					if self.speedx < 0 then
						self.speedx = self.speedx + runaccelerationair*dt*airslidefactor
					else
						self.speedx = self.speedx + runaccelerationair*dt
					end
					
					if self.speedx > maxrunspeed then
						self.speedx = maxrunspeed
					end
				end
					
			elseif self.ducking == false then --ON GROUND
				if self.speedx < 0 then
					if self.speedx < -maxrunspeed then
						self.speedx = self.speedx + superfriction*dt + runacceleration*dt
					else
						self.speedx = self.speedx + friction*dt + runacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "right"
				else
					if self.speedx <= maxrunspeed then
						self.speedx = self.speedx + runacceleration*dt
						self.animationstate = "running"
						self.animationdirection = "right"
					
						if self.speedx > maxrunspeed then
							self.speedx = maxrunspeed
						end
					else
						self.speedx = self.speedx - superfriction*dt
					end
				end
			end
			
		elseif self.controlsenabled and leftkey(self.playernumber) then --MOVEMENT LEFT
			if self.jumping or self.falling then --IN AIR
				if self.speedx > -maxwalkspeed then
					if self.speedx > 0 then
						self.speedx = self.speedx - runaccelerationair*dt*airslidefactor
					else
						self.speedx = self.speedx - runaccelerationair*dt
					end
					
					if self.speedx < -maxwalkspeed then
						self.speedx = -maxwalkspeed
					end
				elseif self.speedx < -maxwalkspeed and self.speedx > -maxrunspeed then
					if self.speedx > 0 then
						self.speedx = self.speedx - runaccelerationair*dt*airslidefactor
					else
						self.speedx = self.speedx - runaccelerationair*dt
					end
					
					if self.speedx < -maxrunspeed then
						self.speedx = -maxrunspeed
					end
				end
				
			elseif self.ducking == false then --ON GROUND
				if self.speedx > 0 then
					if self.speedx > maxrunspeed then
						self.speedx = self.speedx - superfriction*dt - runacceleration*dt
					else
						self.speedx = self.speedx - friction*dt - runacceleration*dt
				
					end
					self.animationstate = "sliding"
					self.animationdirection = "left"
				else
					if self.speedx >= -maxrunspeed then
						self.speedx = self.speedx - runacceleration*dt
						self.animationstate = "running"
						self.animationdirection = "left"
					
						if self.speedx < -maxrunspeed then
							self.speedx = -maxrunspeed
						end
					else
						self.speedx = self.speedx + superfriction*dt
					end
				end
			end
		
		end
		if (not rightkey(self.playernumber) and not leftkey(self.playernumber)) or (self.ducking and self.falling == false and self.jumping == false) or not self.controlsenabled then  --NO MOVEMENT
			if self.jumping or self.falling then
				if self.speedx > 0 then
					self.speedx = self.speedx - frictionair*dt
					if self.speedx < minspeed then
						self.speedx = 0
						self.runframe = 1
					end
				else
					self.speedx = self.speedx + frictionair*dt
					if self.speedx > -minspeed then
						self.speedx = 0
						self.runframe = 1
					end
				end
			else
				if self.speedx > 0 then
					if self.speedx > maxrunspeed then
						self.speedx = self.speedx - superfriction*dt
					else	
						self.speedx = self.speedx - friction*dt
					end
					if self.speedx < minspeed then
						self.speedx = 0
						self.runframe = 1
						self.animationstate = "idle"
					end
				else
					if self.speedx < -maxrunspeed then
						self.speedx = self.speedx + superfriction*dt
					else	
						self.speedx = self.speedx + friction*dt
					end
					if self.speedx > -minspeed then
						self.speedx = 0
						self.runframe = 1
						self.animationstate = "idle"
					end
				end
			end
		end
		
	else --WALKING
	
		if self.controlsenabled and rightkey(self.playernumber) then --MOVEMENT RIGHT
			if self.jumping or self.falling then --IN AIR
				if self.speedx < maxwalkspeed then
					if self.speedx < 0 then
						self.speedx = self.speedx + walkaccelerationair*dt*airslidefactor
					else
						self.speedx = self.speedx + walkaccelerationair*dt
					end
					
					if self.speedx > maxwalkspeed then
						self.speedx = maxwalkspeed
					end
				end
			elseif self.ducking == false then --ON GROUND
				if self.speedx < maxwalkspeed then
					if self.speedx < 0 then
						if self.speedx < -maxrunspeed then
							self.speedx = self.speedx + superfriction*dt + runacceleration*dt
						else
							self.speedx = self.speedx + friction*dt + runacceleration*dt
						end
						self.animationstate = "sliding"
						self.animationdirection = "right"
					else
						self.speedx = self.speedx + walkacceleration*dt
						self.animationstate = "running"
						self.animationdirection = "right"
					end
					
					if self.speedx > maxwalkspeed then
						self.speedx = maxwalkspeed
					end
				else
					if self.speedx > maxrunspeed then
						self.speedx = self.speedx - superfriction*dt
					else
						self.speedx = self.speedx - friction*dt
					end
					
					if self.speedx < maxwalkspeed then
						self.speedx = maxwalkspeed
					end
				end
			end
			
		elseif self.controlsenabled and leftkey(self.playernumber) then --MOVEMENT LEFT
			if self.jumping or self.falling then --IN AIR
				if self.speedx > -maxwalkspeed then
					if self.speedx > 0 then
						self.speedx = self.speedx - walkaccelerationair*dt*airslidefactor
					else
						self.speedx = self.speedx - walkaccelerationair*dt
					end
					
					if self.speedx < -maxwalkspeed then
						self.speedx = -maxwalkspeed
					end
				end
			elseif self.ducking == false then --ON GROUND
				if self.speedx > -maxwalkspeed then
					if self.speedx > 0 then
						if self.speedx > maxrunspeed then
							self.speedx = self.speedx - superfriction*dt - runacceleration*dt
						else
							self.speedx = self.speedx - friction*dt - runacceleration*dt
						end
						self.animationstate = "sliding"
						self.animationdirection = "left"
					else
						self.speedx = self.speedx - walkacceleration*dt
						self.animationstate = "running"
						self.animationdirection = "left"
					end
					
					if self.speedx < -maxwalkspeed then
						self.speedx = -maxwalkspeed
					end
				else
					if self.speedx < -maxrunspeed then
						self.speedx = self.speedx + superfriction*dt
					else
						self.speedx = self.speedx + friction*dt
					end
					
					if self.speedx > -maxwalkspeed then
						self.speedx = -maxwalkspeed
					end
				end
			end
		
		end
		if (not rightkey(self.playernumber) and not leftkey(self.playernumber)) or (self.ducking and self.falling == false and self.jumping == false) or not self.controlsenabled then --no movement
			if self.jumping or self.falling then
				if self.speedx > 0 then
					self.speedx = self.speedx - frictionair*dt
					if self.speedx < 0 then
						self.speedx = 0
						self.runframe = 1
					end
				else
					self.speedx = self.speedx + frictionair*dt
					if self.speedx > 0 then
						self.speedx = 0
						self.runframe = 1
					end
				end
			else
				if self.speedx > 0 then
					if self.speedx > maxrunspeed then
						self.speedx = self.speedx - superfriction*dt
					else	
						self.speedx = self.speedx - friction*dt
					end
					if self.speedx < 0 then
						self.speedx = 0
						self.runframe = 1
						self.animationstate = "idle"
					end
				else
					if self.speedx < -maxrunspeed then
						self.speedx = self.speedx + superfriction*dt
					else	
						self.speedx = self.speedx + friction*dt
					end
					if self.speedx > 0 then
						self.speedx = 0
						self.runframe = 1
						self.animationstate = "idle"
					end
				end
			end
		end
	end
end

function mario:runanimation(dt)
	self.runanimationprogress = self.runanimationprogress + (math.abs(self.speedx)+4)/5*dt*(self.char.rundelay or runanimationspeed)
	while self.runanimationprogress > self.char.runframes+1 do
		self.runanimationprogress = self.runanimationprogress - self.char.runframes
	end
	self.runframe = math.floor(self.runanimationprogress)
end

function mario:underwatermovement(dt)
	if self.jumping or self.falling then
		--Swim animation
		if self.animationstate == "jumping" or self.animationstate == "falling" then
			self.swimanimationprogress = self.swimanimationprogress + runanimationspeed*dt
			while self.swimanimationprogress >= 3 do
				self.swimanimationprogress = self.swimanimationprogress - 2
			end
			self.swimframe = math.floor(self.swimanimationprogress)
			self:setquad()
		end
	else
		if self.animationstate == "running" then
			self:runanimation(dt)
		end
	end
	
	local maxrunspeed = maxrunspeed
	local maxwalkspeed = maxwalkspeed
	local runacceleration = runacceleration
	local walkacceleration = walkacceleration
	--Orange gel
	--not in air
	if self.falling == false and self.jumping == false then
		--bottom on grid
		if math.mod(self.y+self.height, 1) == 0 then
			local x = round(self.x+self.width/2+.5)
			local y = self.y+self.height+1
			--x and y in map
			if inmap(x, y) then
				--top of block orange
				if map[x][y]["gels"]["top"] == 2 then
					maxrunspeed = uwgelmaxrunspeed
					maxwalkspeed = uwgelmaxwalkspeed
					runacceleration = uwgelrunacceleration
					walkacceleration = uwgelwalkacceleration
				end
			end
		end
	end
	
	--bubbles
	self.bubbletimer = self.bubbletimer + dt
	while self.bubbletimer > self.bubbletime do
		self.bubbletimer = self.bubbletimer - self.bubbletime
		self.bubbletime = bubblestime[math.random(#bubblestime)]
		table.insert(bubbles, bubble:new(self.x+8/12, self.y+2/12))
	end
	
	--HORIZONTAL MOVEMENT	
	if self.controlsenabled and rightkey(self.playernumber) and (self.jumping or self.falling or not self.ducking) then --MOVEMENT RIGHT
		if self.jumping or self.falling then --IN AIR
			if self.speedx < uwmaxairwalkspeed then
				if self.speedx < 0 then
					self.speedx = self.speedx + walkaccelerationair*dt*uwairslidefactor
				else
					self.speedx = self.speedx + walkaccelerationair*dt
				end
				
				if self.speedx > uwmaxairwalkspeed then
					self.speedx = uwmaxairwalkspeed
				end
			end
		else --ON GROUND
			if self.speedx < maxwalkspeed then
				if self.speedx < 0 then
					if self.speedx < -maxrunspeed then
						self.speedx = self.speedx + uwsuperfriction*dt + runacceleration*dt
					else
						self.speedx = self.speedx + uwfriction*dt + runacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "right"
				else
					self.speedx = self.speedx + walkacceleration*dt
					self.animationstate = "running"
					self.animationdirection = "right"
				end
				
				if self.speedx > maxwalkspeed then
					self.speedx = maxwalkspeed
				end
			else
				self.speedx = self.speedx - uwfriction*dt
				if self.speedx < maxwalkspeed then
					self.speedx = maxwalkspeed
				end
			end
		end
	elseif self.controlsenabled and leftkey(self.playernumber) and (self.jumping or self.falling or not self.ducking) then --MOVEMENT LEFT
		if self.jumping or self.falling then --IN AIR
			if self.speedx > -uwmaxairwalkspeed then
				if self.speedx > 0 then
					self.speedx = self.speedx - walkaccelerationair*dt*uwairslidefactor
				else
					self.speedx = self.speedx - walkaccelerationair*dt
				end
				
				if self.speedx < -uwmaxairwalkspeed then
					self.speedx = -uwmaxairwalkspeed
				end
			end
		else --ON GROUND
			if self.speedx > -maxwalkspeed then
				if self.speedx > 0 then
					if self.speedx > maxrunspeed then
						self.speedx = self.speedx - uwsuperfriction*dt - runacceleration*dt
					else
						self.speedx = self.speedx - uwfriction*dt - runacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "left"
				else
					self.speedx = self.speedx - walkacceleration*dt
					self.animationstate = "running"
					self.animationdirection = "left"
				end
				
				if self.speedx < -maxwalkspeed then
					self.speedx = -maxwalkspeed
				end
			else
				self.speedx = self.speedx + uwfriction*dt
				if self.speedx > -maxwalkspeed then
					self.speedx = -maxwalkspeed
				end
			end
		end
	
	else --NO MOVEMENT
		if self.jumping or self.falling then
			if self.speedx > 0 then
				self.speedx = self.speedx - uwfrictionair*dt
				if self.speedx < 0 then
					self.speedx = 0
					self.runframe = 1
				end
			else
				self.speedx = self.speedx + uwfrictionair*dt
				if self.speedx > 0 then
					self.speedx = 0
					self.runframe = 1
				end
			end
		else
			if self.speedx > 0 then
				if self.speedx > maxrunspeed then
					self.speedx = self.speedx - uwsuperfriction*dt
				else	
					self.speedx = self.speedx - uwfriction*dt
				end
				if self.speedx < 0 then
					self.speedx = 0
					self.runframe = 1
					self.animationstate = "idle"
				end
			else
				if self.speedx < -maxrunspeed then
					self.speedx = self.speedx + uwsuperfriction*dt
				else	
					self.speedx = self.speedx + uwfriction*dt
				end
				if self.speedx > 0 then
					self.speedx = 0
					self.runframe = 1
					self.animationstate = "idle"
				end
			end
		end
	end
	
	if self.y+self.height < uwmaxheight then
		self.speedy = uwpushdownspeed
	end
end

function mario:setquad(anim, s)
	local angleframe
	if self.char.nopointing then
		angleframe = 1
	elseif not self.portalsavailable[1] and not self.portalsavailable[2] and not self.char.nogunanimations then
		angleframe = 3
	else
		angleframe = getAngleFrame(self.pointingangle, self.rotation)
	end
	
	local animationstate = anim or self.animationstate
	local size = s or self.size
	
	if size == 1 then
		if self.infunnel or animationstate == "jumping" and not self.underwater then
			self.quad = self.char.jump[angleframe][self.jumpframe]
		elseif self.underwater and (self.animationstate == "jumping" or self.animationstate == "falling") then
			self.quad = self.char.swim[angleframe][self.swimframe]
		elseif animationstate == "running" or animationstate == "falling" then
			self.quad = self.char.run[angleframe][self.runframe]
		elseif animationstate == "idle" then
			self.quad = self.char.idle[angleframe]
		elseif animationstate == "sliding" then
			self.quad = self.char.slide[angleframe]
		elseif animationstate == "climbing" then
			self.quad = self.char.climb[angleframe][self.climbframe]
		elseif animationstate == "dead" then
			self.quad = self.char.die[angleframe]
		elseif animationstate == "grow" then
			self.quad = self.char.grow[angleframe]
		end
	elseif size > 1 then
		if self.char.raccoon and self.raccoontimer > 0 and self.falling and animationstate ~= "climbing" then
			self.quad = self.char.bigcustomframe[angleframe][self.tailwagframe+9]
		elseif self.char.raccoon and self.raccoonspinframe then
			if self.falling or self.jumping then
				self.quad = self.char.bigcustomframe[angleframe][self.raccoonspinframe+12]
			else
				self.quad = self.char.bigcustomframe[angleframe][self.raccoonspinframe]
			end
		elseif self.char.raccoon and (animationstate ~= "climbing" and not self.ducking and self.falling and not self.jumping) then
			self.quad = self.char.bigcustomframe[angleframe][self.tailwagframe+3]
			
		elseif self.infunnel or (animationstate == "jumping" and not self.ducking and not self.underwater) then
			self.quad = self.char.bigjump[angleframe][self.jumpframe]
		elseif self.underwater and (self.animationstate == "jumping" or self.animationstate == "falling") then
			self.quad = self.char.bigswim[angleframe][self.swimframe]
		elseif self.ducking then
			self.quad = self.char.bigduck[angleframe]
		elseif self.fireanimationtimer < fireanimationtime then
			self.quad = self.char.bigfire[angleframe]
		else
			if animationstate == "running" or animationstate == "falling" or (self.char.raccoon and animationstate == "jumping") then
				if self.raccoonjump then
					self.quad = self.char.bigcustomframe[angleframe][self.runframe+6]
				else
					self.quad = self.char.bigrun[angleframe][self.runframe]
				end
			elseif animationstate == "idle" then
				self.quad = self.char.bigidle[angleframe]
			elseif animationstate == "sliding" then
				self.quad = self.char.bigslide[angleframe]
			elseif animationstate == "climbing" then
				self.quad = self.char.bigclimb[angleframe][self.climbframe]
			end
		end
	end
end

function gethatoffset(char, graphic, animationstate, runframe, jumpframe, climbframe, swimframe, underwater, infunnel, fireanimationtimer, ducking)
	local hatoffset
	if graphic == char.animations or graphic == char.nogunanimations then
		if not char.hatoffsets then
			return
		end
		
		if infunnel then
			hatoffset = char.hatoffsets["jumping"][jumpframe]
		elseif underwater and (animationstate == "jumping" or animationstate == "falling") then
			hatoffset = char.hatoffsets["swimming"][swimframe]
		elseif animationstate == "jumping" then
			hatoffset = char.hatoffsets["jumping"][jumpframe]
		elseif animationstate == "running" or animationstate == "falling" then
			hatoffset = char.hatoffsets["running"][runframe]
		elseif animationstate == "climbing" then
			hatoffset = char.hatoffsets["climbing"][climbframe]
		end
	else
		if not char.bighatoffsets then
			return
		end
		if infunnel or animationstate == "jumping" and not ducking then
			hatoffset = char.bighatoffsets["jumping"][jumpframe]
		elseif underwater and (animationstate == "jumping" or animationstate == "falling") then
			hatoffset = char.bighatoffsets["swimming"][swimframe]
		elseif ducking then
			hatoffset = char.bighatoffsets["ducking"]
		elseif fireanimationtimer < fireanimationtime then
			hatoffset = char.bighatoffsets["fire"]
		else
			if animationstate == "running" or animationstate == "falling" then
				hatoffset = char.bighatoffsets["running"][runframe]
			elseif animationstate == "climbing" then
				hatoffset = char.bighatoffsets["climbing"][climbframe]
			end
		end
	end
	
	if not hatoffset then
		if graphic == char.animations or graphic == char.nogunanimations then
			hatoffset = char.hatoffsets[animationstate]
		else
			hatoffset = char.bighatoffsets[animationstate]
		end
	end
	
	return hatoffset
end

function mario:jump(force)
	if ((not noupdate or self.animation == "grow1" or self.animation == "grow2") and self.controlsenabled) or force then
	
		if not self.underwater then
			if self.spring then
				self.springhigh = true
				return
			end
			
			if self.raccoonjump then
				self.raccoontimer = raccoontime
				self.raccoonjump = false
				self.tailwag = true
			end
			
			if self.char.raccoon and self.size >= 2 and self.falling and not self.jumping then
				self.raccoonascendtimer = raccoonbuttondelay
				self.tailwag = true
			end
			
			if self.raccoontimer > 0 then
				self.raccoonascendtimer = raccoonbuttondelay 
				self.tailwag = true
			else
				if ((self.animation ~= "grow1" and self.animation ~= "grow2") or self.falling) and (self.falling == false or self.animation == "grow1" or self.animation == "grow2" or self.char.pegasus or (self.char.dbljmppls and not self.dbljmping)) then
					if self.falling and self.char.dbljmppls then
						self.dbljmping = true
					end
					
					if self.animation ~= "grow1" and self.animation ~= "grow2" then
						if self.size == 1 then
							playsound("jump")
						else
							playsound("jumpbig")
						end
					end
					
					local force = -jumpforce - (math.abs(self.speedx) / maxrunspeed)*jumpforceadd
					force = math.max(-jumpforce - jumpforceadd, force)
					
					self.speedy = force
					
					self.jumping = true
					self.animationstate = "jumping"
					self:setquad()
				end
			end
		else
			if self.ducking then
				self:duck(false)
			end
			playsound("swim")
			
			self.speedy = -uwjumpforce - (math.abs(self.speedx) / maxrunspeed)*uwjumpforceadd
			self.jumping = true
			self.animationstate = "jumping"
			self:setquad()
		end
		
		--check if upper half is inside block
		if self.size > 1 then
			local x = round(self.x+self.width/2+.5)
			local y = round(self.y)
			
			if inmap(x, y) and tilequads[map[x][y][1]].collision then
				if getPortal(x, y) then
					self.speedy = 0
					self.jumping = false
					self.falling = true
				else
					self:ceilcollide("tile", objects["tile"][x .. "-" .. y], "player", self)
				end
			end
		end
	end
end

function mario:stopjump(force)
	if self.controlsenabled or force then
		if self.jumping == true then
			self.jumping = false
			self.falling = true
		end
	end
end

function mario:rightkey()
	if self.controlsenabled and self.vine then
		if self.vineside == "left" then
			self.x = self.x + 8/16
			self.pointingangle = math.pi/2
			self.animationdirection = "left"
			self.vineside = "right"
		else
			self:dropvine("right")
		end
	end
end

function mario:leftkey()
	if self.controlsenabled and self.vine then
		if self.vineside == "right" then
			self.x = self.x - 8/16
			self.pointingangle = -math.pi/2
			self.animationdirection = "right"
			self.vineside = "left"
		else
			self:dropvine("left")
		end
	end
end

function mario:grow()
	self.animationmisc = self.animationstate
	if self.animation and self.animation ~= "invincible" then
		return
	end
	addpoints(1000, self.x+self.width/2, self.y)
	playsound("mushroomeat")
	
	if bigmario then
		return
	end
	
	if self.size > 2 then
		
	else
		self.size = self.size + 1
		if self.size == 2 then		
			self.y = self.y - 12/16
			self.height = 24/16
		elseif self.size == 3 then
			self.colors = self.char.flowercolor or flowercolor
		end
		
		if self.size == 2 then
			self.animation = "grow1"
			track("mushrooms_eaten")
		else
			self.animation = "grow2"
			track("flowers_eaten")
		end
		
		self.drawable = true
		self.invincible = false
		self.animationtimer = 0
		noupdate = true
	end
end

function mario:shrink()
	self.animationmisc = self.animationstate
	if self.animation then
		return
	end
	if self.ducking then
		self:duck(false)
	end
	playsound("shrink")
	
	self.size = 1
	
	self.colors = mariocolors[self.playernumber]
	
	self.animation = "shrink"
	self.drawable = true
	self.invincible = true
	self.animationtimer = 0
	self.raccoontimer = 0
	self.raccoonascendtimer = 0
	
	self.y = self.y + 12/16
	self.height = 12/16
	
	noupdate = true
end

function mario:floorcollide(a, b, c, d)
	if self:globalcollide(a, b, c, d, "floor") then
		return false
	end
	
	self.rainboomallowed = true
	if self.jumping and (a == "platform" or a == "seesawplatform") and self.speedy < -jumpforce + 0.1 then
		return false
	end

	local anim = self.animationstate
	local jump = self.jumping
	local fall = self.falling
	
	if self.char.dbljmppls then
		self.dbljmping = false
	end
	
	if a == "spring" then
		self:hitspring(b)
		return false
	end
	
	if self.speedx == 0 then
		self.animationstate = "idle"
	else
		if self.animationstate ~= "sliding" then
			self.animationstate = "running"
		end
	end
	self:setquad()
	
	if a == "tile" then
		local x, y = b.cox, b.coy
		self.lastground = {x, y}
		if bigmario and self.speedy > 2 then
			destroyblock(x, y)
			self.speedy = self.speedy/10
		end
		
		--check for invisible block
		if tilequads[map[x][y][1]].invisible then
			self.jumping = jump
			self.falling = fall
			self.animationstate = anim
			return false
		end
		
		if self.falling and self.raccoontimer > 0 and self.controlsenabled then
			self.speedx = self.speedx * 0.5
			self.raccoonascendtimer = 0
		end
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b, c, d) then
			return false
		end
	end
	
	self.falling = false
	self.jumping = false
	
	--Make mario snap to runspeed if at walkspeed. why is this commented out
	--[[if leftkey(self.playernumber) then
		if runkey(self.playernumber) then
			if self.speedx <= -maxwalkspeed then
				self.speedx = -maxrunspeed
				self.animationdirection = "left"
			end
		end
	elseif rightkey(self.playernumber) then
		if runkey(self.playernumber) then
			if self.speedx >= maxwalkspeed then
				self.speedx = maxrunspeed
				self.animationdirection = "right"
			end
		end
	end--]]
	
	if b.stompable then
		self:stompenemy(a, b, c, d)
		return false
	elseif a == "tile" then
		local x, y = b.cox, b.coy
		
		if map[x][y].gels and map[x][y].gels.top == 1 then
			if self:bluegel("top") then
				return false
			end
		end
	elseif b.kills or b.killsontop then
		if self.invincible then
			self.jumping = jump
			self.falling = fall
			self.animationstate = anim
			return false
		else
			self:die("enemy")
			return false
		end
	elseif a == "lightbridgebody" and b.gels.top == 1 then
		if self:bluegel("top") then
			return false
		end
	end		
	
	self.combo = 1
end

function mario:bluegel(dir)
	if dir == "top" then
		if downkey(self.playernumber) == false and self.speedy > gdt*yacceleration*10 then
			self.speedy = -self.speedy
			self.falling = true
			self.animationstate = "jumping"
			self:setquad()
			self.speedy = self.speedy + (self.gravity or yacceleration)*gdt
			
			return true
		end
	elseif dir == "left" then
		if downkey(self.playernumber) == false and (self.falling or self.jumping) then
			if self.speedx > horbounceminspeedx then
				self.speedx = math.min(-horbouncemaxspeedx, -self.speedx*horbouncemul)
				self.speedy = math.min(self.speedy, -horbouncespeedy)
				
				return true
			end
		end
	elseif dir == "right" then
		if downkey(self.playernumber) == false and (self.falling or self.jumping) then
			if self.speedx < -horbounceminspeedx then
				self.speedx = math.min(horbouncemaxspeedx, -self.speedx*horbouncemul)
				self.speedy = math.min(self.speedy, -horbouncespeedy)
				
				return false
			end
		end
	end
end

function mario:stompenemy(a, b, c, d, side)
	if not b then
		return
	end
	
	track("enemy_kills")
	
	local bounce = false
	if b.shellanimal then
		if b.small then	
			playsound("shot")
			if b.speedx == 0 then
				addpoints(500, b.x, b.y)
				self.combo = 1
			end
		else
			playsound("stomp")
		end
		
		b:stomp(self.x, self)
		
		if b.speedx == 0 or (b.flying and b.small == false) then
			addpoints(mariocombo[self.combo], self.x, self.y)
			if self.combo < #mariocombo then
				self.combo = self.combo + 1
			end
		
			local grav = self.gravity or yacceleration
			
			local bouncespeed = math.sqrt(2*grav*bounceheight)
			
			self.speedy = -bouncespeed
			
			self.falling = true
			self.animationstate = "jumping"
			self:setquad()
			if not side then
				self.y = b.y - self.height-1/16
			end
		elseif b.x > self.x then
			b.x = self.x + b.width + self.speedx*gdt + 0.05
			local col = checkrect(b.x, b.y, b.width, b.height, {"tile"})
			if #col > 1 then
				b.x = objects[col[1] ][col[2] ].x-b.width
				bounce = true
			end
		else
			b.x = self.x - b.width + self.speedx*gdt - 0.05
			local col = checkrect(b.x, b.y, b.width, b.height, {"tile"})
			if #col > 1 then
				b.x = objects[col[1] ][col[2] ].x+1
				bounce = true
			end
		end
	elseif b.stompable then
		b:stomp(self.x, self)
		if self.combo < #mariocombo then
			addpoints(mariocombo[self.combo], self.x, self.y)
			if not b.stompcombosuppressor then
				self.combo = self.combo + 1
			end
		else
			if mariolivecount ~= false then
				for i = 1, players do
					mariolives[i] = mariolives[i]+1
				end
			end
			table.insert(scrollingscores, scrollingscore:new("1up", self.x, self.y))
			playsound("oneup")
		end
		playsound("stomp")
		bounce = true
	end
	
	if bounce then
		local grav = self.gravity or yacceleration
		
		local bouncespeed = math.sqrt(2*grav*bounceheight)
		
		self.animationstate = "jumping"
		self.falling = true
		self:setquad()
		
		self.speedy = -bouncespeed
	end
end

function mario:rightcollide(a, b, c, d)
	if self:globalcollide(a, b, c, d, "right") then
		return false
	end
	
	allowskip = self.gravitydirection == math.pi/2
	
	if a == "tile" then
		if tilequads[map[b.cox][b.coy][1]].platform then
			return false
		end
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b, c, d) then
			return false
		end
	end
	
	if a == "platform" and (b.dir == "right" or b.dir == "justright") then
		return false
	elseif self.speedy > 2 and b.stompable then
		self:stompenemy(a, b, c, d, true)
		return false
	elseif b.kills or b.killsonsides or a == "bowser" then --KILLS
		if self.invincible then
			if b.shellanimal and b.small and b.speedx == 0 then
				b:stomp(self.x, self)
				playsound("shot")
				addpoints(500, b.x, b.y)
			end
			return false
		else
			if self.raccoonspinframe and b.shotted then
				b:shotted("right", true, true)
				addpoints(firepoints[b.t] or 100, self.x, self.y)
				return false
			end
			if b.shellanimal and b.small and b.speedx == 0 then
				b:stomp(self.x, self)
				playsound("shot")
				addpoints(500, b.x, b.y)
				return false
			end
			
			self:die("Enemy (rightcollide)")
			return false
		end
	elseif a == "tile" then
		local x, y = b.cox, b.coy
			
		if map[x][y].gels and map[x][y].gels.left == 1 then
			if self:bluegel("left") then
				return false
			end
		end
		
		--check for invisible block
		if tilequads[map[x][y][1]].invisible then
			return false
		end
		
		--Check if it's a pipe with pipe pipe.
		if self.falling == false and self.jumping == false and (rightkey(self.playernumber) or intermission) then --but only on ground and rightkey
			local t2 = map[x][y][2]
			if t2 and entityquads[t2] and entityquads[t2].t == "pipe" then
				self:pipe(x, y, "right", tonumber(map[x][y][3])-1)
				return
			else
				if inmap(x, y+1) then
					t2 = map[x][y+1][2]
					if t2 and entityquads[t2] and entityquads[t2].t == "pipe" then
						self:pipe(x, y+1, "right", tonumber(map[x][y+1][3])-1)
						return
					end
				end
			end
		end
		
		--Check if mario should run across a gap.
		if allowskip and inmap(x, y-1) and tilequads[map[x][y-1][1]].collision == false and self.speedy > 0 and self.y+self.height+1 < y+spacerunroom then
			self.y = b.y - self.height
			self.speedy = 0
			self.x = b.x-self.width+0.0001
			self.falling = false
			self.animationstate = "running"
			self:setquad()
			return false
		end
		
		if bigmario then
			destroyblock(x, y)
			return false
		end
	elseif a == "box" and self.gravitydirection == math.pi/2 then
		if self.speedx > maxwalkspeed/2 then
			self.speedx = self.speedx - self.speedx * 6 * gdt
		end
		
		--check if box can even move
		local out = checkrect(b.x+self.speedx*gdt, b.y, b.width, b.height, {"exclude", b}, true)
		if #out == 0 then
			b.speedx = self.speedx
			return false
		end
	elseif a == "button" then
		self.y = b.y - self.height
		self.x = b.x - self.width+0.001
		if self.speedy > 0 then
			self.speedy = 0
		end
		return false
	elseif a == "lightbridgebody" and b.gels.left == 1 then
		if self:bluegel("left") then
			return false
		end
	end
	
	if self.falling == false and self.jumping == false then
		self.animationstate = "idle"
		self:setquad()
	end
end

function mario:leftcollide(a, b, c, d)
	if self:globalcollide(a, b, c, d, "left") then
		return false
	end
	
	allowskip = self.gravitydirection == math.pi/2
	
	if a == "tile" then
		if tilequads[map[b.cox][b.coy][1]].platform then
			return false
		end
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b, c, d) then
			return false
		end
	end
	
	if a == "platform" and (b.dir == "right" or b.dir == "justright") then --NOTHING
		return false
	elseif self.speedy > 2 and b.stompable then
		self:stompenemy(a, b, c, d, true)
		return false
	elseif b.kills or b.killsonsides or a == "bowser" then --KILLS
		if self.invincible then
			if b.shellanimal and b.small and b.speedx == 0 then
				b:stomp(self.x, self)
				playsound("shot")
				addpoints(500, b.x, b.y)
			end
			return false
		else
			if self.raccoonspinframe and b.shotted then
				b:shotted("left", true, true)
				addpoints(firepoints[b.t] or 100, self.x, self.y)
				return false
			end
			
			if b.shellanimal and b.small and b.speedx == 0 then
				b:stomp(self.x, self)
				playsound("shot")
				addpoints(500, b.x, b.y)
				return false
			end
			
			self:die("Enemy (leftcollide)")
			return false
		end
	elseif a == "tile" then
		local x, y = b.cox, b.coy
		
		if map[x][y].gels and map[x][y].gels.right == 1 then
			if self:bluegel("right") then
				return false
			end
		end
		
		--check for invisible block
		if tilequads[map[x][y][1]].invisible then
			return false
		end
		
		if allowskip and inmap(x, y-1) and tilequads[map[x][y-1][1]].collision == false and self.speedy > 0 and self.y+1+self.height < y+spacerunroom then
			self.y = b.y - self.height
			self.speedy = 0
			self.x = b.x+1-0.0001
			self.falling = false
			self.animationstate = "running"
			self:setquad()
			return false
		end
	
		if bigmario then
			destroyblock(x, y)
			return false
		end
	elseif a == "box" and self.gravitydirection == math.pi/2 then
		if self.speedx < -maxwalkspeed/2 then
			self.speedx = self.speedx - self.speedx * 6 * gdt
		end
		
		--check if box can even move
		local out = checkrect(b.x+self.speedx*gdt, b.y, b.width, b.height, {"exclude", b}, true)
		if #out == 0 then
			b.speedx = self.speedx
			return false
		end
	elseif a == "button" then
		self.y = b.y - self.height
		self.x = b.x + b.width - 0.001
		if self.speedy > 0 then
			self.speedy = 0
		end
		return false
	elseif a == "lightbridgebody" and b.gels.right == 1 then
		if self:bluegel("right") then
			return false
		end
	end
	
	if self.falling == false and self.jumping == false then
		self.animationstate = "idle"
		self:setquad()
	end
end

function mario:ceilcollide(a, b, c, d)
	if self:globalcollide(a, b, c, d, "ceil") then
		return false
	end
	
	if a == "tile" then
		if tilequads[map[b.cox][b.coy][1]].platform then
			return false
		end
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b, c, d) then
			return false
		end
	end
	
	if b.kills or b.killsonbottom then --STUFF THAT KILLS
		if b.shellanimal and b.small and b.speedx == 0 then
			self:stompenemy(a, b, c, d, true)
			return false
		end
		
		if self.invincible then
			return false
		else
			self:die("Enemy (Ceilcollided)")
			return false
		end
	elseif a == "tile" then
		local x, y = b.cox, b.coy
		local r = map[x][y]
		
		--check if it's an invisible block
		if tilequads[map[x][y][1]].invisible then
			if self.y-self.speedy <= y-1 then
				return false
			end
		else
			if bigmario then
				destroyblock(x, y)
				return false
			end
			
			--Check if it should bounce the block next to it, or push mario instead (Hello, devin hitch!)
			
			if self.gravitydirection == math.pi/2 then
				if self.x < x-22/16 then
					--check if block left of it is a better fit
					if x > 1 and tilequads[map[x-1][y][1]].collision == true then
						x = x - 1
					else
						local col = checkrect(x-28/16, self.y, self.width, self.height, {"exclude", self}, true)
						if #col == 0 then
							self.x = x-28/16
							if self.speedx > 0 then
								self.speedx = 0
							end
							return false
						end					
					end
				elseif self.x > x-6/16 then
					--check if block right of it is a better fit
					if x < mapwidth and tilequads[map[x+1][y][1]].collision == true then
						x = x + 1
					else
						local col = checkrect(x, self.y, self.width, self.height, {"exclude", self}, true)
						if #col == 0 then
							self.x = x
							if self.speedx < 0 then
								self.speedx = 0
							end
							return false
						end	
					end
				end
			end
		end

		hitblock(x, y, self)
	end
	
	self.jumping = false
	self.falling = true
	self.speedy = headforce
end

function mario:globalcollide(a, b, c, d, dir)
	self.lastcollision = {a, b, c, d, dir}
	if a == "screenboundary" then
		if self.x+self.width/2 > b.x then
			self.x = b.x
		else
			self.x = b.x-self.width
		end
		self.speedx = 0
		return true
	elseif a == "vine" then
		if self.vine == false then
			self:grabvine(b)
		end
		
		return true
	elseif a == "tile" then
		--check for spikes
		if self.invincible or self.starred then
			--super mario dadada, dada-da, dada-da. dadada, dada-da, dada-da...
		else
			dir = twistdirection(self.gravitydirection, dir)
			if dir == "ceil" and tilequads[map[b.cox][b.coy][1]].spikes.bottom then
				self:die("Spikes")
				return false
			elseif dir == "right" and tilequads[map[b.cox][b.coy][1]].spikes.left then
				self:die("Spikes")
				return false
			elseif dir == "left" and tilequads[map[b.cox][b.coy][1]].spikes.right then
				self:die("Spikes")
				return false
			elseif dir == "floor" and tilequads[map[b.cox][b.coy][1]].spikes.top then
				self:die("Spikes")
				return false
			end
		end
	elseif b.makesmariogrow then
		self:grow()
		return true
	elseif b.givesalife then
		givelive(self.playernumber, b)
		return true
	elseif b.makesmariostar then
		self:star()
		return true
	end
end

function twistdirection(gravitydir, dir)
	if not gravitydir or (gravitydir > math.pi/4*1 and gravitydir <= math.pi/4*3) then
		if dir == "floor" then
			return "floor"
		elseif dir == "left" then
			return "left"
		elseif dir == "ceil" then
			return "ceil"
		elseif dir == "right" then
			return "right"
		end
	elseif gravitydir > math.pi/4*3 and gravitydir <= math.pi/4*5 then
		if dir == "floor" then
			return "left"
		elseif dir == "left" then
			return "ceil"
		elseif dir == "ceil" then
			return "right"
		elseif dir == "right" then
			return "floor"
		end
	elseif gravitydir > math.pi/4*5 and gravitydir <= math.pi/4*7 then
		if dir == "floor" then
			return "ceil"
		elseif dir == "left" then
			return "right"
		elseif dir == "ceil" then
			return "floor"
		elseif dir == "right" then
			return "left"
		end
	else
		if dir == "floor" then
			return "right"
		elseif dir == "left" then
			return "floor"
		elseif dir == "ceil" then
			return "left"
		elseif dir == "right" then
			return "ceil"
		end
	end
end

function mario:passivecollide(a, b, c, d)
	if self:globalcollide(a, b, c, d) then
		return false
	end
	
	if a == "tile" then
		if tilequads[map[b.cox][b.coy][1]].platform then
			return false
		end
	end
	
	if a == "platform" or a == "seesawplatform" then
		return false
	elseif a == "box" then
		if self.speedx < 0 then
			if self.speedx < -maxwalkspeed/2 then
				self.speedx = self.speedx - self.speedx * 0.1
			end
			
			--check if box can even move
			local out = checkrect(b.x+self.speedx*gdt, b.y, b.width, b.height, {"exclude", b})
			if #out == 0 then	
				b.speedx = self.speedx
				return false
			end
		else
			if self.speedx > maxwalkspeed/2 then
				self.speedx = self.speedx - self.speedx * 6 * gdt
			end
			
			--check if box can even move
			local out = checkrect(b.x+self.speedx*gdt, b.y, b.width, b.height, {"exclude", b})
			if #out == 0 then	
				b.speedx = self.speedx
				return false
			end
		end
	end
	if self.passivemoved == false then
		self.passivemoved = true
		if a == "tile" or a == "portalwall" then
			if a == "tile" then
				local x, y = b.cox, b.coy
				
				--check for invisible block
				if inmap(x, y) and tilequads[map[x][y][1]].invisible then
					return false
				end
			end
			if self.pointingangle < 0 then
				self.x = self.x - passivespeed*gdt
			else
				self.x = self.x + passivespeed*gdt
			end
			self.speedx = 0
		else
			--nothing, lol.
		end
	end
	
	
	self:rightcollide(a, b, c, d)
end

function mario:starcollide(a, b, c, d)
	--enemies that die
	if a == "enemy" then
		b:shotted("right", nil, nil, false, true)
		addpoints(firepoints[b.t] or 100, self.x, self.y)
		return true
	elseif a == "bowser" then
		b:shotted("right")
		return true
	--enemies (and stuff) that don't do shit
	elseif a == "upfire" or a == "fire" or a == "hammer" or a == "fireball" or a == "castlefirefire" then
		return true
	end
end

function mario:hitspring(b)
	b:hit()
	self.springb = b
	self.springx = self.x
	self.springy = b.coy
	self.speedy = 0
	self.spring = true
	self.springhigh = false
	self.springtimer = 0
	self.gravity = 0
	self.mask[19] = true
	self.animationstate = "idle"
	self:setquad()
end

function mario:leavespring()
	self.y = self.springy - self.height-31/16
	if self.springhigh then
		self.speedy = -springhighforce
	else
		self.speedy = -springforce
	end
	self.animationstate = "falling"
	self:setquad()
	self.gravity = yacceleration
	self.falling = true
	self.spring = false
	self.mask[19] = false
end

function mario:dropvine(dir)
	if dir == "right" then
		self.x = self.x + 8/16
	else
		self.x = self.x - 6/16
	end
	self.y = self.y - self.height + 12/16
	self.animationstate = "falling"
	self:setquad()
	self.gravity = mariogravity
	self.vine = false
	self.mask[18] = false
end

function mario:grabvine(b)
	if self.ducking then
		self:duck(false)
	end
	if insideportal(self.x, self.y, self.width, self.height) then
		return
	end
	self.mask[18] = true
	self.vine = true
	self.gravity = 0
	self.speedx = 0
	self.speedy = 0
	self.animationstate = "climbing"
	self.climbframe = 2
	self.vinemovetimer = 0
	self:setquad()
	self.vinex = b.cox
	self.viney = b.coy
	if b.x > self.x then --left of vine
		self.x = b.x+b.width/2-self.width+1/16
		self.pointingangle = -math.pi/2
		self.animationdirection = "right"
		self.vineside = "left"
	else --right
		self.x = b.x+b.width/2 - 3/16
		self.pointingangle = math.pi/2
		self.animationdirection = "left"
		self.vineside = "right"
	end
end

function hitblock(x, y, t, koopa)	
	for i, v in pairs(portals) do
		if v.x1 and v.x2 and v.y1 and v.y2 then
			local x1 = v.x1
			local y1 = v.y1
			
			local x2 = v.x2
			local y2 = v.y2
			
			local x3 = x1
			local y3 = y1
			
			if v.facing1 == "up" then
				x3 = x3+1
			elseif v.facing1 == "right" then
				y3 = y3+1
			elseif v.facing1 == "down" then
				x3 = x3-1
			elseif v.facing1 == "left" then
				y3 = y3-1
			end
			
			local x4 = x2
			local y4 = y2
			
			if v.facing2 == "up" then
				x4 = x4+1
			elseif v.facing2 == "right" then
				y4 = y4+1
			elseif v.facing2 == "down" then
				x4 = x4-1
			elseif v.facing2 == "left" then
				y4 = y4-1
			end
			
			if (x == x1 and y == y1) or (x == x2 and y == y2) or (x == x3 and y == y3) or (x == x4 and y == y4) then
				return
			end
		end
	end


	if editormode then
		return
	end

	if not inmap(x, y) then
		return
	end
	
	local r = map[x][y]
	if not t or not t.infunnel then
		playsound("blockhit")
	end
	track("blocks_hit")
	
	if tilequads[r[1]].breakable == true or tilequads[r[1]].coinblock == true then --Block should bounce!
		table.insert(blockbouncetimer, 0.000000001) --yeah it's a cheap solution to a problem but screw it.
		table.insert(blockbouncex, x)
		table.insert(blockbouncey, y)
		if #r > 1 and entityquads[r[2]] and entityquads[r[2]].t ~= "manycoins" then --block contained something!
			table.insert(blockbouncecontent, entityquads[r[2]].t)
			table.insert(blockbouncecontent2, t.size)
			if tilequads[r[1]].invisible then
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 118
				else
					map[x][y][1] = 112
				end
			else
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 114
				else
					map[x][y][1] = 117
				end
			end
			if entityquads[r[2]].t == "vine" then
				playsound("vine")
			else
				playsound("mushroomappear")
			end
		elseif #r > 1 and tablecontains(enemies, r[2]) then
			table.insert(blockbouncecontent, r[2])
			table.insert(blockbouncecontent2, t.size)
			playsound("mushroomappear")
			
			
			if tilequads[r[1]].invisible then
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 118
				else
					map[x][y][1] = 112
				end
			else
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 114
				else
					map[x][y][1] = 117
				end
			end
		else
			table.insert(blockbouncecontent, false)
			table.insert(blockbouncecontent2, t.size)
			
			if (koopa or (t and t.size > 1)) and tilequads[r[1]].coinblock == false and (#r == 1 or (entityquads[r[2]] and entityquads[r[2]].t ~= "manycoins")) then --destroy block!
				destroyblock(x, y)
			end
		end
		
		if #r == 1 and tilequads[r[1]].coinblock then --coinblock
			playsound("coin")
			if tilequads[r[1]].invisible then
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 118
				else
					map[x][y][1] = 112
				end
			else
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 114
				else
					map[x][y][1] = 117
				end
			end
			if #r == 1 then
				table.insert(coinblockanimations, coinblockanimation:new(x-0.5, y-1))
				mariocoincount = mariocoincount + 1
				track("coins_collected")
				if mariocoincount == 100 then
					if mariolivecount ~= false then
						for i = 1, players do
							mariolives[i] = mariolives[i] + 1
							respawnplayers()
						end
					end
					mariocoincount = 0
					playsound("oneup")
				end
				addpoints(200)
			end
		end
		
		if #r > 1 and entityquads[r[2]] and entityquads[r[2]].t == "manycoins" then --block with many coins inside! yay $_$
			playsound("coin")
			table.insert(coinblockanimations, coinblockanimation:new(x-0.5, y-1))
			mariocoincount = mariocoincount + 1
			track("coins_collected")
			
			if mariocoincount == 100 then
				if mariolivecount ~= false then
					for i = 1, players do
						mariolives[i] = mariolives[i] + 1
						respawnplayers()
					end
				end
				mariocoincount = 0
				playsound("oneup")
			end
			addpoints(200)
			
			local exists = false
			for i = 1, #coinblocktimers do
				if x == coinblocktimers[i][1] and y == coinblocktimers[i][2] then
					exists = i
				end
			end
			
			if not exists then
				table.insert(coinblocktimers, {x, y, coinblocktime})
			elseif coinblocktimers[exists][3] <= 0 then
				if spriteset == 1 then
					map[x][y][1] = 113
				elseif spriteset == 2 then
					map[x][y][1] = 114
				else
					map[x][y][1] = 117
				end
			end
		end
		
		--kill enemies on top
		for j, w in pairs(objects["enemy"]) do
			if not w.notkilledfromblocksbelow then
				local centerX = w.x + w.width/2
				if inrange(centerX, x-1, x, true) and y-1 == w.y+w.height then
					--get dir
					local dir = "right"
					if w.x+w.width/2 < x-0.5 then
						dir = "left"
					end
				
					if w.shotted then
						w:shotted(dir, true)
						addpoints(100, w.x+w.width/2, w.y)
					end
				end
			end
		end
		
		--make items jump
		for j, w in pairs(objects["enemy"]) do
			if w.jumpsfromblocksbelow then
				local centerX = w.x + w.width/2
				if inrange(centerX, x-1, x, true) and y-1 == w.y+w.height then
					w.falling = true
					w.speedy = -(w.jumpforce or mushroomjumpforce)
					if w.x+w.width/2 < x-0.5 then
						w.speedx = -math.abs(w.speedx)
					elseif w.x+w.width/2 > x-0.5 then
						w.speedx = math.abs(w.speedx)
					end
				end
			end
		end
		
		--check for coin on top
		if inmap(x, y-1) and coinmap[x][y-1] then
			collectcoin(x, y-1)
			table.insert(coinblockanimations, coinblockanimation:new(x-0.5, y-1))
		end
		generatespritebatch()
	end
end

function mario:goinvincible()
	self.animationstate = self.animationmisc
	self.animation = "invincible"
	self.invincible = true
	noupdate = false
	self.quadcenterY = self.char.smallquadcenterY
	self.graphic = self.smallgraphic
	self.animationtimer = 0
	self.quadcenterX = self.char.smallquadcenterX
	self.offsetY = self.char.smalloffsetY
	self.drawable = true
end

function destroyblock(x, y)
	for i = 1, players do
		local v = objects["player"][i].portal
		local x1 = v.x1
		local y1 = v.y1
		
		local x2 = v.x2
		local y2 = v.y2
		
		local x3 = x1
		local y3 = y1
		
		if v.facing1 == "up" then
			x3 = x3+1
		elseif v.facing1 == "right" then
			y3 = y3+1
		elseif v.facing1 == "down" then
			x3 = x3-1
		elseif v.facing1 == "left" then
			y3 = y3-1
		end
		
		local x4 = x2
		local y4 = y2
		
		if v.facing2 == "up" then
			y4 = y4-1
		elseif v.facing2 == "right" then
			x4 = x4+1
		elseif v.facing2 == "down" then
			y4 = y4+1
		elseif v.facing2 == "left" then
			x4 = x4-1
		end
		
		if (x == x1 and y == y1) or (x == x2 and y == y2) or (x == x3 and y == y3) or (x == x4 and y == y4) then
			return
		end
	end
	
	map[x][y][1] = 1
	objects["tile"][x .. "-" .. y] = nil
	map[x][y]["gels"] = {}
	playsound("blockbreak")
	addpoints(50)
	
	table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, 3.5, -23))
	table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, -3.5, -23))
	table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, 3.5, -14))
	table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, -3.5, -14))
	
	generatespritebatch()
end

function mario:faithplate(dir)
	self.animationstate = "jumping"
	self.falling = true
	self:setquad()
end

function mario:startfall()
	if self.falling == false then
		self.falling = true
		self.animationstate = "falling"
		self:setquad()
	end
end

function mario:die(how)
	if self.dead then 
		return
	end
	if editormode then
		self.y = 0
		self.speedy = 0
		return
	end
	
	
	if how ~= "pit" and how ~= "time" then
		if self.size > 1 then
			self:shrink()
			return
		end
	elseif how ~= "time" then
		if bonusstage then
			levelscreen_load("sublevel", 0)
			return
		end
	end
	
	
	if timetrials then
		if how == "pit" then
			self.x = self.lastground[1]+2/16-1
			self.y = self.lastground[2]-12/16-1
			self.speedx = 0
			self.speedy = 0
			
			if self.ducking then
				self:duck(false)
			end
			
			self.size = 1
			self.colors = mariocolors[self.playernumber]
			self.drawable = true
			self.height = 12/16
			
			ttlosetime()
		else
			ttlosetime()
		end
		
		self:goinvincible()
		return
	end
	
	self.dead = true
	track("deaths")
	
	if self.pickup then
		self:dropbox()
	end
	
	if not arcade then
		everyonedead = true
		for i = 1, players do
			if not objects["player"][i].dead then
				everyonedead = false
			end
		end
	end
	
	self.animationmisc = false
	if everyonedead then
		self.animationmisc = "everyonedead"
		love.audio.stop()
	end
	
	playsound("death")
	
	if how == "time" then
		noupdate = false
		self.quadcenterY = self.char.smallquadcenterY
		self.graphic = self.smallgraphic
		self.size = 1
		self.quadcenterX = self.char.smallquadcenterX
		self.offsetY = self.char.smalloffsetY
		self.drawable = true
	end
	
	if how == "pit" then
		self.animation = "deathpit"
		self.size = 1
		self.drawable = false
		self.invincible = false
	else
		self.animation = "death"
		self.drawable = true
		self.invincible = false
		self.animationstate = "dead"
		self:setquad()
		self.speedy = 0
	end
	
	self.y = self.y - 1/16
	
	self.animationx = self.x
	self.animationy = self.y
	self.infunnel = false
	self.animationtimer = 0
	self.controlsenabled = false
	self.active = false
	prevsublevel = false
	
	if not levelfinished and not testlevel and not infinitelives and mariolivecount ~= false and not arcade and not mkstation then
		mariolives[self.playernumber] = mariolives[self.playernumber] - 1
	end
	
	if arcade then
		if mariolives[self.playernumber] == 0 then
			arcadeleave(self.playernumber)
		end
	end
	
	return
end

function mario:laser(dir)
	if self.pickup then
		if dir == "right" and self.pointingangle < 0 then
			return
		elseif dir == "left" and self.pointingangle > 0 then
			return
		elseif dir == "up" and self.pointingangle > -math.pi/2 and self.pointingangle < math.pi/2 then
			return
		elseif dir == "down" and (self.pointingangle > math.pi/2 or self.pointingangle < -math.pi/2) then
			return
		end
	end
	self:die("Laser")
end

function getAngleFrame(angle, rotation)
	angle = angle + rotation

	if angle > math.pi then
		angle = angle - math.pi*2
	elseif angle < -math.pi then
		angle = angle + math.pi*2
	end

	local mouseabs = math.abs(angle)
	local angleframe
	
	if mouseabs < math.pi/8 then
		angleframe = 1
	elseif mouseabs >= math.pi/8 and mouseabs < math.pi/8*3 then
		angleframe = 2
	elseif mouseabs >= math.pi/8*3 and mouseabs < math.pi/8*5 then
		angleframe = 3
	elseif mouseabs >= math.pi/8*5 and mouseabs < math.pi/8*7 then
		angleframe = 4
	elseif mouseabs >= math.pi/8*7 then
		angleframe = 4
	end
	
	return angleframe
end

function mario:emancipate(a)
	self:removeportals()
	
	local delete = {}
	
	for i, v in pairs(portalprojectiles) do
		if v.payload[1] == self.playernumber then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(portalprojectiles, v) --remove
	end
end

function mario:removeportals(i)	
	if (self.portalsavailable[1] and self.portal.x1) or (self.portalsavailable[2] and self.portal.x2) then
		playsound("portalfizzle")
	end
	
	
	if self.portalsavailable[1] then
		self.portal:removeportal(1)
	end
	if self.portalsavailable[2] then
		self.portal:removeportal(2)
	end
end

function mario:use(xcenter, ycenter)
	if not xcenter then
		xcenter = self.x + 6/16 - math.sin(self.pointingangle)*userange
		ycenter = self.y + 6/16 - math.cos(self.pointingangle)*userange
	end
	
	if self.pickup then
		if self.pickup.destroying then
			self.pickup = false
		else
			self:dropbox()
			return
		end
	end
	
	local col, i = userect(xcenter-usesquaresize/2, ycenter-usesquaresize/2, usesquaresize, usesquaresize)
	if #col > 0 then
		col[1]:used(self.playernumber)
	end
end

function mario:pickupbox(box)
	self.pickup = box
end

function mario:dropbox()
	self.pickup:dropped()
	
	self.pickup.gravitydirection = self.gravitydirection
	
	local set = false
	
	local boxx = self.x+math.sin(-self.pointingangle)*0.3
	local boxy = self.y-math.cos(-self.pointingangle)*0.3
	
	if self.pointingangle < 0 then
		if #checkrect(self.x+self.width, self.y+self.height-12/16, 12/16, 12/16, {"exclude", self.pickup}, true) == 0 then
			self.pickup.x = self.x+self.width
			self.pickup.y = self.y+self.height-12/16
			set = true
		end
	else
		if #checkrect(self.x-12/16, self.y+self.height-12/16, 12/16, 12/16, {"exclude", self.pickup}, true) == 0 then
			self.pickup.x = self.x-12/16
			self.pickup.y = self.y+self.height-12/16
			set = true
		end
	end
	
	if set == false then
		if #checkrect(self.x+self.width, self.y+self.height-12/16, 12/16, 12/16, {"exclude", self.pickup}, true) == 0 then
			self.pickup.x = self.x+self.width
			self.pickup.y = self.y+self.height-12/16
		elseif #checkrect(self.x-12/16, self.y+self.height-12/16, 12/16, 12/16, {"exclude", self.pickup}, true) == 0 then
			self.pickup.x = self.x-12/16
			self.pickup.y = self.y+self.height-12/16
		elseif #checkrect(self.x, self.y+self.height, 12/16, 12/16, {"exclude", self.pickup}, true) == 0 then
			self.pickup.x = self.x
			self.pickup.y = self.y+self.height
		elseif #checkrect(self.x, self.y-12/16, 12/16, 12/16, {"exclude", self.pickup}, true) == 0 then
			self.pickup.x = self.x
			self.pickup.y = self.y-12/16
		else
			self.pickup.x = self.x
			self.pickup.y = self.y
		end
	end
	
	for h, u in pairs(emancipationgrills) do
		if u.dir == "hor" then
			if inrange(self.pickup.x+6/16, u.startx-1, u.endx, true) and inrange(u.y-14/16, boxy, self.pickup.y, true) then
				self.pickup:emancipate(h)
			end
		else
			if inrange(self.pickup.y+6/16, u.starty-1, u.endy, true) and inrange(u.x-14/16, boxx, self.pickup.x, true) then
				self.pickup:emancipate(h)
			end
		end
	end
	self.pickup = false
end

function mario:cubeemancipate()
	self.pickup = false
end

function mario:duck(ducking) --goose
	if self.infunnel then
		self.ducking = false
	else
		self.ducking = ducking
	end
	
	if self.ducking then
		self.raccoonspinframe = false
		self.y = self.y + 12/16
		self.height = 12/16
		self.quadcenterY = self.char.duckquadcenterY
		self.offsetY = self.char.duckoffsetY
	else
		self.y = self.y - 12/16
		self.height = 24/16
		self.quadcenterY = self.char.bigquadcenterY
		self.offsetY = self.char.bigoffsetY
	end
end

function mario:pipe(x, y, dir, i)	
	track("pipes_used")
	
	self.active = false
	self.infunnel = false
	self.animation = "pipe" .. dir
	self.invincible = false
	self.drawable = true
	self.animationx = x
	self.animationy = y
	self.animationtimer = 0
	self.animationmisc = i
	self.controlsenabled = false
	playsound("pipe")
	
	if intermission then
		respawnsublevel = i
	end
	
	if dir == "down" then
		if self.size > 1 then
			self.animationy = y - self.height + 12/16
		end
		self.animationstate = "idle"
		self.customscissor = {x-4, y-3, 6, 2}
	else
		if self.size == 1 then
			self.y = self.animationy-1/16 - self.height
		else
			self.y = self.animationy-1/16 - self.height
		end
		self.animationstate = "running"
		self.customscissor = {x-2, y-5, 1, 6}
	end
	
	self:setquad()
end

function mario:savereplaydata()
	local i = 1
	while love.filesystem.exists(i .. ".json") do
		i = i + 1
	end
	
	if self.noChangeFrames > 0 then
		table.insert(livereplaydata[self.playernumber], self.noChangeFrames)
		self.noChangeFrames = 0
	end
	
	local rep = {frames=self.replayFrames, name=ttname, data=livereplaydata[self.playernumber]}
	
	local s = JSON:encode(rep)
	love.filesystem.write(i .. ".json", s)
	
	if #replaydata > 300 then
		if ttrank <= 300 then
			replaydata[301].data = nil
		else
			rep.data = nil
		end
	end
	
	table.insert(replaydata, rep)
	
	table.sort(replaydata, function(a, b) return a.frames < b.frames end)
	
	replaydrawtable[#replaydata] = {}
	lastreplaydraw[#replaydata] = 1
	replaychar[#replaydata] = characters.mario
	
	-- Upload replay data
	r, e = http.request('http://timetrial.dev/api/replays',
		"name=" .. ttname .. "&" ..
		"frames=" .. self.replayFrames .. "&" ..
		"data=" .. JSON:encode(livereplaydata[self.playernumber]) .. "&" ..
		"event=" .. "GC2017"
	)
	
	print(r, e)
end

function mario:flag()	
	for i = 1, players do
		objects["player"][i].invincible = true
	end
	
	if levelfinished then
		return
	end
	track("levels_finished")
	self.raccoontimer = 0
	self.ducking = false
	self.animation = "flag"
	self.drawable = true
	self.controlsenabled = false
	self.animationstate = "climbing"
	self.pointingangle = -math.pi/2
	self.animationdirection = "right"
	self.animationtimer = 0
	self.speedx = 0
	self.speedy = 0
	self.x = flagx-2/16
	self.gravity = 0
	self.climbframe = 2
	self.active = false
	self.infunnel = false
	self:setquad()
	levelfinished = true
	levelfinishtype = "flag"
	subtractscore = false
	firework = false
	castleflagy = castleflagstarty
	objects["screenboundary"]["flag"].active = false
	
	--get score
	flagscore = flagscores[1]
	for i = 1, #flagvalues do
		if self.y < flagvalues[i]-13+flagy then
			flagscore = flagscores[i+1]
		else
			break
		end
	end
	
	addpoints(flagscore)
	
	--get firework count
	fireworkcount = tonumber(string.sub(math.ceil(mariotime), -1, -1))
	if fireworkcount ~= 1 and fireworkcount ~= 3 and fireworkcount ~= 6 then
		fireworkcount = 0
	end
	
	if portalbackground then
		fireworkcount = 0
	end
	
	love.audio.stop()
	
	
	playsound("levelend")
end

function mario:axe()
	if levelfinished then
		return
	end
	self.ducking = false
	for i = 1, players do
		objects["player"][i]:removeportals()
	end
	
	for i, v in pairs(objects["platform"]) do
		objects["platform"][i] = nil
	end
	
	ttstate = "endanimation"
	
	--get ttrank
	ttrank = #replaydata + 1
	for i, v in ipairs(replaydata) do
		print(self.replayFrames, v.frames)
		if self.replayFrames < v.frames then
			ttrank = i
			break
		end
	end

	track("levels_finished")
	self.raccoontimer = 0
	self.animation = "axe"
	self.invincible = false
	self.drawable = true
	self.animationx = axex
	self.animationy = axey
	self.animationbridgex = axex-1
	self.animationbridgey = axey+2
	self.controlsenabled = false
	self.animationtimer = 0
	self.speedx = 0
	self.speedy = 0
	self.gravity = 0
	self.active = false
	self.infunnel = false
	levelfinished = true
	levelfinishtype = "castle"
	levelfinishedmisc = 0
	levelfinishedmisc2 = 1
	if marioworld == 8 then
		levelfinishedmisc2 = 2
	end
	bridgedisappear = false
	self.animationtimer2 = castleanimationbridgedisappeardelay
	bowserfall = false
	objects["screenboundary"]["axe"] = nil
	
	if objects["bowser"][1] and not objects["bowser"][1].shot then
		local v = objects["bowser"][1]
		v.speedx = 0
		v.speedy = 0
		v.active = false
		v.gravity = 0
		v.category = 1
	else
		self.animationtimer = castleanimationmariomove
		self.active = true
		self.gravity = mariogravity
		self.animationstate = "running"
		self.speedx = 4.27
		self.pointingangle = -math.pi/2
		self.animationdirection = "right"
		
		love.audio.stop()
		playsound("castleend")
	end
	
	axex = false
end

function mario:vineanimation()
	self.infunnel = false
	self.animation = "vine"
	self.invincible = false
	self.drawable = true
	self.controlsenabled = false
	self.animationx = self.x
	self.animationy = vineanimationstart
	self.animationmisc = map[self.vinex][self.viney][3]-1
	self.active = false
	self.vine = false
end

function mario:star()
	addpoints(1000)
	self.startimer = 0
	self.colors = starcolors[1]
	self.starred = true
	stopmusic()
	music:play("starmusic.ogg")
end

function mario:fire()
	if (not noupdate and self.animation ~= "grow1" and self.animation ~= "grow2") and self.char.raccoon and self.size >= 2 and not self.ducking and not self.raccoonspinframe then --Wiggle wiggle wag wag
		self.raccoonspinframe = 1
		self.raccoonspintimer = 0
		
		self:spinhit(self.x+self.width+.75, self.y+self.height-.5, "right")
		self:spinhit(self.x-.75, self.y+self.height-.5, "left")
	end
	if (not noupdate and self.animation ~= "grow1" and self.animation ~= "grow2") and self.controlsenabled and self.size == 3 and self.ducking == false then
		if self.fireballcount < maxfireballs then
			local dir = "right"
			local mul = 1
			if (self.portalsavailable[1] or self.portalsavailable[2]) then
				if self.pointingangle > 0 then
					dir = "left"
					mul = -1
				end
			else
				if self.animationdirection == "left" then
					dir = "left"
					mul = -1
				end
			end
			
			if self.char.pegasus then
				table.insert(objects["fireball"], fireball:new(self.x+1*mul, self.y-4/16, dir, self))
			else
				table.insert(objects["fireball"], fireball:new(self.x, self.y, dir, self))
			end
			self.fireballcount = self.fireballcount + 1
			self.fireanimationtimer = 0
			self:setquad()
			playsound("fireball")
			track("fireballs_shot")
		end
	end
end

function mario:spinhit(x, y, dir)
	local col = checkrect(x, y, 0, 0, "all", true)
	for i = 1, #col, 2 do
		local a = col[i]
		local b = objects[a][col[i+1]]
		if a == "tile" then
			hitblock(b.cox, b.coy, self)
		elseif a ~= "bowser" and b.shotted then
			b:shotted(dir, true, true)
			track("enemy_kills")
			addpoints(firepoints[a], self.x, self.y)
		end
	end
end

function mario:fireballcallback()
	self.fireballcount = self.fireballcount - 1
end

function collectcoin(x, y)
	coinmap[x][y] = false
	addpoints(200)
	playsound("coin")
	mariocoincount = mariocoincount + 1
	track("coins_collected")
	if mariocoincount == 100 then
		if mariolivecount ~= false then
			for i = 1, players do
				mariolives[i] = mariolives[i] + 1
				respawnplayers()
			end
		end
		mariocoincount = 0
		playsound("oneup")
	end
end

function mario:portaled(dir)
	if self.pickup then
		self.pickup:portaled()
	end
	if not sonicrainboom or not self.rainboomallowed then
		return
	end
	
	local didrainboom = false
	
	if dir == "up" then
		if self.speedy < -rainboomspeed then
			didrainboom = true
		end
	elseif dir == "left" then
		if self.speedx < -rainboomspeed then
			didrainboom = true
		end
	elseif dir == "right" then
		if self.speedx > rainboomspeed then
			didrainboom = true
		end
	end
	
	if didrainboom then
		table.insert(rainbooms, rainboom:new(self.x+self.width/2, self.y+self.height/2, dir))
		earthquake = rainboomearthquake
		self.rainboomallowed = false
		playsound("rainboom")
		
		for i, v in pairs(objects["enemy"]) do
			v:shotted()
			if v ~= "bowser" then
				addpoints(firepoints[v.t] or 100, v.x, v.y)
			else
				for i = 1, 6 do
					v:shotted()
				end
			end
		end
		
		self.hats = {33}
	end
end

function mario:shootgel(i)
	table.insert(objects["gel"], gel:new(self.x+self.width/2+8/16, self.y+self.height/2+6/16, i))
	
	local xspeed = math.cos(-self.pointingangle-math.pi/2)*gelcannonspeed
	local yspeed = math.sin(-self.pointingangle-math.pi/2)*gelcannonspeed
	
	objects["gel"][#objects["gel"]].speedy = yspeed
	objects["gel"][#objects["gel"]].speedx = xspeed
end

function mario:respawn()
	if mariolivecount ~= false and (mariolives[self.playernumber] == 0 or levelfinished) then
		return
	end
	
	local i = 1
	while i <= players and (objects["player"][i].dead or (self.playernumber == i and not arcade)) do
		i = i + 1
	end
	
	fastestplayer = objects["player"][i]
	
	local spawnx, spawny
	
	if fastestplayer then
		for i = 2, players do
			if objects["player"][i].x > fastestplayer.x and not objects["player"][i].dead then
				fastestplayer = objects["player"][i]
			end
		end
	end
	
	if fastestplayer then
		spawnx = fastestplayer.x
		spawny = fastestplayer.y + fastestplayer.height-12/16
	elseif pipestartx then
		spawnx = pipestartx-6/16
		spawny = pipestarty-1-1-12/16
	elseif startx and startx[1] then
		spawnx = startx[1]-6/16
		spawny = starty[1]-12/16
	else
		spawnx = 3
		spawny = 12
	end
	
	--Check checkpoints to see if there was a non-all checkpoint!
	if not arcade then
		local checkid = self.playernumber
		if checkid > 4 then
			checkid = 5
		end
		
		if checkpointx[checkid] then
			local checkspawn = false
			for i = 1, 5 do
				if checkpointx[i] ~= checkpointx[checkid] or checkpointy[i] ~= checkpointy[checkid] then
					checkspawn = true
					break
				end
			end
			
			if checkspawn then
				fastestplayer = {x=checkpointx[checkid], y=checkpointy[checkid],height=0}
			end
		end
	end
	
	self.colors = mariocolors[self.playernumber]
	self.speedy = 0
	self.speedx = 0
	self.dead = false
	self.quadcenterY = self.char.smallquadcenterY
	self.height = 12/16
	self.graphic = self.smallgraphic
	self.size = 1
	self.quadcenterX = self.char.smallquadcenterX
	self.offsetY = self.char.smalloffsetY
	self.drawable = true
	self.animationstate = "idle"
	self:setquad()
	
	self.animation = "invincible"
	self.invincible = true
	self.animationtimer = 0
	
	self.y = spawny
	self.x = spawnx
	
	self.jumping = false
	self.falling = true
	self.ducking = false
	
	self.controlsenabled = true
	self.active = true
end

function mario:dive(water)
	if water then
		self.gravity = uwgravity
		self.underwater = true
		self.speedx = self.speedx*waterdamping
		self.speedy = self.speedy*waterdamping
	else
		self.gravity = mariogravity
		if not underwater then
			self.underwater = false
		end
		if self.speedy < 0 then
			self.speedy = -waterjumpforce
		end
	end
	self:setquad()
end

function mario:enteredfunnel(inside)
	if inside then
		self.infunnel = true
	else
		self.infunnel = false
	end
end

function mario:animationwalk(dir)
	self.animation = "animationwalk"
	self.animationstate = "running"
	self.animationmisc = dir
end

function mario:stopanimation()
	self.animation = false
end

function mario:portalpickup(i)
	self.lastportal = i
	
	if not self.portalsavailable[1] and not self.portalsavailable[2] then
		self.biggraphic = self.char.biganimations
		self.smallgraphic = self.char.animations
		if self.size == 1 then
			self.graphic = self.smallgraphic
		else
			self.graphic = self.biggraphic
		end
	end
	
	self.portalsavailable[i] = true
end