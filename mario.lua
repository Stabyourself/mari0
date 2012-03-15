mario = class:new()

function mario:init(x, y, i, animation, size, t)
	self.playernumber = i or 1
	if bigmario then
		self.size = 1
	else
		self.size = size or 1
	end
	self.t = t or "portal"
	
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
	self.smallgraphic = {}
	if playertype == "minecraft" then
		for j = 0, 3 do
			self.smallgraphic[j] = minecraftanimations[j]
		end
	else
		for j = 0, 3 do
			self.smallgraphic[j] = marioanimations[j]
		end
	end
	
	self.biggraphic = {}
	if playertype == "minecraft" then
		for j = 0, 3 do
			self.biggraphic[j] = bigminecraftanimations[j]
		end
	else
		for j = 0, 3 do
			self.biggraphic[j] = bigmarioanimations[j]
		end
	end
	
	self.drawable = true
	self.quad = marioidle[3]
	self.colors = mariocolors[self.playernumber]
	if self.size == 1 then
		self.offsetX = 6
		self.offsetY = 3
		self.quadcenterX = 11
		self.quadcenterY = 10
		
		self.graphic = self.smallgraphic
	else
		self.graphic = self.biggraphic
		
		self.quadcenterY = 20
		self.quadcenterX = 9
		self.offsetY = -3
		self.offsetX = 6
		
		self.y = self.y - 12/16
		self.height = 24/16
		
		if self.size == 3 then
			self.colors = flowercolor
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
	
	self.customscissor = nil
	
	
	if players == 1 then
		self.portal1color = {60, 188, 252}
		self.portal2color = {232, 130, 30}
	else
		self.portal1color = portalcolor[self.playernumber][1]
		self.portal2color = portalcolor[self.playernumber][2]
	end
	
	--OTHER STUFF!
	self.controlsenabled = true
	
	self.runframe = 3
	self.swimframe = 1
	self.climbframe = 1
	self.runanimationprogress = 1
	self.swimanimationprogress = 1
	self.animationstate = "idle" --idle, running, jumping, falling, swimming, sliding, climbing, dead
	self.animationdirection = "right" --left, right. duh
	self.platform = false
	self.combo = 1
	self.portal1X = false
	self.portal1Y = false
	self.portal2X = false
	self.portal2Y = false
	self.portal1facing = nil
	self.portal2facing = nil
	self.rotation = 0 --for portals
	self.portaldotstimer = 0
	self.pointingangle = -math.pi/2
	self.passivemoved = false
	self.ducking = false
	self.invincible = false
	self.rainboomallowed = true
	
	self.animation = animation --pipedown, piperight, pipeup, flag, vine, intermission
	self.animationx = nil
	self.animationy = nil
	self.animationtimer = 0
	
	self.falling = false
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
	
	if underwater then
		self.gravity = uwgravity
	end
	
	self.controlsoverwrite = {}
	
	if self.animation == "intermission" and editormode then
		self.animation = nil
	end
	
	if mariolivecount ~= false and mariolives[self.playernumber] <= 0 then
		self.dead = true
		self.drawable = false
		self.active = false
		self.static = true
		self.controlsenabled = false
		self.animation = nil
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
	elseif self.animation == "intermission" then
		self.controlsenabled = false
		self.active = true
		self.gravity = mariogravity
		self.animationstate = "running"
		self.speedx = 2.61
		self.pointingangle = -math.pi/2
	elseif self.animation == "vinestart" then
		self.controlsenabled = false
		self.active = false
		self.pointingangle = -math.pi/2
		self.climbframe = 2
		self.animationstate = "climbing"
		self:setquad()
		self.x = 4-3/16
		self.y = 15+0.4*(self.playernumber-1)
		self.vineanimationclimb = false
		self.vineanimationdropoff = false
		self.vinemovetimer = 0
		playsound(vinesound)
		
		if #objects["vine"] == 0 then
			table.insert(objects["vine"], vine:new(5, 16, "start"))
		end
	end
	
	self:setquad()
end

function mario:update(dt)
	self.passivemoved = false
	--rotate back to 0 (portals)
	self.rotation = math.mod(self.rotation, math.pi*2)
	
	if self.rotation < -math.pi then
		self.rotation = self.rotation + math.pi*2
	elseif self.rotation > math.pi then
		self.rotation = self.rotation - math.pi*2
	end
	
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
				music:stop("starmusic")
			end
		end
		
		if self.startimer >= mariostarduration then
			if self.size == 3 then --flower colors
				self.colors = flowercolor
			else
				self.colors = mariocolors[self.playernumber]
			end
			self.starred = false
			self.startimer = mariostarduration
		end
	end
	
	--ANIMATIONS
	if self.animation == "pipedown" then
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
					warpzone(tonumber(string.sub(self.animationmisc, 5, 5)))
				end
			end
		end
		return
	elseif self.animation == "pipeup" then
		self.animationtimer = self.animationtimer + dt
		if self.animationtimer < pipeupdelay then
		
		elseif self.animationtimer < pipeanimationtime+pipeupdelay then
			self.y = self.animationy + 20/16 - (self.animationtimer-pipeupdelay)/pipeanimationtime*pipeanimationdistancedown
		else
			self.y = self.animationy + 20/16 - pipeanimationdistancedown
			
			if self.animationtimer >= pipeanimationtime then
				self.active = true
				self.controlsenabled = true
				self.animation = nil
				self.customscissor = nil
			end
		end
		return
	elseif self.animation == "piperight" then
		self.animationtimer = self.animationtimer + dt
		if self.animationtimer < pipeanimationtime then
			self.x = self.animationx - 28/16 + self.animationtimer/pipeanimationtime*pipeanimationdistanceright
			
			--Run animation
			if self.animationstate == "running" then
				self.runanimationprogress = self.runanimationprogress + (math.abs(pipeanimationrunspeed)+4)/5*dt*7
				while self.runanimationprogress >= 4 do
					self.runanimationprogress = self.runanimationprogress - 3
				end
				self.runframe = math.floor(self.runanimationprogress)
				self:setquad()
			end
		else
			self.x = self.animationx - 28/16 + pipeanimationdistanceright
			
			if self.animationtimer >= pipeanimationtime+pipeanimationdelay then
				updatesizes()
				if type(self.animationmisc) == "number" then --sublevel
					levelscreen_load("sublevel", self.animationmisc)
				else --warpzone
					warpzone(tonumber(string.sub(self.animationmisc, 5, 5)))
				end
			end
		end
		return
	elseif self.animation == "flag" then
		if self.animationtimer < flagdescendtime then 	
			flagimgy = 49/16 + flagydistance * (self.animationtimer/flagdescendtime)
			self.y = self.y + flagydistance/flagdescendtime * dt
			
			self.animationtimer = self.animationtimer + dt
				
			if self.y > 68/16 + flagydistance-self.height then
				self.y = 68/16 + flagydistance-self.height
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
				flagimgy = 49/16 + flagydistance
				self.pointingangle = math.pi/2
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
			end
		else
			self.animationtimer = self.animationtimer + dt
		end
		
		local add = 6
		
		if self.x >= flagx + add and self.active then
			self.drawable = false
			self.active = false
			if mariotime > 0 then
				playsound(scoreringsound)
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
					scoreringsound:stop()
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
					table.insert(fireworks, fireworkboom:new(flagx+6))
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
			self.runanimationprogress = self.runanimationprogress + (math.abs(self.speedx)+4)/5*dt*runanimationspeed
			while self.runanimationprogress >= 4 do
				self.runanimationprogress = self.runanimationprogress - 3
			end
			self.runframe = math.floor(self.runanimationprogress)
			
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
					if map[self.animationbridgex][self.animationbridgey-1][1] == 10 then
						map[self.animationbridgex][self.animationbridgey-1][1] = 1
					end
					generatespritebatch()
					playsound(bridgebreaksound)
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
				playsound(bowserfallsound)
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
		
			love.audio.stop()
			playsound(castleendsound)
		end
		
		if self.speedx > 0 and self.x >= mapwidth - 8 then
			self.x = mapwidth - 8
			self.animationstate = "idle"
			self:setquad()
			self.speedx = 0
		end
		
		if levelfinishedmisc2 == 1 then
			if self.animationtimer - dt < castleanimationtextfirstline and self.animationtimer >= castleanimationtextfirstline then
				levelfinishedmisc = 1
			end
			
			if self.animationtimer - dt < castleanimationtextsecondline and self.animationtimer >= castleanimationtextsecondline then
				levelfinishedmisc = 2
			end
		
			if self.animationtimer - dt < castleanimationnextlevel and self.animationtimer >= castleanimationnextlevel then
				nextlevel()
			end
		else
			if self.animationtimer - dt < endanimationtextfirstline and self.animationtimer >= endanimationtextfirstline then
				levelfinishedmisc = 1
			end
			
			if self.animationtimer - dt < endanimationtextsecondline and self.animationtimer >= endanimationtextsecondline then
				levelfinishedmisc = 2
				love.audio.stop()
				music:play("princessmusic")
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
				endpressbutton = true
			end
		end
		
		--Run animation
		if self.animationstate == "running" and self.animationtimer >= castleanimationmariomove then
			self.runanimationprogress = self.runanimationprogress + (math.abs(self.speedx)+4)/5*dt*runanimationspeed
			while self.runanimationprogress >= 4 do
				self.runanimationprogress = self.runanimationprogress - 3
			end
			self.runframe = math.floor(self.runanimationprogress)
			
			self:setquad()
		end
		return
		
	elseif self.animation == "death" or self.animation == "deathpit" then
		self.animationtimer = self.animationtimer + dt
		self.animationstate = "dead"
		self:setquad()
		
		if self.animation == "death" then
			if self.animationtimer > deathanimationjumptime then
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
			self.runanimationprogress = self.runanimationprogress + (math.abs(pipeanimationrunspeed)+4)/5*dt*7
			while self.runanimationprogress >= 4 do
				self.runanimationprogress = self.runanimationprogress - 3
			end
			self.runframe = math.floor(self.runanimationprogress)
			self:setquad()
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
			self.quadcenterY = 32
			self.quadcenterX = 9
			self.offsetY = -3
			self.animationstate = "idle"
		else
			self.graphic = self.smallgraphic
			self.quadcenterX = 11
			self.offsetY = 3
			if frame == 2 then
				self.animationstate = "grow"
				self:setquad("grow")
				self.quadcenterY = 16
			else
				self.animationstate = "idle"
				self:setquad()
				self.quadcenterY = 10
			end
		end
		
		local invis = math.ceil(math.mod(self.animationtimer, invicibleblinktime*2)/invicibleblinktime)
		
		if invis == 1 then
			self.drawable = true
		else
			self.drawable = false
		end
		
		if self.animationtimer - dt < shrinktime and self.animationtimer > shrinktime then
			self.animationstate = self.animationmisc
			self.animation = "invincible"
			self.invincible = true
			noupdate = false
			self.quadcenterY = 10
			self.graphic = self.smallgraphic
			self.animationtimer = 0
			self.quadcenterX = 11
			self.offsetY = 3
			self.drawable = true
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
			self.quadcenterY = 20
			self.quadcenterX = 9
			self.offsetY = -3
		else
			self.graphic = self.smallgraphic
			self.quadcenterX = 11
			self.offsetY = 3
			if frame == 2 then
				self.animationstate = "grow"
				self:setquad("grow", 1)
				self.quadcenterY = 4
			else
				self.animationstate = "idle"
				self:setquad(nil, 1)
				self.quadcenterY = -2
			end
		end
		
		if self.animationtimer - dt < growtime and self.animationtimer > growtime then
			self.animationstate = self.animationmisc
			self.animation = false
			noupdate = false
			self.quadcenterY = 20
			self.graphic = self.biggraphic
			self.animationtimer = 0
			self.quadcenterX = 9
			self.offsetY = -3
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
	
	--vine controls and shit
	if self.vine then
	
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
		local y = math.floor(self.y+self.height)+1
		if inmap(x, y) and tilequads[map[x][y][1]].coin then
			collectcoin(x, y)
		end
		local y = math.floor(self.y+self.height/2)+1
		if inmap(x, y) and tilequads[map[x][y][1]].coin then
			collectcoin(x, y)
		end
		if self.size > 1 then
			if inmap(x, y-1) and tilequads[map[x][y-1][1]].coin then
				collectcoin(x, y-1)
			end
		end
	end
	
	--mazegate
	local x = math.floor(self.x+self.width/2)+1
	local y = math.floor(self.y+self.height/2)+1
	if inmap(x, y) and map[x][y][2] and entityquads[map[x][y][2]].t == "mazegate" then
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
		if self.jumping then
			if underwater then
				self.gravity = uwyaccelerationjumping
			else
				self.gravity = yaccelerationjumping
			end
			
			if self.speedy > 0 then
				self.jumping = false
				self.falling = true
			end
		else
			if underwater then
				self.gravity = uwyacceleration
			else
				self.gravity = yacceleration
			end
		end
		
		--check for pipe pipe pipe²
		if inmap(math.floor(self.x+30/16), math.floor(self.y+self.height+20/16)) and downkey(self.playernumber) and self.falling == false and self.jumping == false then
			local t2 = map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][2]
			if t2 and entityquads[t2].t == "pipe" then
				self:pipe(math.floor(self.x+30/16), math.floor(self.y+self.height+20/16), "down", tonumber(map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][3]))
				return
			elseif t2 and entityquads[t2].t == "warppipe" then
				self:pipe(math.floor(self.x+30/16), math.floor(self.y+self.height+20/16), "down", "pipe" .. map[math.floor(self.x+30/16)][math.floor(self.y+self.height+20/16)][3])
				return
			end				
		end
	
		self:updateangle()
		
		--Portaldots
		self.portaldotstimer = self.portaldotstimer + dt
		while self.portaldotstimer > portaldotstime do
			self.portaldotstimer = self.portaldotstimer - portaldotstime
		end
		
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
			self:movement(dt)
		else
			self:underwatermovement(dt)
		end
		
		if self.y >= 15 then
			self:die("pit")
		elseif flagx and self.x+self.width >= flagx+6/16 and self.y > 2.2 then
			self:flag()
		end
		
		if firestartx and self.x >= firestartx - 1 then
			firestarted = true
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
	end
	
	--checkpoints
	local checkx = checkpoints[checkpointi+1]
	if checkx then
		if self.x > checkx then
			checkpointi = checkpointi + 1
			checkpointx = checkpoints[checkpointi]
		end
	end
	
	--drains
	local x = math.floor(self.x+self.width/2)+1
	
	if inmap(x, 15) and #map[x][15] > 1 and entityquads[map[x][15][2]].t == "drain" then
		if self.speedy < drainmax then
			self.speedy = math.min( drainmax, self.speedy + drainspeed*dt)
		end
	end
	
	self:setquad()
end

function mario:updateangle()
	--UPDATE THE PLAYER ANGLE
	if self.playernumber == mouseowner then
		local scale = scale
		if shaders and shaders.scale then scale = shaders.scale end
		self.pointingangle = math.atan2(self.x+6/16-xscroll-(love.mouse.getX()/16/scale), (self.y+6/16-.5)-(love.mouse.getY()/16/scale))
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
		--bottom on grid
		if math.mod(self.y+self.height, 1) == 0 then
			local x = round(self.x+self.width/2+.5)
			local y = self.y+self.height+1
			--x and y in map
			if inmap(x, y) then
				--top of block orange
				if map[x][y]["gels"]["top"] == 2 then
					maxrunspeed = gelmaxrunspeed
					maxwalkspeed = gelmaxwalkspeed
					runacceleration = gelrunacceleration
					walkacceleration = gelwalkacceleration
				end
			end
		end
	end

	--Run animation
	if self.animationstate == "running" then
		self.runanimationprogress = self.runanimationprogress + (math.abs(self.speedx)+4)/5*dt*runanimationspeed
		while self.runanimationprogress >= 4 do
			self.runanimationprogress = self.runanimationprogress - 3
		end
		self.runframe = math.floor(self.runanimationprogress)
	end
		
	--HORIZONTAL MOVEMENT
	if runkey(self.playernumber) then --RUNNING
		if rightkey(self.playernumber) then --MOVEMENT RIGHT
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
					if self.speedx > maxrunspeed then
						self.speedx = self.speedx + superfriction*dt + runacceleration*dt
					else
						self.speedx = self.speedx + friction*dt + runacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "right"
				else
					self.speedx = self.speedx + runacceleration*dt
					self.animationstate = "running"
					self.animationdirection = "right"
				end
				
				if self.speedx > maxrunspeed then
					self.speedx = maxrunspeed
				end
			end
			
		elseif leftkey(self.playernumber) then --MOVEMENT LEFT
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
					if self.speedx < -maxrunspeed then
						self.speedx = self.speedx - superfriction*dt - runacceleration*dt
					else
						self.speedx = self.speedx - friction*dt - runacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "left"
				else
					self.speedx = self.speedx - runacceleration*dt
					self.animationstate = "running"
					self.animationdirection = "left"
				end
				
				if self.speedx < -maxrunspeed then
					self.speedx = -maxrunspeed
				end
			end
		
		end
		if (not rightkey(self.playernumber) and not leftkey(self.playernumber)) or (self.ducking and self.falling == false and self.jumping == false) then  --NO MOVEMENT
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
	
		if rightkey(self.playernumber) then --MOVEMENT RIGHT
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
					self.speedx = self.speedx - friction*dt
					if self.speedx < maxwalkspeed then
						self.speedx = maxwalkspeed
					end
				end
			end
			
		elseif leftkey(self.playernumber) then --MOVEMENT LEFT
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
					self.speedx = self.speedx + friction*dt
					if self.speedx > -maxwalkspeed then
						self.speedx = -maxwalkspeed
					end
				end
			end
		
		end
		if (not rightkey(self.playernumber) and not leftkey(self.playernumber)) or (self.ducking and self.falling == false and self.jumping == false) then --no movement
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

function mario:underwatermovement(dt)
	if self.jumping or self.falling then
		--Swim animation
		if self.animationstate == "jumping" or self.animationstate == "falling" then
			self.swimanimationprogress = self.swimanimationprogress + runanimationspeed*dt
			while self.swimanimationprogress >= 3 do
				self.swimanimationprogress = self.swimanimationprogress - 2
			end
			self.swimframe = math.floor(self.swimanimationprogress)
		end
	else
		--Run animation
		if self.animationstate == "running" then
			self.runanimationprogress = self.runanimationprogress + (math.abs(self.speedx)+4)/5*dt*runanimationspeed
			while self.runanimationprogress >= 4 do
				self.runanimationprogress = self.runanimationprogress - 3
			end
			self.runframe = math.floor(self.runanimationprogress)
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
	if rightkey(self.playernumber) then --MOVEMENT RIGHT
		if self.jumping or self.falling then --IN AIR
			if self.speedx < uwmaxairwalkspeed then
				if self.speedx < 0 then
					self.speedx = self.speedx + uwwalkaccelerationair*dt*uwairslidefactor
				else
					self.speedx = self.speedx + uwwalkaccelerationair*dt
				end
				
				if self.speedx > uwmaxairwalkspeed then
					self.speedx = uwmaxairwalkspeed
				end
			end
		elseif self.ducking == false then --ON GROUND
			if self.speedx < uwmaxwalkspeed then
				if self.speedx < 0 then
					if self.speedx < -uwmaxrunspeed then
						self.speedx = self.speedx + uwsuperfriction*dt + uwrunacceleration*dt
					else
						self.speedx = self.speedx + uwfriction*dt + uwrunacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "right"
				else
					self.speedx = self.speedx + uwwalkacceleration*dt
					self.animationstate = "running"
					self.animationdirection = "right"
				end
				
				if self.speedx > uwmaxwalkspeed then
					self.speedx = uwmaxwalkspeed
				end
			else
				self.speedx = self.speedx - uwfriction*dt
				if self.speedx < uwmaxwalkspeed then
					self.speedx = uwmaxwalkspeed
				end
			end
		end
		
	elseif leftkey(self.playernumber) then --MOVEMENT LEFT
		if self.jumping or self.falling then --IN AIR
			if self.speedx > -uwmaxairwalkspeed then
				if self.speedx > 0 then
					self.speedx = self.speedx - uwwalkaccelerationair*dt*uwairslidefactor
				else
					self.speedx = self.speedx - uwwalkaccelerationair*dt
				end
				
				if self.speedx < -uwmaxairwalkspeed then
					self.speedx = -uwmaxairwalkspeed
				end
			end
		elseif self.ducking == false then --ON GROUND
			if self.speedx > -uwmaxwalkspeed then
				if self.speedx > 0 then
					if self.speedx > uwmaxrunspeed then
						self.speedx = self.speedx - uwsuperfriction*dt - uwrunacceleration*dt
					else
						self.speedx = self.speedx - uwfriction*dt - uwrunacceleration*dt
					end
					self.animationstate = "sliding"
					self.animationdirection = "left"
				else
					self.speedx = self.speedx - uwwalkacceleration*dt
					self.animationstate = "running"
					self.animationdirection = "left"
				end
				
				if self.speedx < -uwmaxwalkspeed then
					self.speedx = -uwmaxwalkspeed
				end
			else
				self.speedx = self.speedx + uwfriction*dt
				if self.speedx > -uwmaxwalkspeed then
					self.speedx = -uwmaxwalkspeed
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
				if self.speedx > uwmaxrunspeed then
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
				if self.speedx < -uwmaxrunspeed then
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
	local angleframe = getAngleFrame(self.pointingangle+self.rotation)
	
	local animationstate = anim or self.animationstate
	local size = s or self.size
	
	if size == 1 then
		if underwater and (self.animationstate == "jumping" or self.animationstate == "falling") then
			self.quad = marioswim[angleframe][self.swimframe]
		elseif animationstate == "running" or animationstate == "falling" then
			self.quad = mariorun[angleframe][self.runframe]
		elseif animationstate == "idle" then
			self.quad = marioidle[angleframe]
		elseif animationstate == "sliding" then
			self.quad = marioslide[angleframe]
		elseif animationstate == "jumping" then
			self.quad = mariojump[angleframe]
		elseif animationstate == "climbing" then
			self.quad = marioclimb[angleframe][self.climbframe]
		elseif animationstate == "dead" then
			self.quad = mariodie[angleframe]
		elseif animationstate == "grow" then
			self.quad = mariogrow[angleframe]
		end
	elseif size > 1 then
		if underwater and (self.animationstate == "jumping" or self.animationstate == "falling") then
			self.quad = bigmarioswim[angleframe][self.swimframe]
		elseif self.ducking then
			self.quad = bigmarioduck[angleframe]
		elseif self.fireanimationtimer < fireanimationtime then
			self.quad = bigmariofire[angleframe]
		else
			if animationstate == "running" or animationstate == "falling" then
				self.quad = bigmariorun[angleframe][self.runframe]
			elseif animationstate == "idle" then
				self.quad = bigmarioidle[angleframe]
			elseif animationstate == "sliding" then
				self.quad = bigmarioslide[angleframe]
			elseif animationstate == "climbing" then
				self.quad = bigmarioclimb[angleframe][self.climbframe]
			elseif animationstate == "jumping" then
				self.quad = bigmariojump[angleframe]
			end
		end
	end
end

function mario:jump()
	if not noupdate and self.controlsenabled then
		if not underwater then
			if self.spring then
				self.springhigh = true
				return
			end
			
			if self.falling == false then
				if self.size == 1 then
					playsound(jumpsound)
				else
					playsound(jumpbigsound)
				end
				
				local force = -jumpforce - (math.abs(self.speedx) / maxrunspeed)*jumpforceadd
				force = math.max(-jumpforce - jumpforceadd, force)
				
				self.speedy = force
				self.jumping = true
				self.animationstate = "jumping"
				self:setquad()
			end
		else
			if self.ducking then
				self:duck(false)
			end
			playsound(swimsound)
			
			self.speedy = -uwjumpforce - (math.abs(self.speedx) / maxrunspeed)*uwjumpforceadd
			self.jumping = true
			self.animationstate = "jumping"
			self:setquad()
		end
	end
end

function mario:stopjump()
	if self.controlsenabled then
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
	playsound(mushroomeatsound)
	
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
			self.colors = flowercolor
		end
		
		if self.size == 2 then
			self.animation = "grow1"
		else
			self.animation = "grow2"
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
	playsound(shrinksound)
	
	self.size = 1
	
	self.colors = mariocolors[self.playernumber]
	
	self.animation = "shrink"
	self.drawable = true
	self.invincible = true
	self.animationtimer = 0
	
	self.y = self.y + 12/16
	self.height = 12/16
	
	noupdate = true
end

function mario:floorcollide(a, b)
	self.rainboomallowed = true
	if self.jumping and (a == "platform" or a == "seesawplatform") and self.speedy < -jumpforce + 0.1 then
		return false
	end

	local anim = self.animationstate
	local jump = self.jumping
	local fall = self.falling
	
	if self:globalcollide(a, b) then
		return false
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
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b) then
			return false
		end
	end
	
	self.falling = false
	self.jumping = false
	
	--Make mario snap to runspeed if at walkspeed.
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
	
	if a == "mushroom" or a == "oneup" or a == "star" or a == "flower" then
		self.falling = true
		return false
	elseif (a == "goomba" and b.t == "goomba") or a == "bulletbill" or a == "flyingfish" or a == "lakito" or a == "hammerbro" or a == "koopa" then
		self:stompenemy(a, b)
		return false
	elseif a == "tile" then
		local x, y = b.cox, b.coy
		
		if map[x][y]["gels"] then
			if downkey(self.playernumber) == false and map[x][y]["gels"]["top"] == 1 and self.speedy > gdt*yacceleration*10 then
				self.speedy = -self.speedy
				self.falling = true
				self.animationstate = "jumping"
				self:setquad()
				self.speedy = self.speedy + self.gravity*gdt
				
				return false
			end
		end
	elseif a == "plant" or a == "bowser" or a == "cheep" or a == "upfire" or (a == "goomba" and b.t ~= "goomba") or a == "squid" or a == "hammer" then --KILL
		if self.invincible then
			self.jumping = jump
			self.falling = fall
			self.animationstate = anim
			return false
		else			
			self:die("Enemy (floorcollide)")
			return false
		end
	elseif a == "castlefirefire" or a == "fire" then
		if self.invincible then
			self.jumping = jump
			self.falling = fall
			self.animationstate = anim
			return false
		else
			self:die("castlefirefire")
			return false
		end
	end
	
	self.combo = 1
end

function mario:stompenemy(a, b)
	local bounce = false
	if a == "koopa" then
		if b.small then	
			playsound(shotsound)
			if b.speedx == 0 then
				addpoints(500, b.x, b.y)
				self.combo = 1
			end
		else
			playsound(stompsound)
		end
		
		b:stomp(self.x, self)
		
		if b.speedx == 0 or ((b.t == "redflying" or b.t == "flying") and b.small == false) then
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
			self.y = b.y - self.height-1/16
		elseif b.x > self.x then
			b.x = self.x + b.width + self.speedx*gdt + 0.05
			local col = checkrect(b.x, b.y, b.width, b.height, {"tile"})
			if #col > 1 then
				b.x = objects[col[1]][col[2]].x-b.width
				bounce = true
			end
		else
			b.x = self.x - b.width + self.speedx*gdt - 0.05
			local col = checkrect(b.x, b.y, b.width, b.height, {"tile"})
			if #col > 1 then
				b.x = objects[col[1]][col[2]].x+1
				bounce = true
			end
		end
	else
		b:stomp()
		if self.combo < #mariocombo then
			addpoints(mariocombo[self.combo], self.x, self.y)
			if a ~= "bulletbill" then
				self.combo = self.combo + 1
			end
		else
			if mariolivecount ~= false then
				mariolives[self.playernumber] = mariolives[self.playernumber]+1
			end
			table.insert(scrollingscores, scrollingscore:new("1up", self.x, self.y))
			playsound(oneupsound)
		end
		playsound(stompsound)
		
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

function mario:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b) then
			return false
		end
	end
	
	if a == "mushroom" or a == "oneup" or a == "star" or a == "flower" or (a == "platform" and (b.dir == "right" or b.dir == "justright")) then
		return false
	elseif self.speedy > 2 and ((a == "goomba" and b.t == "goomba") or a == "bulletbill" or a == "flyingfish" or a == "lakito" or a == "hammerbro" or a == "koopa") then
		self:stompenemy(a, b)
		return false
	elseif a == "castlefirefire" or a == "fire" or a == "koopa" or a == "goomba" or a == "bulletbill" or a == "plant" or a == "bowser" or a == "cheep" or a == "flyingfish" or a == "upfire" or a == "lakito" or a == "squid" or a == "hammer" or a == "hammerbro" then --KILLS
		if self.invincible then
			if a == "koopa" and b.small and b.speedx == 0 then
				b:stomp(self.x)
				playsound(shotsound)
				addpoints(500, b.x, b.y)
			end
			return false
		else
			if a == "koopa" and b.small and b.speedx == 0 then
				b:stomp(self.x)
				playsound(shotsound)
				addpoints(500, b.x, b.y)
				return false
			end
			
			self:die("Enemy (rightcollide)")
			return false
		end
	elseif a == "tile" then
		local x, y = b.cox, b.coy
			
		if map[x][y]["gels"] then
			if downkey(self.playernumber) == false and map[x][y]["gels"]["left"] == 1 and (self.falling or self.jumping) then
				if self.speedx > horbounceminspeedx then
					self.speedx = math.min(-horbouncemaxspeedx, -self.speedx*horbouncemul)
					self.speedy = math.min(self.speedy, -horbouncespeedy)
					
					return false
				end
			end
		end
		
		--check for invisible block
		if tilequads[map[x][y][1]].invisible then
			return false
		end
		
		--Check if it's a pipe with pipe pipe.
		if self.falling == false and self.jumping == false and (rightkey(self.playernumber) or intermission) then --but only on ground and rightkey
			local t2 = map[x][y][2]
			if t2 and entityquads[t2].t == "pipe" then
				self:pipe(x, y, "right", tonumber(map[x][y][3]))
				return
			else
				if inmap(x, y+1) then
					t2 = map[x][y+1][2]
					if t2 and entityquads[t2].t == "pipe" then
						self:pipe(x, y+1, "right", tonumber(map[x][y+1][3]))
						return
					end
				end
			end
		end
		
		--Check if mario should run across a gap.
		if inmap(x, y-1) and tilequads[map[x][y-1][1]].collision == false and self.speedy > 0 and self.y+self.height+1 < y+spacerunroom then
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
	elseif a == "box" then
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
	end
	
	if self.falling == false and self.jumping == false then
		self.animationstate = "idle"
		self:setquad()
	end
end

function mario:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b) then
			return false
		end
	end
	
	if a == "mushroom" or a == "oneup" or a == "star" or a == "flower" or (a == "platform" and (b.dir == "right" or b.dir == "justright")) then --NOTHING
		return false
	elseif self.speedy > 2 and ((a == "goomba" and b.t == "goomba") or a == "bulletbill" or a == "flyingfish" or a == "lakito" or a == "hammerbro" or a == "koopa") then
		self:stompenemy(a, b)
		return false
	elseif a == "castlefirefire" or a == "fire" or a == "koopa" or a == "goomba" or a == "bulletbill" or a == "plant" or a == "bowser" or a == "cheep" or a == "flyingfish" or a == "upfire" or a == "lakito" or a == "squid" or a == "hammer" or a == "hammerbro" then --KILLS
		if self.invincible then
			if a == "koopa" and b.small and b.speedx == 0 then
				b:stomp(self.x)
				playsound(shotsound)
				addpoints(500, b.x, b.y)
			end
			return false
		else
			if a == "koopa" and b.small and b.speedx == 0 then
				b:stomp(self.x)
				playsound(shotsound)
				addpoints(500, b.x, b.y)
				return false
			end
			
			self:die("Enemy (leftcollide)")
			return false
		end
	elseif a == "tile" then
		local x, y = b.cox, b.coy
		
		if map[x][y]["gels"] then
			if downkey(self.playernumber) == false and map[x][y]["gels"]["right"] == 1 and (self.falling or self.jumping) then
				if self.speedx < -horbounceminspeedx then
					self.speedx = math.min(horbouncemaxspeedx, -self.speedx*horbouncemul)
					self.speedy = math.min(self.speedy, -horbouncespeedy)
					
					return false
				end
			end
		end
		
		--check for invisible block
		if tilequads[map[x][y][1]].invisible then
			return false
		end
		
		if inmap(x, y-1) and tilequads[map[x][y-1][1]].collision == false and self.speedy > 0 and self.y+1+self.height < y+spacerunroom then
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
	elseif a == "box" then
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
	end
	
	if self.falling == false and self.jumping == false then
		self.animationstate = "idle"
		self:setquad()
	end
end

function mario:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	--star logic
	if self.starred or bigmario then
		if self:starcollide(a, b) then
			return false
		end
	end
	
	if a == "mushroom" or a == "oneup" or a == "star" or a == "flower" then --STUFF THAT SHOULDN'T DO SHIT
		return false
	elseif a == "castlefirefire" or a == "fire" or a == "plant" or a == "goomba" or a == "koopa" or a == "bulletbill" or a == "bowser" or a == "cheep" or a == "flyingfish" or a == "upfire" or a == "lakito" or a == "squid" or a == "hammer" or a == "hammerbro" then --STUFF THAT KILLS
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

		hitblock(x, y, self)
	end
	
	self.jumping = false
	self.falling = true
	self.speedy = headforce
end

function mario:globalcollide(a, b)
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
	end
end

function mario:passivecollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	if a == "platform" or a == "seesawplatform" or a == "portalwall" then
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
		if a == "tile" then
			local x, y = b.cox, b.coy
			
			--check for invisible block
			if inmap(x, y) and tilequads[map[x][y][1]].invisible then
				return false
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
	
	
	self:rightcollide(a, b)
end

function mario:starcollide(a, b)
	--enemies that die
	if a == "goomba" or a == "koopa" or a == "plant" or a == "bowser" or a == "squid" or a == "cheep" or a == "hammerbro" or a == "lakito" or a == "bulletbill" or a == "flyingfish" then
		b:shotted("right")
		if a ~= "bowser" then
			addpoints(firepoints[a], self.x, self.y)
		end
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
		self.x = self.x + 7/16
	else
		self.x = self.x - 7/16
	end
	self.animationstate = "falling"
	self:setquad()
	self.gravity = mariogravity
	self.vine = false
	self.mask[18] = false
end

function mario:grabvine(b)
	self.ducking = false
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
		self.x = b.x+b.width/2-self.width+2/16
		self.pointingangle = -math.pi/2
		self.vineside = "left"
	else --right
		self.x = b.x+b.width/2 - 2/16
		self.pointingangle = math.pi/2
		self.vineside = "right"
	end
end

function hitblock(x, y, t)
	for i = 1, players do
		local x1 = objects["player"][i].portal1X
		local y1 = objects["player"][i].portal1Y
		
		local x2 = objects["player"][i].portal2X
		local y2 = objects["player"][i].portal2Y
		
		local x3 = x1
		local y3 = y1
		
		if objects["player"][i].portal1facing == "up" then
			x3 = x3+1
		elseif objects["player"][i].portal1facing == "right" then
			y3 = y3+1
		elseif objects["player"][i].portal1facing == "down" then
			x3 = x3-1
		elseif objects["player"][i].portal1facing == "left" then
			y3 = y3-1
		end
		
		local x4 = x2
		local y4 = y2
		
		if objects["player"][i].portal2facing == "up" then
			y4 = y4-1
		elseif objects["player"][i].portal2facing == "right" then
			x4 = x4+1
		elseif objects["player"][i].portal2facing == "down" then
			y4 = y4+1
		elseif objects["player"][i].portal2facing == "left" then
			x4 = x4-1
		end
		
		if (x == x1 and y == y1) or (x == x2 and y == y2) or (x == x3 and y == y3) or (x == x4 and y == y4) then
			return
		end
	end


	if editormode then
		return
	end

	if not inmap(x, y) then
		return
	end
	
	local r = map[x][y]
	playsound(blockhitsound)
	
	if tilequads[r[1]].breakable == true or tilequads[r[1]].coinblock == true then --Block should bounce!
		table.insert(blockbouncetimer, 0.000000001) --yeah it's a cheap solution to a problem but screw it.
		table.insert(blockbouncex, x)
		table.insert(blockbouncey, y)
		generatespritebatch()
		if #r > 1 and entityquads[r[2]].t ~= "manycoins" then --block contained something!
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
				playsound(vinesound)
			else
				playsound(mushroomappearsound)
			end
		else
			table.insert(blockbouncecontent, false)
			table.insert(blockbouncecontent2, t.size)
			
			if t and t.size > 1 and tilequads[r[1]].coinblock == false and (#r == 1 or entityquads[r[2]].t ~= "manycoins") then --destroy block!
				destroyblock(x, y)
			end
		end
		
		if #r == 1 and tilequads[r[1]].coinblock then --coinblock
			playsound(coinsound)
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
				if mariocoincount == 100 then
					if mariolivecount ~= false then
						for i = 1, players do
							mariolives[i] = mariolives[i] + 1
							respawnplayers()
						end
					end
					mariocoincount = 0
					playsound(oneupsound)
				end
				addpoints(200)
			end
		end
		
		if #r > 1 and entityquads[r[2]].t == "manycoins" then --block with many coins inside! yay $_$
			playsound(coinsound)
			table.insert(coinblockanimations, coinblockanimation:new(x-0.5, y-1))
			mariocoincount = mariocoincount + 1
			
			if mariocoincount == 100 then
				if mariolivecount ~= false then
					for i = 1, players do
						mariolives[i] = mariolives[i] + 1
						respawnplayers()
					end
				end
				mariocoincount = 0
				playsound(oneupsound)
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
		for i, v in pairs(enemies) do
			if objects[v] then
				for j, w in pairs(objects[v]) do
					local centerX = w.x + w.width/2
					if inrange(centerX, x-1, x, true) and y-1 == w.y+w.height then
						--get dir
						local dir = "right"
						if w.x+w.width/2 < x-0.5 then
							dir = "left"
						end
					
						if w.shotted then
							w:shotted(dir)
							addpoints(100, w.x+w.width/2, w.y)
						end
					end
				end
			end
		end
		
		--make items jump
		for i, v in pairs(jumpitems) do
			for j, w in pairs(objects[v]) do
				local centerX = w.x + w.width/2
				if inrange(centerX, x-1, x, true) and y-1 == w.y+w.height then
					if w.jump then
						w:jump(x)
					end
				end
			end
		end
		
		--check for coin on top
		if inmap(x, y-1) and tilequads[map[x][y-1][1]].coin then
			collectcoin(x, y-1)
			table.insert(coinblockanimations, coinblockanimation:new(x-0.5, y-1))
		end
	end
end

function destroyblock(x, y)
	for i = 1, players do
		local x1 = objects["player"][i].portal1X
		local y1 = objects["player"][i].portal1Y
		
		local x2 = objects["player"][i].portal2X
		local y2 = objects["player"][i].portal2Y
		
		local x3 = x1
		local y3 = y1
		
		if objects["player"][i].portal1facing == "up" then
			x3 = x3+1
		elseif objects["player"][i].portal1facing == "right" then
			y3 = y3+1
		elseif objects["player"][i].portal1facing == "down" then
			x3 = x3-1
		elseif objects["player"][i].portal1facing == "left" then
			y3 = y3-1
		end
		
		local x4 = x2
		local y4 = y2
		
		if objects["player"][i].portal2facing == "up" then
			y4 = y4-1
		elseif objects["player"][i].portal2facing == "right" then
			x4 = x4+1
		elseif objects["player"][i].portal2facing == "down" then
			y4 = y4+1
		elseif objects["player"][i].portal2facing == "left" then
			x4 = x4-1
		end
		
		if (x == x1 and y == y1) or (x == x2 and y == y2) or (x == x3 and y == y3) or (x == x4 and y == y4) then
			return
		end
	end
	
	map[x][y][1] = 1
	objects["tile"][x .. "-" .. y] = nil
	map[x][y]["gels"] = {}
	playsound(blockbreaksound)
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
	print("Death cause: " .. how)
	
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
	
	if editormode then
		self.y = 0
		self.speedy = 0
		return
	end
	self.dead = true
	
	everyonedead = true
	for i = 1, players do
		if not objects["player"][i].dead then
			everyonedead = false
		end
	end
	
	self.animationmisc = nil
	if everyonedead then
		self.animationmisc = "everyonedead"
		love.audio.stop()
	end
	
	playsound(deathsound)
	
	if how == "time" then
		noupdate = false
		self.quadcenterY = 10
		self.graphic = self.smallgraphic
		self.size = 1
		self.quadcenterX = 11
		self.offsetY = 3
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
	self.animationtimer = 0
	self.controlsenabled = false
	self.active = false
	prevsublevel = nil
	
	if not levelfinished and not testlevel and not infinitelives and mariolivecount ~= false then
		mariolives[self.playernumber] = mariolives[self.playernumber] - 1
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

function getAngleFrame(angle)
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
	if self.portal1X or self.portal2X then
		playsound(portalfizzlesound)
	end

	moveoutportal(1)
	moveoutportal(2)

	if i ~= 2 then
	
		if self.portal1facing == "up" then	
			modifyportaltiles(self.portal1X, self.portal1Y, 1, 0, self.playernumber, 1, "add")
		elseif self.portal1facing == "down" then	
			modifyportaltiles(self.portal1X, self.portal1Y, -1, 0, self.playernumber, 1, "add")
		elseif self.portal1facing == "left" then	
			modifyportaltiles(self.portal1X, self.portal1Y, 0, -1, self.playernumber, 1, "add")
		elseif self.portal1facing == "right" then	
			modifyportaltiles(self.portal1X, self.portal1Y, 0, 1, self.playernumber, 1, "add")
		end
		self.portal1X, self.portal1Y = false, false
		
		objects["portalwall"][self.playernumber .. "-1-1"] = nil
		objects["portalwall"][self.playernumber .. "-1-2"] = nil
		objects["portalwall"][self.playernumber .. "-1-3"] = nil
	end
	
	if i ~= 1 then
		
		if self.portal2facing == "up" then	
			modifyportaltiles(self.portal2X, self.portal2Y, 1, 0, self.playernumber, 2, "add")
		elseif self.portal2facing == "down" then	
			modifyportaltiles(self.portal2X, self.portal2Y, -1, 0, self.playernumber, 2, "add")
		elseif self.portal2facing == "left" then	
			modifyportaltiles(self.portal2X, self.portal2Y, 0, -1, self.playernumber, 2, "add")
		elseif self.portal2facing == "right" then	
			modifyportaltiles(self.portal2X, self.portal2Y, 0, 1, self.playernumber, 2, "add")
		end
		self.portal2X, self.portal2Y  = false, false
		
		objects["portalwall"][self.playernumber .. "-2-1"] = nil
		objects["portalwall"][self.playernumber .. "-2-2"] = nil
		objects["portalwall"][self.playernumber .. "-2-3"] = nil
	end
	
	if i ~= 2 then
		self.portal1facing = nil
	end
	if i ~= 1 then
		self.portal2facing = nil
	end
	
	for i, v in pairs(objects["lightbridge"]) do
		v:updaterange()
	end
	
	for i, v in pairs(objects["laser"]) do
		v:updaterange()
	end
end

function mario:use()
	if self.pickup then
		if self.pickup.destroying then
			self.pickup = false
		else
			self:dropbox()
			return
		end
	end
	local xcenter = self.x + 6/16 - math.sin(self.pointingangle)*userange
	local ycenter = self.y + 6/16 - math.cos(self.pointingangle)*userange
	
	local col = userect(xcenter-usesquaresize/2, ycenter-usesquaresize/2, usesquaresize, usesquaresize)
	if #col > 0 then
		col[1]:used(self.playernumber)
	end
end

function mario:pickupbox(box)
	self.pickup = box
end

function mario:dropbox()
	self.pickup:dropped()
	
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
	self.pickup = nil
end

function mario:cubeemancipate()
	self.pickup = nil
end

function mario:duck(ducking) --goose
	self.ducking = ducking
	if self.ducking then
		self.y = self.y + 12/16
		self.height = 12/16
		self.quadcenterY = 22
		self.offsetY = 7
	else
		self.y = self.y - 12/16
		self.height = 24/16
		self.quadcenterY = 20
		self.offsetY = -3
	end
end

function mario:pipe(x, y, dir, i)
	self.active = false
	self.animation = "pipe" .. dir
	self.invincible = false
	self.drawable = true
	self.animationx = x
	self.animationy = y
	self.animationtimer = 0
	self.animationmisc = i
	self.controlsenabled = false
	playsound(pipesound)
	
	if intermission then
		respawnsublevel = i
	end
	
	if dir == "down" then
		if self.size > 1 then
			self.animationy = y - self.height + 12/16
		end
		self.animationstate = "idle"
		self.customscissor = {x-2, y-3, 2, 2}
	else
		if self.size == 1 then
			self.y = self.animationy-1/16 - self.height
		else
			self.y = self.animationy-1/16 - self.height
		end
		self.animationstate = "running"
		self.customscissor = {x-2, y-3, 1, 4}
	end
	
	self:setquad()
end

function mario:flag()
	if levelfinished then
		return
	end
	self.ducking = false
	self.animation = "flag"
	self.invincible = false
	self.drawable = true
	self.controlsenabled = false
	self.animationstate = "climbing"
	self.pointingangle = -math.pi/2
	self.animationtimer = 0
	self.speedx = 0
	self.speedy = 0
	self.x = flagx-2/16
	self.gravity = 0
	self.climbframe = 2
	self.active = false
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
		if self.y < flagvalues[i] then
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
	
	
	playsound(levelendsound)
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
		
		love.audio.stop()
		playsound(castleendsound)
	end
	
	axex = false
	axey = false
end

function mario:vineanimation()
	self.animation = "vine"
	self.invincible = false
	self.drawable = true
	self.controlsenabled = false
	self.animationx = self.x
	self.animationy = vineanimationstart
	self.animationmisc = map[self.vinex][self.viney][3]
	self.active = false
	self.vine = false
end

function mario:star()
	addpoints(1000)
	self.startimer = 0
	self.colors = starcolors[1]
	self.starred = true
	stopmusic()
	music:play("starmusic")
end

function mario:fire()
	if not noupdate and self.controlsenabled and self.size == 3 and self.ducking == false then
		if self.fireballcount < maxfireballs then
			local dir = "right"
			if self.pointingangle > 0 then
				dir = "left"
			end
			table.insert(objects["fireball"], fireball:new(self.x+.5, self.y, dir, self))
			self.fireballcount = self.fireballcount + 1
			self.fireanimationtimer = 0
			self:setquad()
			playsound(fireballsound)
		end
	end
end

function mario:fireballcallback()
	self.fireballcount = self.fireballcount - 1
end

function collectcoin(x, y)
	map[x][y][1] = 1
	addpoints(200)
	playsound(coinsound)
	mariocoincount = mariocoincount + 1
	if mariocoincount == 100 then
		if mariolivecount ~= false then
			for i = 1, players do
				mariolives[i] = mariolives[i] + 1
				respawnplayers()
			end
		end
		mariocoincount = 0
		playsound(oneupsound)
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
		playsound(rainboomsound)
		
		for i, v in pairs(enemies) do
			if objects[v] then
				for j, w in pairs(objects[v]) do
					w:shotted()
					if v ~= "bowser" then
						addpoints(firepoints[v], w.x, w.y)
					else
						for i = 1, 6 do
							w:shotted()
						end
					end
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
	while i <= players and (objects["player"][i].dead or self.playernumber == i) do
		i = i + 1
	end
	
	fastestplayer = objects["player"][i]
	
	for i = 2, players do
		if objects["player"][i].x > fastestplayer.x and not objects["player"][i].dead then
			fastestplayer = objects["player"][i]
		end
	end
	
	self.colors = mariocolors[self.playernumber]
	self.speedy = 0
	self.speedx = 0
	self.dead = false
	self.quadcenterY = 10
	self.height = 12/16
	self.graphic = self.smallgraphic
	self.size = 1
	self.quadcenterX = 11
	self.offsetY = 3
	self.drawable = true
	self.animationstate = "idle"
	self:setquad()
	
	self.animation = "invincible"
	self.invincible = true
	self.animationtimer = 0
	
	self.y = fastestplayer.y + fastestplayer.height-12/16
	self.x = fastestplayer.x
	
	self.jumping = false
	self.falling = true
	
	self.controlsenabled = true
	self.active = true
end
