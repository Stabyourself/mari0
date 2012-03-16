function menu_load()
	love.audio.stop()
	editormode = false
	gamestate = "menu"
	selection = 1
	coinanimation = 1
	love.graphics.setBackgroundColor(92, 148, 252)
	scrollsmoothrate = 4
	optionstab = 2
	optionsselection = 1
	skinningplayer = 1
	rgbselection = 1
	mappackselection = 1
	onlinemappackselection = 1
	mappackhorscroll = 0
	mappackhorscrollsmooth = 0
	checkpointx = false
	love.graphics.setBackgroundColor(backgroundcolor[1])
	
	controlstable = {"left", "right", "up", "down", "run", "jump", "reload", "use", "aimx", "aimy", "portal1", "portal2"}
	
	portalanimation = 1
	portalanimationtimer = 0
	portalanimationdelay = 0.08
	
	infmarioY = 0
	infmarioR = 0
	
	infmarioYspeed = 200
	infmarioRspeed = 4
	
	RGBchangespeed = 200
	huechangespeed = 0.5
	spriteset = 1
	
	portalcolors = {}
	for i = 1, players do
		portalcolors[i] = {}
	end
	
	continueavailable = false
	if love.filesystem.exists("suspend.txt") then
		continueavailable = true
	end
	
	mariolevel = 1
	marioworld = 1
	mariosublevel = 0
	
	--load 1-1 as background
	loadbackground("1-1.txt")
	
	skipupdate = true
end

function menu_update(dt)
	--coinanimation
	coinanimation = coinanimation + dt*6.75
	while coinanimation > 6 do
		coinanimation = coinanimation - 5
	end		
	
	if mappackscroll then
		--smooth the scroll
		if mappackscrollsmooth > mappackscroll then
			mappackscrollsmooth = mappackscrollsmooth - (mappackscrollsmooth-mappackscroll)*dt*5-0.1*dt
			if mappackscrollsmooth < mappackscroll then
				mappackscrollsmooth = mappackscroll
			end
		elseif mappackscrollsmooth < mappackscroll then
			mappackscrollsmooth = mappackscrollsmooth - (mappackscrollsmooth-mappackscroll)*dt*5+0.1*dt
			if mappackscrollsmooth > mappackscroll then
				mappackscrollsmooth = mappackscroll
			end
		end
	end
	
	if onlinemappackscroll then
		--smooth the scroll
		if onlinemappackscrollsmooth > onlinemappackscroll then
			onlinemappackscrollsmooth = onlinemappackscrollsmooth - (onlinemappackscrollsmooth-onlinemappackscroll)*dt*5-0.1*dt
			if onlinemappackscrollsmooth < onlinemappackscroll then
				onlinemappackscrollsmooth = onlinemappackscroll
			end
		elseif onlinemappackscrollsmooth < onlinemappackscroll then
			onlinemappackscrollsmooth = onlinemappackscrollsmooth - (onlinemappackscrollsmooth-onlinemappackscroll)*dt*5+0.1*dt
			if onlinemappackscrollsmooth > onlinemappackscroll then
				onlinemappackscrollsmooth = onlinemappackscroll
			end
		end
	end
	
	if mappackhorscroll then
		if mappackhorscrollsmooth > mappackhorscroll then
			mappackhorscrollsmooth = mappackhorscrollsmooth - (mappackhorscrollsmooth-mappackhorscroll)*dt*5-0.03*dt
			if mappackhorscrollsmooth < mappackhorscroll then
				mappackhorscrollsmooth = mappackhorscroll
			end
		elseif mappackhorscrollsmooth < mappackhorscroll then
			mappackhorscrollsmooth = mappackhorscrollsmooth - (mappackhorscrollsmooth-mappackhorscroll)*dt*5+0.03*dt
			if mappackhorscrollsmooth > mappackhorscroll then
				mappackhorscrollsmooth = mappackhorscroll
			end
		end
	end
	
	if gamestate == "options" and optionstab == 2 then
		portalanimationtimer = portalanimationtimer + dt
		while portalanimationtimer > portalanimationdelay do
			portalanimation = portalanimation + 1
			if portalanimation > 6 then
				portalanimation = 1
			end
			portalanimationtimer = portalanimationtimer - portalanimationdelay
		end
		
		infmarioY = infmarioY + infmarioYspeed*dt
		while infmarioY > 64 do
			infmarioY = infmarioY - 64
		end
		
		infmarioR = infmarioR + infmarioRspeed*dt
		while infmarioR > math.pi*2 do
			infmarioR = infmarioR - math.pi*2
		end
	
		if optionsselection > 3 and optionsselection < 13 then
			local colornumber = math.floor((optionsselection-1)/3)
			local colorRGB = math.mod(optionsselection-4, 3)+1
			
			if love.keyboard.isDown("right") and mariocolors[skinningplayer][colornumber][colorRGB] < 255 then
				mariocolors[skinningplayer][colornumber][colorRGB] = mariocolors[skinningplayer][colornumber][colorRGB] + RGBchangespeed*dt
				if mariocolors[skinningplayer][colornumber][colorRGB] > 255 then
					mariocolors[skinningplayer][colornumber][colorRGB] = 255
				end
			elseif love.keyboard.isDown("left") and mariocolors[skinningplayer][colornumber][colorRGB] > 0 then
				mariocolors[skinningplayer][colornumber][colorRGB] = mariocolors[skinningplayer][colornumber][colorRGB] - RGBchangespeed*dt
				if mariocolors[skinningplayer][colornumber][colorRGB] < 0 then
					mariocolors[skinningplayer][colornumber][colorRGB] = 0
				end
			end
			
		elseif optionsselection == 13 then
			if love.keyboard.isDown("right") and portalhues[skinningplayer][1] < 1 then
				portalhues[skinningplayer][1] = portalhues[skinningplayer][1] + huechangespeed*dt
				if portalhues[skinningplayer][1] > 1 then
					portalhues[skinningplayer][1] = 1
				end
				portalcolor[skinningplayer][1] = getrainbowcolor(portalhues[skinningplayer][1])
				
			elseif love.keyboard.isDown("left") and portalhues[skinningplayer][1] > 0 then
				portalhues[skinningplayer][1] = portalhues[skinningplayer][1] - huechangespeed*dt
				if portalhues[skinningplayer][1] < 0 then
					portalhues[skinningplayer][1] = 0
				end
				portalcolor[skinningplayer][1] = getrainbowcolor(portalhues[skinningplayer][1])
			end
			
		elseif optionsselection == 14 then
			if love.keyboard.isDown("right") and portalhues[skinningplayer][2] < 1 then
				portalhues[skinningplayer][2] = portalhues[skinningplayer][2] + huechangespeed*dt
				if portalhues[skinningplayer][2] > 1 then
					portalhues[skinningplayer][2] = 1
				end
				portalcolor[skinningplayer][2] = getrainbowcolor(portalhues[skinningplayer][2])
				
			elseif love.keyboard.isDown("left") and portalhues[skinningplayer][2] > 0 then
				portalhues[skinningplayer][2] = portalhues[skinningplayer][2] - huechangespeed*dt
				if portalhues[skinningplayer][2] < 0 then
					portalhues[skinningplayer][2] = 0
				end
				portalcolor[skinningplayer][2] = getrainbowcolor(portalhues[skinningplayer][2])
			end
		end
	end
end

function menu_draw()
	--GUI LIBRARY?! Never heard of that.
	--I'm not proud of this at all; But I'm even lazier than not proud.

	--TILES
	love.graphics.translate(0, yoffset*scale)
	local xtodraw
	if mapwidth < width+1 then
		xtodraw = mapwidth
	else
		if mapwidth > width then
			xtodraw = width+1
		else
			xtodraw = width
		end
	end
		
	--custom background
	if custombackground then
		for i = #custombackgroundimg, 1, -1 do
			for y = 1, math.ceil(15/custombackgroundheight[i]) do
				for x = 1, math.ceil(width/custombackgroundwidth[i])+1 do
					love.graphics.draw(custombackgroundimg[i], math.floor(((x-1)*custombackgroundwidth[i])*16*scale), (y-1)*custombackgroundheight[i]*16*scale, 0, scale, scale)
				end
			end
		end
	end
	
	local coinframe
	if math.floor(coinanimation) == 4 then
		coinframe = 2
	elseif math.floor(coinanimation) == 5 then
		coinframe = 1
	else
		coinframe = math.floor(coinanimation)
	end
	
	for y = 1, 15 do
		for x = 1, xtodraw do
			local t = map[x][y]
			local tilenumber = tonumber(t[1])
			if tilequads[tilenumber].coinblock and tilequads[tilenumber].invisible == false then --coinblock
				love.graphics.drawq(coinblockimage, coinblockquads[spriteset][coinframe], math.floor((x-1)*16*scale), ((y-1)*16-8)*scale, 0, scale, scale)
			elseif tilenumber ~= 0 and tilequads[tilenumber].invisible == false then
				love.graphics.drawq(tilequads[tilenumber].image, tilequads[tilenumber].quad, math.floor((x-1)*16*scale), ((y-1)*16-8)*scale, 0, scale, scale)
			end
		end
	end
	
	---UI
	
	properprint("mario", uispace*.5 - 24*scale, 8*scale)
	properprint("000000", uispace*0.5-24*scale, 16*scale)
	
	properprint("*", uispace*1.5-8*scale, 16*scale)
	
	love.graphics.drawq(coinanimationimage, coinanimationquads[1][coinframe], uispace*1.5-16*scale, 16*scale, 0, scale, scale)
	properprint("00", uispace*1.5-0*scale, 16*scale)
	
	properprint("world", uispace*2.5 - 20*scale, 8*scale)
	properprint("1-1", uispace*2.5 - 12*scale, 16*scale)
	
	properprint("time", uispace*3.5 - 16*scale, 8*scale)
	
	for j = 1, players do
	
		--draw player
		love.graphics.setColor(255, 255, 255, 255)
		for k = 1, 3 do
			love.graphics.setColor(unpack(mariocolors[j][k]))
			love.graphics.draw(skinpuppet[k], (startx*16-6)*scale+8*(j-1)*scale, (starty*16-23)*scale, 0, scale, scale)
		end
		
		--hat
		
		offsets = hatoffsets["idle"]
		if #mariohats[j] > 1 or mariohats[j][1] ~= 1 then
			local yadd = 0
			for i = 1, #mariohats[j] do
				love.graphics.setColor(255, 255, 255)
				love.graphics.draw(hat[mariohats[j][i]].graphic, (startx*16-11)*scale+8*(j-1)*scale, (starty*16-25)*scale, 0, scale, scale, - hat[mariohats[j][i]].x + offsets[1], - hat[mariohats[j][i]].y + offsets[2] + yadd)
				yadd = yadd + hat[mariohats[j][i]].height
			end
		elseif #mariohats[j] == 1 then
			love.graphics.setColor(mariocolors[j][1])
			love.graphics.draw(hat[mariohats[j][1]].graphic, (startx*16-11)*scale+8*(j-1)*scale, (starty*16-25)*scale, 0, scale, scale, - hat[mariohats[j][1]].x + offsets[1], - hat[mariohats[j][1]].y + offsets[2])
		end
		
		love.graphics.setColor(255, 255, 255, 255)
		
		love.graphics.draw(skinpuppet[0], (startx*16-6)*scale+8*(j-1)*scale, (starty*16-23)*scale, 0, scale, scale)
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	
	if gamestate == "menu" then
		love.graphics.draw(titleimage, 40*scale, 24*scale, 0, scale, scale)
		
		if updatenotification then
			love.graphics.setColor(255, 0, 0)
			properprint("version outdated!|go to stabyourself.net|to download latest", 220*scale, 90*scale)
			love.graphics.setColor(255, 255, 255, 255)
		end
		
		if selection == 0 then
			love.graphics.draw(menuselection, 73*scale, (137+(selection-1)*16)*scale, 0, scale, scale)
		elseif selection == 1 then
			love.graphics.draw(menuselection, 73*scale, (137+(selection-1)*16)*scale, 0, scale, scale)
		elseif selection == 2 then
			love.graphics.draw(menuselection, 81*scale, (137+(selection-1)*16)*scale, 0, scale, scale)
		elseif selection == 3 then
			love.graphics.draw(menuselection, 73*scale, (137+(selection-1)*16)*scale, 0, scale, scale)
		elseif selection == 4 then
			love.graphics.draw(menuselection, 98*scale, (137+(selection-1)*16)*scale, 0, scale, scale)
		end
		
		local start = 9
		if custombackground then
			start = 1
		end
		
		for i = start, 9 do
			local tx, ty = -scale, scale
			love.graphics.setColor(0, 0, 0)
			if i == 2 then
				tx, ty = scale, scale
			elseif i == 3 then
				tx, ty = -scale, -scale
			elseif i == 4 then
				tx, ty = scale, -scale
			elseif i == 5 then
				tx, ty = 0, -scale
			elseif i == 6 then
				tx, ty = 0, scale
			elseif i == 7 then
				tx, ty = scale, 0
			elseif i == 8 then
				tx, ty = -scale, 0
			elseif i == 9 then
				tx, ty = 0, 0
				love.graphics.setColor(255, 255, 255)
			end
			
			love.graphics.translate(tx, ty)
			
			if continueavailable then
				properprint("continue game", 87*scale, 122*scale)
			end
			
			properprint("player game", 103*scale, 138*scale)
			
			properprint("level editor", 95*scale, 154*scale)
			
			properprint("select mappack", 87*scale, 170*scale)
			
			properprint("options", 111*scale, 186*scale)
		
			properprint(players, 87*scale, 138*scale)
			
			love.graphics.translate(-tx, -ty)
		end
		
		if players > 1 then
			love.graphics.draw(playerselectimg, 82*scale, 138*scale, 0, scale, scale)
		end
		
		if players < 4 then
			love.graphics.draw(playerselectimg, 102*scale, 138*scale, 0, -scale, scale)
		end
		
		if selectworldopen then
			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle("fill", 30*scale, 92*scale, 200*scale, 60*scale)
			love.graphics.setColor(255, 255, 255)
			drawrectangle(31, 93, 198, 58)
			properprint("select world", 83*scale, 105*scale)
			for i = 1, 8 do
				if selectworldcursor == i then
					love.graphics.setColor(255, 255, 255)
				elseif reachedworlds[mappack][i] then
					love.graphics.setColor(200, 200, 200)
				elseif selectworldexists[i] then
					love.graphics.setColor(50, 50, 50)
				else
					love.graphics.setColor(0, 0, 0)
				end
				
				properprint(i, (55+(i-1)*20)*scale, 130*scale)
				if i == selectworldcursor then
					properprint("v", (55+(i-1)*20)*scale, 120*scale)
				end
			end
		end
		
	elseif gamestate == "mappackmenu" then
		--background
		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle("fill", 21*scale, 16*scale, 218*scale, 200*scale)
		love.graphics.setColor(255, 255, 255, 255)
		
		--set scissor
		love.graphics.setScissor(21*scale, 16*scale, 218*scale, 200*scale)
		
		if loadingonlinemappacks then
			love.graphics.setColor(0, 0, 0, 200)
			love.graphics.rectangle("fill", 21*scale, 16*scale, 218*scale, 200*scale)
			love.graphics.setColor(255, 255, 255, 255)
			properprint("a little patience..|downloading " .. currentdownload .. " of " .. downloadcount, 50*scale, 30*scale)
			drawrectangle(50, 55, 152, 10)
			love.graphics.rectangle("fill", 50*scale, 55*scale, 152*((currentfiledownload-1)/(filecount-1))*scale, 10*scale)
		else
			love.graphics.translate(-round(mappackhorscrollsmooth*scale*mappackhorscrollrange), 0)
			
			if mappackhorscrollsmooth < 1 then
				--draw each butten (even if all you do, is press ONE. BUTTEN.)
				--scrollbar offset
				love.graphics.translate(0, -round(mappackscrollsmooth*60*scale))
				
				love.graphics.setScissor(240*scale, 16*scale, 200*scale, 200*scale)
				love.graphics.setColor(0, 0, 0, 200)
				love.graphics.rectangle("fill", 240*scale, 81*scale, 115*scale, 61*scale)
				love.graphics.setColor(255, 255, 255)
				if not savefolderfailed then
					properprint("press right to|access the dlc||press m to|open your|mappack folder", 241*scale, 83*scale)
				else
					properprint("press right to|access the dlc||could not|open your|mappack folder", 241*scale, 83*scale)
				end
				love.graphics.setScissor(21*scale, 16*scale, 218*scale, 200*scale)
				
				for i = 1, #mappacklist do
					--back
					love.graphics.draw(mappackback, 25*scale, (20+(i-1)*60)*scale, 0, scale, scale)
					
					--icon
					if mappackicon[i] ~= nil then
						local scale2w = scale*50 / math.max(1, mappackicon[i]:getWidth())
						local scale2h = scale*50 / math.max(1, mappackicon[i]:getHeight())
						love.graphics.draw(mappackicon[i], 29*scale, (24+(i-1)*60)*scale, 0, scale2w, scale2h)
					else
						love.graphics.draw(mappacknoicon, 29*scale, (24+(i-1)*60)*scale, 0, scale, scale)
					end
					love.graphics.draw(mappackoverlay, 29*scale, (24+(i-1)*60)*scale, 0, scale, scale)
					
					--name
					love.graphics.setColor(200, 200, 200)
					if mappackselection == i then
						love.graphics.setColor(255, 255, 255)
					end
					
					properprint(string.sub(mappackname[i]:lower(), 1, 17), 83*scale, (26+(i-1)*60)*scale)
					
					--author
					love.graphics.setColor(100, 100, 100)
					if mappackselection == i then
						love.graphics.setColor(100, 100, 100)
					end
					
					if mappackauthor[i] then
						properprint(string.sub("by " .. mappackauthor[i]:lower(), 1, 16), 91*scale, (35+(i-1)*60)*scale)
					end
					
					--description
					love.graphics.setColor(130, 130, 130)
					if mappackselection == i then
						love.graphics.setColor(180, 180, 180)
					end
					
					if mappackdescription[i] then
						properprint( string.sub(mappackdescription[i]:lower(), 1, 17), 83*scale, (47+(i-1)*60)*scale)
						
						if mappackdescription[i]:len() > 17 then
							properprint( string.sub(mappackdescription[i]:lower(), 18, 34), 83*scale, (56+(i-1)*60)*scale)
						end
						
						if mappackdescription[i]:len() > 34 then
							properprint( string.sub(mappackdescription[i]:lower(), 35, 51), 83*scale, (65+(i-1)*60)*scale)
						end
					end
					
					love.graphics.setColor(255, 255, 255)
					
					--highlight
					if i == mappackselection then
						love.graphics.draw(mappackhighlight, 25*scale, (20+(i-1)*60)*scale, 0, scale, scale)
					end
				end
			
				love.graphics.translate(0, round(mappackscrollsmooth*60*scale))
			
				local i = mappackscrollsmooth / (#mappacklist-3.233)
			
				love.graphics.draw(mappackscrollbar, 227*scale, (20+i*160)*scale, 0, scale, scale)
			
			end
			
			love.graphics.translate(round(mappackhorscrollsmooth*scale*mappackhorscrollrange), 0)
			----------
			--ONLINE--
			----------
			
			love.graphics.translate(round(mappackhorscrollrange*scale - mappackhorscrollsmooth*scale*mappackhorscrollrange), 0)
			
			if mappackhorscrollsmooth > 0 then
				if #onlinemappacklist == 0 then
					properprint("something went wrong||      sorry d:||maybe your internet|does not work right?", 40*scale, 80*scale)
				end
				
				love.graphics.setScissor()
				love.graphics.setColor(0, 0, 0, 200)
				love.graphics.rectangle("fill", 241*scale, 16*scale, 150*scale, 200*scale)
				love.graphics.setColor(255, 255, 255, 255)
				properprint("wanna contribute?|make a mappack and|send an email to|mappack at|stabyourself.net!||include your map-|pack! you can find|it in your appdata|love/mari0 dir.", 244*scale, 19*scale)
				if outdated then
					love.graphics.setColor(255, 0, 0, 255)
					properprint("version outdated!|you have an old|version of mari0!|mappacks could not|be downloaded.|go to|stabyourself.net|to download latest", 244*scale, 130*scale)
					love.graphics.setColor(255, 255, 255, 255)
				elseif downloaderror then
					love.graphics.setColor(255, 0, 0, 255)
					properprint("download error!|something went|wrong while|downloading|mappacks.|press left and|right to try|again.  sorry.", 244*scale, 130*scale)
					love.graphics.setColor(255, 255, 255, 255)
				end
					
				love.graphics.setScissor(21*scale, 16*scale, 218*scale, 200*scale)
				
				--scrollbar offset
				love.graphics.translate(0, -round(onlinemappackscrollsmooth*60*scale))
				for i = 1, #onlinemappacklist do
					--back
					love.graphics.draw(mappackback, 25*scale, (20+(i-1)*60)*scale, 0, scale, scale)
					
					--icon
					if onlinemappackicon[i] ~= nil then
						love.graphics.draw(onlinemappackicon[i], 29*scale, (24+(i-1)*60)*scale, 0, scale, scale)
					else
						love.graphics.draw(mappacknoicon, 29*scale, (24+(i-1)*60)*scale, 0, scale, scale)
					end
					love.graphics.draw(mappackoverlay, 29*scale, (24+(i-1)*60)*scale, 0, scale, scale)
					
					--name
					love.graphics.setColor(200, 200, 200)
					if onlinemappackselection == i then
						love.graphics.setColor(255, 255, 255)
					end
					
					properprint(string.sub(onlinemappackname[i]:lower(), 1, 17), 83*scale, (26+(i-1)*60)*scale)
					
					--author
					love.graphics.setColor(100, 100, 100)
					if onlinemappackselection == i then
						love.graphics.setColor(100, 100, 100)
					end
					
					if onlinemappackauthor[i] then
						properprint(string.sub("by " .. onlinemappackauthor[i]:lower(), 1, 16), 91*scale, (35+(i-1)*60)*scale)
					end
					
					--description
					love.graphics.setColor(130, 130, 130)
					if onlinemappackselection == i then
						love.graphics.setColor(180, 180, 180)
					end
					
					if onlinemappackdescription[i] then
						properprint( string.sub(onlinemappackdescription[i]:lower(), 1, 17), 83*scale, (47+(i-1)*60)*scale)
						
						if onlinemappackdescription[i]:len() > 17 then
							properprint( string.sub(onlinemappackdescription[i]:lower(), 18, 34), 83*scale, (56+(i-1)*60)*scale)
						end
						
						if onlinemappackdescription[i]:len() > 34 then
							properprint( string.sub(onlinemappackdescription[i]:lower(), 35, 51), 83*scale, (65+(i-1)*60)*scale)
						end
					end
					
					love.graphics.setColor(255, 255, 255)
					
					--highlight
					if i == onlinemappackselection then
						love.graphics.draw(mappackhighlight, 25*scale, (20+(i-1)*60)*scale, 0, scale, scale)
					end
				end
			
				love.graphics.translate(0, round(onlinemappackscrollsmooth*60*scale))
			
				local i = onlinemappackscrollsmooth / (#onlinemappacklist-3.233)
			
				love.graphics.draw(mappackscrollbar, 227*scale, (20+i*160)*scale, 0, scale, scale)
			end
			
			love.graphics.translate(- round(mappackhorscrollrange*scale - mappackhorscrollsmooth*scale*mappackhorscrollrange), 0)
		end
		
		love.graphics.setScissor()
		
		if mappackhorscroll == 0 then
			love.graphics.setColor(255, 255, 255)
			love.graphics.rectangle("fill", 22*scale, 3*scale, 44*scale, 13*scale)
			love.graphics.setColor(0, 0, 0)
			properprint("local", 23*scale, 6*scale)
			drawrectangle(22, 3, 44, 13)
			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle("fill", 70*scale, 3*scale, 29*scale, 13*scale)
			love.graphics.setColor(255, 255, 255)
			properprint("dlc", 72*scale, 6*scale)
		else
			love.graphics.setColor(0, 0, 0)
			love.graphics.rectangle("fill", 22*scale, 3*scale, 44*scale, 13*scale)
			love.graphics.setColor(255, 255, 255)
			properprint("local", 23*scale, 6*scale)
			love.graphics.setColor(255, 255, 255)
			love.graphics.rectangle("fill", 70*scale, 3*scale, 29*scale, 13*scale)
			love.graphics.setColor(0, 0, 0)
			properprint("dlc", 72*scale, 6*scale)
			drawrectangle(70, 3, 29, 13)
		end
		
	elseif gamestate == "onlinemenu" then
		if CLIENT == false and SERVER == false then
			properprint("press c for client", 70*scale, 100*scale)
			properprint("press s for server", 70*scale, 160*scale)
			properprint("run away to quit", 78*scale, 170*scale)
		elseif CLIENT then
			properprint("waiting for server..", 62*scale, 100*scale)
		elseif SERVER then
			properprint("press enter to start!", 62*scale, 100*scale)
		end
	elseif gamestate == "options" then
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle("fill", 21*scale, 16*scale, 218*scale, 200*scale)
		
		--Controls tab head
		if optionstab == 1 then
			love.graphics.setColor(100, 100, 100, 100)
			love.graphics.rectangle("fill", 25*scale, 20*scale, 67*scale, 11*scale)
		end
		
		if optionstab == 1 and optionsselection == 1 then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(100, 100, 100, 255)
		end
		properprint("controls", 26*scale, 22*scale)
		
		--Skins tab head
		if optionstab == 2 then
			love.graphics.setColor(100, 100, 100, 100)
			love.graphics.rectangle("fill", 96*scale, 20*scale, 43*scale, 11*scale)
		end
		
		
		if optionstab == 2 and optionsselection == 1 then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(100, 100, 100, 255)
		end
		properprint("skins", 97*scale, 22*scale)
		
		--Miscellaneous tab head
		if optionstab == 3 then
			love.graphics.setColor(100, 100, 100, 100)
			love.graphics.rectangle("fill", 145*scale, 20*scale, 39*scale, 11*scale)
		end
		
		if optionstab == 3 and optionsselection == 1 then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(100, 100, 100, 255)
		end
		properprint("misc.", 146*scale, 22*scale)
		
		--Cheat tab head
		if optionstab == 4 then
			love.graphics.setColor(100, 100, 100, 100)
			love.graphics.rectangle("fill", 190*scale, 20*scale, 43*scale, 11*scale)
		end
		
		if optionstab == 4 and optionsselection == 1 then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(100, 100, 100, 255)
		end
		properprint("cheat", 191*scale, 22*scale)
		
		love.graphics.setColor(255, 255, 255, 255)
		
		if optionstab == 1 then
			--CONTROLS
			if optionsselection == 2 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("edit player:" .. skinningplayer, 74*scale, 40*scale)
			
			if optionsselection == 3 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			if mouseowner == skinningplayer then
				properprint("uses the mouse: yes", 46*scale, 52*scale)
			else
				properprint("uses the mouse: no", 46*scale, 52*scale)
			end
			
			for i = 1, #controlstable do
				if mouseowner ~= skinningplayer or i <= 8 then		
					if optionsselection == 3+i then
						love.graphics.setColor(255, 255, 255, 255)
					else
						love.graphics.setColor(100, 100, 100, 255)
					end
					
					properprint(controlstable[i], 30*scale, (70+(i-1)*12)*scale)
					
					local s = ""
					
					if controls[skinningplayer][controlstable[i]] then
						for j = 1, #controls[skinningplayer][controlstable[i]] do
							s = s .. controls[skinningplayer][controlstable[i]][j]
						end
					end
					if s == " " then
						s = "space"
					end
					properprint(s, 120*scale, (70+(i-1)*12)*scale)
				end
			end
				
			if keyprompt then
				love.graphics.setColor(0, 0, 0, 255)
				love.graphics.rectangle("fill", 30*scale, 100*scale, 200*scale, 60*scale)
				love.graphics.setColor(255, 255, 255, 255)
				drawrectangle(30, 100, 200, 60)
				if controlstable[optionsselection-3] == "aimx" then
					properprint("move stick right", 40*scale, 110*scale)
				elseif controlstable[optionsselection-3] == "aimy" then
					properprint("move stick down", 40*scale, 110*scale)
				else
					properprint("press key for '" .. controlstable[optionsselection-3] .. "'", 40*scale, 110*scale)
				end
				properprint("press 'esc' to cancel", 40*scale, 140*scale)
				
				if buttonerror then
					love.graphics.setColor(200, 0, 0)
					properprint("you can only set", 40*scale, 120*scale)
					properprint("buttons for this", 40*scale, 130*scale)
				elseif axiserror then
					love.graphics.setColor(200, 0, 0)
					properprint("you can only set", 40*scale, 120*scale)
					properprint("axes for this", 40*scale, 130*scale)
				end
			end
		elseif optionstab == 2 then
			--SKINS
			if optionsselection == 2 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("edit player:" .. skinningplayer, 74*scale, 32*scale)
			
			--PREVIEW MARIO IN BIG. WITH BIG LETTERS
			love.graphics.setColor(255, 255, 255, 255)
			for i = 1, 3 do
				love.graphics.setColor(unpack(mariocolors[skinningplayer][i]))
				love.graphics.draw(skinpuppet[i], 80*scale, 42*scale, 0, scale*2, scale*2)
			end
			
			--hat
			offsets = hatoffsets["idle"]
			if #mariohats[skinningplayer] > 1 or mariohats[skinningplayer][1] ~= 1 then
				local yadd = 0
				for i = 1, #mariohats[skinningplayer] do
					love.graphics.setColor(255, 255, 255)
					love.graphics.draw(hat[mariohats[skinningplayer][i]].graphic, 70*scale, 38*scale, 0, scale*2, scale*2, - hat[mariohats[skinningplayer][i]].x + offsets[1], - hat[mariohats[skinningplayer][i]].y + offsets[2] + yadd)
					yadd = yadd + hat[mariohats[skinningplayer][i]].height
				end
			elseif #mariohats[skinningplayer] == 1 then
				love.graphics.setColor(mariocolors[skinningplayer][1])
				love.graphics.draw(hat[mariohats[skinningplayer][1]].graphic, 70*scale, 38*scale, 0, scale*2, scale*2, - hat[mariohats[skinningplayer][1]].x + offsets[1], - hat[mariohats[skinningplayer][1]].y + offsets[2])
			end
			
			love.graphics.setColor(255, 255, 255, 255)
			
			love.graphics.draw(skinpuppet[0], 80*scale, 42*scale, 0, scale*2, scale*2)
			
			--PREVIEW PORTALS WITH FALLING MARIO BECAUSE I CAN AND IT LOOKS RAD
			love.graphics.setScissor(142*scale, 42*scale, 32*scale, 32*scale)
			
			for j = 1, 3 do
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(secondskinpuppet[0], 158*scale, (2+((j-1)*32)+infmarioY)*scale, infmarioR, scale, scale, 8, 8)
				for i = 1, 3 do
					love.graphics.setColor(unpack(mariocolors[skinningplayer][i]))
					love.graphics.draw(secondskinpuppet[i], 158*scale, (2+((j-1)*32)+infmarioY)*scale, infmarioR, scale, scale, 8, 8)
				end
			end
			
			local portalframe = portalanimation
			
			love.graphics.setColor(255, 255, 255, 80 - math.abs(portalframe-3)*10)
			love.graphics.draw(portalglow, 174*scale, 59*scale, math.pi, scale, scale)
			love.graphics.draw(portalglow, 142*scale, 57*scale, 0, scale, scale)
			
			love.graphics.setColor(unpack(portalcolor[skinningplayer][1]))
			love.graphics.drawq(portalimage, portal1quad[portalframe], 174*scale, 46*scale, math.pi, scale, scale)
			love.graphics.setColor(unpack(portalcolor[skinningplayer][2]))
			love.graphics.drawq(portalimage, portal1quad[portalframe], 142*scale, 70*scale, 0, scale, scale)
			
			love.graphics.setScissor()
			
			--HAT
			if optionsselection == 3 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			if mariohats[skinningplayer][1] == nil then
				properprint("hat: none", (79)*scale, 80*scale)
			else
				properprint("hat: " .. mariohats[skinningplayer][1], (95-string.len(mariohats[skinningplayer][1])*4)*scale, 80*scale)
			end
			
			love.graphics.setColor(255, 255, 255, 255)
			--WHITE BACKGROUND FOR RGB BARS
			
			if optionsselection > 3 and optionsselection < 13 then
				love.graphics.rectangle("fill", 69*scale, 89*scale + math.mod(optionsselection-4, 3)*10*scale + math.floor((optionsselection-4)/3)*14*scale, 142*scale, 10*scale)
			end
			
			if math.floor((optionsselection-1)/3) == 1 then
				love.graphics.setColor(255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100)
			end
			
			properprint("hat", 35*scale, 90*scale)
			
			if math.floor((optionsselection-1)/3) == 2 then
				love.graphics.setColor(255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100)
			end
			
			properprint("hair", 31*scale, 114*scale)
			
			if math.floor((optionsselection-1)/3) == 3 then
				love.graphics.setColor(255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100)
			end
			
			properprint("skin", 31*scale, 138*scale)
			for i = 1, 3 do
				if math.floor((optionsselection-1)/3) == i then
					love.graphics.setColor(100, 0, 0)
					properprint("r", 70*scale, (91+(i-1)*14)*scale)
					love.graphics.setColor(255, 0, 0)	
					properprint("r", 69*scale, (90+(i-1)*14)*scale)
					
					love.graphics.setColor(0, 100, 0)
					properprint("g", 70*scale, (101+(i-1)*14)*scale)
					love.graphics.setColor(0, 255, 0)	
					properprint("g", 69*scale, (100+(i-1)*14)*scale)
					
					love.graphics.setColor(0, 0, 100)
					properprint("b", 70*scale, (111+(i-1)*14)*scale)
					love.graphics.setColor(0, 0, 255)	
					properprint("b", 69*scale, (110+(i-1)*14)*scale)
				end
			end
			
			for j = 1, 3 do
				if math.floor((optionsselection-1)/3) == j then
					love.graphics.setColor(100, 0, 0)
					love.graphics.rectangle("fill", 81*scale, (91+(j-1)*14)*scale, math.floor(129*scale * (mariocolors[skinningplayer][j][1]/255)), 7*scale)
					love.graphics.setColor(255, 0, 0)
					love.graphics.rectangle("fill", 80*scale, (90+(j-1)*14)*scale, math.floor(129*scale * (mariocolors[skinningplayer][j][1]/255)), 7*scale)
					
					love.graphics.setColor(0, 100, 0)
					love.graphics.rectangle("fill", 81*scale, (101+(j-1)*14)*scale, math.floor(129*scale * (mariocolors[skinningplayer][j][2]/255)), 7*scale)
					love.graphics.setColor(0, 255, 0)
					love.graphics.rectangle("fill", 80*scale, (100+(j-1)*14)*scale, math.floor(129*scale * (mariocolors[skinningplayer][j][2]/255)), 7*scale)
					
					love.graphics.setColor(0, 0, 100)
					love.graphics.rectangle("fill", 81*scale, (111+(j-1)*14)*scale, math.floor(129*scale * (mariocolors[skinningplayer][j][3]/255)), 7*scale)
					love.graphics.setColor(0, 0, 255)
					love.graphics.rectangle("fill", 80*scale, (110+(j-1)*14)*scale, math.floor(129*scale * (mariocolors[skinningplayer][j][3]/255)), 7*scale)
				end
			end
			
			--Portalhues
			--hue
			local alpha = 100
			if optionsselection == 13 then
				alpha = 255
			end
			
			love.graphics.setColor(255, 255, 255, alpha)
			
			properprint("coop portal 1 color:", 31*scale, 150*scale)
			
			love.graphics.draw(huebarimg, 32*scale, 170*scale, 0, scale, scale)
			
			--marker
			love.graphics.setColor(unpack(portalcolor[skinningplayer][1]))
			love.graphics.rectangle("fill", math.floor(29 + (portalhues[skinningplayer][1])*178)*scale, 161*scale, 7*scale, 6*scale)
			love.graphics.setColor(alpha, alpha, alpha)
			love.graphics.draw(huebarmarkerimg, math.floor(28 + (portalhues[skinningplayer][1])*178)*scale, 160*scale, 0, scale, scale)
			
			alpha = 100
			if optionsselection == 14 then
				alpha = 255
			end
			
			love.graphics.setColor(255, 255, 255, alpha)
			
			properprint("coop portal 2 color:", 31*scale, 180*scale)
			
			love.graphics.draw(huebarimg, 32*scale, 200*scale, 0, scale, scale)
			
			--marker
			love.graphics.setColor(unpack(portalcolor[skinningplayer][2]))
			love.graphics.rectangle("fill", math.floor(29 + (portalhues[skinningplayer][2])*178)*scale, 191*scale, 7*scale, 6*scale)
			love.graphics.setColor(alpha, alpha, alpha)
			love.graphics.draw(huebarmarkerimg, math.floor(28 + (portalhues[skinningplayer][2])*178)*scale, 190*scale, 0, scale, scale)
		elseif optionstab == 3 then
			if optionsselection == 2 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			properprint("scale:", 30*scale, 40*scale)
			properprint(scale, (180-string.len(scale)*8)*scale, 40*scale)
			
			
			if optionsselection == 3 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("shader1:", 30*scale, 55*scale)
			if shaderssupported == false then
				properprint("unsupported", (180-string.len("unsupported")*8)*scale, 55*scale)
			else
				properprint(string.lower(shaderlist[currentshaderi1]), (180-string.len(shaderlist[currentshaderi1])*8)*scale, 55*scale)
			end
			
			if optionsselection == 4 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			properprint("shader2:", 30*scale, 65*scale)
			if shaderssupported == false then
				properprint("unsupported", (180-string.len("unsupported")*8)*scale, 65*scale)
			else
				properprint(string.lower(shaderlist[currentshaderi2]), (180-string.len(shaderlist[currentshaderi2])*8)*scale, 65*scale)
			end
			
			love.graphics.setColor(100, 100, 100, 255)
			properprint("shaders will really", 30*scale, 80*scale)
			properprint("reduce performance!", 30*scale, 90*scale)
			
			if optionsselection == 5 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			properprint("volume:", 30*scale, 105*scale)
			drawrectangle(90, 108, 90, 1)
			drawrectangle(90, 105, 1, 7)
			drawrectangle(179, 105, 1, 7)
			love.graphics.draw(volumesliderimg, math.floor((89+89*volume)*scale), 105*scale, 0, scale, scale)
			
			if optionsselection == 6 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("reset game mappacks", 30*scale, 120*scale)
			
			if optionsselection == 7 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("reset all settings", 30*scale, 135*scale)
			
			if optionsselection == 8 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("vsync:", 30*scale, 150*scale)
			if vsync then
				properprint("on", (180-16)*scale, 150*scale)
			else
				properprint("off", (180-24)*scale, 150*scale)
			end
			
			love.graphics.setColor(100, 100, 100, 255)
			properprint("you can lock the|mouse with f12", 30*scale, 165*scale)
			
			love.graphics.setColor(255, 255, 255, 255)
			properprint(versionstring, 150*scale, 207*scale)
		elseif optionstab == 4 then
			love.graphics.setColor(255, 255, 255, 255)
			if not gamefinished then
				properprint("unlock this by completing", 30*scale, 40*scale)
				properprint("the original levels pack!", 30*scale, 50*scale)
			else
				properprint("have fun with these!", 30*scale, 45*scale)
			end
			
			if optionsselection == 2 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("mode:", 30*scale, 65*scale)
			properprint("{" .. playertype .. "}", (180-(string.len(playertype)+2)*8)*scale, 65*scale)
			
			if optionsselection == 3 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("knockback:", 30*scale, 80*scale)
			if portalknockback then
				properprint("on", (180-16)*scale, 80*scale)
			else
				properprint("off", (180-24)*scale, 80*scale)
			end
			
			if optionsselection == 4 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("bullettime:", 30*scale, 95*scale)
			properprint("use mousewheel", 30*scale, 105*scale)
			if bullettime then
				properprint("on", (180-16)*scale, 95*scale)
			else
				properprint("off", (180-24)*scale, 95*scale)
			end
			
			if optionsselection == 5 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("huge mario:", 30*scale, 120*scale)
			if bigmario then
				properprint("on", (180-16)*scale, 120*scale)
			else
				properprint("off", (180-24)*scale, 120*scale)
			end
			
			if optionsselection == 6 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("goomba attack:", 30*scale, 135*scale)
			if goombaattack then
				properprint("on", (180-16)*scale, 135*scale)
			else
				properprint("off", (180-24)*scale, 135*scale)
			end
			
			if optionsselection == 7 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("sonic rainboom:", 30*scale, 150*scale)
			if sonicrainboom then
				properprint("on", (180-16)*scale, 150*scale)
			else
				properprint("off", (180-24)*scale, 150*scale)
			end
			
			if optionsselection == 8 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("playercollision:", 30*scale, 165*scale)
			if playercollisions then
				properprint("on", (180-16)*scale, 165*scale)
			else
				properprint("off", (180-24)*scale, 165*scale)
			end
			
			if optionsselection == 9 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("infinite time:", 30*scale, 180*scale)
			if infinitetime then
				properprint("on", (180-16)*scale, 180*scale)
			else
				properprint("off", (180-24)*scale, 180*scale)
			end
			
			if optionsselection == 10 then
				love.graphics.setColor(255, 255, 255, 255)
			else
				love.graphics.setColor(100, 100, 100, 255)
			end
			
			properprint("infinite lives:", 30*scale, 195*scale)
			if infinitelives then
				properprint("on", (180-16)*scale, 195*scale)
			else
				properprint("off", (180-24)*scale, 195*scale)
			end
		end
	end
	love.graphics.translate(0, yoffset*scale)
end

function loadbackground(background)
	if love.filesystem.exists("mappacks/" .. mappack .. "/" .. background) == false then
	
		map = {}
		mapwidth = width
		for x = 1, width do
			map[x] = {}
			for y = 1, 13 do
				map[x][y] = {1}
			end
		
			for y = 14, 15 do
				map[x][y] = {2}
			end
		end
		startx = 3
		starty = 13
		custombackground = false
		backgroundi = 1
		love.graphics.setBackgroundColor(backgroundcolor[backgroundi])
	else
		local s = love.filesystem.read( "mappacks/" .. mappack .. "/" .. background )
		local s2 = s:split(";")
		
		--remove custom sprites
		for i = smbtilecount+portaltilecount+1, #tilequads do
			tilequads[i] = nil
		end
		
		for i = smbtilecount+portaltilecount+1, #rgblist do
			rgblist[i] = nil
		end
		
		--add custom tiles
		if love.filesystem.exists("mappacks/" .. mappack .. "/tiles.png") then
			customtiles = true
			customtilesimg = love.graphics.newImage("mappacks/" .. mappack .. "/tiles.png")
			local imgwidth, imgheight = customtilesimg:getWidth(), customtilesimg:getHeight()
			local width = math.floor(imgwidth/17)
			local height = math.floor(imgheight/17)
			local imgdata = love.image.newImageData("mappacks/" .. mappack .. "/tiles.png")
			
			for y = 1, height do
				for x = 1, width do
					table.insert(tilequads, quad:new(customtilesimg, imgdata, x, y, imgwidth, imgheight))
					local r, g, b = getaveragecolor(imgdata, x, y)
					table.insert(rgblist, {r, g, b})
				end
			end
			customtilecount = width*height
		else
			customtiles = false
			customtilecount = 0
		end
		
		--MAP ITSELF
		local t = s2[1]:split(",")
		
		if math.mod(#t, 15) ~= 0 then
			print("Incorrect number of entries: " .. #t)
			return false
		end
		
		mapwidth = #t/15
		startx = 3
		starty = 13
		
		map = {}
		
		for y = 1, 15 do
			for x = 1, #t/15 do
				if y == 1 then
					map[x] = {}
				end
				
				map[x][y] = t[(y-1)*(#t/15)+x]:split("-")
				
				r = map[x][y]
				
				if #r > 1 then
					if entityquads[tonumber(r[2])].t == "spawn" then
						startx = x
						starty = y
					end
				end
				
				if tonumber(r[1]) > smbtilecount+portaltilecount+customtilecount then
					r[1] = 1
				end
			end
		end
		
		--get background color
		custombackground = false
		
		for i = 2, #s2 do
			s3 = s2[i]:split("=")
			if s3[1] == "background" then
				local backgroundi = tonumber(s3[2])
		
				love.graphics.setBackgroundColor(backgroundcolor[backgroundi])
			elseif s3[1] == "spriteset" then
				spriteset = tonumber(s3[2])
			elseif s3[1] == "custombackground" or s3[1] == "portalbackground" then
				custombackground = true
			end
		end
		
		if custombackground then
			loadcustombackground()
		end
	end
end

function updatescroll()
	--check if current focus is completely onscreen
	if inrange(mappackselection, 1+mappackscroll, 3+mappackscroll, true) == false then
		if mappackselection < 1+mappackscroll then --above window
			mappackscroll = mappackselection-1
		else
			mappackscroll = mappackselection-3.233
		end
	end
end

function onlineupdatescroll()
	--check if current focus is completely onscreen
	if inrange(onlinemappackselection, 1+onlinemappackscroll, 3+onlinemappackscroll, true) == false then
		if onlinemappackselection < 1+onlinemappackscroll then --above window
			onlinemappackscroll = onlinemappackselection-1
		else
			onlinemappackscroll = onlinemappackselection-3.233
		end
	end
end

function mappacks()
	if mappackhorscroll == 0 then
		loadmappacks()
	else
		loadonlinemappacks()
	end
end

function loadmappacks()
	mappacktype = "local"
	mappacklist = love.filesystem.enumerate( "mappacks" )
	
	local delete = {}
	for i = 1, #mappacklist do
		if love.filesystem.exists( "mappacks/" .. mappacklist[i] .. "/version.txt") or not love.filesystem.exists( "mappacks/" .. mappacklist[i] .. "/settings.txt") then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(mappacklist, v) --remove
	end
	
	mappackicon = {}
	
	--get info
	mappackname = {}
	mappackauthor = {}
	mappackdescription = {}
	mappackbackground = {}
	
	for i = 1, #mappacklist do
		if love.filesystem.exists( "mappacks/" .. mappacklist[i] .. "/icon.png" ) then
			mappackicon[i] = love.graphics.newImage("mappacks/" .. mappacklist[i] .. "/icon.png")
		else
			mappackicon[i] = nil
		end
		
		mappackauthor[i] = ""
		mappackdescription[i] = ""
		mappackbackground[i] = "1-1"
		if love.filesystem.exists( "mappacks/" .. mappacklist[i] .. "/settings.txt" ) then		
			local s = love.filesystem.read( "mappacks/" .. mappacklist[i] .. "/settings.txt" )
			local s1 = s:split("\n")
			for j = 1, #s1 do
				local s2 = s1[j]:split("=")
				if s2[1] == "name" then
					mappackname[i] = s2[2]
				elseif s2[1] == "author" then
					mappackauthor[i] = s2[2]
				elseif s2[1] == "description" then
					mappackdescription[i] = s2[2]
				elseif s2[1] == "background" then
					mappackbackground[i] = s2[2]
				end
			end
		else
			mappackname[i] = mappacklist[i]
		end
	end
	
	table.insert(mappacklist, "custom_mappack")
	table.insert(mappackname, "{new mappack}")
	table.insert(mappackauthor, "you")
	table.insert(mappackdescription, "create a mappack from scratch withthis!")
	
	--get the current cursorposition
	for i = 1, #mappacklist do
		if mappacklist[i] == mappack then
			mappackselection = i
		end
	end
	
	mappack = mappacklist[mappackselection]
	
	--load background
	if mappackbackground[mappackselection] then
		loadbackground(mappackbackground[mappackselection] .. ".txt")
	else
		loadbackground("1-1.txt")
	end
	
	mappackscroll = 0
	updatescroll()
	mappackscrollsmooth = mappackscroll
end

function loadonlinemappacks()
	mappacktype = "online"
	downloadmappacks()
	onlinemappacklist = love.filesystem.enumerate( "mappacks" )
	
	local delete = {}
	for i = 1, #onlinemappacklist do
		if not love.filesystem.exists( "mappacks/" .. onlinemappacklist[i] .. "/version.txt") or not love.filesystem.exists( "mappacks/" .. onlinemappacklist[i] .. "/settings.txt") then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(onlinemappacklist, v) --remove
	end
	
	onlinemappackicon = {}
	
	--get info
	onlinemappackname = {}
	onlinemappackauthor = {}
	onlinemappackdescription = {}
	onlinemappackbackground = {}
	
	for i = 1, #onlinemappacklist do
		if love.filesystem.exists( "mappacks/" .. onlinemappacklist[i] .. "/icon.png" ) then
			onlinemappackicon[i] = love.graphics.newImage("mappacks/" .. onlinemappacklist[i] .. "/icon.png")
		else
			onlinemappackicon[i] = nil
		end
		
		onlinemappackauthor[i] = nil
		onlinemappackdescription[i] = nil
		onlinemappackbackground[i] = nil
		if love.filesystem.exists( "mappacks/" .. onlinemappacklist[i] .. "/settings.txt" ) then		
			local s = love.filesystem.read( "mappacks/" .. onlinemappacklist[i] .. "/settings.txt" )
			local s1 = s:split("\n")
			for j = 1, #s1 do
				local s2 = s1[j]:split("=")
				if s2[1] == "name" then
					onlinemappackname[i] = s2[2]
				elseif s2[1] == "author" then
					onlinemappackauthor[i] = s2[2]
				elseif s2[1] == "description" then
					onlinemappackdescription[i] = s2[2]
				elseif s2[1] == "background" then
					onlinemappackbackground[i] = s2[2]
				end
			end
		else
			onlinemappackname[i] = onlinemappacklist[i]
		end
	end
	
	--get the current cursorposition
	for i = 1, #onlinemappacklist do
		if onlinemappacklist[i] == mappack then
			onlinemappackselection = i
		end
	end
	
	if #onlinemappacklist >= 1 then
		mappack = onlinemappacklist[onlinemappackselection]
	end
	
	--load background
	if onlinemappackbackground[onlinemappackselection] then
		loadbackground(onlinemappackbackground[onlinemappackselection] .. ".txt")
	else
		loadbackground("1-1.txt")
	end
	
	onlinemappackscroll = 0
	onlineupdatescroll()
	onlinemappackscrollsmooth = onlinemappackscroll
end

function downloadmappacks()	
	downloaderror = false
	local onlinedata, code = http.request("http://server.stabyourself.net/mari0/index2.php?mode=mappacks")
	
	if code ~= 200 then
		downloaderror = true
		return false
	elseif not onlinedata then
		downloaderror = true
		return false
	end
	
	local maplist = {}
	local versionlist = {}
	local latestversion = marioversion
	
	local split1 = onlinedata:split("<")
	for i = 2, #split1 do
		local split2 = split1[i]:split(">")
		if split2[1] == "latestversion" then
			latestversion = tonumber(split2[2])
		elseif split2[1] == "mapfile" then
			table.insert(maplist, split2[2])
		elseif split2[1] == "version" then
			table.insert(versionlist, tonumber(split2[2]))
		end
	end
	
	if latestversion > marioversion then
		outdated = true
		return false
	end
	
	success = true
	
	--download all mappacks
	for i = 1, #maplist do
		--check if current version is equal or newer
		local version = 0
		if love.filesystem.exists("mappacks/" .. maplist[i] .. "/version.txt") then
			local data = love.filesystem.read("mappacks/" .. maplist[i] .. "/version.txt")
			if data then
				version = tonumber(data)
			end
		end
		
		if version < versionlist[i] then
			print("DOWNLOADING MAPPACK: " .. maplist[i])
			
			--draw
			currentdownload = i
			downloadcount = #maplist
			
			if love.filesystem.exists("mappacks/" .. maplist[i] .. "/") then
				love.filesystem.remove("mappacks/" .. maplist[i] .. "/")
			end
			
			love.filesystem.mkdir("mappacks/" .. maplist[i])
			local onlinedata, code = http.request("http://server.stabyourself.net/mari0/index2.php?mode=getmap&get=" .. maplist[i])
			
			if code == 200 then
				filecount = 0
				local checksums = {}
				
				local split1 = onlinedata:split("<")
				for j = 2, #split1 do
					local split2 = split1[j]:split(">")
					if split2[1] == "asset" then
						filecount = filecount + 1
					elseif split2[1] == "checksum" then
						table.insert(checksums, split2[2])
					end
				end
				
				currentfiledownload = 1
				
				local split1 = onlinedata:split("<")
				for j = 2, #split1 do
					local split2 = split1[j]:split(">")
					if split2[1] == "asset" then
						loadingonlinemappacks = true
						love.graphics.clear()
						love.draw()
						love.graphics.present()
						loadingonlinemappacks = false
						
						local target = "mappacks/" .. maplist[i] .. "/" .. split2[2]:match("([^/]-)$")
						
						local tries = 0
						success = false
						while not success and tries < 3 do
							success = downloadfile(split2[2], target, checksums[currentfiledownload])
							tries = tries + 1
						end
						
						if not success then
							break
						end
						currentfiledownload = currentfiledownload + 1
					end
				end
				if success then
					love.filesystem.write( "mappacks/" .. maplist[i] .. "/version.txt", versionlist[i])
				end
			else
				success = false
			end
		end
		
		--Delete stuff and stuff.
		if not success then
			if love.filesystem.exists("mappacks/" .. maplist[i] .. "/") then
				local list = love.filesystem.enumerate("mappacks/" .. maplist[i] .. "/")
				for j = 1, #list do
					love.filesystem.remove("mappacks/" .. maplist[i] .. "/" .. list[j])
				end
				
				love.filesystem.remove("mappacks/" .. maplist[i] .. "/")
			end
			downloaderror = true
			break
		else
			print("Download succeeded.")
		end
	end
	
	return true
end

function menu_keypressed(key, unicode)
	if gamestate == "menu" then
		if selectworldopen then
			if (key == "right" or key == "d") then
				local target = selectworldcursor+1
				while target < 9 and not reachedworlds[mappack][target] do
					target = target + 1
				end
				if target < 9 then
					selectworldcursor = target
				end
			elseif (key == "left" or key == "a") then
				local target = selectworldcursor-1
				while target > 0 and not reachedworlds[mappack][target] do
					target = target - 1
				end
				if target > 0 then
					selectworldcursor = target
				end
			elseif (key == "return" or key == "enter" or key == "kpenter" or key == " ") then
				selectworldopen = false
				game_load(selectworldcursor)
			elseif key == "escape" then
				selectworldopen = false
			end
			return
		end
		if (key == "up" or key == "w") then
			if continueavailable then
				if selection > 0 then
					selection = selection - 1
				end
			else
				if selection > 1 then
					selection = selection - 1
				end
			end
		elseif (key == "down" or key == "s") then
			if selection < 4 then
				selection = selection + 1
			end
		elseif (key == "return" or key == "enter" or key == "kpenter" or key == " ") then
			if selection == 0 then
				game_load(true)
			elseif selection == 1 then
				selectworld()
			elseif selection == 2 then
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
			elseif selection == 3 then
				gamestate = "mappackmenu"
				mappacks()
			elseif selection == 4 then
				gamestate = "options"
			end
		elseif key == "escape" then
			love.event.quit()
		elseif (key == "left" or key == "a") then
			if players > 1 then
				players = players - 1
			end
		elseif (key == "right" or key == "d") then
			players = players + 1
			if players > 4 then
				players = 4
			end
		end
	elseif gamestate == "mappackmenu" then
		if (key == "up" or key == "w") then
			if mappacktype == "local" then
				if mappackselection > 1 then
					mappackselection = mappackselection - 1
					mappack = mappacklist[mappackselection]
					
					--load background
					if mappackbackground[mappackselection] then
						loadbackground(mappackbackground[mappackselection] .. ".txt")
					else
						loadbackground("1-1.txt")
					end
					
					updatescroll()
				end
			else
				if onlinemappackselection > 1 then
					onlinemappackselection = onlinemappackselection - 1
					mappack = onlinemappacklist[onlinemappackselection]
					
					--load background
					if onlinemappackbackground[onlinemappackselection] then
						loadbackground(onlinemappackbackground[onlinemappackselection] .. ".txt")
					else
						loadbackground("1-1.txt")
					end
					
					onlineupdatescroll()
				end
			end
		elseif (key == "down" or key == "s") then
			if mappacktype == "local" then
				if mappackselection < #mappacklist then
					mappackselection = mappackselection + 1
					mappack = mappacklist[mappackselection]
					
					--load background
					if mappackbackground[mappackselection] then
						loadbackground(mappackbackground[mappackselection] .. ".txt")
					else
						loadbackground("1-1.txt")
					end
					
					updatescroll()
				end
			else
				if onlinemappackselection < #onlinemappacklist then
					onlinemappackselection = onlinemappackselection + 1
					mappack = onlinemappacklist[onlinemappackselection]
					
					--load background
					if onlinemappackbackground[onlinemappackselection] then
						loadbackground(onlinemappackbackground[onlinemappackselection] .. ".txt")
					else
						loadbackground("1-1.txt")
					end
					
					onlineupdatescroll()
				end
			end	
		elseif key == "escape" or (key == "return" or key == "enter" or key == "kpenter" or key == " ") then
			gamestate = "menu"
			saveconfig()
			if mappack == "custom_mappack" then
				createmappack()
			end
		elseif (key == "right" or key == "d") then
			loadonlinemappacks()
			mappackhorscroll = 1
		elseif (key == "left" or key == "a") then
			loadmappacks()
			mappackhorscroll = 0
		elseif key == "m" then
			if not openSaveFolder("mappacks") then
				savefolderfailed = true
			end
		end
	elseif gamestate == "onlinemenu" then
		if CLIENT == false and SERVER == false then
			if key == "c" then
				client_load()
			elseif key == "s" then
				server_load()
			end
		elseif SERVER then
			if (key == "return" or key == "enter" or key == "kpenter" or key == " ") then
				server_start()
			end
		end
	elseif gamestate == "options" then
		if optionsselection == 1 then
			if (key == "left" or key == "a") then
				if optionstab > 1 then
					optionstab = optionstab - 1
				end
			elseif (key == "right" or key == "d") then
				if optionstab < 4 then
					optionstab = optionstab + 1
				end
			end
		elseif optionsselection == 2 then
			if (key == "left" or key == "a") then
				if optionstab == 2 or optionstab == 1 then
					if skinningplayer > 1 then
						skinningplayer = skinningplayer - 1
					end
				end
			elseif (key == "right" or key == "d") then
				if optionstab == 2 or optionstab == 1 then
					if skinningplayer < 4 then
						skinningplayer = skinningplayer + 1
						if players > #controls then
							loadconfig()
						end
					end
				end
			end
		end
		
		if (key == "return" or key == "enter" or key == "kpenter" or key == " ") then
			if optionstab == 1 then
				if optionsselection == 3 then
					if mouseowner == skinningplayer then
						mouseowner = 0
					else
						mouseowner = skinningplayer
					end
				elseif optionsselection > 3 then
					keypromptstart()
				end
			elseif optionstab == 3 then
				if optionsselection == 6 then
					reset_mappacks()
				elseif optionsselection == 7 then
					resetconfig()
				end
			end
		elseif (key == "down" or key == "s") then
			if optionstab == 1 then
				if skinningplayer ~= mouseowner then
					if optionsselection < 15 then
						optionsselection = optionsselection + 1
					else
						optionsselection = 1
					end
				else
					if optionsselection < 11 then
						optionsselection = optionsselection + 1
					else
						optionsselection = 1
					end
				end
			elseif optionstab == 2 then
				if optionsselection < 14 then
					optionsselection = optionsselection + 1
				else
					optionsselection = 1
				end
			elseif optionstab == 3 then
				if optionsselection < 8 then
					optionsselection = optionsselection + 1
				else
					optionsselection = 1
				end
			elseif optionstab == 4 and gamefinished then
				if optionsselection < 10 then
					optionsselection = optionsselection + 1
				else
					optionsselection = 1
				end
			end
		elseif (key == "up" or key == "w") then
			if optionsselection > 1 then
				optionsselection = optionsselection - 1
			else
				if optionstab == 1 then
					if skinningplayer ~= mouseowner then
						optionsselection = 15
					else
						optionsselection = 11
					end
				elseif optionstab == 2 then
					optionsselection = 14
				elseif optionstab == 3 then
					optionsselection = 8
				elseif optionstab == 4 and gamefinished then
					optionsselection = 10
				end
			end
		elseif (key == "right" or key == "d") then
			if optionstab == 2 then
				if optionsselection == 3 then
					if mariohats[skinningplayer][1] == nil then
						mariohats[skinningplayer][1] = 1
					elseif mariohats[skinningplayer][1] < #hat then
						mariohats[skinningplayer][1] = mariohats[skinningplayer][1] + 1
					end
				end
			elseif optionstab == 3 then
				if optionsselection == 2 then
					if scale < 5 then
						changescale(scale+1)
					end
				elseif optionsselection == 3 then
					currentshaderi1 = currentshaderi1 + 1
					if currentshaderi1 > #shaderlist then
						currentshaderi1 = 1
					end
					if shaderlist[currentshaderi1] == "none" then
						shaders:set(1, nil)
					else
						shaders:set(1, shaderlist[currentshaderi1])
					end
					
				elseif optionsselection == 4 then
					currentshaderi2 = currentshaderi2 + 1
					if currentshaderi2 > #shaderlist then
						currentshaderi2 = 1
					end
					if shaderlist[currentshaderi2] == "none" then
						shaders:set(2, nil)
					else
						shaders:set(2, shaderlist[currentshaderi2])
					end
					
				elseif optionsselection == 5 then
					if volume < 1 then
						volume = volume + 0.1
						if volume > 1 then
							volume = 1
						end
						love.audio.setVolume( volume )
						playsound(coinsound)
						soundenabled = true
					end
				elseif optionsselection == 8 then
					vsync = not vsync
					changescale(scale)
				end
			elseif optionstab == 4 then
				if optionsselection == 2 then
					playertypei = playertypei + 1
					if playertypei > #playertypelist then
						playertypei = 1
					end
					playertype = playertypelist[playertypei]
					if playertype == "minecraft" then
						portalknockback = false
						bullettime = false
						bigmario = false
						sonicrainboom = false
					elseif playertype == "gelcannon" then
						sonicrainboom = false
					end
				elseif optionsselection == 3 then
					portalknockback = not portalknockback
					if portalknockback then
						if playertype == "minecraft" then
							playertypei = 1
							playertype = "portal"
						end
					end
				elseif optionsselection == 4 then
					bullettime = not bullettime
					if bullettime then
						if playertype == "minecraft" then
							playertypei = 1
							playertype = "portal"
						end
					end
				elseif optionsselection == 5 then
					bigmario = not bigmario
					if bigmario then
						if playertype == "minecraft" then
							playertypei = 1
							playertype = "portal"
						end
					end
				elseif optionsselection == 6 then
					goombaattack = not goombaattack
				elseif optionsselection == 7 then
					sonicrainboom = not sonicrainboom
					playertype = "portal"
					playertypei = 1
				elseif optionsselection == 8 then
					playercollisions = not playercollisions
				elseif optionsselection == 9 then
					infinitetime = not infinitetime
				elseif optionsselection == 10 then
					infinitelives = not infinitelives
				end
			end				
		elseif (key == "left" or key == "a") then
			if optionstab == 2 then
				if optionsselection == 3 then
					if mariohats[skinningplayer][1] == 1 then
						mariohats[skinningplayer] = {}
					elseif mariohats[skinningplayer][1] and mariohats[skinningplayer][1] > 1 then
						mariohats[skinningplayer][1] = mariohats[skinningplayer][1] - 1
					end
				end
			elseif optionstab == 3 then
				if optionsselection == 2 then
					if scale > 1 then
						changescale(scale-1)
					end
				elseif optionsselection == 3 then
					currentshaderi1 = currentshaderi1 - 1
					if currentshaderi1 < 1 then
						currentshaderi1 = #shaderlist
					end
					
					if shaderlist[currentshaderi1] == "none" then
						shaders:set(1, nil)
					else
						shaders:set(1, shaderlist[currentshaderi1])
					end
				elseif optionsselection == 4 then
					currentshaderi2 = currentshaderi2 - 1
					if currentshaderi2 < 1 then
						currentshaderi2 = #shaderlist
					end
					
					if shaderlist[currentshaderi2] == "none" then
						shaders:set(2, nil)
					else
						shaders:set(2, shaderlist[currentshaderi2])
					end
					
				elseif optionsselection == 5 then
					if volume > 0 then
						volume = volume - 0.1
						if volume <= 0 then
							volume = 0
							soundenabled = false
						end
						love.audio.setVolume( volume )
						playsound(coinsound)
					end
				elseif optionsselection == 8 then
					vsync = not vsync
					changescale(scale)
				end
			elseif optionstab == 4 then
				if optionsselection == 2 then
					playertypei = playertypei - 1
					if playertypei < 1 then
						playertypei = #playertypelist
					end
					playertype = playertypelist[playertypei]
					if playertype == "minecraft" then
						portalknockback = false
						bullettime = false
						bigmario = false
						sonicrainboom = false
					elseif playertype == "gelcannon" then
						sonicrainboom = false
					end
				elseif optionsselection == 3 then
					portalknockback = not portalknockback
					if portalknockback then
						if playertype == "minecraft" then
							playertypei = 1
							playertype = "portal"
						end
					end
				elseif optionsselection == 4 then
					bullettime = not bullettime
					if bullettime then
						if playertype == "minecraft" then
							playertypei = 1
							playertype = "portal"
						end
					end
				elseif optionsselection == 5 then
					bigmario = not bigmario
					if bigmario then
						if playertype == "minecraft" then
							playertypei = 1
							playertype = "portal"
						end
					end
				elseif optionsselection == 6 then
					goombaattack = not goombaattack
				elseif optionsselection == 7 then
					sonicrainboom = not sonicrainboom
					playertype = "portal"
					playertypei = 1
				elseif optionsselection == 8 then
					playercollisions = not playercollisions
				elseif optionsselection == 9 then
					infinitetime = not infinitetime
				elseif optionsselection == 10 then
					infinitelives = not infinitelives
				end
			end
		elseif key == "escape" then
			gamestate = "menu"
			saveconfig()
		end
	end
end

function menu_keyreleased(key, unicode)

end

function menu_mousepressed(x, y, button)

end

function menu_mousereleased(x, y, button)

end

function menu_joystickpressed(joystick, button)

end

function menu_joystickreleased(joystick, button)

end

function keypromptenter(t, ...)
	arg = {...}
	if t == "key" and (arg[1] == ";" or arg[1] == "," or arg[1] == "," or arg[1] == "-") then
		return
	end
	buttonerror = false
	axiserror = false
	local buttononly = {"run", "jump", "reload", "use", "portal1", "portal2"}
	local axisonly = {"aimx", "aimy"}
	if t ~= "key" or arg[1] ~= "escape" then
		if t == "key" then
			if tablecontains(axisonly, controlstable[optionsselection-3]) then
				axiserror = true
			else
				controls[skinningplayer][controlstable[optionsselection-3]] = {arg[1]}
			end
		elseif t == "joybutton" then
			if tablecontains(axisonly, controlstable[optionsselection-3]) then
				axiserror = true
			else
				controls[skinningplayer][controlstable[optionsselection-3]] = {"joy", arg[1], "but", arg[2]}
			end
		elseif t == "joyhat" then
			if tablecontains(buttononly, controlstable[optionsselection-3]) then
				buttonerror = true
			elseif tablecontains(axisonly, controlstable[optionsselection-3]) then
				axiserror = true
			else
				controls[skinningplayer][controlstable[optionsselection-3]] = {"joy", arg[1], "hat", arg[2], arg[3]}
			end
		elseif t == "joyaxis" then
			if tablecontains(buttononly, controlstable[optionsselection-3]) then
				buttonerror = true
			else
				controls[skinningplayer][controlstable[optionsselection-3]] = {"joy", arg[1], "axe", arg[2], arg[3]}
			end
		end
	end
	
	if (not buttonerror and not axiserror) or arg[1] == "escape" then
		keyprompt = false
	end
end

function keypromptstart()
	keyprompt = true
	buttonerror = false
	axiserror = false
	
	--save number of stuff
	prompt = {}
	prompt.joystick = {}
	prompt.joysticks = love.joystick.getNumJoysticks()
	
	for i = 1, prompt.joysticks do
		prompt.joystick[i] = {}
		prompt.joystick[i].hats = love.joystick.getNumHats(i)
		prompt.joystick[i].axes = love.joystick.getNumAxes(i)
		
		prompt.joystick[i].validhats = {}
		for j = 1, prompt.joystick[i].hats do
			if love.joystick.getHat(i, j) == "c" then
				table.insert(prompt.joystick[i].validhats, j)
			end
		end
		
		prompt.joystick[i].axisposition = {}
		for j = 1, prompt.joystick[i].axes do
			table.insert(prompt.joystick[i].axisposition, love.joystick.getAxis(i, j))
		end
	end
end

function downloadfile(url, target, checksum)
	local data, code = http.request(url)
	
	if code ~= 200 then
		return false
	end
	
	if checksum ~= sha1(data) then
		print("Checksum doesn't match!")
		return false
	end
	
	if data then
		love.filesystem.write(target, data)
		return true
	else
		return false
	end
end

function reset_mappacks()
	delete_mappack("smb")
	delete_mappack("portal")
	
	loadbackground("1-1.txt")
	
	playsound(oneupsound)
end

function delete_mappack(pack)
	if not love.filesystem.exists("mappacks/" .. pack .. "/") then
		return false
	end
	
	local list = love.filesystem.enumerate("mappacks/" .. pack .. "/")
	for i = 1, #list do
		love.filesystem.remove("mappacks/" .. pack .. "/" .. list[i])
	end
	
	love.filesystem.remove("mappacks/" .. pack .. "/")
end

function createmappack()
	local i = 1
	while love.filesystem.exists("mappacks/custom_mappack_" .. i .. "/") do
		i = i + 1
	end
	
	mappack = "custom_mappack_" .. i
	
	love.filesystem.mkdir("mappacks/" .. mappack .. "/")
	
	local s = ""
	s = s .. "name=new mappack" .. "\n"
	s = s .. "author=you" .. "\n"
	s = s .. "description=the newest best  mappack?" .. "\n"
	
	love.filesystem.write("mappacks/" .. mappack .. "/settings.txt", s)
end

function resetconfig()
	defaultconfig()
	
	changescale(scale)
	love.audio.setVolume(volume)
	currentshaderi1 = 1
	currentshaderi2 = 1
	shaders:set(1, nil)
	shaders:set(2, nil)
	saveconfig()
	loadbackground("1-1.txt")
end

function selectworld()
	if not reachedworlds[mappack] then
		game_load()
	end
	
	local noworlds = true
	for i = 2, 8 do
		if reachedworlds[mappack][i] then
			noworlds = false
			break
		end
	end
	
	if noworlds then
		game_load()
		return
	end
	
	selectworldopen = true
	selectworldcursor = 1
	
	selectworldexists = {}
	for i = 1, 8 do
		if love.filesystem.exists("mappacks/" .. mappack .. "/" .. i .. "-1.txt") then
			selectworldexists[i] = true
		end
	end
end