function editor_load()
	currentanimation = 1
	tilecount1 = 168
	tilecount2 = 74
	
	tilesoffset = 0
	
	minimapscroll = 0
	minimapx = 3
	minimapy = 30
	minimapheight = 15
	
	currenttile = 1
	
	rightclicka = 0
	
	minimapscrollspeed = 30
	minimapdragging = false
	
	allowdrag = true
	
	animationguiarea =  {12, 33, 399, 212}
	animationlineinset = 14
	
	guielements["tabmain"] = guielement:new("button", 1, 1, "main", maintab, 3)
	guielements["tabmain"].fillcolor = {63, 63, 63}
	guielements["tabtiles"] = guielement:new("button", 43, 1, "tiles", tilestab, 3)
	guielements["tabtiles"].fillcolor = {63, 63, 63}
	guielements["tabtools"] = guielement:new("button", 93, 1, "tools", toolstab, 3)
	guielements["tabtools"].fillcolor = {63, 63, 63}
	guielements["tabmaps"] = guielement:new("button", 143, 1, "maps", mapstab, 3)
	guielements["tabmaps"].fillcolor = {63, 63, 63}
	guielements["tabanimations"] = guielement:new("button", 185, 1, "animations", animationstab, 3)
	guielements["tabanimations"].fillcolor = {63, 63, 63}
	
	--MAIN
	--left side
	guielements["colorsliderr"] = guielement:new("scrollbar", 17, 75, 101, 11, 11, background[1]/255, "hor")
	guielements["colorsliderr"].backgroundcolor = {255, 0, 0}
	guielements["colorsliderg"] = guielement:new("scrollbar", 17, 87, 101, 11, 11, background[2]/255, "hor")
	guielements["colorsliderg"].backgroundcolor = {0, 255, 0}
	guielements["colorsliderb"] = guielement:new("scrollbar", 17, 99, 101, 11, 11, background[3]/255, "hor")
	guielements["colorsliderb"].backgroundcolor = {0, 0, 255}
	
	for i = 1, 3 do
		guielements["defaultcolor" .. i] = guielement:new("button", 125, 63+i*12, "", defaultbackground, 0, {i}, 1, 8)
		guielements["defaultcolor" .. i].fillcolor = backgroundcolor[i]
	end
	
	local args = {unpack(musiclist)}
	local musici = 1
	for i = 1, #args do
		if args[i] == musicname then
			musici = i
		end
		args[i] = string.lower(string.sub(string.sub(args[i], 1, -5), 1, 11))
	end
	
	guielements["musicdropdown"] = guielement:new("dropdown", 17, 125, 11, changemusic, musici, unpack(args))
	guielements["spritesetdropdown"] = guielement:new("dropdown", 17, 150, 11, changespriteset, spriteset, "overworld", "underground", "castle", "underwater")
	guielements["timelimitdecrease"] = guielement:new("button", 17, 175, "{", decreasetimelimit, 0, nil, nil, nil, true)
	guielements["timelimitincrease"] = guielement:new("button", 31 + string.len(mariotimelimit)*8, 175, "}", increasetimelimit, 0, nil, nil, nil, true)
	
	local i = 1
	if portalsavailable[1] and not portalsavailable[2] then
		i = 2
	elseif not portalsavailable[1] and portalsavailable[2] then
		i = 3
	elseif not portalsavailable[1] and not portalsavailable[2] then
		i = 4
	end
	guielements["portalgundropdown"] = guielement:new("dropdown", 87, 187, 6, changeportalgun, i, "both", "blue", "orange", "none")
	
	--right side
	guielements["autoscrollcheckbox"] = guielement:new("checkbox", 291, 65, toggleautoscroll, autoscroll)
	
	guielements["intermissioncheckbox"] = guielement:new("checkbox", 200, 80, toggleintermission, intermission)
	guielements["warpzonecheckbox"] = guielement:new("checkbox", 200, 95, togglewarpzone, haswarpzone)
	guielements["underwatercheckbox"] = guielement:new("checkbox", 200, 110, toggleunderwater, underwater)
	guielements["bonusstagecheckbox"] = guielement:new("checkbox", 200, 125, togglebonusstage, bonusstage)
	guielements["custombackgroundcheckbox"] = guielement:new("checkbox", 200, 140, togglecustombackground, custombackground)
	guielements["customforegroundcheckbox"] = guielement:new("checkbox", 200, 170, togglecustomforeground, customforeground)
	
	--bottom
	guielements["savebutton"] = guielement:new("button", 10, 200, "save", savelevel, 2)
	guielements["menubutton"] = guielement:new("button", 54, 200, "return to menu", menu_load, 2)
	guielements["testbutton"] = guielement:new("button", 204, 200, "test level", test_level, 2)
	guielements["widthbutton"] = guielement:new("button", 296, 200, "change size", openchangewidth, 2)
	
	guielements["savebutton"].bordercolor = {255, 0, 0}
	guielements["savebutton"].bordercolorhigh = {255, 127, 127}
	
	--maybe I should use webkit next time
	--hahahahhahahaha no
	
	--mapsize stuff
	guielements["maptopup"] = guielement:new("button", 0, 0, "_dir4", changenewmapsize, nil, {"top", "up"}, nil, 8, 0.02)
	guielements["maptopdown"] = guielement:new("button", 0, 0, "_dir6", changenewmapsize, nil, {"top", "down"}, nil, 8, 0.02)
	guielements["mapleftleft"] = guielement:new("button", 0, 0, "_dir3", changenewmapsize, nil, {"left", "left"}, nil, 8, 0.02)
	guielements["mapleftright"] = guielement:new("button", 0, 0, "_dir5", changenewmapsize, nil, {"left", "right"}, nil, 8, 0.02)
	guielements["maprightleft"] = guielement:new("button", 0, 0, "_dir3", changenewmapsize, nil, {"right", "left"}, nil, 8, 0.02)
	guielements["maprightright"] = guielement:new("button", 0, 0, "_dir5", changenewmapsize, nil, {"right", "right"}, nil, 8, 0.02)
	guielements["mapbottomup"] = guielement:new("button", 0, 0, "_dir4", changenewmapsize, nil, {"bottom", "up"}, nil, 8, 0.02)
	guielements["mapbottomdown"] = guielement:new("button", 0, 0, "_dir6", changenewmapsize, nil, {"bottom", "down"}, nil, 8, 0.02)
	
	guielements["mapwidthapply"] = guielement:new("button", 0, 0, "apply", mapwidthapply, 3)
	guielements["mapwidthcancel"] = guielement:new("button", 0, 0, "cancel", mapwidthcancel, 3)
	
	local args = {unpack(custombackgrounds)}
	table.insert(args, 1, "default")
	
	local i = 1
	for j = 1, #custombackgrounds do
		if custombackground == custombackgrounds[j] then
			i = j+1
		end
	end
	
	guielements["backgrounddropdown"] = guielement:new("dropdown", 298, 139, 10, changebackground, i, unpack(args))
	
	local args = {unpack(custombackgrounds)}
	table.insert(args, 1, "none")
	
	local i = 1
	for j = 1, #custombackgrounds do
		if customforeground == custombackgrounds[j] then
			i = j+1
		end
	end
	
	guielements["foregrounddropdown"] = guielement:new("dropdown", 298, 169, 10, changeforeground, i, unpack(args))
	
	guielements["scrollfactorscrollbar"] = guielement:new("scrollbar", 298, 154, 93, 35, 11, reversescrollfactor(), "hor")
	guielements["fscrollfactorscrollbar"] = guielement:new("scrollbar", 298, 184, 93, 35, 11, reversefscrollfactor(), "hor")
	
	--TILES
	guielements["tilesall"] = guielement:new("button", 4, 20, "all", tilesall, 2) --72
	guielements["tilessmb"] = guielement:new("button", 37, 20, "smb", tilessmb, 2)
	guielements["tilesportal"] = guielement:new("button", 70, 20, "portal", tilesportal, 2)
	guielements["tilescustom"] = guielement:new("button", 127, 20, "custom", tilescustom, 2)
	guielements["tilesanimated"] = guielement:new("button", 184, 20, "animated", tilesanimated, 2)
	guielements["tilesentities"] = guielement:new("button", 257, 20, "entities", tilesentities, 2)
	guielements["tilesenemies"] = guielement:new("button", 330, 20, "enemies", tilesenemies, 2)
	
	guielements["tilesscrollbar"] = guielement:new("scrollbar", 381, 37, 167, 15, 40, 0, "ver", nil, nil, nil, nil, true)
	
	--TOOLS
	guielements["selectionbutton"] = guielement:new("button", 5, 22, "selection tool|click and drag to select entities|rightclick to configure all at once|hit del to delete.", selectionbutton, 2, false, 4, 383)
	guielements["selectionbutton"].bordercolor = {0, 255, 0}
	guielements["selectionbutton"].bordercolorhigh = {220, 255, 220}
	guielements["lightdrawbutton"] = guielement:new("button", 5, 71, "power line draw|click and drag to draw power lines", lightdrawbutton, 2, false, 2, 383)
	guielements["lightdrawbutton"].bordercolor = {0, 0, 255}
	guielements["lightdrawbutton"].bordercolorhigh = {127, 127, 255}
	
	guielements["livesdecrease"] = guielement:new("button", 198, 104, "{", livesdecrease, 0)
	guielements["livesincrease"] = guielement:new("button", 194, 104, "}", livesincrease, 0)
	
	--MAPS
	guielements["savebutton2"] = guielement:new("button", 10, 140, "save", savelevel, 2)
	guielements["savebutton2"].bordercolor = {255, 0, 0}
	guielements["savebutton2"].bordercolorhigh = {255, 127, 127}
	
	--ANIMATIONS
	guielements["animationsscrollbarver"] = guielement:new("scrollbar", animationguiarea[1]-10, animationguiarea[2], animationguiarea[4]-animationguiarea[2], 10, 40, 0, "ver", nil, nil, nil, nil, true)
	guielements["animationsscrollbarhor"] = guielement:new("scrollbar", animationguiarea[1], animationguiarea[4], animationguiarea[3]-animationguiarea[1], 40, 10, 0, "hor", nil, nil, nil, nil, false)
	
	local args = {}
	for i, v in ipairs(animations) do
		table.insert(args, string.sub(v.name, 1, -6))
	end
	guielements["animationselectdrop"] = guielement:new("dropdown", 3, 20, 15, selectanimation, 1, unpack(args))
	guielements["animationsavebutton"] = guielement:new("button", 138, 19, "save", saveanimation, 1)
	
	addanimationtriggerbutton = guielement:new("button", 0, 0, "+", addanimationtrigger, nil, nil, nil, 8)
	addanimationtriggerbutton.textcolor = {0, 200, 0}
	
	addanimationconditionbutton = guielement:new("button", 0, 0, "+", addanimationcondition, nil, nil, nil, 8)
	addanimationconditionbutton.textcolor = {0, 200, 0}
	
	addanimationactionbutton = guielement:new("button", 0, 0, "+", addanimationaction, nil, nil, nil, 8)
	addanimationactionbutton.textcolor = {0, 200, 0}
	
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

function editor_start()
	editormode = true
	players = 1
	playertype = "portal"
	playertypei = 1
	bullettime = false
	portalknockback = false
	bigmario = false
	goombaattack = false
	sonicrainboom = false
	playercollisions = false
	infinitetime = false
	infinitelives = false
	game_load()
end

function editor_update(dt)
	----------
	--EDITOR--
	----------
	if rightclickm then
		rightclickm:update(dt)
		if rightclicka < 1 then
			rightclicka = math.min(1, rightclicka + dt/linktoolfadeouttime)
		end
	elseif not rightclickactive then
		if rightclicka > 0 then
			rightclicka = math.max(0, rightclicka - dt/linktoolfadeouttime)
		end
	end
	
	if regiondragging then
		if regiondragging:update(dt) then
			regiondragging = nil
		end
		return
	end
	
	if changemapwidthmenu then
		return
	end
	
	if editormenuopen == false then
		--key scroll
		if love.keyboard.isDown("left") then
			autoscroll = false
			guielements["autoscrollcheckbox"].var = autoscroll
			xscroll = xscroll - 30*gdt
			if xscroll < 0 then
				xscroll = 0
			end
			generatespritebatch()
		elseif love.keyboard.isDown("right") then
			autoscroll = false
			guielements["autoscrollcheckbox"].var = autoscroll
			xscroll = xscroll + 30*gdt
			if xscroll > mapwidth-width then
				xscroll = mapwidth-width
			end
			generatespritebatch()
		end
		if love.keyboard.isDown("up") then
			autoscroll = false
			guielements["autoscrollcheckbox"].var = autoscroll
			yscroll = yscroll - 30*gdt
			if yscroll < 0 then
				yscroll = 0
			end
			generatespritebatch()
		elseif love.keyboard.isDown("down") then
			autoscroll = false
			guielements["autoscrollcheckbox"].var = autoscroll
			yscroll = yscroll + 30*gdt
			if yscroll > mapheight-height-1 then
				yscroll = mapheight-height-1
			end
			generatespritebatch()
		end
		
		if editorstate == "lightdraw" then
			if love.mouse.isDown("l") then
				local mousex, mousey = mouse.getPosition()
				local currentx, currenty = getMouseTile(mousex, mousey+8*scale)
				
				if lightdrawX and (currentx ~= lightdrawX or currenty ~= lightdrawY) then
					
					local xdir = 0
					if currentx > lightdrawX then
						xdir = 1
					elseif currentx < lightdrawX then
						xdir = -1
					end
					
					local ydir = 0
					if currenty > lightdrawY then
						ydir = 1
					elseif currenty < lightdrawY then
						ydir = -1
					end
					
					--fill in the gaps
					local x, y = lightdrawX, lightdrawY
					while x ~= currentx or y ~= currenty do
						if x ~= currentx then
							if x < currentx then
								x = x + 1
							else
								x = x - 1
							end
						else
							if y < currenty then
								y = y + 1
							else
								y = y - 1
							end
						end
						table.insert(lightdrawtable, {x=x,y=y})
					
						if #lightdrawtable >= 3 then
							local prevx, prevy = lightdrawtable[#lightdrawtable-2].x, lightdrawtable[#lightdrawtable-2].y
							local currx, curry = lightdrawtable[#lightdrawtable-1].x, lightdrawtable[#lightdrawtable-1].y
							local nextx, nexty = lightdrawtable[#lightdrawtable].x, lightdrawtable[#lightdrawtable].y
							
							local prev = "up"
							if prevx < currx then
								prev = "left"
							elseif prevx > currx then
								prev = "right"
							elseif prevy > curry then
								prev = "down"
							end
							
							local next = "up"
							if nextx < currx then
								next = "left"
							elseif nextx > currx then
								next = "right"
							elseif nexty > curry then
								next = "down"
							end
							
							local tile
							if (prev == "up" and next == "down") or (prev == "down" and next == "up") then
								tile = 43
							elseif (prev == "left" and next == "right") or (prev == "right" and next == "left") then
								tile = 44
							elseif (prev == "up" and next == "right") or (prev == "right" and next == "up") then
								tile = 45
							elseif (prev == "right" and next == "down") or (prev == "down" and next == "right") then
								tile = 46
							elseif (prev == "down" and next == "left") or (prev == "left" and next == "down") then
								tile = 47
							elseif (prev == "left" and next == "up") or (prev == "up" and next == "left") then
								tile = 48
							end
							
							placetile((currx-xscroll-.5)*16*scale, (curry-yscroll-1)*16*scale, tile, true)
						end
					end
					
					lightdrawX = currentx
					lightdrawY = currenty
				end
				
				return
			end
		end
		
		if rightclickactive or editorstate == "lightdraw" or editorstate == "selection" then
			return
		end
		
		if love.mouse.isDown("l") and allowdrag then
			local x, y = mouse.getPosition()
			placetile(x, y)
		end
	elseif editorstate == "main" then
		if love.mouse.isDown("l") then
			local mousex, mousey = mouse.getPosition()
			if mousey >= minimapy*scale and mousey < (minimapy+minimapheight*2+4)*scale then
				if mousex >= minimapx*scale and mousex < (minimapx+394)*scale then
					--HORIZONTAL
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
					
					--VERTICAL
					if mousey < (minimapy+5)*scale then
						if yscroll > 0 then
							yscroll = yscroll - minimapscrollspeed*dt
							if yscroll < 0 then
								yscroll = 0
							end
						end
					elseif mousey >= (minimapy+minimapheight*2+4-5)*scale then
						if yscroll < mapheight-height then
							yscroll = yscroll + minimapscrollspeed*dt
							if yscroll > mapheight-height-1 then
								yscroll = mapheight-height-1
							end
						end
					end
				
					xscroll = (mousex/scale-3-width) / 2 + minimapscroll
					
					if xscroll < minimapscroll then
						xscroll = minimapscroll
					end
					if xscroll > 170 + minimapscroll then
						xscroll = 170 + minimapscroll
					end
					if xscroll > mapwidth-width then
						xscroll = mapwidth-width
					end
	
					--SPRITEBATCH UPDATE
					if math.floor(xscroll) ~= spritebatchX[1] then
						generatespritebatch()
						spritebatchX[1] = math.floor(xscroll)
					elseif math.floor(yscroll) ~= spritebatchY[1] then
						generatespritebatch()
						spritebatchY[1] = math.floor(yscroll)
					end
				end
			end
			
			updatescrollfactor()
			updatefscrollfactor()
			updatebackground()
		end
	elseif editorstate == "tiles" then
		tilesoffset = guielements["tilesscrollbar"].value * tilescrollbarheight * scale
	end
	
	
	if animationguilines then
		for i, v in pairs(animationguilines) do
			for k, w in pairs(v) do
				w:update(dt)
			end
		end
	end
end

function editor_draw()	
	love.graphics.setColor(255, 255, 255)
	
	local mousex, mousey = mouse.getPosition()
	
	--EDITOR
	if editormenuopen == false then
		if editorstate == "selection" then
			if selectiondragging or selectionwidth then
				local x, y, width, height
				
				x, y = selectionx, selectiony
				if selectiondragging then
					width, height = mousex-selectionx, mousey-selectiony
				else
					width, height = selectionwidth, selectionheight
				end
				
				if width < 0 then
					x = x + width
					width = -width
				end
				if height < 0 then
					y = y + height
					height = -height
				end
				
				if selectiondragging then
					drawrectangle(x/scale, y/scale, width/scale, height/scale)
				end
				
				local selectionlist = selectiongettiles(x, y, width, height)
				
				love.graphics.setColor(255, 255, 255, 100)
				for i = 1, #selectionlist do
					local v = selectionlist[i]
					if map[v.x][v.y][2] and rightclickmenues[entitylist[map[v.x][v.y][2]]] then
						love.graphics.rectangle("fill", (v.x-xscroll-1)*16*scale, (v.y-yscroll-1.5)*16*scale, 16*scale, 16*scale)
					end
				end
			end
			
		elseif not rightclickactive and not rightclickm and editorstate ~= "lightdraw" and not regiondragging then
			local x, y = getMouseTile(mouse.getX(), mouse.getY()-8*scale)
			
			if inmap(x, y+1) then
				love.graphics.setColor(255, 255, 255, 200)
				if editentities == false then
					love.graphics.drawq(tilequads[currenttile].image, tilequads[currenttile].quad, math.floor((x-xscroll-1)*16*scale), math.floor(((y-yscroll-1)*16+8)*scale), 0, scale, scale)
				elseif editenemies == false then
					love.graphics.drawq(entityquads[currenttile].image, entityquads[currenttile].quad, math.floor((x-xscroll-1)*16*scale), math.floor(((y-yscroll-1)*16+8)*scale), 0, scale, scale)
				else
					local v = enemiesdata[currenttile]
					local xoff, yoff = (((v.spawnoffsetx or 0)+v.width/2-.5)*16 - v.offsetX + v.quadcenterX)*scale, (((v.spawnoffsety or 0)-v.height+1)*16-v.offsetY - v.quadcenterY)*scale
					love.graphics.drawq(v.graphic, v.quad, math.floor((x-xscroll-1)*16*scale+xoff), math.floor(((y-yscroll)*16)*scale+yoff), 0, scale, scale)
				end
			end
		end
		
		if rightclickactive and not regiondragging then
			local cox, coy = getMouseTile(mousex, mousey+8*scale)
			
			local table1 = {}
			for i, v in pairs(outputsi) do
				table.insert(table1, v)
			end
			
			for x = math.floor(xscroll), math.floor(xscroll)+width+1 do
				for y = math.floor(yscroll), math.floor(yscroll)+height+1 do
					for i, v in pairs(table1) do
						if inmap(x, y) and #map[x][y] > 1 and map[x][y][2] == v then							
							local r = map[x][y]
							local drawline = false
							
							if cox == x and coy == y and tablecontains(outputsi, map[x][y][2]) then
								love.graphics.setColor(255, 255, 150, 255)
							elseif tablecontains(outputsi, map[x][y][2]) then
								love.graphics.setColor(255, 255, 150, 150)
							end
							love.graphics.rectangle("fill", math.floor((x-xscroll-1)*16*scale), ((y-1-yscroll)*16-8)*scale, 16*scale, 16*scale)
						end
					end
				end
			end
		end
		
		if drawalllinks then
			local added = 0
			for x = 1, mapwidth do
				for y = 1, mapheight do
					local tx, ty = x, y
					local x1, y1
					local x2, y2
					
					x1, y1 = math.floor((tx-xscroll-.5)*16*scale), math.floor((ty-yscroll-1)*16*scale)
					
					local drawtable = {}
					
					for i = 1, #map[tx][ty] do
						if map[tx][ty][i] == "link" then
							x2, y2 = math.floor((map[tx][ty][i+2]-xscroll-.5)*16*scale), math.floor((map[tx][ty][i+3]-yscroll-1)*16*scale)
							
							local t = map[tx][ty][i+1]
							added = added + 0.2
							local color = getrainbowcolor(math.mod(added, 1))
							table.insert(drawtable, {x1, y1, x2, y2, t, color})
						end
					end
					
					table.sort(drawtable, function(a,b) return math.abs(a[3]-a[1])>math.abs(b[3]-b[1]) end)
					
					for i = 1, #drawtable do
						local x1, y1, x2, y2, t, c = unpack(drawtable[i])
						local r, g, b = unpack(c)
						love.graphics.setColor(r, g, b, math.max(0, (1-rightclicka)*255))
						
						if math.mod(i, 2) == 0 then
							drawlinkline2(x1, y1, x2, y2)
						else
							drawlinkline(x1, y1, x2, y2)
						end
						properprintbackground(t, math.floor(x2-string.len(t)*4*scale), y2+10*scale, true, {r, g, b, math.max(0, (1-rightclicka)*255)})
					end
				end
			end
		end
		
		if (rightclickactive or rightclickm) and editorstate ~= "lightdraw" or rightclicka > 0 then
			local tx, ty
			local x1, y1
			local x2, y2
			
			if rightclickm then
				tx = rightclickm.tx
				ty = rightclickm.ty
				x1, y1 = math.floor((tx-xscroll-.5)*16*scale), math.floor((ty-yscroll-1)*16*scale)
			else
				tx = linktoolX
				ty = linktoolY
				x1, y1 = math.floor((tx-xscroll-.5)*16*scale), math.floor((ty-yscroll-1)*16*scale)
			end
			
			local drawtable = {}
			
			for i = 1, #map[tx][ty] do
				if map[tx][ty][i] == "link" then
					x2, y2 = math.floor((map[tx][ty][i+2]-xscroll-.5)*16*scale), math.floor((map[tx][ty][i+3]-yscroll-1)*16*scale)
					
					local t = map[tx][ty][i+1]
					table.insert(drawtable, {x1, y1, x2, y2, t})
				end
			end
			
			table.sort(drawtable, function(a,b) return math.abs(a[3]-a[1])>math.abs(b[3]-b[1]) end)
			
			for i = 1, #drawtable do
				local x1, y1, x2, y2, t = unpack(drawtable[i])
				love.graphics.setColor(127, 127, 255*(i/#drawtable), 255*rightclicka)
				
				if math.mod(i, 2) == 0 then
					drawlinkline2(x1, y1, x2, y2)
				else
					drawlinkline(x1, y1, x2, y2)
				end
				
				properprintbackground(t, math.floor(x2-string.len(t)*4*scale), y2+10*scale, true, {0, 0, 0, 255*rightclicka})
			end
			
			if linktoolt then
				local x1, y1 = math.floor((linktoolX-xscroll-.5)*16*scale), math.floor((linktoolY-yscroll-1)*16*scale)
				local x2, y2 = mousex, mousey
				
				love.graphics.setColor(255, 172, 47, 255)
				
				drawlinkline(x1, y1, x2, y2)
				
				love.graphics.setColor(200, 140, 30, 255)
				
				love.graphics.draw(linktoolpointerimg, x2-math.ceil(scale/2), y2, 0, scale, scale, 3, 3)
				
				properprintbackground(linktoolt, math.floor(x2+4*scale), y2-4*scale, true)
			end
			
			--faithplate paths
			if entitylist[map[tx][ty][2]] == "faithplate" then
				local x = tx
				local y = ty-1
				local pointstable = {{x=x, y=y}}
				
				local speedx, speedy
				
				if rightclickm then
					speedx = rightclickm.t[2].value
					speedy = -rightclickm.t[4].value
				else
					speedx = tonumber(map[tx][ty][3])
					speedy = -tonumber(map[tx][ty][4])
				end
				
				local step = 1/60
				
				repeat
					x, y = x+speedx*step, y+speedy*step
					speedy = speedy + yacceleration*step
					table.insert(pointstable, {x=x, y=y})
				until y > yscroll+height+.5
				
				love.graphics.setColor(62, 213, 244, 150*rightclicka)
				for i = 1, #pointstable-1 do
					local v = pointstable[i]
					local w = pointstable[i+1]
					love.graphics.line((v.x-xscroll)*16*scale, (v.y-yscroll-.5)*16*scale, (w.x-xscroll)*16*scale, (w.y-yscroll-.5)*16*scale)
				end
			end
		end
		if rightclickm then
			rightclickm:draw()
		end
	else
		if changemapwidthmenu then
			local w = width*16-52
			local h = height*16-52
			
			local s = math.min(w/newmapwidth, h/newmapheight)
			
			w = newmapwidth*s
			h = newmapheight*s
			
			local mapx, mapy = (width*16 - w)/2, (height*16 - h)/2
			
			love.graphics.setColor(0, 0, 0, 200)
			love.graphics.rectangle("fill", (mapx-2)*scale, (mapy-2)*scale, (w+4)*scale, (h+4)*scale)
			
			
			--minimap
			for x = 1, mapwidth do
				for y = 1, mapheight do
					if x > -newmapoffsetx and x <= newmapwidth-newmapoffsetx and y > -newmapoffsety and y <= newmapheight-newmapoffsety then
						local id = map[x][y][1]
						if id ~= nil and rgblist[id] and id ~= 0 and tilequads[id].invisible == false then
							love.graphics.setColor(unpack(rgblist[id]))
							love.graphics.rectangle("fill", (mapx+(x-1+newmapoffsetx)*s)*scale, (mapy+(y-1+newmapoffsety)*s)*scale, s*scale, s*scale)
						end
					end
				end
			end
			
			love.graphics.setColor(255, 0, 0, 255)
			drawrectangle(mapx-1, mapy-1, w+2, h+2)
			
			love.graphics.setColor(255, 255, 255)
			properprintbackground("old width: " .. mapwidth, 26*scale, (mapy-21)*scale, true)
			properprintbackground("old height: " .. mapheight, 26*scale, (mapy-11)*scale, true)
			
			properprintbackground("new width: " .. newmapwidth, 26*scale, (mapy+h+4)*scale, true)
			properprintbackground("new height: " .. newmapheight, 26*scale, (mapy+h+14)*scale, true)
			
			--button positioning
			guielements["maptopup"].x, guielements["maptopup"].y = width*8-5, mapy-24
			guielements["maptopdown"].x, guielements["maptopdown"].y = width*8-5, mapy-13
			
			guielements["mapbottomup"].x, guielements["mapbottomup"].y = width*8-5, mapy+h+2
			guielements["mapbottomdown"].x, guielements["mapbottomdown"].y = width*8-5, mapy+h+13
			
			guielements["mapleftleft"].x, guielements["mapleftleft"].y = mapx-24, height*8-5
			guielements["mapleftright"].x, guielements["mapleftright"].y = mapx-13, height*8-5
			
			guielements["maprightleft"].x, guielements["maprightleft"].y = mapx+w+2, height*8-5
			guielements["maprightright"].x, guielements["maprightright"].y = mapx+w+13, height*8-5
			
			guielements["mapwidthapply"].x, guielements["mapwidthapply"].y = width*8+10, mapy+h+4
			guielements["mapwidthcancel"].x, guielements["mapwidthcancel"].y = width*8+65, mapy+h+4
		else
			if editorstate == "maps" then
				love.graphics.setColor(0, 0, 0, 100)
			else
				love.graphics.setColor(0, 0, 0, 230)
			end
			
			if minimapdragging == false then
				love.graphics.rectangle("fill", 1*scale, 18*scale, 398*scale, 205*scale)		
			else
				love.graphics.rectangle("fill", 1*scale, 18*scale, 398*scale, (27+minimapheight*2)*scale)
			end
			
			if editorstate == "tiles" then			
				--TILES
				love.graphics.setColor(255, 255, 255)
				
				drawrectangle(4, 37, 375, 167)
				
				love.graphics.setScissor(5*scale, 38*scale, 373*scale, 165*scale)
				
				if editentities == false then
					if animatedtilelist then
						for i = 1, tilelistcount+1 do
							love.graphics.drawq(tilequads[i+tileliststart-1+10000].image, tilequads[i+tileliststart-1+10000].quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
						end
					else
						for i = 1, tilelistcount+1 do
							love.graphics.drawq(tilequads[i+tileliststart-1].image, tilequads[i+tileliststart-1].quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
						end
					end
				else
					if not editenemies then
						for i = 1, #editorentitylist do
							love.graphics.drawq(entityquads[editorentitylist[i]].image, entityquads[editorentitylist[i]].quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
						end
					else
						for i = 1, #enemies do
							local v = enemiesdata[enemies[i]]
							love.graphics.setScissor(math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 16*scale, 16*scale)
							love.graphics.drawq(v.graphic, v.quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
							love.graphics.setScissor()
						end
					end
				end
				
				local tile = gettilelistpos(mouse.getX(), mouse.getY())
				if editentities == false then
					if tile and tile <= tilelistcount+1 then
						love.graphics.setColor(255, 255, 255, 127)
						love.graphics.rectangle("fill", (5+math.mod((tile-1), 22)*17)*scale, (38+math.floor((tile-1)/22)*17)*scale-tilesoffset, 16*scale, 16*scale)
					end
				elseif editenemies == false then
					if tile and tile <= entitiescount then
						love.graphics.setColor(255, 255, 255, 127)
						love.graphics.rectangle("fill", (5+math.mod((tile-1), 22)*17)*scale, (38+math.floor((tile-1)/22)*17)*scale-tilesoffset, 16*scale, 16*scale)
					end
				else
					if tile and tile <= #enemies then
						love.graphics.setColor(255, 255, 255, 127)
						love.graphics.rectangle("fill", (5+math.mod((tile-1), 22)*17)*scale, (38+math.floor((tile-1)/22)*17)*scale-tilesoffset, 16*scale, 16*scale)
					end
				end
				
				love.graphics.setScissor()
				
				love.graphics.setColor(255, 255, 255)
				if editentities then
					if editenemies then
						if enemies[tile] then
							properprint(enemies[tile], 3*scale, 205*scale)
						end
					else
						if entitydescriptions[editorentitylist[tile]] then
							local newstring = entitydescriptions[editorentitylist[tile]]
							if string.len(newstring) > 49 then
								newstring = string.sub(newstring, 1, 49) .. "|" .. string.sub(newstring, 50, 98)
							end
							properprint(newstring, 3*scale, 205*scale)
						end
					end
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
				love.graphics.rectangle("fill", minimapx*scale, minimapy*scale, 394*scale, minimapheight*2*scale+4*scale)
				love.graphics.setColor(unpack(background))
				love.graphics.rectangle("fill", (minimapx+2)*scale, (minimapy+2)*scale, 390*scale, minimapheight*2*scale)
				
				local lmap = map
				
				love.graphics.setScissor((minimapx+2)*scale, (minimapy+2)*scale, 390*scale, minimapheight*2*scale)
				
				for x = 1, mapwidth do --blocks
					for y = math.floor(yscroll)+1, math.min(mapheight, math.ceil(yscroll)+16) do
						if x-minimapscroll > 0 and x-minimapscroll < 196 then
							local id = lmap[x][y][1]
							if id ~= nil and id ~= 0 and tilequads[id].invisible == false then
								if rgblist[id] then
									love.graphics.setColor(unpack(rgblist[id]))
									love.graphics.rectangle("fill", (minimapx+x*2-minimapscroll*2)*scale, (minimapy+(y+1)*2-(math.floor(yscroll)+1)*2-math.mod(yscroll, 1)*2)*scale, 2*scale, 2*scale)
								end
							end
						end
					end
				end
				
				love.graphics.setScissor()
				
				love.graphics.setColor(255, 0, 0)
				drawrectangle(xscroll*2+minimapx-minimapscroll*2, minimapy, (width+2)*2, minimapheight*2+4)
				drawrectangle(xscroll*2+minimapx-minimapscroll*2+1, minimapy+1, (width+1)*2, minimapheight*2+2)
				love.graphics.setColor(255, 255, 255)
				properprint("follow mario", 301*scale, 66*scale)
				
				if minimapdragging == false then
					properprint("portalgun:", 8*scale, 189*scale)
					properprint(mariotimelimit, 29*scale, 177*scale)
					properprint("timelimit", 8*scale, 166*scale)
					properprint("spriteset", 8*scale, 141*scale)
					properprint("music", 8*scale, 116*scale)
					properprint("background color", 8*scale, 66*scale)
					
					if custombackground then
						love.graphics.setColor(255, 255, 255, 255)
					else
						love.graphics.setColor(150, 150, 150, 255)
					end
					properprint("scrollfactor", 199*scale, 156*scale)
					properprint(formatscrollnumber(scrollfactor), (guielements["scrollfactorscrollbar"].x+1+guielements["scrollfactorscrollbar"].xrange*guielements["scrollfactorscrollbar"].value)*scale, 156*scale)
					
					if customforeground then
						love.graphics.setColor(255, 255, 255, 255)
					else
						love.graphics.setColor(150, 150, 150, 255)
					end
					properprint("scrollfactor", 199*scale, 186*scale)
					properprint(formatscrollnumber(fscrollfactor), (guielements["fscrollfactorscrollbar"].x+1+guielements["fscrollfactorscrollbar"].xrange*guielements["fscrollfactorscrollbar"].value)*scale, 186*scale)
					
					
					love.graphics.setColor(255, 255, 255, 255)
						
					properprint("intermission", 210*scale, 81*scale)
					properprint("has warpzone", 210*scale, 96*scale)
					properprint("underwater", 210*scale, 111*scale)
					properprint("bonusstage", 210*scale, 126*scale)
					properprint("background:", 210*scale, 141*scale)
					properprint("foreground:", 210*scale, 171*scale)
				end
			elseif editorstate == "maps" then
				love.graphics.setColor(255, 255, 255)
				for i = 1, 8 do
					properprint("w" .. i, ((i-1)*49 + 19)*scale, 23*scale)
				end
				properprint("do not forget to save your current map before|changing!", 5*scale, 120*scale)
			elseif editorstate == "tools" then
				love.graphics.setColor(255, 255, 255)
				properprint("mappack title:", 5*scale, 106*scale)
				properprint("author:", 5*scale, 131*scale)
				properprint("description:", 5*scale, 156*scale)
				
				properprint("lives:", 150*scale, 106*scale)
				if mariolivecount == false then
					properprint("inf", 210*scale, 106*scale)
				else
					properprint(mariolivecount, 210*scale, 106*scale)
				end
			
			elseif editorstate == "animations" then
			
				love.graphics.setScissor(animationguiarea[1]*scale, animationguiarea[2]*scale, (animationguiarea[3]-animationguiarea[1])*scale, (animationguiarea[4]-animationguiarea[2])*scale)
				local completeheight = 14+#animationguilines.triggers*13+12+#animationguilines.conditions*13+12+#animationguilines.actions*13
				local offy = math.max(0, guielements["animationsscrollbarver"].value/1*(completeheight-(animationguiarea[4]-animationguiarea[2])))
				local completewidth = 0
				for i, v in pairs(animationguilines) do
					for k, w in pairs(v) do
						local width = 32+animationlineinset
						for j, z in pairs(w.elements) do
							width = width + w.elements[j].width
						end
						if width > completewidth then
							completewidth = width
						end
					end
				end
				
				local offx = -math.max(0, guielements["animationsscrollbarhor"].value/1*(completewidth-(animationguiarea[3]-animationguiarea[1])))
				
				love.graphics.setColor(255, 255, 255)
				
				local y = animationguiarea[2]+1-offy
				y = y + 2
				
				addanimationtriggerbutton.x = animationguiarea[1]+2+offx
				addanimationtriggerbutton.y = y-2
				addanimationtriggerbutton:draw()
				
				properprint("triggers:", (animationguiarea[1]+13+offx)*scale, y*scale)
				y = y + 10
				
				for i, v in pairs(animationguilines.triggers) do
					v:draw((animationguiarea[1]+animationlineinset+offx), y)
					y = y + 13
				end
				y = y + 2
				
				addanimationconditionbutton.x = animationguiarea[1]+2+offx
				addanimationconditionbutton.y = y-2
				addanimationconditionbutton:draw()
				
				properprint("conditions:", (animationguiarea[1]+13+offx)*scale, y*scale)
				y = y + 10
				
				for i, v in pairs(animationguilines.conditions) do
					v:draw((animationguiarea[1]+animationlineinset+offx), y)
					y = y + 13
				end
				y = y + 2
				
				addanimationactionbutton.x = animationguiarea[1]+2+offx
				addanimationactionbutton.y = y-2
				addanimationactionbutton:draw()
				
				properprint("actions:", (animationguiarea[1]+13+offx)*scale, y*scale)
				y = y + 10
				
				for i, v in pairs(animationguilines.actions) do
					v:draw((animationguiarea[1]+animationlineinset+offx), y)
					y = y + 13
				end
				
				for i, v in pairs(animationguilines) do
					for k, w in pairs(v) do
						for anotherletter, fuck in pairs(w.elements) do
							if fuck.gui and not fuck.gui.priority then
								fuck.gui:draw()
							end
						end
					end
				end
				
				love.graphics.setScissor()
				
				love.graphics.setColor(90, 90, 90)
				drawrectangle(animationguiarea[1]-10, animationguiarea[4], 10, 10)
			end
		end
	end
	
	if minimapdragging == false then
		--GUI not priority
		for i, v in pairs(guielements) do
			if not v.priority and v.active then
				v:draw()
			end
		end

		--GUI priority
		for i, v in pairs(guielements) do
			if v.priority and v.active then
				v:draw()
			end
		end
	else
		for i, v in pairs({"tabmain", "tabtiles", "tabtools", "tabmaps", "tabanimations", "autoscrollcheckbox"}) do
			guielements[v]:draw()
		end
	end
	
	if editorstate == "animations" and editormenuopen and not changemapwidthmenu then
		for i, v in pairs(animationguilines) do
			for k, w in pairs(v) do
				for anotherletter, fuck in pairs(w.elements) do
					if fuck.gui and fuck.gui.priority then
						fuck.gui:draw()
					end
				end
			end
		end
	end
	
	if regiondragging then
		regiondragging:draw()
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
	guielements["tabanimations"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	guielements["tabanimations"].active = true
	
	guielements["colorsliderr"].active = true
	guielements["colorsliderg"].active = true
	guielements["colorsliderb"].active = true
	guielements["defaultcolor1"].active = true
	guielements["defaultcolor2"].active = true
	guielements["defaultcolor3"].active = true
	
	guielements["autoscrollcheckbox"].active = true
	guielements["musicdropdown"].active = true
	guielements["spritesetdropdown"].active = true
	guielements["timelimitdecrease"].active = true
	guielements["timelimitincrease"].active = true
	guielements["portalgundropdown"].active = true
	guielements["savebutton"].active = true
	guielements["menubutton"].active = true
	guielements["testbutton"].active = true
	guielements["widthbutton"].active = true
	guielements["intermissioncheckbox"].active = true
	guielements["warpzonecheckbox"].active = true
	guielements["underwatercheckbox"].active = true
	guielements["bonusstagecheckbox"].active = true
	guielements["custombackgroundcheckbox"].active = true
	guielements["customforegroundcheckbox"].active = true
	guielements["scrollfactorscrollbar"].active = true
	guielements["fscrollfactorscrollbar"].active = true
	guielements["backgrounddropdown"].active = true
	guielements["foregrounddropdown"].active = true
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
	guielements["tabanimations"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	guielements["tabanimations"].active = true
	
	guielements["tilesscrollbar"].active = true
	
	guielements["tilesall"].active = true
	guielements["tilessmb"].active = true
	guielements["tilesportal"].active = true
	guielements["tilescustom"].active = true
	guielements["tilesanimated"].active = true
	guielements["tilesentities"].active = true
	guielements["tilesenemies"].active = true
	
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
	guielements["tabanimations"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	guielements["tabanimations"].active = true
	
	guielements["selectionbutton"].active = true
	guielements["lightdrawbutton"].active = true
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
	guielements["tabanimations"].fillcolor = {63, 63, 63}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	guielements["tabanimations"].active = true
	guielements["savebutton2"].active = true
	
	for i = 1, 8 do --world
		for j = 1, 4 do --level
			for k = 0, 5 do --sublevel
				guielements[i .. "-" .. j .. "_" .. k].active = true
			end
		end
	end
end

function animationstab()
	editorstate = "animations"
	for i, v in pairs(guielements) do
		v.active = false
	end
	
	guielements["tabmain"].fillcolor = {63, 63, 63}
	guielements["tabtiles"].fillcolor = {63, 63, 63}
	guielements["tabtools"].fillcolor = {63, 63, 63}
	guielements["tabmaps"].fillcolor = {63, 63, 63}
	guielements["tabanimations"].fillcolor = {0, 0, 0}
	guielements["tabmain"].active = true
	guielements["tabtiles"].active = true
	guielements["tabtools"].active = true
	guielements["tabmaps"].active = true
	guielements["tabanimations"].active = true
	
	guielements["animationsscrollbarver"].active = true
	guielements["animationsscrollbarhor"].active = true
	guielements["animationsavebutton"].active = true
	guielements["animationselectdrop"].active = true
	
	generateanimationgui()
end

function generateanimationgui()
	animationguilines = {}
	animationguilines.triggers = {}
	for i, v in pairs(animations[currentanimation].triggers) do
		table.insert(animationguilines.triggers, animationguiline:new(v, "trigger"))
	end
	animationguilines.conditions = {}
	for i, v in pairs(animations[currentanimation].conditions) do
		table.insert(animationguilines.conditions, animationguiline:new(v, "condition"))
	end
	animationguilines.actions = {}
	for i, v in pairs(animations[currentanimation].actions) do
		table.insert(animationguilines.actions, animationguiline:new(v, "action"))
	end
end
	
function deleteanimationguiline(t, tabl)
	for i, v in ipairs(animationguilines[t .. "s"]) do
		if v == tabl then
			table.remove(animationguilines[t .. "s"], i)
		end
	end
end

function movedownanimationguiline(t, tabl)
	for i, v in ipairs(animationguilines[t .. "s"]) do
		if v == tabl then
			if i ~= #animationguilines[t .. "s"] then
				animationguilines[t .. "s"][i], animationguilines[t .. "s"][i+1] = animationguilines[t .. "s"][i+1], animationguilines[t .. "s"][i]
				break
			end
		end
	end
end

function moveupanimationguiline(t, tabl)
	for i, v in ipairs(animationguilines[t .. "s"]) do
		if v == tabl then
			if i ~= 1 then
				animationguilines[t .. "s"][i], animationguilines[t .. "s"][i-1] = animationguilines[t .. "s"][i-1], animationguilines[t .. "s"][i]
				break
			end
		end
	end
end

function selectanimation(i)
	guielements["animationselectdrop"].var = i
	
	saveanimation()
	currentanimation = i
	generateanimationgui()
end

function saveanimation()
	local out = {}
	
	local typelist = {"triggers", "conditions", "actions"}
	for h, w in ipairs(typelist) do
		out[w] = {}
		for i, v in ipairs(animationguilines[w]) do
			out[w][i] = {}
			for j, k in ipairs(v.elements) do
				if k.gui then
					local val = ""
					if k.gui.type == "dropdown" then
						if j == 1 then
							--find normal name
							for l, m in pairs(animationlist) do
								if m.nicename == k.gui.entries[k.gui.var] then
									val = l
									break
								end
							end
						else
							val = k.gui.entries[k.gui.var]
						end
					elseif k.gui.type == "input" then
						val = k.gui.value
					end
					
					table.insert(out[w][i], val)
				end
			end
		end
	end
	
	print_r(out)
	local json = JSON:encode_pretty(out)
	print(json)
	love.filesystem.write(animations[currentanimation].filepath, json)
end

function addanimationtrigger()
	table.insert(animationguilines.triggers, animationguiline:new({}, "trigger"))
end

function addanimationcondition()
	table.insert(animationguilines.conditions, animationguiline:new({}, "condition"))
end

function addanimationaction()
	table.insert(animationguilines.actions, animationguiline:new({}, "action"))
end

function openchangewidth()
	for i, v in pairs(guielements) do
		v.active = false
	end
	
	guielements["maptopup"].active = true
	guielements["maptopdown"].active = true
	guielements["mapbottomup"].active = true
	guielements["mapbottomdown"].active = true
	guielements["mapleftleft"].active = true
	guielements["mapleftright"].active = true
	guielements["maprightleft"].active = true
	guielements["maprightright"].active = true
	guielements["mapwidthapply"].active = true
	guielements["mapwidthcancel"].active = true

	changemapwidthmenu = true
	newmapwidth = mapwidth
	newmapheight = mapheight
	newmapoffsetx = 0
	newmapoffsety = 0
end

function mapwidthapply()
	changemapwidthmenu = false
	objects["tile"] = {}
	
	local newmap = {}
	for x = 1, newmapwidth do
		newmap[x] = {}
		for y = 1, newmapheight do
			local oldx, oldy = x-newmapoffsetx, y-newmapoffsety
			if inmap(oldx, oldy) then
				newmap[x][y] = map[oldx][oldy]
			else
				newmap[x][y] = {1, gels={}, portaloverride={}}
			end
			
			if tilequads[newmap[x][y][1]].collision then
				objects["tile"][x .. "-" .. y] = tile:new(x-1, y-1, 1, 1, true)
			end
		end
	end
	
	objects["player"][1].x = objects["player"][1].x + newmapoffsetx
	objects["player"][1].y = objects["player"][1].y + newmapoffsety
	
	xscroll = xscroll + newmapoffsetx
	yscroll = yscroll + newmapoffsety
	
	if xscroll < 0 then
		xscroll = 0
	end
	
	if xscroll > mapwidth-width then
		xscroll = math.max(0, mapwidth-width)
		hitrightside()
	end
	
	map = newmap
	mapwidth = newmapwidth
	mapheight = newmapheight
	
	objects["screenboundary"]["right"].x = mapwidth
	generatespritebatch()
	
	editorclose()
	--maintab()
end

function mapwidthcancel()
	changemapwidthmenu = false
	editorclose()
	--maintab()
end

function changenewmapsize(side, dir)
	if side == "top" then
		if dir == "up" then
			newmapheight = newmapheight + 1
			newmapoffsety = newmapoffsety + 1
		else
			if newmapheight > 15 then
				newmapheight = newmapheight - 1
				newmapoffsety = newmapoffsety - 1
			end
		end
	elseif side == "bottom" then
		if dir == "up" then
			if newmapheight > 15 then
				newmapheight = newmapheight - 1
			end
		else
			newmapheight = newmapheight + 1
		end
	elseif side == "left" then
		if dir == "left" then
			newmapwidth = newmapwidth + 1
			newmapoffsetx = newmapoffsetx + 1
		else
			if newmapwidth > 1 then
				newmapwidth = newmapwidth - 1
				newmapoffsetx = newmapoffsetx - 1
			end
		end
	elseif side == "right" then
		if dir == "left" then
			if newmapwidth > 1 then
				newmapwidth = newmapwidth - 1
			end
		else
			newmapwidth = newmapwidth + 1
		end
	end
end

function tilesall()
	guielements["tilesall"].textcolor = {255, 255, 255}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	guielements["tilesenemies"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
	tileliststart = 1
	tilelistcount = smbtilecount + portaltilecount + customtilecount -1
	
	tilescrollbarheight = math.max(0, math.ceil((smbtilecount + portaltilecount + customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
	editenemies = false
end

function tilessmb()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {255, 255, 255}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	guielements["tilesenemies"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
	tileliststart = 1
	tilelistcount = smbtilecount-1
	
	tilescrollbarheight = math.max(0, math.ceil((smbtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
	editenemies = false
end

function tilesportal()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {255, 255, 255}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	guielements["tilesenemies"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
	tileliststart = smbtilecount + 1
	tilelistcount = portaltilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((portaltilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
	editenemies = false
end

function tilescustom()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {255, 255, 255}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	guielements["tilesenemies"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
	tileliststart = smbtilecount + portaltilecount + 1
	tilelistcount = customtilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
	editenemies = false
end

function tilesanimated()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {255, 255, 255}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	guielements["tilesenemies"].textcolor = {127, 127, 127}
	
	animatedtilelist = true
	tileliststart = 1
	tilelistcount = animatedtilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
	editenemies = false
end

function tilesentities()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {255, 255, 255}
	guielements["tilesenemies"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
	tilescrollbarheight = math.max(0, math.ceil((entitiescount)/22)*17 - 1 - (17*9) - 12)
	editentities = true
	editenemies = false
	
	currenttile = 1
end

function tilesenemies()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	guielements["tilesenemies"].textcolor = {255, 255, 255}
	
	animatedtilelist = false
	tilescrollbarheight = math.max(0, math.ceil((#enemiesdata)/22)*17 - 1 - (17*9) - 12)
	editentities = true
	editenemies = true
	
	currenttile = enemies[1]
end

function placetile(x, y, t, ent)
	local editentities = ent or editentities
	local currenttile = t or currenttile
	local cox, coy = getMouseTile(x, y+8*scale)
	if inmap(cox, coy) == false then
		return
	end
	
	if editentities == false then
		if tilequads[currenttile].coin then
			coinmap[cox][coy] = not editorcoinstart
			return
		end
	
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
			placetile(x+16*scale, y, 137)
			placetile(x, y+16*scale, 138)
			placetile(x+16*scale, y+16*scale, 139)
		end
		
	else
		local t = map[cox][coy]
		if editenemies == false and entityquads[currenttile].t == "remove" then --removing tile
			for i = 2, #map[cox][coy] do
				map[cox][coy][i] = nil
			end
		else
			for i = 3, #map[cox][coy] do
				map[cox][coy][i] = nil
			end
			
			map[cox][coy][2] = currenttile
			
			if editenemies == false then
				if rightclickmenues[entitylist[currenttile]] then
					for i = 1, #rightclickmenues[entitylist[currenttile]] do
						local v = rightclickmenues[entitylist[currenttile]][i]
						if tablecontains(rightclickelementslist, v.t) then
							if v.default then
								table.insert(map[cox][coy], v.default)
							else
								table.insert(map[cox][coy], "nil")
							end
						end
					end
				end
			else --Enemy rightclick menu?
			
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
	if editorstate == "lightdraw" or editorstate == "selection" then
		editorstate = "tools"
	end
	closerightclickmenu()
	finishregion()
	editormenuopen = true
	
	if mariolivecount == false then
		guielements["livesincrease"].x = 212 + 24
	else
		guielements["livesincrease"].x = 212 + string.len(mariolivecount)*8
	end
	guirepeattimer = 0
	getmaps()
	
	selectionx, selectiony, selectionwidth, selectionheight = nil, nil, nil, nil
	
	if editorstate == "main" then
		maintab()
	elseif editorstate == "tiles" then
		tilestab()
	elseif editorstate == "tools" then
		toolstab()
	elseif editorstate == "maps" then
		mapstab()
	elseif editorstate == "animations" then
		animationstab()
	end
end

function mapnumberclick(i, j, k)
	if editormode then
		marioworld = i
		mariolevel = j
		editorloadopen = true
		if k ~= 0 then
			loadlevel(k)
		else
			loadlevel(i .. "-" .. j)
		end
		startlevel()
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
	if regiondragging then
		if regiondragging:mousepressed(x, y, button) then
			finishregion()
		end
		return
	end
	
	if rightclickm then
		allowdrag = false
		if button == "r" or not rightclickm:mousepressed(x, y, button) then
			closerightclickmenu()
			return
		else
			return
		end
	end
	
	if animationguilines and editormenuopen and not changemapwidthmenu and not guielements["animationselectdrop"].extended then
		local b = false
		for i, v in pairs(animationguilines) do
			for k, w in pairs(v) do
				if w:haspriority() then
					w:click(x, y, button)
					b = true
					break
				end
			end
			if b then
				break
			end
		end
		
		if not b then
			if x >= animationguiarea[1]*scale and y >= animationguiarea[2]*scale and x < animationguiarea[3]*scale and y < animationguiarea[4]*scale then
				addanimationtriggerbutton:click(x, y, button)
				addanimationconditionbutton:click(x, y, button)
				addanimationactionbutton:click(x, y, button)
				
				for i, v in pairs(animationguilines) do
					for k, w in pairs(v) do						
						if w:click(x, y, button) then
							b = true
							break
						end
					end
					if b then
						break
					end
				end
			end
		end
	end
	
	if changemapwidthmenu then
		return
	end
	
	if button == "l" then
		if editormenuopen == false then
			if editorstate == "lightdraw" then
				lightdrawX, lightdrawY = getMouseTile(x, y+8*scale)
				lightdrawtable = {{x=lightdrawX, y=lightdrawY}}
			elseif rightclickactive then
				finishlinking(x, y)
			elseif editorstate == "selection" then
				selectionstart()
			else
				local cox, coy = getMouseTile(x, y+8*scale)
				if coinmap[cox][coy] then
					editorcoinstart = true
				else
					editorcoinstart = false
				end
				
				placetile(x, y)
			end
		else
			if editorstate == "tiles" then
				local tile = gettilelistpos(x, y)
				if editentities == false then
					if tile and tile <= tilelistcount+1 then
						if animatedtilelist then
							currenttile = tile + tileliststart-1+10000
						else
							currenttile = tile + tileliststart-1
						end
						
						editorclose()
						allowdrag = false
					end
				else
					if editenemies then
						if tile and tile <= #enemies then
							currenttile = enemies[tile]
							editorclose()
							allowdrag = false
						end
					else
						if tile and tile <= entitiescount then
							currenttile = editorentitylist[tile]
							editorclose()
							allowdrag = false
						end
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
		if not editormenuopen and not editentities and not animatedtilelist then
			if currenttile > 1 then
				currenttile = currenttile - 1
			end
		end
		
	elseif button == "wd" then
		if not editormenuopen and not editentities and not animatedtilelist then
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
			
			if editorstate ~= "lightdraw" then
				local r = map[tileX][tileY]
				if #r > 1 then
					local tile = r[2]
					if rightclickmenues[entitylist[tile]] then
						local tileX, tileY = getMouseTile(x, y+8*scale)
						rightclickm = rightclickmenu:new(x/scale, y/scale, rightclickmenues[entitylist[r[2]]], tileX, tileY)
						rightclickactive = false
						linktoolfadeouttime = linktoolfadeouttimefast
						linktoolX, linktoolY = tileX, tileY
					end
				else
					local cox, coy = getMouseTile(x, y+8*scale)
					
					if objects["player"][1] and not objects["player"][1].vine then
						objects["player"][1].x = cox-1+2/16
						objects["player"][1].y = coy-objects["player"][1].height
						objects["player"][1].vine = false
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

function editor_mousereleased(x, y, button)
	if regiondragging then
		if regiondragging:mousereleased(x, y, button) then
			regiondragging = nil
		end
		return
	end
	
	if button == "l" then
		if selectiondragging then
			selectionend()
		end
			
		if rightclickm then
			rightclickm:mousereleased(x, y, button)
		end
		guirepeattimer = 0
		minimapdragging = false
	end
	allowdrag = true
	
	if animationguilines and editormenuopen and not changemapwidthmenu then
		for i, v in pairs(animationguilines) do
			for k, w in pairs(v) do					
				w:unclick(x, y, button)
			end
		end
	end
end

function editor_keypressed(key, unicode)
	if selectionwidth then
		if key == "delete" then
			local x, y = round(selectionx/scale), round(selectiony/scale)
			local width, height = round(selectionwidth/scale), round(selectionheight/scale)
			
			local selectionlist = selectiongettiles(selectionx, selectiony, selectionwidth, selectionheight)
			
			for i = 1, #selectionlist do
				for j = 2, #map[selectionlist[i].x][selectionlist[i].y] do
					map[selectionlist[i].x][selectionlist[i].y][j] = nil
				end
			end
		end
	end
	
	if rightclickm then
		rightclickm:keypressed(key, unicode)
	end
	
	if animationguilines then
		for i, v in pairs(animationguilines) do
			for k, w in pairs(v) do
				w:keypressed(unicode and string.lower(unicode) or "", key)
			end
		end
	end
	
	if key == "escape" then
		if rightclickm then
			closerightclickmenu()
		else
			if editormenuopen then
				editorclose()
			else
				editoropen()
			end
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
	if custombackground then
		custombackground = false
	else
		custombackground = custombackgrounds[guielements["backgrounddropdown"].var-1]
		if custombackground == nil then
			custombackground = true
		end
	end
	
	guielements["custombackgroundcheckbox"].var = custombackground ~= false
end

function togglecustomforeground(var)
	if customforeground then
		customforeground = false
	else
		customforeground = custombackgrounds[guielements["foregrounddropdown"].var-1]
		if customforeground == nil then
			customforeground = true
		end
	end
	
	guielements["customforegroundcheckbox"].var = customforeground ~= false
end

function changebackground(var)
	guielements["backgrounddropdown"].var = var
	if custombackground then
		custombackground = custombackgrounds[guielements["backgrounddropdown"].var-1]
		if custombackground == nil then
			custombackground = true
		end
	end	
end

function changeforeground(var)
	guielements["foregrounddropdown"].var = var
	if customforeground then
		customforeground = custombackgrounds[guielements["foregrounddropdown"].var-1]
		if customforeground == nil then
			customforeground = true
		end
	end	
end

function changeportalgun(var)
	if var == 1 then
		portalsavailable = {true, true}
	elseif var == 2 then
		portalsavailable = {true, false}
	elseif var == 3 then
		portalsavailable = {false, true}
	elseif var == 4 then
		portalsavailable = {false, false}
	end
	guielements["portalgundropdown"].var = var
end

function changemusic(var)
	stopmusic()
	musicname = musiclist[var]
	
	if var == 1 then
		musicname = nil
	end
	
	playmusic()
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

function test_level()
	savelevel()
	editorclose()
	editormode = false
	testlevel = true
	testlevelworld = marioworld
	testlevellevel = mariolevel
	autoscroll = true
	if mariosublevel ~= 0 then
		loadlevel(marioworld .. "-" .. mariolevel .. "_" .. mariosublevel)
	else
		loadlevel(marioworld .. "-" .. mariolevel)
	end
	startlevel()
end

function lightdrawbutton()
	editorstate = "lightdraw"
	lightdrawX = nil
	lightdrawY = nil
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

function defaultbackground(i)
	background = {unpack(backgroundcolor[i])}
	love.graphics.setBackgroundColor(unpack(background))
	
	guielements["colorsliderr"].value = background[1]/255
	guielements["colorsliderg"].value = background[2]/255
	guielements["colorsliderb"].value = background[3]/255
end

function updatebackground()
	background[1] = guielements["colorsliderr"].value*255
	background[2] = guielements["colorsliderg"].value*255
	background[3] = guielements["colorsliderb"].value*255
	love.graphics.setBackgroundColor(unpack(background))
end

function updatescrollfactor()
	scrollfactor = round((guielements["scrollfactorscrollbar"].value*3)^2, 2)
end

function updatefscrollfactor()
	fscrollfactor = round((guielements["fscrollfactorscrollbar"].value*3)^2, 2)
end

function reversescrollfactor()
	return math.sqrt(scrollfactor)/3
end

function reversefscrollfactor()
	return math.sqrt(fscrollfactor)/3
end

function formatscrollnumber(i)
	if i < 0 then
		i = round(i, 1)
	else
		i = round(i, 2)
	end
	
	if string.len(i) == 1 then
		i = i .. ".00"
	elseif string.len(i) == 3 and math.abs(i) < 10 then
		i = i .. "0"
	end
	
	if string.sub(i, 4, 4) == "." then
		return string.sub(i, 1, 3)
	else
		return string.sub(i, 1, 4)
	end
end

function closerightclickmenu()
	if rightclickm then
		local edittable = {{x=rightclickm.tx, y=rightclickm.ty}}
		
		if selectionwidth then
			local selectionlist = selectiongettiles(selectionx, selectiony, selectionwidth, selectionheight)
			
			for i = 1, #selectionlist do
				local v = selectionlist[i]
				
				if (map[v.x][v.y][2] == map[rightclickm.tx][rightclickm.ty][2] or (tablecontains(groundlighttable, entitylist[map[rightclickm.tx][rightclickm.ty][2]]) and tablecontains(groundlighttable, entitylist[map[v.x][v.y][2]]))) and (v.x ~= rightclickm.tx or v.y ~= rightclickm.ty) then
					table.insert(edittable, {x=v.x, y=v.y})
				end
			end
		end
		
		for i = 1, #edittable do
			local x, y = edittable[i].x, edittable[i].y
			
			--remove all values until link or region
			while map[x][y][3] and map[x][y][3] ~= "link" and tostring(map[x][y][3]):split(":")[1] ~= "region" do
				table.remove(map[x][y], 3)
			end
			
			--add values to link
			for i = #rightclickm.variables, 1, -1 do
				local v = rightclickm.variables[i]
				local value
				
				if v.t == "scrollbar" then
					value = rightclickm.t[i].value
				elseif v.t == "checkbox" then
					value = tostring(rightclickm.t[i].var)
				elseif v.t == "directionbuttons" then
					value = v.value
				elseif v.t == "submenu" then
					if rightclickm.t[i].actualvalue then
						value = rightclickm.t[i].entries[rightclickm.t[i].value]
					else
						value = rightclickm.t[i].value
					end
				elseif v.t == "input" then
					value = rightclickm.t[i].value
				end
				
				if value then
					table.insert(map[x][y], 3, value)
				end
			end
		end
		
		rightclickm = nil
	end
end

function startlinking(x, y, t)
	rightclickactive = true
	linktoolX = x
	linktoolY = y
	linktoolt = t
	rightclicka = 1
	
	closerightclickmenu()
end

function startregion(x, y, t)
	rightclickactive = true
	regiontoolX = x
	regiontoolY = y
	regiontoolt = t
	rightclicka = 1
	
	--get width n shit
	
	local j
	
	for i = 3, #map[x][y] do
		local s = tostring(map[x][y][i]):split(":")
		if s[1] == t then
			j = i
			break
		end
	end
	
	if j then
		local s = map[x][y][j]:split(":")
		
		local rx, ry = s[2], s[3]
		
		if string.sub(rx, 1, 1) == "m" then
			rx = -tonumber(string.sub(rx, 2))
		end
		if string.sub(ry, 1, 1) == "m" then
			ry = -tonumber(string.sub(ry, 2))
		end
		regiondragging = regiondrag:new(x+rx, y+ry, s[4], s[5])
	else
		print("Error! Unknown t :(")
	end
	
	closerightclickmenu()
end

function finishregion()
	if regiondragging then
		local t = regiontoolt
		local x, y = regiontoolX, regiontoolY
		
		local j
		
		for i = 3, #map[x][y] do
			local s = tostring(map[x][y][i]):split(":")
			if s[1] == t then
				j = i
				break
			end
		end
		
		local rx, ry = regiondragging.x-x+1, regiondragging.y-y+1
		
		if rx < 0 then
			rx = "m" .. -rx
		end
		
		if ry < 0 then
			ry = "m" .. -ry
		end
		
		map[x][y][j] = t .. ":" .. rx .. ":" .. ry .. ":" .. regiondragging.width .. ":" .. regiondragging.height
		
		regiondragging = nil
		rightclickactive = false
	end
end

function removelink(x, y, t)
	local edittable = {{x=x, y=y}}
	
	if selectionwidth then
		local selectionlist = selectiongettiles(selectionx, selectiony, selectionwidth, selectionheight)
		
		for i = 1, #selectionlist do
			local v = selectionlist[i]
			if (map[v.x][v.y][2] == map[x][y][2] or (tablecontains(groundlighttable, entitylist[map[v.x][v.y][2]]) and tablecontains(groundlighttable, entitylist[map[x][y][2]]))) and (v.x ~= x or v.y ~= y) then
				table.insert(edittable, {x=v.x, y=v.y})
			end
		end
	end
	
	for j = 1, #edittable do
		local cx, cy = edittable[j].x, edittable[j].y
		
		local r = map[cx][cy]
		local i = 1
		
		while (r[i] ~= "link" or tostring(r[i+1]) ~= tostring(t)) and i < #r do
			i = i + 1
		end
		
		if i < #r then --found a match
			table.remove(map[cx][cy], i)
			table.remove(map[cx][cy], i)
			table.remove(map[cx][cy], i)
			table.remove(map[cx][cy], i)
		end
	end
end

function finishlinking(x, y)
	if rightclickactive then
		local startx, starty = linktoolX, linktoolY
		local endx, endy = getMouseTile(x, y+8*scale)
		
		local edittable = {{x=startx, y=starty}}
		
		if selectionwidth then
			local selectionlist = selectiongettiles(selectionx, selectiony, selectionwidth, selectionheight)
			
			for i = 1, #selectionlist do
				local v = selectionlist[i]
				if (map[v.x][v.y][2] == map[startx][starty][2] or (tablecontains(groundlighttable, entitylist[map[v.x][v.y][2]]) and tablecontains(groundlighttable, entitylist[map[startx][starty][2]]))) and (v.x ~= startx or v.y ~= starty) then
					table.insert(edittable, {x=v.x, y=v.y})
				end
			end
		end
		
		
		for i = 1, #edittable do
			local x, y = edittable[i].x, edittable[i].y
			if x ~= endx or y ~= endy then
				local r = map[endx][endy]
				
				--LIST OF NUMBERS THAT ARE ACCEPTED AS INPUTS (buttons, laserdetectors)
				if #r > 1 and tablecontains( outputsi, r[2] ) then
					r = map[x][y]
					
					local i = 1
					while (r[i] ~= "link" or r[i+1] ~= linktoolt) and i <= #r do
						i = i + 1
					end
					
					map[x][y][i] = "link"
					map[x][y][i+1] = linktoolt
					map[x][y][i+2] = endx
					map[x][y][i+3] = endy
					linktoolfadeouttime = linktoolfadeouttimeslow
				end
				
				rightclickactive = false
				
				allowdrag = false
			end
		end
		linktoolt = false
	end
end

function drawlinkline(x1, y1, x2, y2)
	love.graphics.rectangle("fill", x1, y1-math.ceil(scale/2), x2-x1, scale)
	love.graphics.rectangle("fill", x2-math.ceil(scale/2), y1, scale, y2-y1)
end

function drawlinkline2(x1, y1, x2, y2)
	love.graphics.rectangle("fill", x1-math.ceil(scale/2), y1, scale, y2-y1)
	love.graphics.rectangle("fill", x2, y2-math.ceil(scale/2), x1-x2, scale)
end

function selectionbutton()
	editorstate = "selection"
	editorclose()
end

function selectionstart()
	local mousex, mousey = mouse.getPosition()
	selectionx = mousex
	selectiony = mousey
	
	selectiondragging = true
end

function selectionend()
	local mousex, mousey = mouse.getPosition()
	selectionwidth = mousex - selectionx
	selectionheight = mousey - selectiony
	
	if selectionwidth < 0 then
		selectionx = selectionx + selectionwidth
		selectionwidth = -selectionwidth
	end
	if selectionheight < 0 then
		selectiony = selectiony + selectionheight
		selectionheight = -selectionheight
	end
	
	selectiondragging = false
end

function selectiongettiles(x, y, width, height)
	x, y = round(x), round(y)
	width, height = round(width), round(height)

	local out = {}
	
	local xstart, ystart = getMouseTile(x, y+7*scale)
	local xend, yend = getMouseTile(x+width, y+height+7*scale)
	
	for cox = xstart, xend do
		for coy = ystart, yend do
			table.insert(out, {x=cox, y=coy})
		end
	end
	
	return out
end