function intro_load()
	gamestate = "intro"
	
	introduration = 2.5
	blackafterintro = 0.3
	introfadetime = 0.5
	introprogress = 0
	
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
			playsound("stab")
			
			playedwilhelm = true
		end
		
		if introprogress == introduration + blackafterintro then
			menu_load()
			shaders:set(1, shaderlist[currentshaderi1])
			shaders:set(2, shaderlist[currentshaderi2])
		end
	end
end

function intro_draw()	
	local logoscale = scale
	if logoscale <= 1 then
		logoscale = 0.5
	else
		logoscale = 1
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
			love.graphics.draw(logo, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, logoscale, logoscale, 142, 150)
			love.graphics.setScissor(0, love.graphics.getHeight()/2+150*logoscale - y, love.graphics.getWidth(), y)
			love.graphics.draw(logoblood, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, logoscale, logoscale, 142, 150)
			love.graphics.setScissor()
			
		elseif introprogress >= introduration - introfadetime then
			love.graphics.draw(logoblood, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, logoscale, logoscale, 142, 150)
		else
			love.graphics.draw(logo, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, logoscale, logoscale, 142, 150)
		end
		
		local a2 = math.max(0, (1-(introprogress-.5)/0.3)*255)
		love.graphics.setColor(100, 100, 100, a2)
		properprint("loading mari0 se..", love.graphics.getWidth()/2-string.len("loading mari0 se..")*4*scale, love.graphics.getHeight()/2-170*logoscale-7*scale)
		love.graphics.setColor(50, 50, 50, a)
		properprint(loadingtext, love.graphics.getWidth()/2-string.len(loadingtext)*4*scale, love.graphics.getHeight()/2+165*logoscale)
	end
end

function intro_mousepressed()
	if not allowskip then
		return
	end
	soundlist["stab"].source:stop()
	menu_load()
	shaders:set(1, shaderlist[currentshaderi1])
	shaders:set(2, shaderlist[currentshaderi2])
end

function intro_keypressed()
	if not allowskip then
		return
	end
	soundlist["stab"].source:stop()
	menu_load()
	shaders:set(1, shaderlist[currentshaderi1])
	shaders:set(2, shaderlist[currentshaderi2])
end