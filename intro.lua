function intro_load()
	gamestate = "intro"
	
	introduration = 2.5
	blackafterintro = 0.3
	introfadetime = 0.5
	introprogress = -0.2 
	
	screenwidth = 400*scale
	screenheight = 224*scale
	allowskip = false
end

function intro_update(dt)
	allowskip = true
	if introprogress < introduration+blackafterintro then
		introprogress = introprogress + dt
		if introprogress > introduration+blackafterintro then
			introprogress = introduration+blackafterintro
		end
		
		if introprogress > 0.5 and playedwilhelm == nil then
			playsound(stabsound)
			
			playedwilhelm = true
		end
		
		if introprogress == introduration + blackafterintro then
			menu_load()
		end
	end
end

function intro_draw()
	local scale = scale
	if scale <= 1 then
		scale = 0.5
	else
		scale = 1
	end
	if introprogress >= 0 and introprogress < introduration then
		local a = 255
		if introprogress < introfadetime then
			a = introprogress/introfadetime * 255
		elseif introprogress >= introduration-introfadetime then
			a = (1-(introprogress-(introduration-introfadetime))/introfadetime) * 255
		end
		
		love.graphics.setColor(255, 255, 255, a)
		
		if introprogress > introfadetime+0.3 and introprogress < introduration - introfadetime then
			local y = (introprogress-0.2-introfadetime) / (introduration-2*introfadetime) * 206 * 5
			love.graphics.draw(logo, screenwidth/2, screenheight/2, 0, scale, scale, 142, 150)
			love.graphics.setScissor(0, screenheight/2+150*scale - y, screenwidth, y)
			love.graphics.draw(logoblood, screenwidth/2, screenheight/2, 0, scale, scale, 142, 150)
			love.graphics.setScissor()
		elseif introprogress >= introduration - introfadetime then
			love.graphics.draw(logoblood, screenwidth/2, screenheight/2, 0, scale, scale, 142, 150)
		else
			love.graphics.draw(logo, screenwidth/2, screenheight/2, 0, scale, scale, 142, 150)
		end
	end
end

function intro_mousepressed()
	if not allowskip then
		return
	end
	stabsound:stop()
	menu_load()
end

function intro_keypressed()
	if not allowskip then
		return
	end
	stabsound:stop()
	menu_load()
end