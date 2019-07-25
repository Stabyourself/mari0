function editor_load()
	tilecount1 = 168
	tilecount2 = 74
	
	minimapscroll = 0
	minimapx = 3
	minimapy = 30
	minimapheight = 15
	
	currenttile = 1
	
	rightclicka = 0
	
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
	guielements["tabanimations"] = guielement:new("button", 185, 1, "animations", animationstab, 3)
	guielements["tabanimations"].fillcolor = {63, 63, 63}
	
	--MAIN
	guielements["autoscrollcheckbox"] = guielement:new("checkbox", 291, 65, toggleautoscroll, autoscroll)
	
	guielements["colorsliderr"] = guielement:new("scrollbar", 17, 78, 101, 11, 11, background[1]/255, "hor")
	guielements["colorsliderr"].backgroundcolor = {255, 0, 0}
	guielements["colorsliderg"] = guielement:new("scrollbar", 17, 90, 101, 11, 11, background[2]/255, "hor")
	guielements["colorsliderg"].backgroundcolor = {0, 255, 0}
	guielements["colorsliderb"] = guielement:new("scrollbar", 17, 102, 101, 11, 11, background[3]/255, "hor")
	guielements["colorsliderb"].backgroundcolor = {0, 0, 255}
	
	for i = 1, 3 do
		guielements["defaultcolor" .. i] = guielement:new("button", 125, 66+i*12, "", defaultbackground, 0, {i}, 1, 8)
		guielements["defaultcolor" .. i].fillcolor = backgroundcolor[i]
	end
	
	local args = {"none", "overworld", "underground", "castle", "underwater", "star"}
	for i = 1, #custommusics do
		table.insert(args, string.lower(string.sub(string.sub(custommusics[i], 1, -5), 1, 11)))
	end
	
	guielements["musicdropdown"] = guielement:new("dropdown", 17, 128, 11, changemusic, musici, unpack(args))
	guielements["spritesetdropdown"] = guielement:new("dropdown", 17, 153, 11, changespriteset, spriteset, "overworld", "underground", "castle", "underwater")
	guielements["timelimitdecrease"] = guielement:new("button", 17, 178, "{", decreasetimelimit, 0)
	guielements["timelimitincrease"] = guielement:new("button", 31 + string.len(mariotimelimit)*8, 178, "}", increasetimelimit, 0)
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
	guielements["customforegroundcheckbox"] = guielement:new("checkbox", 200, 170, togglecustomforeground, customforeground)
	
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
	guielements["tilesall"] = guielement:new("button", 72, 20, "all", tilesall, 2)
	guielements["tilessmb"] = guielement:new("button", 105, 20, "smb", tilessmb, 2)
	guielements["tilesportal"] = guielement:new("button", 138, 20, "portal", tilesportal, 2)
	guielements["tilescustom"] = guielement:new("button", 195, 20, "custom", tilescustom, 2)
	guielements["tilesanimated"] = guielement:new("button", 252, 20, "animated", tilesanimated, 2)
	guielements["tilesentities"] = guielement:new("button", 325, 20, "entities", tilesentities, 2)
	
	guielements["tilesscrollbar"] = guielement:new("scrollbar", 381, 37, 167, 15, 40, 0, "ver")
	
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
				local mousex, mousey = love.mouse.getPosition()
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
			local x, y = love.mouse.getPosition()
			placetile(x, y)
		end
	elseif editorstate == "main" then
		if love.mouse.isDown("l") then
			local mousex, mousey = love.mouse.getPosition()
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
end

function editor_draw()	
	love.graphics.setColor(255, 255, 255)
	
	local mousex, mousey = love.mouse.getPosition()
	
	--EDITOR
	if editormenuopen == false then
		if editorstate == "selection" then
			if selectiondragging or selectionwidth then
				local x, y, width, height
				local mousex, mousey = love.mouse.getPosition()
				
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
			local x, y = getMouseTile(love.mouse.getX(), love.mouse.getY()-8*scale)
			
			if inmap(x, y+1) then
				love.graphics.setColor(255, 255, 255, 200)
				if editentities == false then
					love.graphics.drawq(tilequads[currenttile].image, tilequads[currenttile].quad, math.floor((x-xscroll-1)*16*scale), math.floor(((y-yscroll-1)*16+8)*scale), 0, scale, scale)
				else
					love.graphics.drawq(entityquads[currenttile].image, entityquads[currenttile].quad, math.floor((x-xscroll-1)*16*scale), math.floor(((y-yscroll-1)*16+8)*scale), 0, scale, scale)
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
					speedx = faithplatexfunction(rightclickm.t[2].value)
					speedy = -faithplateyfunction(rightclickm.t[4].value)
				else
					speedx = faithplatexfunction(tonumber(map[tx][ty][3]))
					speedy = -faithplateyfunction(tonumber(map[tx][ty][4]))
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
		
		guielements["tabmain"]:draw()
		guielements["tabtiles"]:draw()
		guielements["tabtools"]:draw()
		guielements["tabmaps"]:draw()
		guielements["tabanimations"]:draw()
		
		if editorstate == "tiles" then			
			--TILES
			love.graphics.setColor(255, 255, 255)
			
			properprint("tilelist", 3*scale, 24*scale)
			guielements["tilesall"]:draw()
			guielements["tilessmb"]:draw()
			guielements["tilesportal"]:draw()
			guielements["tilescustom"]:draw()
			guielements["tilesanimated"]:draw()
			guielements["tilesentities"]:draw()
			
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
				for i = 1, #editorentitylist do
					love.graphics.drawq(entityquads[editorentitylist[i]].image, entityquads[editorentitylist[i]].quad, math.mod((i-1), 22)*17*scale+5*scale, math.floor((i-1)/22)*17*scale+38*scale-tilesoffset, 0, scale, scale)
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
			
			if editentities then
				if entitydescriptions[editorentitylist[tile]] then
					local newstring = entitydescriptions[editorentitylist[tile]]
					if string.len(newstring) > 49 then
						newstring = string.sub(newstring, 1, 49) .. "|" .. string.sub(newstring, 50, 98)
					end
					properprint(newstring, 3*scale, 205*scale)
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
			guielements["autoscrollcheckbox"]:draw()
			properprint("follow mario", 301*scale, 66*scale)
			
			if minimapdragging == false then
				guielements["colorsliderr"]:draw()
				guielements["colorsliderg"]:draw()
				guielements["colorsliderb"]:draw()
				
				guielements["defaultcolor1"]:draw()
				guielements["defaultcolor2"]:draw()
				guielements["defaultcolor3"]:draw()
			
				guielements["savebutton"]:draw()
				guielements["menubutton"]:draw()
				guielements["testbutton"]:draw()
				guielements["timelimitdecrease"]:draw()
				properprint(mariotimelimit, 29*scale, 180*scale)
				guielements["timelimitincrease"]:draw()
				properprint("timelimit", 8*scale, 169*scale)
				guielements["spritesetdropdown"]:draw()
				properprint("spriteset", 8*scale, 144*scale)
				properprint("music", 8*scale, 119*scale)
				properprint("background color", 8*scale, 69*scale)
				guielements["musicdropdown"]:draw()
				
				guielements["intermissioncheckbox"]:draw()
				guielements["warpzonecheckbox"]:draw()
				guielements["underwatercheckbox"]:draw()
				guielements["bonusstagecheckbox"]:draw()
				guielements["custombackgroundcheckbox"]:draw()
				guielements["customforegroundcheckbox"]:draw()
				
				guielements["scrollfactorscrollbar"]:draw()
				if custombackground then
					love.graphics.setColor(255, 255, 255, 255)
				else
					love.graphics.setColor(150, 150, 150, 255)
				end
				properprint("scrollfactor", 199*scale, 156*scale)
				properprint(formatscrollnumber(scrollfactor), (guielements["scrollfactorscrollbar"].x+1+guielements["scrollfactorscrollbar"].xrange*guielements["scrollfactorscrollbar"].value)*scale, 156*scale)
				
				guielements["fscrollfactorscrollbar"]:draw()
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
				guielements["backgrounddropdown"]:draw()
				guielements["foregrounddropdown"]:draw()
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
			guielements["selectionbutton"]:draw()
			guielements["lightdrawbutton"]:draw()
			
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
	guielements["savebutton"].active = true
	guielements["menubutton"].active = true
	guielements["testbutton"].active = true
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
	guielements["tabanimations"].active = true
	
	guielements["tilesscrollbar"].active = true
	
	guielements["tilesall"].active = true
	guielements["tilessmb"].active = true
	guielements["tilesportal"].active = true
	guielements["tilescustom"].active = true
	guielements["tilesanimated"].active = true
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
end

function tilesall()
	guielements["tilesall"].textcolor = {255, 255, 255}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
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
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
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
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
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
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	animatedtilelist = false
	tileliststart = smbtilecount + portaltilecount + 1
	tilelistcount = customtilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
end

function tilesanimated()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {255, 255, 255}
	guielements["tilesentities"].textcolor = {127, 127, 127}
	
	animatedtilelist = true
	tileliststart = 1
	tilelistcount = animatedtilecount - 1
	
	tilescrollbarheight = math.max(0, math.ceil((customtilecount)/22)*17 - 1 - (17*9) - 12)
	editentities = false
end

function tilesentities()
	guielements["tilesall"].textcolor = {127, 127, 127}
	guielements["tilessmb"].textcolor = {127, 127, 127}
	guielements["tilesportal"].textcolor = {127, 127, 127}
	guielements["tilescustom"].textcolor = {127, 127, 127}
	guielements["tilesanimated"].textcolor = {127, 127, 127}
	guielements["tilesentities"].textcolor = {255, 255, 255}
	
	animatedtilelist = false
	tilescrollbarheight = math.max(0, math.ceil((entitiescount)/22)*17 - 1 - (17*9) - 12)
	editentities = true
	
	if currenttile > entitiescount then
		currenttile = 1
	end
end

function placetile(x, y, t, ent)
	local editentities = ent or editentities
	local currenttile = t or currenttile
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
			placetile(x+16*scale, y, 137)
			placetile(x, y+16*scale, 138)
			placetile(x+16*scale, y+16*scale, 139)
		end
		
	else
		local t = map[cox][coy]
		if entityquads[currenttile].t == "remove" then --removing tile
			for i = 2, #map[cox][coy] do
				map[cox][coy][i] = nil
			end
		else
			for i = 3, #map[cox][coy] do
				map[cox][coy][i] = nil
			end
			
			map[cox][coy][2] = currenttile
			
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
	end
end

function mapnumberclick(i, j, k)
	if editormode then
		marioworld = i
		mariolevel = j
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
					if tile and tile <= entitiescount then
						currenttile = editorentitylist[tile]
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

function changemusic(var)
	if musici >= 7 then
		music:stop("mappacks/" .. mappack .. "/music/" .. custommusic)
	elseif musici ~= 1 then
		music:stopIndex(musici-1)
	end
	musici = var
	if musici >= 7 then
		custommusic = custommusics[musici-6]
		music:play("mappacks/" .. mappack .. "/music/" .. custommusic)
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

function test_level()
	savelevel()
	editorclose()
	editormode = false
	testlevel = true
	testlevelworld = marioworld
	testlevellevel = mariolevel
	autoscroll = true
	if mariosublevel ~= 0 then
		startlevel(marioworld .. "-" .. mariolevel .. "_" .. mariosublevel)
	else
		startlevel(marioworld .. "-" .. mariolevel)
	end
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
			
			love.graphics.setColor(255, 255, 255, 100)
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
					value = rightclickm.t[i].value
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
	local r = map[x][y]
	local i = 1
	while (r[i] ~= "link" or r[i+1] ~= t) and i <= #r do
		i = i + 1
	end
	table.remove(map[x][y], i)
	table.remove(map[x][y], i)
	table.remove(map[x][y], i)
	table.remove(map[x][y], i)
end

function finishlinking(x, y)
	if rightclickactive then
		local startx, starty = linktoolX, linktoolY
		local endx, endy = getMouseTile(x, y+8*scale)
		
		local edittable = {{x=startx, y=starty}}
		
		if selectionwidth then
			local selectionlist = selectiongettiles(selectionx, selectiony, selectionwidth, selectionheight)
			
			love.graphics.setColor(255, 255, 255, 100)
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
	local mousex, mousey = love.mouse.getPosition()
	selectionx = mousex
	selectiony = mousey
	
	selectiondragging = true
end

function selectionend()
	local mousex, mousey = love.mouse.getPosition()
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