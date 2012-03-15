function editor_load()

	tilecount1 = 168
	tilecount2 = 74
	
	minimapscroll = 0
	minimapx = 3
	minimapy = 30
	
	currenttile = 1
	
	minimapscrollspeed = 30
	minimapdragging = false
	
	allowdrag = true
	
	guielements["tabmain"] = guielement:new("button", 1, 1, "main", maintab, 3)
	guielements["tabmain"].fillcolor = {63, 63, 63}
	guielements["tabtiles"] = guielement:new("button", 43, 1, "tiles", tilestab, 3)
	guielements["tabtiles"].fillcolor = {63, 63, 63}
	guielements["tabtools"] = guielement:new("button", 93, 1, "tools", toolstab, 3)
	guielements["tabtools"].fillcolor = {63, 63, 63}
	guielements["tabmaps"] = guielement:new("button", 143, 1, "maps", mapstab, 3)
	guielements["tabmaps"].fillcolor = {63, 63, 63}
	
	--MAIN
	guielements["autoscrollcheckbox"] = guielement:new("checkbox", 291, 65, toggleautoscroll, autoscroll)
	guielements["backgrounddropdown"] = guielement:new("dropdown", 17, 85, 6, changebackground, background, "blue", "black", "water")
	guielements["musicdropdown"] = guielement:new("dropdown", 17, 110, 11, changemusic, musici, "none", "overworld", "underground", "castle", "underwater", "star", "custom")
	guielements["spritesetdropdown"] = guielement:new("dropdown", 17, 135, 11, changespriteset, spriteset, "overworld", "underground", "castle", "underwater")
	guielements["timelimitdecrease"] = guielement:new("button", 17, 160, "{", decreasetimelimit, 0)
	guielements["timelimitincrease"] = guielement:new("button", 31 + string.len(mariotimelimit)*8, 160, "}", increasetimelimit, 0)
	guielements["mapwidthdecrease"] = guielement:new("button", 268, 178, "{", nil, 0)
	guielements["mapwidthincrease"] = guielement:new("button", 264, 178, "}", nil, 0)
	guielements["mapwidthapply"] = guielement:new("button", 320, 178, "apply", applymapwidth, 0)
	guielements["savebutton"] = guielement:new("button", 10, 200, "save", savelevel, 2)
	guielements["menubutton"] = guielement:new("button", 54, 200, "return to menu", menu_load, 2)
	guielements["testbutton"] = guielement:new("button", 178, 200, "test level", test_level, 2)
	guielements["savebutton"].bordercolor = {255, 0, 0}
	guielements["savebutton"].bordercolorhigh = {255, 127, 127}
	
	guielements["intermissioncheckbox"] = guielement:new("checkbox", 200, 80, toggleintermission, intermission)
	guielements["warpzonecheckbox"] = guielement:new("checkbox", 200, 95, togglewarpzone, haswarpzone)
	guielements["underwatercheckbox"] = guielement:new("checkbox", 200, 110, toggleunderwater, underwater)
	guielements["bonusstagecheckbox"] = guielement:new("checkbox", 200, 125, togglebonusstage, bonusstage)
	guielements["custombackgroundcheckbox"] = guielement:new("checkbox", 200, 140, togglecustombackground, custombackground)
	
	guielements["scrollfactorscrollbar"] = guielement:new("scrollbar", 298, 154, 100, 35, 11, reversescrollfactor(), "hor")
	
	--TILES
	guielements["tilesall"] = guielement:new("button", 70, 20, "all", tilesall, 2)
	guielements["tilessmb"] = guielement:new("button", 103, 20, "smb", tilessmb, 2)
	guielements["tilesportal"] = guielement:new("button", 136, 20, "portal", tilesportal, 2)
	guielements["tilescustom"] = guielement:new("button", 193, 20, "custom", tilescustom, 2)
	guielements["tilesentities"] = guielement:new("button", 268, 20, "entities", tilesentities, 2)
	
	guielements["tilesscrollbar"] = guielement:new("scrollbar", 381, 37, 167, 15, 40, 0, "ver")
	
	--TOOLS
	guielements["linkbutton"] = guielement:new("button", 5, 22, "link tool|to link testing equipment, drag a line from the|red devices to a yellow activator to turn them|green and connected. insert zelda joke here.", linkbutton, 2, false, 4, 383)
	guielements["linkbutton"].bordercolor = {0, 255, 0}
	guielements["linkbutton"].bordercolorhigh = {220, 255, 220}
	guielements["portalbutton"] = guielement:new("button", 5, 71, "portal gun|for testing purposes, use this to shoot portals!", portalbutton, 2, false, 2, 383)
	guielements["portalbutton"].bordercolor = {0, 0, 255}
	guielements["portalbutton"].bordercolorhigh = {127, 127, 255}
	
	guielements["livesdecrease"] = guielement:new("button", 198, 104, "{", livesdecrease, 0)
	guielements["livesincrease"] = guielement:new("button", 194, 104, "}", livesincrease, 0)
	
	--MAPS
	guielements["savebutton2"] = guielement:new("button", 10, 140, "save", savelevel, 2)
	guielements["savebutton2"].bordercolor = {255, 0, 0}
	guielements["savebutton2"].bordercolorhigh = {255, 127, 127}
	
	--get current description and shit
	local mappackname = ""
	local mappackauthor = ""
	local mappackdescription = ""
	if love.filesystem.exists("mappacks/" .. mappack .. "/settings.txt") then
		local data = love.filesystem.read("mappacks/" .. mappack .. "/settings.txt")
		local split1 = data:split("\n")
		for i = 1, #split1 do
			local split2 = split1[i]:split("=")
			if split2[1] == "name" then
				mappackname = split2[2]:lower()
			elseif split2[1] == "author" then
				mappackauthor = split2[2]:lower()
			elseif split2[1] == "description" then
				mappackdescription = split2[2]:lower()
			end
		end
	end
	
	guielements["edittitle"] = guielement:new("input", 5, 115, 17, nil, mappackname, 17)
	guielements["editauthor"] = guielement:new("input", 5, 140, 13, nil, mappackauthor, 13)
	guielements["editdescription"] = guielement:new("input", 5, 165, 17, nil, mappackdescription, 51, 3)
	guielements["savesettings"] = guielement:new("button", 5, 203, "save settings", savesettings, 2)
	guielements["savesettings"].bordercolor = {255, 0, 0}
	guielements["savesettings"].bordercolorhigh = {255, 127, 127}
	
	tilesall()
	if editorloadopen then
		editoropen()
		editorloadopen = false
	else
		editorclose()
		editorstate = "main"
		editentities = false
	end
end

function editor_update(dt)
	----------
	--EDITOR--
	----------	
	if editormenuopen == false then
		--key scroll
		if love.keyboard.isDown("left") then
			autoscroll = false
			guielements["autoscrollcheckbox"].var = autoscroll
			splitxscroll[1] = splitxscroll[1] - 30*gdt
			if splitxscroll[1] < 0 then
				splitxscroll[1] = 0
			end
			generatespritebatch()
		elseif love.keyboard.isDown("right") then
			autoscroll = false
			guielements["autoscrollcheckbox"].var = autoscroll
			splitxscroll[1] = splitxscroll[1] + 30*gdt
			if splitxscroll[1] > mapwidth-width then
				splitxscroll[1] = mapwidth-width
			end
			generatespritebatch()
		end
		
		if editorstate == "linktool" or editorstate == "portalgun" then
			return
		end
		
		if love.mouse.isDown("l") and allowdrag then
			local x, y = love.mouse.getPosition()
			placetile(x, y)
		end
	elseif editorstate == "main" then
		if love.mouse.isDown("l") then
			local mousex, mousey = love.mouse.getPosition()
			if mousey >= minimapy*scale and mousey < (minimapy+34)*scale then
				if mousex >= minimapx*scale and mousex < (minimapx+394)*scale then
					if mousex < (minimapx+width)*scale then
						if minimapscroll > 0 then
							minimapscroll = minimapscroll - minimapscrollspeed*dt
							if minimapscroll < 0 then
								minimapscroll = 0
							end
						end
					elseif mousex >= (minimapx+394-width)*scale then
						if minimapscroll < mapwidth-width-170 then
							minimapscroll = minimapscroll + minimapscrollspeed*dt
							if minimapscroll > mapwidth-width-170 then
								minimapscroll = mapwidth-width-170
							end
						end
					end
				
					splitxscroll[1] = (mousex/scale-3-width) / 2 + minimapscroll
					
					if splitxscroll[1] < minimapscroll then
						splitxscroll[1] = minimapscroll
					end
					if splitxscroll[1] > 170 + minimapscroll then
						splitxscroll[1] = 170 + minimapscroll
					end
					if splitxscroll[1] > mapwidth-width then
						splitxscroll[1] = mapwidth-width
					end
	
					--SPRITEBATCH UPDATE
					if math.floor(splitxscroll[1]) ~= spritebatchX[1] then
						generatespritebatch()
						spritebatchX[1] = math.floor(splitxscroll[1])
					end
				end
			end
			
			--mapwidth repeat
			if guirepeattimer > 0 then
				guirepeattimer = guirepeattimer - dt
			else
				if guielements["mapwidthincrease"]:inhighlight(mousex, mousey) then
					targetmapwidth = targetmapwidth+1
					guirepeattimer = guirepeatdelay
					guielements["mapwidthincrease"].x = 282 + string.len(targetmapwidth)*8
				elseif guielements["mapwidthdecrease"]:inhighlight(mousex, mousey) then
					targetmapwidth = targetmapwidth-1
					guirepeattimer = guirepeatdelay
					guielements["mapwidthincrease"].x = 282 + string.len(targetmapwidth)*8
				end
			end
		end
		updatescrollfactor()
	elseif editorstate == "tiles" then
		tilesoffset = guielements["tilesscrollbar"].value * tilescrollbarheight * scale
	end
end

function editor_draw()
	love.graphics.setColor(255, 255, 255)
	
	local mousex, mousey = love.mouse.getPosition()
	
	--EDITOR
	if editormenuopen == false then
		if rightclickmenuopen then
			rightclickmenu:draw()
		elseif editorstate ~= "linktool" and editorstate ~= "portalgun" then
			local x, y = getMouseTile(love.mouse.getX(), love.mouse.getY()-8*scale)
			
			if inmap(x, y+1) then
				love.graphics.setColor(255, 255, 255, 200)
				if editentities == false then
					love.graphics.drawq(tilequads[currenttile].image, tilequads[currenttile].quad, math.floor((x-splitxscroll[1]-1)*16*scale), ((y-1)*16+8)*scale, 0, scale, scale)
				else
					love.graphics.drawq(entityquads[currenttile].image, entityquads[currenttile].quad, math.floor((x-splitxscroll[1]-1)*16*scale), ((y-1)*16+8)*scale, 0, scale, scale)
				end
			end
		end
		
		if editorstate == "linktool" and editorstate ~= "portalgun" then
			if linktoolX and love.mouse.isDown("l") then
				love.graphics.line(math.floor((linktoolX-xscroll-.5)*16*scale), math.floor((linktoolY-1)*16*scale), mousex, mousey)
			end
			
			local cox, coy = getMouseTile(mousex, mousey+8*scale)
			
			local table1 = {}
			for i, v in pairs(outputsi) do
				table.insert(table1, v)
			end
			for i, v in pairs(inputsi) do
				table.insert(table1, v)
			end
			
			for x = math.floor(splitxscroll[1]), math.floor(splitxscroll[1])+width+1 do
				for y = 1, 15 do
					for i, v in pairs(table1) do
						if inmap(x, y) and #map[x][y] > 1 and map[x][y][2] == v then							
							local r = map[x][y]
							local drawline = false
							
							if tablecontains(r, "link") and cox == x and coy == y and not love.mouse.isDown("l") then
								love.graphics.setColor(0, 255, 0, 255)
								drawline = true
							elseif tablecontains(r, "link") then
								love.graphics.setColor(150, 255, 150, 100)
								drawline = true
							elseif tablecontains(outputsi, map[x][y][2]) and cox == x and coy == y and linktoolX and love.mouse.isDown("l") then
								love.graphics.setColor(255, 255, 0, 255)
							elseif tablecontains(outputsi, map[x][y][2]) then
								love.graphics.setColor(255, 255, 150, 150)
							elseif cox == x and coy == y and not love.mouse.isDown("l") then
								love.graphics.setColor(255, 0, 0, 255)
							else
								love.graphics.setColor(255, 150, 150, 150)
							end
							love.graphics.rectangle("fill", math.floor((x-splitxscroll[1]-1)*16*scale), ((y-1)*16-8)*scale, 16*scale, 16*scale)
							
							if drawline then
								local x2, y2
								for i = 3, #map[x][y] do
									if map[x][y][i] == "link" then
										x2, y2 = tonumber(map[x][y][i+1]), tonumber(map[x][y][i+2])
										break
									end
								end
								love.graphics.line((x-xscroll-.5)*16*scale, (y-1)*16*scale, (x2-xscroll-.5)*16*scale, (y2-1)*16*scale)
							end
						end
					end
				end
			end
		end
	else
		if editorstate == "maps" then
			love.graphics.setColor(0, 0, 0, 100)
		else
			love.graphics.setColor(0, 0, 0, 230)
		end
		
		if minimapdragging == false then
			love.graphics.rectangle("fill", 1*scale, 18*scale, 398*scale, 205*scale)		
		else
			love.graphics.rectangle("fill", 1*scale, 18*scale, 398*scale, 57*scale)
		end
		
		guielements["tabmain"]:draw()
		guielements["tabtiles"]:draw()
		guielements["tabtools"]:draw()
		guielements["tabmaps"]:draw()
		
		if editorstate == "tiles" then			
			--TILES
			love.graphics.setColor(255, 255, 255)
			
			properprint("tilelist", 3*scale, 24*scale)
			guielements["tilesall"]:draw()
			guielements["tilessmb"]:draw()
			guielements["tilesportal"]:draw()
			guielements["tilescustom"]:draw()
			guielements["tilesentities"]:draw()
			
			drawrectangle(4, 37, 375, 167)
			
			love.graphics.setScissor(5*scale, 38*scale, 373*scale, 165*scale)
			
			if editentities == false then
				for i = 1, tilelistcount+1 do
					love.graphics.drawq(tilequads[i+tileliststart-1].image, tilequads[i+tileliststart-1].quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
				end
			else
				for i = 1, entitiescount do
					love.graphics.drawq(entityquads[i].image, entityquads[i].quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
				end
			end
			
			local tile = gettilelistpos(love.mouse.getX(), love.mouse.getY())
			if editentities == false then
				if tile and tile <= tilelistcount+1 then
					love.graphics.setColor(255, 255, 255, 127)
					love.graphics.rectangle("fill", (5+math.mod((tile-1), 22)*17)*scale, (38+math.floor((tile-1)/22)*17)*scale-tilesoffset, 16*scale, 16*scale)
				end
			else
				if tile and tile <= entitiescount then
					love.graphics.setColor(255, 255, 255, 127)
					love.graphics.rectangle("fill", (5+math.mod((tile-1), 22)*17)*scale, (38+math.floor((tile-1)/22)*17)*scale-tilesoffset, 16*scale, 16*scale)
				end
			end
			
			love.graphics.setScissor()
			
			guielements["tilesscrollbar"]:draw()
			
			if editentities and entitydescriptions[tile] then
				local newstring = entitydescriptions[tile]
				if string.len(newstring) > 49 then
					newstring = string.sub(newstring, 1, 49) .. "|" .. string.sub(newstring, 50, 98)
				end
				properprint(newstring, 3*scale, 205*scale)
			else
				if tile and tilequads[tile+tileliststart-1] then
					if tilequads[tile+tileliststart-1].collision then
						properprint("collision: true", 3*scale, 205*scale)
					else
						properprint("collision: false", 3*scale, 205*scale)
					end
					
					if tilequads[tile+tileliststart-1].collision and tilequads[tile+tileliststart-1].portalable then
						properprint("portalable: true", 3*scale, 215*scale)
					else
						properprint("portalable: false", 3*scale, 215*scale)
					end
				end
			end
			
			love.graphics.setColor(255, 255, 255)
		elseif editorstate == "main" then		
			--MINIMAP
			love.graphics.setColor(255, 255, 255)
			properprint("minimap", 3*scale, 21*scale)
			love.graphics.rectangle("fill", minimapx*scale, minimapy*scale, 394*scale, 34*scale)
			love.graphics.setColor(unpack(backgroundcolor[background]))
			love.graphics.rectangle("fill", (minimapx+2)*scale, (minimapy+2)*scale, 390*scale, 30*scale)
			
			local lmap = map
			
			love.graphics.setScissor((minimapx+2)*scale, (minimapy+2)*scale, 390*scale, 30*scale)
			
			for x = 1, mapwidth do
				for y = 1, 15 do
					if x-minimapscroll > 0 and x-minimapscroll < 196 then
						local id = lmap[x][y][1]
						if id ~= nil and id ~= 0 and tilequads[id].invisible == false then
							if rgblist[id] then
								love.graphics.setColor(unpack(rgblist[id]))
								love.graphics.rectangle("fill", (minimapx+x*2-minimapscroll*2)*scale, (minimapy+y*2)*scale, 2*scale, 2*scale)
							end
						end
					end
				end
			end
			
			love.graphics.setScissor()
			
			love.graphics.setColor(255, 0, 0)
			drawrectangle(splitxscroll[1]*2+minimapx-minimapscroll*2, minimapy, (width+2)*2, 34)
			drawrectangle(splitxscroll[1]*2+minimapx-minimapscroll*2+1, minimapy+1, (width+1)*2, 32)
			guielements["autoscrollcheckbox"]:draw()
			properprint("follow mario", 301*scale, 66*scale)
			
			if minimapdragging == false then
				guielements["mapwidthdecrease"]:draw()
				guielements["mapwidthincrease"]:draw()
				guielements["mapwidthapply"]:draw()
				properprint("current mapwidth: " .. mapwidth, 160*scale, 170*scale)
				properprint("new mapwidth:  " .. targetmapwidth, 160*scale, 180*scale)
				guielements["savebutton"]:draw()
				guielements["menubutton"]:draw()
				guielements["testbutton"]:draw()
				guielements["timelimitdecrease"]:draw()
				properprint(mariotimelimit, 29*scale, 162*scale)
				guielements["timelimitincrease"]:draw()
				properprint("timelimit", 8*scale, 151*scale)
				guielements["spritesetdropdown"]:draw()
				properprint("spriteset", 8*scale, 126*scale)
				guielements["musicdropdown"]:draw()
				properprint("music", 8*scale, 101*scale)
				guielements["backgrounddropdown"]:draw()
				properprint("background color", 8*scale, 76*scale)
				
				guielements["intermissioncheckbox"]:draw()
				guielements["warpzonecheckbox"]:draw()
				guielements["underwatercheckbox"]:draw()
				guielements["bonusstagecheckbox"]:draw()
				guielements["custombackgroundcheckbox"]:draw()
				
				if custombackground then
					love.graphics.setColor(255, 255, 255, 255)
				else
					love.graphics.setColor(150, 150, 150, 255)
				end
				properprint("scrollfactor", 199*scale, 156*scale)
				
				guielements["scrollfactorscrollbar"]:draw()
				if custombackground then
					love.graphics.setColor(255, 255, 255, 255)
				else
					love.graphics.setColor(150, 150, 150, 255)
				end
				properprint(formatscrollnumber(scrollfactor), (guielements["scrollfactorscrollbar"].x+1+guielements["scrollfactorscrollbar"].xrange*guielements["scrollfactorscrollbar"].value)*scale, 156*scale)
				
				love.graphics.setColor(255, 255, 255, 255)
					
				properprint("intermission", 210*scale, 81*scale)
				properprint("has warpzone", 210*scale, 96*scale)
				properprint("underwater", 210*scale, 111*scale)
				properprint("bonusstage", 210*scale, 126*scale)
				properprint("custom background", 210*scale, 141*scale)
			end
		elseif editorstate == "maps" then
			for i = 1, 8 do
				properprint("w" .. i, ((i-1)*49 + 19)*scale, 23*scale)
				for j = 1, 4 do
					for k = 0, 5 do
						guielements[i .. "-" .. j .. "_" .. k]:draw()
					end
				end
			end
			properprint("do not forget to save your current map before|changing!", 5*scale, 120*scale)
			guielements["savebutton2"]:draw()
		elseif editorstate == "tools" then
			guielements["linkbutton"]:draw()
			guielements["portalbutton"]:draw()
			
			properprint("mappack title:", 5*scale, 106*scale)
			properprint("author:", 5*scale, 131*scale)
			properprint("description:", 5*scale, 156*scale)
			guielements["edittitle"]:draw()
			guielements["editauthor"]:draw()
			guielements["editdescription"]:draw()
			guielements["savesettings"]:draw()
			
			properprint("lives:", 150*scale, 106*scale)
			guielements["livesincrease"]:draw()
			if mariolivecount == false then
				properprint("inf", 210*scale, 106*scale)
			else
				properprint(mariolivecount, 210*scale, 106*scale)
			end
			
			guielements["livesdecrease"]:draw()
		end
	end
end

function maintab()
	editorstate = "main"
	for i, v in pairs(guielements) do
		v.active = false
	end
	
	guielements["tabmain"].fillcolor = {0, 0, 0}
	guielements["tabtiles"].fillcolor = {63, 63, 63}
	guielements["tabtools"].fillcolor = {63, 63, 63}
	guielements["tabmaps"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	
	guielements["autoscrollcheckbox"].active = true
	guielements["backgrounddropdown"].active = true
	guielements["musicdropdown"].active = true
	guielements["spritesetdropdown"].active = true
	guielements["timelimitdecrease"].active = true
	guielements["timelimitincrease"].active = true
	guielements["mapwidthdecrease"].active = true
	guielements["mapwidthincrease"].active = true
	guielements["mapwidthapply"].active = true
	guielements["savebutton"].active = true
	guielements["menubutton"].active = true
	guielements["testbutton"].active = true
	guielements["intermissioncheckbox"].active = true
	guielements["warpzonecheckbox"].active = true
	guielements["underwatercheckbox"].active = true
	guielements["bonusstagecheckbox"].active = true
	guielements["custombackgroundcheckbox"].active = true
	guielements["scrollfactorscrollbar"].active = true
end

function tilestab()
	editorstate = "tiles"
	for i, v in pairs(guielements) do
		v.active = false
	end
	
	guielements["tabmain"].fillcolor = {63, 63, 63}
	guielements["tabtiles"].fillcolor = {0, 0, 0}
	guielements["tabtools"].fillcolor = {63, 63, 63}
	guielements["tabmaps"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	
	guielements["tilesscrollbar"].active = true
	
	guielements["tilesall"].active = true
	guielements["tilessmb"].active = true
	guielements["tilesportal"].active = true
	guielements["tilescustom"].active = true
	guielements["tilesentities"].active = true
	
end

function toolstab()
	editorstate = "tools"
	for i, v in pairs(guielements) do
		v.active = false
	end
	
	guielements["tabmain"].fillcolor = {63, 63, 63}
	guielements["tabtiles"].fillcolor = {63, 63, 63}
	guielements["tabtools"].fillcolor = {0, 0, 0}
	guielements["tabmaps"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	
	guielements["linkbutton"].active = true
	guielements["portalbutton"].active = true
	guielements["edittitle"].active = true
	guielements["editauthor"].active = true
	guielements["editdescription"].active = true
	guielements["savesettings"].active = true
	
	guielements["livesdecrease"].active = true
	guielements["livesincrease"].active = true
end

function mapstab()
	editorstate = "maps"
	for i, v in pairs(guielements) do
		v.active = false
	end
	
	guielements["tabmain"].fillcolor = {63, 63, 63}
	guielements["tabtiles"].fillcolor = {63, 63, 63}
	guielements["tabtools"].fillcolor = {63, 63, 63}
	guielements["tabmaps"].fillcolor = {0, 0, 0}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	guielements["savebutton2"].active = true
	
	for i = 1, 8 do --world
		for j = 1, 4 do --level
			for k = 0, 5 do --sublevel
				guielements[i .. "-" .. j .. "_" .. k].active = true
			end
		end
	end
end

function tilesall()
	guielements["tilesall"].textcolor = {255, 255, 255}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	tileliststart = 1
	tilelistcount = smbtilecount + portaltilecount + customtilecount -1
	
	tilescrollbarheight = math.max(0, math.ceil((smbtilecount + portaltilecount + customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
end

function tilessmb()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {255, 255, 255}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	tileliststart = 1
	tilelistcount = smbtilecount-1
	
	tilescrollbarheight = math.max(0, math.ceil((smbtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
end

function tilesportal()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {255, 255, 255}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	tileliststart = smbtilecount + 1
	tilelistcount = portaltilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((portaltilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
end

function tilescustom()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {255, 255, 255}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	tileliststart = smbtilecount + portaltilecount + 1
	tilelistcount = customtilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
end

function tilesentities()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {255, 255, 255}
	
	tilescrollbarheight = math.max(0, math.ceil((entitiescount)/22)*17 - 1 - (17*9) - 12)
	editentities = true
	
	if currenttile > entitiescount then
		currenttile = 1
	end
end

function placetile(x, y)
	local cox, coy = getMouseTile(x, y+8*scale)
	if inmap(cox, coy) == false then
		return
	end
	
	if editentities == false then
		if tilequads[currenttile].collision == true and tilequads[map[cox][coy][1]].collision == false then
			objects["tile"][cox .. "-" .. coy] = tile:new(cox-1, coy-1, 1, 1, true)
		elseif tilequads[currenttile].collision == false and tilequads[map[cox][coy][1]].collision == true then
			objects["tile"][cox .. "-" .. coy] = nil
		end
		if map[cox][coy][1] ~= currenttile then
			map[cox][coy][1] = currenttile
			map[cox][coy]["gels"] = {}
			generatespritebatch()
		end
		
		if currenttile == 136 then
			currenttile = 137
			placetile(x+16*scale, y)
			
			currenttile = 138
			placetile(x, y+16*scale)
			
			currenttile = 139
			placetile(x+16*scale, y+16*scale)
			
			currenttile = 136
		end
			
	else
		local t = map[cox][coy]
		if entityquads[currenttile].t == "remove" then --removing tile
			for i = 2, #map[cox][coy] do
				map[cox][coy][i] = nil
			end
		else
			map[cox][coy][2] = currenttile
			--check if tile has settable option, if so default to this.
			if rightclickvalues[entitylist[currenttile]] then
				map[cox][coy][3] = rightclickvalues[entitylist[currenttile]][2]
				for i = 4, #map[cox][coy] do
					map[cox][coy][i] = nil
				end
			else
				for i = 3, #map[cox][coy] do
					map[cox][coy][i] = nil
				end
			end
		end
	end
end

function editorclose()
	editormenuopen = false
	for i, v in pairs(guielements) do
		v.active = false
	end
end

function editoropen()
	for i = 1, players do
		objects["player"][i]:removeportals()
	end
	if editorstate == "linktool" or editorstate == "portalgun" then
		editorstate = "tools"
	end
	rightclickmenuopen = false
	editormenuopen = true
	targetmapwidth = mapwidth
	guielements["mapwidthincrease"].x = 282 + string.len(targetmapwidth)*8
	if mariolivecount == false then
		guielements["livesincrease"].x = 212 + 24
	else
		guielements["livesincrease"].x = 212 + string.len(mariolivecount)*8
	end
	guirepeattimer = 0
	getmaps()
	
	if editorstate == "main" then
		maintab()
	elseif editorstate == "tiles" then
		tilestab()
	elseif editorstate == "tools" then
		toolstab()
	elseif editorstate == "maps" then
		mapstab()
	end
end

function mapnumberclick(i, j, k)
	if editormode then
		marioworld = i
		mariolevel = j
		checkpointx = nil
		editorloadopen = true
		if k ~= 0 then
			startlevel(k)
		else
			startlevel(i .. "-" .. j)
		end
	end
end

function getmaps()
	existingmaps = {}
	for i = 1, 8 do --world
		existingmaps[i] = {}
		for j = 1, 4 do --level
			existingmaps[i][j] = {}
			for k = 0, 5 do --sublevel
				if k == 0 then
					guielements[i .. "-" .. j .. "_" .. k] = guielement:new("button", (i-1)*49 + (j-1)*11 + 6, 35, j, mapnumberclick, 0, {i, j, k})
				else
					guielements[i .. "-" .. j .. "_" .. k] = guielement:new("button", (i-1)*49 + (j-1)*11 + 6, k*11+40, k, mapnumberclick, 0, {i, j, k})
				end
				
				local s = i .. "-" .. j
				if k ~= 0 then
					s = s .. "_" .. k
				end
				s = s .. ".txt"
				if love.filesystem.exists("mappacks/" .. mappack .. "/" .. s) then
					existingmaps[i][j][k] = true
					guielements[i .. "-" .. j .. "_" .. k].fillcolor = {0, 150, 0}
				else
					guielements[i .. "-" .. j .. "_" .. k].fillcolor = {150, 0, 0}
				end
				
				if i == marioworld and j == mariolevel and k == mariosublevel then
					if existingmaps[i][j][k] == true  then
						guielements[i .. "-" .. j .. "_" .. k].textcolor = {0, 150, 0}
					else
						guielements[i .. "-" .. j .. "_" .. k].textcolor = {150, 0, 0}
					end
						
					guielements[i .. "-" .. j .. "_" .. k].bordercolor = {255, 255, 255}
					guielements[i .. "-" .. j .. "_" .. k].bordercolorhigh = {255, 255, 255}
					guielements[i .. "-" .. j .. "_" .. k].fillcolor = {255, 255, 255}
				end
			end
		end
	end
end

function editor_mousepressed(x, y, button)
	if rightclickmenuopen then
		rightclickmenu:click(x, y, button)
		rightclickmenuopen = false
		allowdrag = false
		return
	end

	if button == "l" then
		if editormenuopen == false then
			if editorstate == "linktool" then
				local tileX, tileY = getMouseTile(x, y+8*scale)
				local r = map[tileX][tileY]
				if #r > 1 then
					local tile = r[2]
					--LIST OF NUMBERS THAT ARE ACCEPT AS OUTPUT (doors, lights)
					if tablecontains( inputsi, r[2] ) then
						linktoolX, linktoolY = tileX, tileY
					end
				end
			elseif editorstate ~= "portalgun" then
				placetile(x, y)
			end
		else
			if editorstate == "tiles" then
				local tile = gettilelistpos(x, y)
				if editentities == false then
					if tile and tile <= tilelistcount+1 then
						currenttile = tile + tileliststart-1
						editorclose()
						allowdrag = false
					end
				else
					if tile and tile <= entitiescount then
						currenttile = tile
						editorclose()
						allowdrag = false
					end
				end
			elseif editorstate == "main" then
				if y >= minimapy*scale and y < (minimapy+34)*scale then
					if x >= minimapx*scale and x < (minimapx+394)*scale then
						minimapdragging = true
						toggleautoscroll(false)
					end
				end
			end
		end
	elseif button == "m" then
		local cox, coy = getMouseTile(x, y+8*scale)
		if inmap(cox, coy) == false then
			return
		end
		editentities = false
		tilesall()
		currenttile = map[cox][coy][1]
		
	elseif button == "wu" then
		if editormenuopen then
		else
			if currenttile > 1 then
				currenttile = currenttile - 1
			end
		end
		
	elseif button == "wd" then
		if editormenuopen then
		else
			if editentities then
				if currenttile < #entitylist then
					currenttile = currenttile + 1
				end
			else
				if currenttile < smbtilecount+portaltilecount+customtilecount then
					currenttile = currenttile + 1
				end
			end
		end
		
	elseif button == "r" then
		if editormenuopen == false then
			local tileX, tileY = getMouseTile(x, y+8*scale)
			if inmap(tileX, tileY) == false then
				return
			end
			
			local r = map[tileX][tileY]
			if #r > 1 then
				local tile = r[2]
				--LIST OF TILES THAT DO SHIT
				if rightclickvalues[entitylist[r[2]]] then
					rightclickmenuX = x
					rightclickmenuY = y
					rightclickmenucox = tileX
					rightclickmenucoy = tileY
					rightclickmenuopen = true
					rightclickmenutile = entitylist[r[2]]
					
					--create button
					--get width and start
					local width = 0
					local start
					for i = 1, #rightclickvalues[rightclickmenutile] do
						if string.len(rightclickvalues[rightclickmenutile][i]) > width then
							width = string.len(rightclickvalues[rightclickmenutile][i])
						end
						
						if rightclickvalues[rightclickmenutile][i] == r[3] then
							start = rightclickvalues[rightclickmenutile][i]
						end
					end
					
					rightclickmenu = guielement:new("rightclick", x/scale, y/scale, width, rightclickmenuclick, start, unpack(rightclickvalues[rightclickmenutile]))
				end
			else
				if editorstate ~= "portalgun" then
					local cox, coy = getMouseTile(x, y+8*scale)
					
					if objects["player"][1] then
						objects["player"][1].x = cox-1+2/16
						objects["player"][1].y = coy-objects["player"][1].height
					end
				end
			end
		else
			if editorstate == "main" then
				if y >= (minimapy+2)*scale and y < (minimapy+32)*scale then
					if x >= (minimapx+2)*scale and x < (minimapx+392)*scale then
						local x = math.floor((x-minimapx*scale+math.floor(minimapscroll*scale*2))/scale/2)
						local y = math.floor((y-minimapy*scale)/scale/2)
						
						if objects["player"][1] then
							objects["player"][1].x = x-1+2/16
							objects["player"][1].y = y-1+2/16
						end
					end
				end
			end
		end
	end
end

function rightclickmenuclick(i)
	if i > 1 then
		map[rightclickmenucox][rightclickmenucoy][3] = rightclickvalues[rightclickmenutile][i]
	end
end

function editor_mousereleased(x, y, button)
	if button == "l" then
		guirepeattimer = 0
		minimapdragging = false
		if editorstate == "linktool" then
			if linktoolX then
				local startx, starty = linktoolX, linktoolY
				local endx, endy = getMouseTile(x, y+8*scale)
				
				if startx ~= endx or starty ~= endy then
					local r = map[endx][endy]
					
					--LIST OF NUMBERS THAT ARE ACCEPTED AS INPUTS (buttons, laserdetectors)
					if #r > 1 and tablecontains( outputsi, r[2] ) then
						r = map[startx][starty]
						
						local i = 1
						while r[i] ~= "link" and i <= #r do
							i = i + 1
						end
						
						map[startx][starty][i] = "link"
						map[startx][starty][i+1] = endx
						map[startx][starty][i+2] = endy
					end
					
					linktoolX, linktoolY = nil, nil
					
					--Update links
					for i, v in pairs(objects) do
						for j, w in pairs(v) do
							if w.outtable then
								w.outtable = {}
							end
						end
					end
					
					for i, v in pairs(objects) do
						for j, w in pairs(v) do
							if w.link then
								w:link()
							end
						end
					end
				end
			end
		else
			allowdrag = true
		end
	end
end

function editor_keypressed(key)
	if key == "escape" then
		if editormenuopen then
			editorclose()
		else
			editoropen()
		end
	end
end

function toggleautoscroll(var)
	if var ~= nil then
		autoscroll = var
	else
		autoscroll = not autoscroll
	end
	guielements["autoscrollcheckbox"].var = autoscroll
end

function toggleintermission(var)
	if var ~= nil then
		intermission = var
	else
		intermission = not intermission
	end
	guielements["intermissioncheckbox"].var = intermission
end

function togglewarpzone(var)
	if var ~= nil then
		haswarpzone = var
	else
		haswarpzone = not haswarpzone
	end
	guielements["warpzonecheckbox"].var = haswarpzone
end

function toggleunderwater(var)
	if var ~= nil then
		underwater = var
	else
		underwater = not underwater
	end
	guielements["underwatercheckbox"].var = underwater
end

function togglebonusstage(var)
	if var ~= nil then
		bonusstage = var
	else
		bonusstage = not bonusstage
	end
	guielements["bonusstagecheckbox"].var = bonusstage
end

function togglecustombackground(var)
	if var ~= nil then
		custombackground = var
	else
		custombackground = not custombackground
	end
	
	if custombackground then
		loadcustombackground()
	end
	
	guielements["custombackgroundcheckbox"].var = custombackground
end

function changebackground(var)
	background = var
	guielements["backgrounddropdown"].var = var
	love.graphics.setBackgroundColor(backgroundcolor[var])
end

function changemusic(var)
	if musici == 7 and custommusic then
		music:stop(custommusic)
	elseif musici ~= 1 then
		music:stopIndex(musici-1)
	end
	musici = var
	if musici == 7 and custommusic then
		music:play(custommusic)
	elseif musici ~= 1 then
		music:playIndex(musici-1)
	end
	guielements["musicdropdown"].var = var
end

function changespriteset(var)
	spriteset = var
	guielements["spritesetdropdown"].var = var
end

function decreasetimelimit()
	mariotimelimit = mariotimelimit - 10
	if mariotimelimit < 0 then
		mariotimelimit = 0
	end
	mariotime = mariotimelimit
	guielements["timelimitincrease"].x = 31 + string.len(mariotimelimit)*8
end

function increasetimelimit()
	mariotimelimit = mariotimelimit + 10
	mariotime = mariotimelimit
	guielements["timelimitincrease"].x = 31 + string.len(mariotimelimit)*8
end

function applymapwidth()
	changemapwidth(targetmapwidth)
end

function linkbutton()
	editorstate = "linktool"
	editorclose()
end

function test_level()
	savelevel()
	editorclose()
	editormode = false
	testlevel = true
	testlevelworld = marioworld
	testlevellevel = mariolevel
	autoscroll = true
	checkpointx = false
	if mariosublevel ~= 0 then
		startlevel(marioworld .. "-" .. mariolevel .. "_" .. mariosublevel)
	else
		startlevel(marioworld .. "-" .. mariolevel)
	end
end

function portalbutton()
	editorstate = "portalgun"
	editorclose()
end

function gettilelistpos(x, y)
	if x >= 5*scale and y >= 38*scale and x < 378*scale and y < 203*scale then
		x = (x - 5*scale)/scale
		y = y + tilesoffset
		y = (y - 38*scale)/scale
		
		
		out = math.floor(x/17)+1
		out = out + math.floor(y/17)*22
		
		return out
	end
	
	return false
end

function savesettings()
	local s = ""
	s = s .. "name=" .. guielements["edittitle"].value .. "\n"
	s = s .. "author=" .. guielements["editauthor"].value .. "\n"
	s = s .. "description=" .. guielements["editdescription"].value .. "\n"
	if mariolivecount == false then
		s = s .. "lives=0\n"
	else
		s = s .. "lives=" .. mariolivecount .. "\n"
	end
	
	love.filesystem.mkdir( "mappacks" )
	love.filesystem.mkdir( "mappacks/" .. mappack )
	
	love.filesystem.write("mappacks/" .. mappack .. "/settings.txt", s)
end

function livesdecrease()
	if mariolivecount == false then
		return
	end
	
	mariolivecount = mariolivecount - 1
	if mariolivecount == 0 then
		mariolivecount = false
		guielements["livesincrease"].x = 212 + 24
	else
		guielements["livesincrease"].x = 212 + string.len(mariolivecount)*8
	end
end

function livesincrease()
	if mariolivecount == false then
		mariolivecount = 1
	else
		mariolivecount = mariolivecount + 1
	end
	guielements["livesincrease"].x = 212 + string.len(mariolivecount)*8
end

function updatescrollfactor()
	scrollfactor = round((guielements["scrollfactorscrollbar"].value*3)^2, 2)
end

function reversescrollfactor()
	return math.sqrt(scrollfactor)/3
end

function formatscrollnumber(i)
	if string.len(i) == 1 then
		return i .. ".00"
	elseif string.len(i) == 3 then
		return i .. "0"
	else
		return i
	end
end