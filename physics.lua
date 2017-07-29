--[[
	PHYSICS LIBRARY THING
	WRITTEN BY MAURICE GUÉGAN FOR MARI0
	DON'T STEAL MY SHIT
	Licensed under WTFPL
]]--

--MASK REFERENCE LIST
---1: *ALWAYS NOT COLLIDE*

---2: WORLD
---3: MARIO
---4: GOOMBA
---5: KOOPA
---6: MUSHROOM/ONEUP/FLOWER/STAR

---7: GEL DISPENSER
---8: GEL
---9: BOX
--10: SCREENBOUNDARIES
--11: BULLETBILL

--12: PORTALWALLS
--13: FIREBALLS
--14: HAMMERS
--15: PLATFORMS/SEESAWS
--16: BOWSER

--17: FIRE
--18: VINE
--19: SPRING
--20: HAMMERBROS
--21: LAKITO

--22: BUTTON --Not used anymore
--23: CASTLEFIRE
--24: CHEEP
--25: DOOR
--26: FAITHPLATE

--27: FLYINGFISH
--28: LIGHTBRIDGE
--29: PLANT
--30: SQUID
--31: UPFIRE

function prerotatecall(a, b)
	local prerotatecalls = {"goomba", "koopa", "hammerbros", "lakito", "cheep", "flyingfish", "squid"}
	if tablecontains(prerotatecalls, a) then
		return true
	end
	
	return false
end

function physicsupdate(dt)
	local lobjects = objects
	
	for j, w in pairs(lobjects) do
		if j ~= "tile" then			
			for i, v in pairs(w) do
				if v.static == false and v.active then
					--GRAVITY
					v.speedy = v.speedy + (v.gravity or yacceleration)*dt*0.5
					
					if v.speedy > maxyspeed then
						v.speedy = maxyspeed
					end
					
					--Standard conversion!
					if v.gravitydirection and v.gravitydirection ~= math.pi/2 then
						v.speedx, v.speedy = convertfromstandard(v, v.speedx, v.speedy)
					end
					
					--PORTALS LOL
					local passed = false
					if v.portalable ~= false then
						if not checkportalVER(v, v.x+v.speedx*dt) then
							if checkportalHOR(v, v.y+v.speedy*dt) then
								passed = true
							end
						else
							passed = true
						end
						
						if passed and j == "player" then
							playsound("portalenter")
							track("portals_entered")
						end
					end
					
					--COLLISIONS ROFL
					local horcollision = false
					local vercollision = false
					
					--VS OTHER OBJECTS --but not: portalwall, castlefirefire
					for h, u in pairs(lobjects) do
						if h ~= "tile" and h ~= "portalwall" and h ~= "castlefirefire" then
							local hor, ver = handlegroup(i, h, u, v, j, dt, passed)
							if hor then
								horcollision = true
							end
							if ver then
								vercollision = true
							end
							
							--Check for emancipation grill
							if v.emancipatecheck then
								for h, u in pairs(emancipationgrills) do
									if u.active then
										if u.dir == "hor" then
											if inrange(v.x+6/16, u.startx-1, u.endx, true) and inrange(u.y-14/16, v.y, v.y+v.speedy*dt, true) then
												v:emancipate(h)
											end
										else
											if inrange(v.y+6/16, u.starty-1, u.endy, true) and inrange(u.x-14/16, v.x, v.x+v.speedx*dt, true) then
												v:emancipate(h)
											end
										end
									end
								end
							end
						end
					end
					
					--VS TILES (Because I only wanna check close ones)
					local xstart = math.floor(v.x+v.speedx*dt-2/16)+1
					local ystart = math.floor(v.y+v.speedy*dt-2/16)+1
					
					local xfrom = xstart
					local xto = xstart+math.ceil(v.width)
					local dir = 1
					
					if v.speedx < 0 then
						xfrom, xto = xto, xfrom
						dir = -1
					end
					
					for x = xfrom, xto, dir do
						for y = ystart, ystart+math.ceil(v.height) do
							--check if invisible block
							if inmap(x, y) and (not tilequads[map[x][y][1]].invisible or j == "player") then
								local t = lobjects["tile"][x .. "-" .. y]
								if t then
									--    Same object          Active        Not masked
									if (i ~= g or j ~= h) and t.active and v.mask[t.category] ~= true then
										local collision1, collision2 = checkcollision(v, t, "tile", x .. "-" .. y, j, i, dt, passed)
										if collision1 then
											horcollision = true
										elseif collision2 then
											vercollision = true
										end
									end
								end
							end
						end
					end
					
					--VS: portalwall, castlefirefire
					local latetable = {"portalwall", "castlefirefire"}
					for g, h in pairs(latetable) do
						local u = objects[h]
						local hor, ver = handlegroup(i, h, u, v, j, dt, passed)
						if hor then
							horcollision = true
						end
						if ver then
							vercollision = true
						end
						
						--Check for emancipation grill
						if v.emancipatecheck then
							for h, u in pairs(emancipationgrills) do
								if u.active then
									if u.dir == "hor" then
										if inrange(v.x+6/16, u.startx-1, u.endx, true) and inrange(u.y-14/16, v.y, v.y+v.speedy*dt, true) then
											v:emancipate(h)
										end
									else
										if inrange(v.y+6/16, u.starty-1, u.endy, true) and inrange(u.x-14/16, v.x, v.x+v.speedx*dt, true) then
											v:emancipate(h)
										end
									end
								end
							end
						end
					end
					
					--Move the object
					if vercollision == false then
						v.y = v.y + v.speedy*dt
						if j == "player" then
							track("distance_traveled", math.abs(v.speedy*dt))
						end
						
						if v.previouslyonground and v.startfall then
							v.previouslyonground = false
							if v.speedy >= 0 then
								v:startfall(i)
							end
						end
					elseif not v.previouslyonground and v.startfall then
						v.previouslyonground = true
					end
					
					if horcollision == false then
						v.x = v.x + v.speedx*dt
						if j == "player" then
							track("distance_traveled", math.abs(v.speedx*dt))
						end
					end
					
					if v.gravitydirection and v.gravitydirection ~= math.pi/2 then
						v.speedx, v.speedy = converttostandard(v, v.speedx, v.speedy)
					end
					
					--check if object is inside portal
					if v.portalable ~= false then
						inportal(v)
					end
					
					--GRAVITY
					v.speedy = v.speedy + (v.gravity or yacceleration)*dt*0.5
				end
			end
		end
	end
end

function handlegroup(i, h, u, v, j, dt, passed)
	local horcollision = false
	local vercollision = false
	for g, t in pairs(u) do
		--    Same object?          Active                 Not masked
		if (i ~= g or j ~= h) and t.active and (v.mask == nil or v.mask[t.category] ~= true) and (t.mask == nil or t.mask[v.category] ~= true) then
			local collision1, collision2 = checkcollision(v, t, h, g, j, i, dt, passed)
			if collision1 then
				horcollision = true
			elseif collision2 then
				vercollision = true
			end
		end
	end
	
	return horcollision, vercollision
end

function checkcollision(v, t, h, g, j, i, dt, passed) --v: b1table | t: b2table | h: b2type | g: b2id | j: b1type | i: b1id
	local hadhorcollision = false
	local hadvercollision = false
	
	if h ~= "tile" or (not tilequads[map[t.cox][t.coy][1]].slantupleft and not tilequads[map[t.cox][t.coy][1]].slantupright) then
		if math.abs(v.x+v.speedx*dt-t.x) < math.max(v.width, t.width)+1 and math.abs(v.y+v.speedy*dt-t.y) < math.max(v.height, t.height)+1 then
			--check if it's a passive collision (Object is colliding anyway)
			if not passed and aabb(v.x, v.y, v.width, v.height, t.x, t.y, t.width, t.height) then --passive collision! (oh noes!)
				if passivecollision(v, t, h, g, j, i, dt) then
					hadvercollision = true
				end
				
			elseif aabb(v.x + v.speedx*dt, v.y + v.speedy*dt, v.width, v.height, t.x, t.y, t.width, t.height) then
				if aabb(v.x + v.speedx*dt, v.y, v.width, v.height, t.x, t.y, t.width, t.height) then --Collision is horizontal!
					if horcollision(v, t, h, g, j, i, dt) then
						hadhorcollision = true
					end
					
				elseif aabb(v.x, v.y+v.speedy*dt, v.width, v.height, t.x, t.y, t.width, t.height) then --Collision is vertical!
					if vercollision(v, t, h, g, j, i, dt) then
						hadvercollision = true
					end
					
				else 
					--We're fucked, it's a diagonal collision! run!
					--Okay actually let's take this slow okay. Let's just see if we're moving faster horizontally than vertically, aight?
					local grav = yacceleration
					if self and self.gravity then
						grav = self.gravity
					end
					if math.abs(v.speedy-grav*dt) < math.abs(v.speedx) then
						--vertical collision it is.
						if vercollision(v, t, h, g, j, i, dt) then
							hadvercollision = true
						end
					else 
						--okay so we're moving mainly vertically, so let's just pretend it was a horizontal collision? aight cool.
						if horcollision(v, t, h, g, j, i, dt) then
							hadhorcollision = true
						end
					end
				end
			end
		end
	else
		if math.abs(v.x-t.x) < math.max(v.width, t.width)+1 and math.abs(v.y-t.y) < math.max(v.height, t.height)+1 then
			--check if it's a passive collision (Object is colliding anyway)
			local slant = "ul"
			if tilequads[map[t.cox][t.coy][1]].slantupright then
				slant = "ur"
			end
			if not passed and aabt(v.x, v.y, v.width, v.height, t.x, t.y, t.width, t.height, slant) then --passive collision! (oh noes!)
				if trianglepassivecollision(v, t, h, g, j, i, dt) then
					hadvercollision = true
				end
			elseif aabt(v.x + v.speedx*dt, v.y + v.speedy*dt, v.width, v.height, t.x, t.y, t.width, t.height, slant) then
				if trianglevercollision(v, t, h, g, j, i, dt) then
					hadvercollision = true
				end
			end	
		end
	end
	
	return hadhorcollision, hadvercollision
end

function trianglevercollision(v, t, h, g, j, i, dt)
	if v.floorcollide then
		if v:floorcollide(j, v, g, i) ~= false then
			if v.speedy then
				v.speedy = 0
			end
			if t.slant == "ur" then
				v.y = t.y-v.height + math.max(0, math.min(1, (v.x+v.speedx*dt)-(t.x)))
			elseif t.slant == "ul" then
				v.y = t.y-v.height + math.max(0, math.min(1, (t.x+t.width)-((v.x+v.speedx*dt)+v.width)))
			end
			return true
		end
	else
		if v.speedy then
			v.speedy = 0
		end
		if t.slant == "ur" then
			v.y = t.y-v.height+(t.x-v.x)+2/16
		elseif t.slant == "ul" then
			v.y = t.y-v.height + math.max(0, math.min(1, (t.x+t.width)-((v.x+v.speedx*dt)+v.width)))
		end
		return true
	end
end

function trianglepassivecollision(v, t, h, g, j, i, dt)
	trianglevercollision(v, t, h, g, j, i, dt)
end

function passivecollision(v, t, h, g, j, i, dt)
	if v.passivecollide then
		v:passivecollide(h, t, i, g)
		if t.passivecollide then
			t:passivecollide(j, v, i, g)
		end
	else
		if v.floorcollide then
			if v:floorcollide(h, t, i, g) ~= false then
				if v.speedy > 0 then
					v.speedy = 0
				end
				v.y = t.y - v.height
				return true
			end
		else
			if v.speedy > 0 then
				v.speedy = 0
			end
			v.y = t.y - v.height
			return true
		end
	end
	
	return false
end

function horcollision(v, t, h, g, j, i, dt)
	if v.speedx < 0 then
		--move object RIGHT (because it was moving left)
		
		if collisionexists("right", t) then
			if callcollision("right", t, j, v, g, i) ~= false then
				if t.speedx and t.speedx > 0 then
					t.speedx = 0
				end
			end
		else
			if t.speedx and t.speedx > 0 then
				t.speedx = 0
			end
		end
		if collisionexists("left", v) then
			if callcollision("left", v, h, t, i, g) ~= false then
				if v.speedx < 0 then
					v.speedx = 0
				end
				v.x = t.x + t.width
				return true
			end
		else
			if v.speedx < 0 then
				v.speedx = 0
			end
			v.x = t.x + t.width
			return true
		end
	else
		--move object LEFT (because it was moving right)
		
		if collisionexists("left", t) then
			if callcollision("left", t, j, v, g, i) ~= false then
				if t.speedx and t.speedx < 0 then
					t.speedx = 0
				end
			end
		else
			if t.speedx and t.speedx < 0 then
				t.speedx = 0
			end
		end
		
		if collisionexists("right", v) then
			if callcollision("right", v, h, t, i, g) ~= false then
				if v.speedx > 0 then
					v.speedx = 0
				end
				v.x = t.x - v.width
				return true
			end
		else
			if v.speedx > 0 then
				v.speedx = 0
			end
			v.x = t.x - v.width
			return true
		end
	end
	
	return false
end

function vercollision(v, t, h, g, j, i, dt)
	if v.speedy < 0 then
		--move object DOWN (because it was moving up)
		if collisionexists("floor", t) then
			if callcollision("floor", t, j, v, g, i) ~= false then
				if t.speedy and t.speedy > 0 then
					t.speedy = 0
				end
			end
		else
			if t.speedy and t.speedy > 0 then
				t.speedy = 0
			end
		end
		
		if collisionexists("ceil", v) then
			if callcollision("ceil", v, h, t, i, g) ~= false then
				if v.speedy < 0 then
					v.speedy = 0
				end
				v.y = t.y  + t.height
				return true
			end
		else
			if v.speedy < 0 then
				v.speedy = 0
			end
			v.y = t.y  + t.height
			return true
		end
	else					
		if collisionexists("ceil", t) then
			if callcollision("ceil", t, j, v, g, i) ~= false then
				if t.speedy and t.speedy < 0 then
					t.speedy = 0
				end
			end
		else	
			if t.speedy and t.speedy < 0 then
				t.speedy = 0
			end
		end
		if collisionexists("floor", v) then
			if callcollision("floor", v, h, t, i, g) ~= false then
				if v.speedy > 0 then
					v.speedy = 0
				end
				v.y = t.y - v.height
				return true
			end
		else
			if v.speedy > 0 then
				v.speedy = 0
			end
			v.y = t.y - v.height
			return true
		end
	end
	return false
end

function collisionscalls(dir, obj, a, b, c, d)
	local r
	
	if obj.gravitydirection > math.pi/4*1 and obj.gravitydirection <= math.pi/4*3 then
		if dir == "floor" then
			if obj.floorcollide then
				r = obj:floorcollide(a, b, c, d)
			end
		elseif dir == "left" then
			if obj.leftcollide then
				r = obj:leftcollide(a, b, c, d)
			end
		elseif dir == "ceil" then
			if obj.ceilcollide then
				r = obj:ceilcollide(a, b, c, d)
			end
		elseif dir == "right" then
			if obj.rightcollide then
				r = obj:rightcollide(a, b, c, d)
			end
		end
	elseif obj.gravitydirection > math.pi/4*3 and obj.gravitydirection <= math.pi/4*5 then
		if dir == "floor" then
			if obj.rightcollide then
				r = obj:rightcollide(a, b, c, d)
			end
		elseif dir == "left" then
			if obj.floorcollide then
				r = obj:floorcollide(a, b, c, d)
			end
		elseif dir == "ceil" then
			if obj.leftcollide then
				r = obj:leftcollide(a, b, c, d)
			end
		elseif dir == "right" then
			if obj.ceilcollide then
				r = obj:ceilcollide(a, b, c, d)
			end
		end
	elseif obj.gravitydirection > math.pi/4*5 and obj.gravitydirection <= math.pi/4*7 then
		if dir == "floor" then
			if obj.ceilcollide then
				r = obj:ceilcollide(a, b, c, d)
			end
		elseif dir == "left" then
			if obj.rightcollide then
				r = obj:rightcollide(a, b, c, d)
			end
		elseif dir == "ceil" then
			if obj.floorcollide then
				r = obj:floorcollide(a, b, c, d)
			end
		elseif dir == "right" then
			if obj.leftcollide then
				r = obj:leftcollide(a, b, c, d)
			end
		end
	else
		if dir == "floor" then
			if obj.leftcollide then
				r = obj:leftcollide(a, b, c, d)
			end
		elseif dir == "left" then
			if obj.ceilcollide then
				r = obj:ceilcollide(a, b, c, d)
			end
		elseif dir == "ceil" then
			if obj.rightcollide then
				r = obj:rightcollide(a, b, c, d)
			end
		elseif dir == "right" then
			if obj.floorcollide then
				r = obj:floorcollide(a, b, c, d)
			end
		end
	end
	
	return r
end

function callcollision(dir, obj, a, b, c, d)
	if not obj.gravitydirection then
		if dir == "floor" then
			return obj:floorcollide(a, b, c, d)
		elseif dir == "left" then
			return obj:leftcollide(a, b, c, d)
		elseif dir == "ceil" then
			return obj:ceilcollide(a, b, c, d)
		elseif dir == "right" then
			return obj:rightcollide(a, b, c, d)
		end
	end
	
	obj.speedx, obj.speedy = converttostandard(obj, obj.speedx, obj.speedy)
	
	local r
	
	--PRE ROTATION CALLS!!! WOAAAH
	if prerotatecall(a, b) then
		r = collisionscalls(dir, obj, a, b, c, d)
	end
	
	if a == "tile" then
		local purplegel = false
		local x, y = b.cox, b.coy
		
		--Find a more suitable block if available	
		if dir == "floor" or dir == "ceil" then
			if inmap(x+1, y) and tilequads[map[x+1][y][1]].collision and obj.x+obj.width/2+.5 > x + .5 then
				x = x + 1
			elseif inmap(x-1, y) and tilequads[map[x-1][y][1]].collision and obj.x+obj.width/2+.5 < x - .5 then
				x = x - 1
			end
		end
		if dir == "left" or dir == "right" then
			if inmap(x, y+1) and tilequads[map[x][y+1][1]].collision and obj.y+obj.height/2+.5 > y + .5 then
				y = y + 1
			elseif inmap(x, y-1) and tilequads[map[x][y-1][1]].collision and obj.y+obj.height/2+.5 < y - .5 then
				y = y - 1
			end
		end		
		
		if not obj.runanimationprogress or obj.size == 1 then --cheap check for player
			if dir == "left" and map[x][y]["gels"]["right"] == 4 then
				if obj.gravitydirection == 0 then
					obj.speedx = -obj.speedx
				end
				obj.gravitydirection = math.pi
				purplegel = true
			elseif dir == "floor" and map[x][y]["gels"]["top"] == 4 then
				if obj.gravitydirection == math.pi*1.5 then
					obj.speedx = -obj.speedx
				end
				obj.gravitydirection = math.pi/2
				purplegel = true
				allowskip = false
			elseif dir == "right" and map[x][y]["gels"]["left"] == 4 then
				if obj.gravitydirection == math.pi then
					obj.speedx = -obj.speedx
				end
				obj.gravitydirection = 0
				purplegel = true
			elseif dir == "ceil" and map[x][y]["gels"]["bottom"] == 4 then
				if obj.gravitydirection == math.pi/2 then
					obj.speedx = -obj.speedx
				end
				obj.gravitydirection = math.pi*1.5
				purplegel = true
			end
		end
		
		if purplegel then
			obj.speedy = 0
		elseif obj.gravitydirection ~= math.pi/2 then
			--check if wall is a side. and stuff.
			local resetgravity = false
			
			if obj.gravitydirection > math.pi/4*1 and obj.gravitydirection <= math.pi/4*3 then --down
				if dir == "ceil" or dir == "floor" then
					resetgravity = true
				end
			elseif obj.gravitydirection > math.pi/4*3 and obj.gravitydirection <= math.pi/4*5 then --left
				if dir == "right" or dir == "left" then
					resetgravity = true
				end
			elseif obj.gravitydirection > math.pi/4*5 and obj.gravitydirection <= math.pi/4*7 then --up
				if dir == "floor" or dir == "ceil" then
					resetgravity = true
				end
			else --right
				if dir == "left" or dir == "right" then
					resetgravity = true
				end
			end
			
			if resetgravity then
				obj.gravitydirection = math.pi/2
				obj.speedy = 0
				obj.speedx = -obj.speedx
			end
		end
	elseif obj.gravitydirection ~= math.pi/2 and (not b.gravitydirection or b.gravitydirection ~= obj.gravitydirection) then
		--Player vs box hardcode fix
		if (a == "box" and obj.category == 3) or (a == "player" and obj.category == 9) then
			
		else
			obj.gravitydirection = math.pi/2
			obj.speedy = 0
			obj.speedx = -obj.speedx
		end
	end
	
	--AFTER ROTATION CALLS!!! WOAAAH
	if not prerotatecall(a, b) then
		r = collisionscalls(dir, obj, a, b, c, d)
	end
	
	obj.speedx, obj.speedy = convertfromstandard(obj, obj.speedx, obj.speedy)
	
	return r
end

function collisionexists(dir, obj)
	if not obj.gravitydirection or (obj.gravitydirection > math.pi/4*1 and obj.gravitydirection <= math.pi/4*3) then
		if dir == "floor" then
			return obj.floorcollide
		elseif dir == "left" then
			return obj.leftcollide
		elseif dir == "ceil" then
			return obj.ceilcollide
		elseif dir == "right" then
			return obj.rightcollide
		end
	elseif obj.gravitydirection > math.pi/4*3 and obj.gravitydirection <= math.pi/4*5 then
		if dir == "floor" then
			return obj.rightcollide
		elseif dir == "left" then
			return obj.floorcollide
		elseif dir == "ceil" then
			return obj.leftcollide
		elseif dir == "right" then
			return obj.ceilcollide
		end
	elseif obj.gravitydirection > math.pi/4*5 and obj.gravitydirection <= math.pi/4*7 then
		if dir == "floor" then
			return obj.ceilcollide
		elseif dir == "left" then
			return obj.rightcollide
		elseif dir == "ceil" then
			return obj.floorcollide
		elseif dir == "right" then
			return obj.leftcollide
		end
	else
		if dir == "floor" then
			return obj.leftcollide
		elseif dir == "left" then
			return obj.ceilcollide
		elseif dir == "ceil" then
			return obj.rightcollide
		elseif dir == "right" then
			return obj.floorcollide
		end
	end
end

function adjustcollside(side, gravitydirection)
	if side == "left" then
		if gravitydirection > math.pi/4*1 and gravitydirection <= math.pi/4*3 then --down
			return "left"
		elseif gravitydirection > math.pi/4*3 and gravitydirection <= math.pi/4*5 then --left
			return "up"
		elseif gravitydirection > math.pi/4*5 and gravitydirection <= math.pi/4*7 then --up
			return "right"
		else --right
			return "down"
		end
	elseif side == "up" then
		if gravitydirection > math.pi/4*1 and gravitydirection <= math.pi/4*3 then --down
			return "up"
		elseif gravitydirection > math.pi/4*3 and gravitydirection <= math.pi/4*5 then --left
			return "right"
		elseif gravitydirection > math.pi/4*5 and gravitydirection <= math.pi/4*7 then --up
			return "down"
		else --right
			return "left"
		end
	elseif side == "right" then
		if gravitydirection > math.pi/4*1 and gravitydirection <= math.pi/4*3 then --down
			return "right"
		elseif gravitydirection > math.pi/4*3 and gravitydirection <= math.pi/4*5 then --left
			return "down"
		elseif gravitydirection > math.pi/4*5 and gravitydirection <= math.pi/4*7 then --up
			return "left"
		else --right
			return "up"
		end
	elseif side == "down" then
		if gravitydirection > math.pi/4*1 and gravitydirection <= math.pi/4*3 then --down
			return "down"
		elseif gravitydirection > math.pi/4*3 and gravitydirection <= math.pi/4*5 then --left
			return "left"
		elseif gravitydirection > math.pi/4*5 and gravitydirection <= math.pi/4*7 then --up
			return "up"
		else --right
			return "right"
		end
	end
end

function aabb(ax, ay, awidth, aheight, bx, by, bwidth, bheight)
	return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight
end

function aabt(ax, ay, awidth, aheight, bx, by, bwidth, bheight, bdir)
    if bdir == "ur" then
        return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight and ay + aheight - by > ax - bx
    elseif bdir == "ul" then
        return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight and ay + aheight - by > bheight - ax - awidth + bx
    elseif bdir == "dl" then
        return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight and ay - by < ax+awidth - bx
    elseif bdir == "dr" then
        return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight and ay - by < bwidth- ax + bx
    end
end

function checkrect(x, y, width, height, list, statics)
	local out = {}
	
	local inobj
	
	if type(list) == "table" and list[1] == "exclude" then
		inobj = list[2]
		list = "all"
	end

	for i, v in pairs(objects) do
		local contains = false
		
		if list and list ~= "all" then			
			for j = 1, #list do
				if list[j] == i then
					contains = true
				end
			end
		end
		
		if list == "all" or contains then
			for j, w in pairs(v) do
				if statics or w.static ~= true or list ~= "all" then
					local skip = false
					if inobj then
						if w.x == inobj.x and w.y == inobj.y then
							skip = true
						end
						--masktable
						if (inobj.mask ~= nil and inobj.mask[w.category] == true) or (w.mask ~= nil and w.mask[inobj.category] == true) then
							skip = true
						end
					end
					if not skip then
						if w.active then
							if aabb(x, y, width, height, w.x, w.y, w.width, w.height) then
								table.insert(out, i)
								table.insert(out, j)
							end
						end
					end
				end
			end
		end
	end
	
	return out
end

function inportal(self)
	if self.mask[2] then
		return
	end
	for i, v in pairs(portals) do
		if v.x1 ~= false and v.x2 ~= false then
			local portal1xplus = 0
			local portal2xplus = 0
			local portal1Y = v.y1
			local portal2Y = v.y2
			local portal1yplus = 0
			local portal2yplus = 0
			local portal1X = v.x1
			local portal2X = v.x2
			
			--Get the extra block of each portal
			if v.facing1 == "up" then
				portal1xplus = 1
			elseif v.facing1 == "down" then
				portal1xplus = -1
			end
			
			if v.facing2 == "up" then
				portal2xplus = 1
			elseif v.facing2 == "down" then
				portal2xplus = -1
			end
			
			if v.facing1 == "right" then
				portal1yplus = 1
			elseif v.facing1 == "left" then
				portal1yplus = -1
			end
			
			if v.facing2 == "right" then
				portal2yplus = 1
			elseif v.facing2 == "left" then
				portal2yplus = -1
			end
			
			local x = math.floor(self.x+self.width/2)+1
			local y = math.floor(self.y+self.height/2)+1
			
			if (x == portal1X or x == portal1X + portal1xplus) and (y == portal1Y or y == portal1Y + portal1yplus) then
				local entryportalX = v.x1
				local entryportalY = v.y1
				local entryportalfacing = v.facing1
				
				local exitportalX = v.x2
				local exitportalY = v.y2
				local exitportalfacing = v.facing2
				
				self.x, self.y, self.speedx, self.speedy, self.rotation = portalcoords(self.x, self.y, self.speedx, self.speedy, self.width, self.height, self.rotation, self.animationdirection, entryportalX, entryportalY, entryportalfacing, exitportalX, exitportalY, exitportalfacing, self, true)

			elseif (x == portal2X or x == portal2X + portal2xplus) and (y == portal2Y or y == portal2Y + portal2yplus) then
				local entryportalX = v.x2
				local entryportalY = v.y2
				local entryportalfacing = v.facing2
				
				local exitportalX = v.x1
				local exitportalY = v.y1
				local exitportalfacing = v.facing1
				
				self.x, self.y, self.speedx, self.speedy, self.rotation = portalcoords(self.x, self.y, self.speedx, self.speedy, self.width, self.height, self.rotation, self.animationdirection, entryportalX, entryportalY, entryportalfacing, exitportalX, exitportalY, exitportalfacing, self)

			end
		end
	end
	
	return false
end

function checkportalHOR(self, nextY) --handles horizontal (up- and down facing) portal teleportation
	for i, v in pairs(portals) do
		if v.x1 ~= false and v.x2 ~= false then
		
			local portal1xplus = 0
			local portal2xplus = 0
			local portal1Y = v.y1
			local portal2Y = v.y2
			
			--Get the extra block of each portal
			if v.facing1 == "up" then
				portal1xplus = 1
				portal1Y = portal1Y - 1
			elseif v.facing1 == "down" then
				portal1xplus = -1
			end
			
			if v.facing2 == "up" then
				portal2xplus = 1
				portal2Y = portal2Y - 1
			elseif v.facing2 == "down" then
				portal2xplus = -1
			end
			
			--first part checks whether object is in the portal's x range,                                  second part whether object just moved through the portal's Y value
			if ((v.x1 == math.floor(self.x+1) or v.x1+portal1xplus == math.floor(self.x+1)) and inrange(portal1Y, self.y+self.height/2, nextY+self.height/2))
			or ((v.x2 == math.floor(self.x+1) or v.x2+portal2xplus == math.floor(self.x+1)) and inrange(portal2Y, self.y+self.height/2, nextY+self.height/2)) then
			
				--check which portal is entry
				local entryportalX, entryportalY, entryportalfacing
				local exitportalX, exitportalY, exitportalfacing
				local entryportalxplus, entryportalyplus, exitportalxplus, exitportalyplus
				if (v.x1 == math.floor(self.x+1) or v.x1+portal1xplus == math.floor(self.x+1)) and inrange(portal1Y, self.y+self.height/2, nextY+self.height/2) then
					entryportalX = v.x1
					entryportalY = v.y1
					entryportalfacing = v.facing1
					entryportalxplus = portal1xplus
					
					exitportalX = v.x2
					exitportalY = v.y2
					exitportalfacing = v.facing2
					exitportalxplus = portal2xplus
				else
					entryportalX = v.x2
					entryportalY = v.y2
					entryportalfacing = v.facing2	
					entryportalxplus = portal2xplus
					
					exitportalX = v.x1
					exitportalY = v.y1
					exitportalfacing = v.facing1
					exitportalxplus = portal1xplus
				end
				
				--check if movement makes that portal even a possibility
				if entryportalfacing == "up" then
					if self.speedy < 0 then
						return false
					end
				elseif entryportalfacing == "down" then
					if self.speedy > 0 then
						return false
					end
				end
				
				if entryportalfacing == "left" or entryportalfacing == "right" then
					return false
				end
				
				local testx, testy, testspeedx, testspeedy, testrotation = portalcoords(self.x, self.y, self.speedx, self.speedy, self.width, self.height, self.rotation, self.animationdirection, entryportalX, entryportalY, entryportalfacing, exitportalX, exitportalY, exitportalfacing, self, true)
			
				if #checkrect(testx, testy, self.width, self.height, {"exclude", self}) == 0 then
					self.x, self.y, self.speedx, self.speedy, self.rotation = testx, testy, testspeedx, testspeedy, testrotation
				else
					self.speedy = -self.speedy*0.95
					if math.abs(self.speedy) < 2 then
						if self.speedy > 0 then
							self.speedy = 2
						else
							self.speedy = -2
						end
					end
				end
				
				
				if (entryportalfacing == "down" and exitportalfacing == "up") or (entryportalfacing == "up" and exitportalfacing == "down") then
					
				else
					self.jumping = false
					self.falling = true
				end
				
				if self.portaled then
					self:portaled(exitportalfacing)
				end
				
				return true
			end
		end
	end
	return false
end

function checkportalVER(self, nextX) --handles vertical (left- and right facing) portal teleportation
	for i, v in pairs(portals) do
		if v.x1 ~= false and v.x2 ~= false then
			local portal1yplus = 0
			local portal2yplus = 0
			local portal1X = v.x1
			local portal2X = v.x2
			
			--Get the extra block of each portal
			if v.facing1 == "right" then
				portal1yplus = 1
			elseif v.facing1 == "left" then
				portal1yplus = -1
				portal1X = portal1X - 1
			end
			
			if v.facing2 == "right" then
				portal2yplus = 1
			elseif v.facing2 == "left" then
				portal2yplus = -1
				portal2X = portal2X - 1
			end
			
			if ((v.y1 == math.floor(self.y+1) or v.y1+portal1yplus == math.floor(self.y+1)) and inrange(portal1X, self.x+self.width/2, nextX+self.width/2))
			or ((v.y2 == math.floor(self.y+1) or v.y2+portal2yplus == math.floor(self.y+1)) and inrange(portal2X, self.x+self.width/2, nextX+self.width/2)) then
				--check which portal is entry
				local entryportalX, entryportalY, entryportalfacing
				local exitportalX, exitportalY, exitportalfacing
				local entryportalxplus, entryportalyplus, exitportalxplus, exitportalyplus
				if (v.y1 == math.floor(self.y+1) or v.y1+portal1yplus == math.floor(self.y+1)) and inrange(portal1X, self.x+self.width/2, nextX+self.width/2) then
					entryportalX = v.x1
					entryportalY = v.y1
					entryportalfacing = v.facing1
					entryportalyplus = portal1yplus
					
					exitportalX = v.x2
					exitportalY = v.y2
					exitportalfacing = v.facing2
					exitportalyplus = portal2yplus
				else
					entryportalX = v.x2
					entryportalY = v.y2
					entryportalfacing = v.facing2
					entryportalyplus = portal2yplus
					
					exitportalX = v.x1
					exitportalY = v.y1
					exitportalfacing = v.facing1
					exitportalyplus = portal1yplus
				end
				
				--check if movement makes that portal even a possibility
				if entryportalfacing == "right" then
					if self.speedx > 0 then
						return false
					end
				elseif entryportalfacing == "left" then
					if self.speedx < 0 then
						return false
					end
				end
				
				if entryportalfacing == "up" or entryportalfacing == "down" then
					return false
				end
				
				local testx, testy, testspeedx, testspeedy, testrotation = portalcoords(self.x, self.y, self.speedx, self.speedy, self.width, self.height, self.rotation, self.animationdirection, entryportalX, entryportalY, entryportalfacing, exitportalX, exitportalY, exitportalfacing, self, true)
			
				if #checkrect(testx, testy, self.width, self.height, {"exclude", self}) == 0 then
					self.x, self.y, self.speedx, self.speedy, self.rotation = testx, testy, testspeedx, testspeedy, testrotation
				else
					self.speedx = -self.speedx
				end
				
				self.jumping = false
				self.falling = true
				
				if self.portaled then
					self:portaled(exitportalfacing)
				end
				
				return true
			end
		end
	end
	return false
end

function portalcoords(x, y, speedx, speedy, width, height, rotation, animationdirection, entryportalX, entryportalY, entryportalfacing, exitportalX, exitportalY, exitportalfacing, self, live)
	x = x + width/2
	y = y + height/2
	
	local directrange --vector orthogonal to portal vector T
	local relativerange --vector symmetrical to portal vector =
	
	if entryportalfacing == "up" then
		directrange = entryportalY - y - 1
		if width == 2 then
			relativerange = 0
		else
			relativerange = ((x-width/2) - entryportalX + 1) / (2-width)
		end
	elseif entryportalfacing == "right" then
		directrange = x - entryportalX
		if height == 2 then
			relativerange = 0
		else
			relativerange = ((y-height/2) - entryportalY + 1) / (2-height)
		end
	elseif entryportalfacing == "down" then
		directrange = y - entryportalY	
		if width == 2 then
			relativerange = 0
		else
			relativerange = ((x-width/2) - entryportalX + 2) / (2-width)
		end
	elseif entryportalfacing == "left" then
		directrange = entryportalX - x - 1
		if height == 2 then
			relativerange = 0
		else
			relativerange = ((y-height/2) - entryportalY + 2) / (2-height)
		end
	end
	
	relativerange = math.min(1, math.max(0, relativerange))
	
	if entryportalfacing == "up" and exitportalfacing == "up" then --up -> up
		newx = x + (exitportalX - entryportalX)
		newy = exitportalY + directrange - 1
		speedy = -speedy
		
		rotation = rotation - math.pi
		
		if live then
			local grav = yacceleration
			if self and self.gravity then
				grav = self.gravity
			end

			--keep it from bugging out by having a minimum exit speed
			
			local minspeed = math.sqrt(2*grav*(height))
			
			if speedy > -minspeed then
				speedy = -minspeed
			end
		end
	elseif (entryportalfacing == "down" and exitportalfacing == "down") then --down -> down
		newx = x + (exitportalX - entryportalX)
		newy = exitportalY - directrange
		speedy = -speedy
		
		rotation = rotation - math.pi
		
	elseif entryportalfacing == "up" and exitportalfacing == "right" then --up -> right
		newy = exitportalY - relativerange*(2-height) - height/2 + 1
		newx = exitportalX - directrange
		
		speedx, speedy = speedy, -speedx
		
		rotation = rotation - math.pi/2
		
	elseif entryportalfacing == "up" and exitportalfacing == "left" then --up -> left
		newy = exitportalY + relativerange*(2-height) + height/2 - 2
		newx = exitportalX + directrange - 1
		
		speedx, speedy = -speedy, speedx
		
		rotation = rotation + math.pi/2
		
	elseif (entryportalfacing == "up" and exitportalfacing == "down") then --up -> down
		newx = x + (exitportalX - entryportalX) - 1
		newy = exitportalY - directrange
		
	
		--prevent low-fps bugs in a cheap way:
		if entryportalY > exitportalY then
			while newy+.5 + speedy*gdt > entryportalY do
				newy = newy - 0.01
			end
			
			while newy+.5 < exitportalY do
				newy = newy + 0.01
			end
		end
		
		--prevent porting into block by limiting X, yo
		if newx <= exitportalX - 2 + width/2 then
			newx = exitportalX - 2 + width/2
		elseif newx > exitportalX - width/2 then
			newx = exitportalX - width/2
		end
		
	elseif (entryportalfacing == "down" and exitportalfacing == "up") then --down -> up
		newx = x + (exitportalX - entryportalX) + 1
		newy = exitportalY + directrange - 1
		
	elseif (entryportalfacing == "down" and exitportalfacing == "left") then --down -> left
		newy = exitportalY - relativerange*(2-height) - height/2
		newx = exitportalX + directrange - 1
		
		speedx, speedy = speedy, -speedx
		
		rotation = rotation - math.pi/2
		
	elseif (entryportalfacing == "down" and exitportalfacing == "right") then --down -> right
		newy = exitportalY + relativerange*(2-height) + height/2 - 1
		newx = exitportalX - directrange
		
		speedx, speedy = -speedy, speedx
		
		rotation = rotation + math.pi/2
		
	--LEFT/RIGHT CODE!
	elseif (entryportalfacing == "left" and exitportalfacing == "right") then --left -> right
		newx = exitportalX - directrange
		newy = y + (exitportalY - entryportalY)+1
	elseif (entryportalfacing == "right" and exitportalfacing == "left") then --right -> left
		newx = exitportalX + directrange - 1
		newy = y + (exitportalY - entryportalY)-1
	elseif (entryportalfacing == "right" and exitportalfacing == "right") then --right -> right
		newx = exitportalX - directrange
		newy = y + (exitportalY - entryportalY)
		
		speedx = -speedx
		if animationdirection == "left" then
			animationdirection = "right"
		elseif animationdirection == "right" then
			animationdirection = "left"
		end
		
	elseif (entryportalfacing == "left" and exitportalfacing == "left") then --left -> left
		newx = exitportalX + directrange - 1
		newy = y + (exitportalY - entryportalY)
		
		speedx = -speedx
		if animationdirection == "left" then
			animationdirection = "right"
		elseif animationdirection == "right" then
			animationdirection = "left"
		end
		
	elseif (entryportalfacing == "left" and exitportalfacing == "up") then --left -> up
		newx = exitportalX + relativerange*(2-width) + width/2 - 1
		newy = exitportalY + directrange - 1
		
		speedx, speedy = speedy, -speedx
		
		rotation = rotation - math.pi/2
		
		if live then		
			--keep it from bugging out by having a minimum exit speed
			local grav = yacceleration
			if self and self.gravity then
				grav = self.gravity
			end
			
			local minspeed = math.sqrt(2*grav*(height))
			
			if speedy > -minspeed then
				speedy = -minspeed
			end
		end
		
	elseif (entryportalfacing == "right" and exitportalfacing == "up") then --right -> up
		newx = exitportalX - relativerange*(2-width) - width/2 + 1
		newy = exitportalY + directrange - 1
		
		speedx, speedy = -speedy, speedx
		
		rotation = rotation + math.pi/2
		
		if live then
			--keep it from bugging out by having a minimum exit speed
			local grav = yacceleration
			if self and self.gravity then
				grav = self.gravity
			end
			
			local minspeed = math.sqrt(2*grav*(height))
			
			if speedy > -minspeed then
				speedy = -minspeed
			end
		end
		
	elseif (entryportalfacing == "left" and exitportalfacing == "down") then --left -> down
		newx = exitportalX - relativerange*(2-width) - width/2
		newy = exitportalY - directrange
		
		speedx, speedy = -speedy, speedx
		
		rotation = rotation + math.pi/2
		
	elseif (entryportalfacing == "right" and exitportalfacing == "down") then --right -> down
		newx = exitportalX + relativerange*(2-width) + width/2 - 2
		newy = exitportalY - directrange
		
		speedx, speedy = speedy, -speedx
		
		rotation = rotation - math.pi/2
	end
	
	newx = newx - width/2
	newy = newy - height/2
	
	return newx, newy, speedx, speedy, rotation, animationdirection
end

function converttostandard(obj, speedx, speedy)
	--Convert speedx and speedy to horizontal values
	local speed = math.sqrt(speedx^2+speedy^2)
	local speeddir = math.atan2(speedy, speedx)
	
	local speedx, speedy = math.cos(speeddir-obj.gravitydirection+math.pi/2)*speed, math.sin(speeddir-obj.gravitydirection+math.pi/2)*speed
				
	if math.abs(speedy) < 0.00001 then
		speedy = 0
	end
	if math.abs(speedx) < 0.00001 then
		speedx = 0
	end
	
	return speedx, speedy
end

function convertfromstandard(obj, speedx, speedy)
	--reconvert speedx and speedy to actual directions
	local speed = math.sqrt(speedx^2+speedy^2)
	local speeddir = math.atan2(speedy, speedx)
	
	local speedx, speedy = math.cos(speeddir+obj.gravitydirection-math.pi/2)*speed, math.sin(speeddir+obj.gravitydirection-math.pi/2)*speed
	
	if math.abs(speedy) < 0.00001 then
		speedy = 0
	end
	if math.abs(speedx) < 0.00001 then
		speedx = 0
	end
	
	return speedx, speedy
end

function unrotate(rotation, gravitydirection, dt)
	--rotate back to gravitydirection (portals)
	rotation = math.mod(rotation, math.pi*2)
	
	if rotation < -math.pi then
		rotation = rotation + math.pi*2
	elseif rotation > math.pi then
		rotation = rotation - math.pi*2
	end
	
	if rotation == math.pi and gravitydirection == 0 then
		rotation = rotation + portalrotationalignmentspeed*dt
	elseif rotation <= -math.pi/2 and gravitydirection == math.pi*1.5 then
		rotation = rotation - portalrotationalignmentspeed*dt
	elseif rotation > (gravitydirection-math.pi/2) then
		rotation = rotation - portalrotationalignmentspeed*dt
		if rotation < (gravitydirection-math.pi/2) then
			rotation = (gravitydirection-math.pi/2)
		end
	elseif rotation < (gravitydirection-math.pi/2) then
		rotation = rotation + portalrotationalignmentspeed*dt
		if rotation > (gravitydirection-math.pi/2) then
			rotation = (gravitydirection-math.pi/2)
		end
	end
	
	return rotation
end