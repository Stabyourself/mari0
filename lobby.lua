function lobby_load()
	gamestate = "lobby"
	guielements = {}
	guielements.chatentry = guielement:new("input", 4, 207, 43+7/8, sendchat, "", 43)
	guielements.sendbutton = guielement:new("button", 359, 207, "send", sendchat, 1)
	guielements.playerscroll = guielement:new("scrollbar", 389, 3, 104, 8, 50, 0)
	
	if SERVER then
		guielements.startbutton = guielement:new("button", 4, 80, "start game", server_start, 1)
	end
	guielements.quitbutton = guielement:new("button", 100, 80, "quit to menu", net_quit, 1)
	
	magicdns_timer = 0
	magicdns_delay = 30
end

function lobby_update(dt)
	runanimationtimer = runanimationtimer + dt
	while runanimationtimer > runanimationdelay do
		runanimationtimer = runanimationtimer - runanimationdelay
		runanimationframe = runanimationframe - 1
		if runanimationframe == 0 then
			runanimationframe = 3
		end
	end
	
	if SERVER then
		magicdns_timer = magicdns_timer + dt
		while magicdns_timer > magicdns_delay do
			magicdns_timer = magicdns_timer - magicdns_delay
			--this needs to be changed so the delay is like 2 seconds until the external port is known
			magicdns_keep()
		end
	end
end

function lobby_draw()
	--STUFF
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 3*scale, 3*scale, 233*scale, 104*scale)
	
	love.graphics.setColor(255, 255, 255, 255)
	if usemagic and adjective and noun then
		properprintbackground("magicdns: " .. adjective .. " " .. noun, 4*scale, 98*scale, true)
	end
	if SERVER then
		guielements.startbutton:draw()
	end
	guielements.quitbutton:draw()
	
	--PLAYERLIST
	love.graphics.setScissor(239*scale, 3*scale, 161*scale, 104*scale)
	
	local missingpixels = math.max(0, (players*41-3)-104)
	
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 239*scale, 3*scale, 150*scale, 104*scale)
	
	love.graphics.translate(0, -missingpixels*guielements.playerscroll.value*scale)
	
	local y = 1
	for i = 1, #playerlist do
		if playerlist[i].connected then
			local focus = netplayerid == playerlist[i].id
			local ping = nil
			if i > 1 then
				ping = round(playerlist[i].ping*1000)
			end
			drawplayercard(239, (y-1)*41+3, playerlist[i].colors, playerlist[i].hats, playerlist[i].nick, ping, focus)
			y = y + 1
		end
	end
	
	love.graphics.translate(0, missingpixels*guielements.playerscroll.value*scale)
	guielements.playerscroll:draw()
	love.graphics.setScissor()
	
	--chat
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 3*scale, 110*scale, 394*scale, 111*scale)
	love.graphics.setColor(255, 255, 255, 255)
	drawrectangle(4, 111, 392, 109)
	
	guielements.chatentry:draw()
	guielements.sendbutton:draw()
	
	--chat messages
	local height = 0
	for i = #chatmessages, math.max(1, #chatmessages-8), -1 do
		--find playerlist number
		local pid = 0
		for j = 1, #playerlist do
			if playerlist[j].id == chatmessages[i].id then
				pid = j
				break
			end
		end
		
		if pid ~= 0 then
			local nick = playerlist[pid].nick
			
			local background = {255, 255, 255}
			
			local adds = 0
			for i = 1, 3 do
				adds = adds + playerlist[pid].colors[1][i]
			end
			
			if adds/3 > 40 then
				background = {0, 0, 0}
			end
			
			love.graphics.setColor(unpack(playerlist[pid].colors[1]))
			properprintbackground(nick, 8*scale, (196-(height*10))*scale, true, background)
			
			love.graphics.setColor(255, 255, 255)
			properprint(":" .. chatmessages[i].message, (8+(string.len(nick))*8)*scale, (196-(height*10))*scale)
			height = height + 1
		end
	end
end

function sendchat()
	net_sendchat(guielements.chatentry.value)
	guielements.chatentry.value = ""
	guielements.chatentry.cursorpos = 1
	guielements.chatentry.inputting = true
end