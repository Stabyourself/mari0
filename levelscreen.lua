function levelscreen_load(reason, i)
	if reason ~= "sublevel" and reason ~= "vine" and testlevel then
		marioworld = testlevelworld
		mariolevel = testlevellevel
		editormode = true
		testlevel = false
		startlevel(marioworld .. "-" .. mariolevel)
		return
	end

	checkcheckpoint = false
	
	--check if lives left
	livesleft = false
	for i = 1, players do
		if mariolivecount == false or mariolives[i] > 0 then
			livesleft = true
		end
	end
	
	if reason == "sublevel" then
		gamestate = "sublevelscreen"
		blacktime = sublevelscreentime
		sublevelscreen_level = i
	elseif reason == "vine" then
		gamestate = "sublevelscreen"
		blacktime = sublevelscreentime
		sublevelscreen_level = i
	elseif livesleft then
		gamestate = "levelscreen"
		blacktime = levelscreentime
		if reason == "next" then --next level
			respawnsublevel = 0
			checkpointx = nil
			
			--check if next level doesn't exist
			if not love.filesystem.exists("mappacks/" .. mappack .. "/" .. marioworld .. "-" .. mariolevel .. ".txt") then
				gamestate = "mappackfinished"
				blacktime = gameovertime
				music:play("princessmusic")
			end
		else
			checkcheckpoint = true
		end
	else
		gamestate = "gameover"
		blacktime = gameovertime
		playsound(gameoversound)
		checkpointx = nil
	end
	
	if editormode then
		blacktime = 0
	end
	
	if reason ~= "initial" then
		updatesizes()
	end
	
	if marioworld == 1 or mariolevel == 1 then
		blacktime = blacktime * 1.5
	end
	
	coinframe = 1
	
	love.graphics.setBackgroundColor(0, 0, 0)
	levelscreentimer = 0
	
	--reached worlds
	local updated = false
	if not reachedworlds[mappack] then
		reachedworlds[mappack] = {}
	end
	
	if marioworld ~= "M" and not reachedworlds[mappack][marioworld] then
		reachedworlds[mappack][marioworld] = true
		updated = true
	end
	
	if updated then
		saveconfig()
	end
end

function levelscreen_update(dt)
	levelscreentimer = levelscreentimer + dt
	if levelscreentimer > blacktime then
		if gamestate == "levelscreen" then
			gamestate = "game"
			if respawnsublevel ~= 0 then
				startlevel(marioworld .. "-" .. mariolevel .. "_" .. respawnsublevel)
			else
				startlevel(marioworld .. "-" .. mariolevel)
			end
		elseif gamestate == "sublevelscreen" then
			gamestate = "game"
			startlevel(sublevelscreen_level)
		else
			menu_load()
		end
		
		return
	end
end

function levelscreen_draw()
	if levelscreentimer < blacktime - blacktimesub and levelscreentimer > blacktimesub then
		love.graphics.setColor(255, 255, 255, 255)
		
		if gamestate == "levelscreen" then
			properprint("world " .. marioworld .. "-" .. mariolevel, (width/2*16)*scale-40*scale, 72*scale - (players-1)*6*scale)
			
			for i = 1, players do
				local x = (width/2*16)*scale-29*scale
				local y = (97 + (i-1)*20 - (players-1)*8)*scale
				
				for j = 1, 3 do
					love.graphics.setColor(unpack(mariocolors[i][j]))
					love.graphics.draw(skinpuppet[j], x, y, 0, scale, scale)
				end
		
				--hat
				
				offsets = hatoffsets["idle"]
				if #mariohats[i] > 1 or mariohats[i][1] ~= 1 then
					local yadd = 0
					for j = 1, #mariohats[i] do
						love.graphics.setColor(255, 255, 255)
						love.graphics.draw(hat[mariohats[i][j]].graphic, x-5*scale, y-2*scale, 0, scale, scale, - hat[mariohats[i][j]].x + offsets[1], - hat[mariohats[i][j]].y + offsets[2] + yadd)
						yadd = yadd + hat[mariohats[i][j]].height
					end
				elseif #mariohats[i] == 1 then
					love.graphics.setColor(mariocolors[i][1])
					love.graphics.draw(hat[mariohats[i][1]].graphic, x-5*scale, y-2*scale, 0, scale, scale, - hat[mariohats[i][1]].x + offsets[1], - hat[mariohats[i][1]].y + offsets[2])
				end
			
				love.graphics.setColor(255, 255, 255, 255)
				
				love.graphics.draw(skinpuppet[0], x, y, 0, scale, scale)
				
				if mariolivecount == false then
					properprint("*  inf", (width/2*16)*scale-8*scale, y+7*scale)
				else
					properprint("*  " .. mariolives[i], (width/2*16)*scale-8*scale, y+7*scale)
				end
				
				if mappack == "smb" and marioworld == 1 and mariolevel == 1 then
					local s = "remember that you can run with "
					for i = 1, #controls[1]["run"] do
						s = s .. controls[1]["run"][i]
						if i ~= #controls[1]["run"] then
							s = s .. "-"
						end
					end
					properprint(s, (width/2*16)*scale-string.len(s)*4*scale, 200*scale)
				end
				
				if mappack == "portal" and marioworld == 1 and mariolevel == 1 then
					local s = "you can remove your portals with "
					for i = 1, #controls[1]["reload"] do
						s = s .. controls[1]["reload"][i]
						if i ~= #controls[1]["reload"] then
							s = s .. "-"
						end
					end
					properprint(s, (width/2*16)*scale-string.len(s)*4*scale, 190*scale)
					
					local s = "you can grab cubes and push buttons with "
					for i = 1, #controls[1]["use"] do
						s = s .. controls[1]["use"][i]
						if i ~= #controls[1]["use"] then
							s = s .. "-"
						end
					end
					properprint(s, (width/2*16)*scale-string.len(s)*4*scale, 200*scale)
				end
			end
			
		elseif gamestate == "mappackfinished" then
			properprint("congratulations!", (width/2*16)*scale-64*scale, 120*scale)
			properprint("you have finished this mappack!", (width/2*16)*scale-128*scale, 140*scale)
		else
			properprint("game over", (width/2*16)*scale-40*scale, 120*scale)
		end
		
		love.graphics.translate(0, -yoffset*scale)
		if yoffset < 0 then
			love.graphics.translate(0, yoffset*scale)
		end
		
		properprint("mario", uispace*.5 - 24*scale, 8*scale)
		properprint(addzeros(marioscore, 6), uispace*0.5-24*scale, 16*scale)
		
		properprint("*", uispace*1.5-8*scale, 16*scale)
		
		love.graphics.drawq(coinanimationimage, coinanimationquads[2][coinframe], uispace*1.5-16*scale, 16*scale, 0, scale, scale)
		properprint(addzeros(mariocoincount, 2), uispace*1.5-0*scale, 16*scale)
		
		properprint("world", uispace*2.5 - 20*scale, 8*scale)
		properprint(marioworld .. "-" .. mariolevel, uispace*2.5 - 12*scale, 16*scale)
		
		properprint("time", uispace*3.5 - 16*scale, 8*scale)
	end
end
