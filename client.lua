function client_load()
	message("===CLIENT===")
	message( "Attempting Connection to " .. ip .. ":" .. port .. ".." )
	client_createclient(ip, port)
end

function client_createclient(ip, port)
	pingtime = love.timer.getTime()
	CLIENT = true
	MyClient = lube.client("udp")
	MyClient:setCallback(umsg.recv)
	MyClient:setHandshake("bj")
	MyClient:connect(ip, port, true)
	MyClient:setPing(true, 5, "PING")
	clienttimeouttimer = 0
	playerupdatetimer = 0
	netplay = true
	
	--umsg.hook( "string", function)
	umsg.hook( "client_connectconfirm", client_connectconfirm)
	umsg.hook( "client_playerlistget", client_playerlistget)
	umsg.hook( "client_start", client_start)
	umsg.hook( "client_levelscreen", client_levelscreen)
	umsg.hook( "client_nextlevel", client_nextlevel)
	umsg.hook( "client_warpzone", client_warpzone)
	umsg.hook( "client_objectsync", client_objectsyncreceive)
	umsg.hook( "client_ping", client_ping)
	
	net_messages()
end

function client_update(dt)
	MyClient:update(dt)
	
	playerupdatetimer = playerupdatetimer + dt
	if playerupdatetimer > playerupdatedelay then
		net_playersyncsend()
		playerupdatetimer = math.mod(playerupdatetimer, playerupdatedelay)
	end
	
	clienttimeouttimer = clienttimeouttimer + dt
	if clienttimeouttimer > clienttimeout then
		message("Didn't receive a ping for " .. clienttimeout .. " seconds..")
		client_disconnect()
	end
end

function client_draw()
	
end

function client_disconnect(f)
	MyClient:disconnect()
	message("Disconnected!")
	net_quit(f)
end

function client_connectconfirm(s)
	currenttime = love.timer.getTime()
 	message("Successfully Connected! (" .. math.floor((currenttime - pingtime)*1000) .. "ms)")
	local args = s:split("~")
	netplayerid = tonumber(args[1])
	message("MotD: " .. args[2])
	message("Sending nickname..")
	
	--Send the following: Nick, hats, colors, portalcolors
	local msg = localnick .. "~"
	--hats:
	for i = 1, #mariohats[playerconfig] do
		msg = msg .. mariohats[playerconfig][i]
		if i ~= #mariohats[playerconfig] then
			msg = msg .. ";"
		else
			msg = msg .. "~"
		end
	end
	
	--colors:
	msg = msg .. mariocolors[playerconfig][1][1] .. "-" .. mariocolors[playerconfig][1][2] .. "-" .. mariocolors[playerconfig][1][3] .. ";"
	msg = msg .. mariocolors[playerconfig][2][1] .. "-" .. mariocolors[playerconfig][2][2] .. "-" .. mariocolors[playerconfig][2][3] .. ";"
	msg = msg .. mariocolors[playerconfig][3][1] .. "-" .. mariocolors[playerconfig][3][2] .. "-" .. mariocolors[playerconfig][3][3] .. "~"
	
	--portalcolors
	msg = msg .. portalcolor[playerconfig][1][1] .. "-" .. portalcolor[playerconfig][1][2] .. "-" .. portalcolor[playerconfig][1][3] .. ";"
	msg = msg .. portalcolor[playerconfig][2][1] .. "-" .. portalcolor[playerconfig][2][2] .. "-" .. portalcolor[playerconfig][2][3]
	
	local um = usermessage:new( "nickname", msg)	
	um:send()
	
	message("Entering Lobby..")
end

function client_playerlistget(s)
	playerlist = s:split("~")
	for i, v in pairs(playerlist) do
		local split = playerlist[i]:split("|")
		--hats
		local hats = split[4]:split(";")
		for k = 1, #hats do
			hats[k] = tonumber(hats[k])
		end
		
		--colors
		local colors = {}
		local s = split[5]:split(";")
		for k = 1, 3 do
			colors[k] = {}
			local s2 = s[k]:split("-")
			for j = 1, 3 do
				colors[k][j] = tonumber(s2[j])
			end
		end
		
		--portalcolors
		local colors2 = {}
		local s = split[6]:split(";")
		for k = 1, 2 do
			colors2[k] = {}
			local s2 = s[k]:split("-")
			for j = 1, 3 do
				colors2[k][j] = tonumber(s2[j])
			end
		end
		
		playerlist[i] = {id=tonumber(split[1]), nick=split[2], hats=hats, colors=colors, portalcolors=colors2}
		if split[3] == "true" then
			playerlist[i].connected = true
		else
			playerlist[i].connected = false
		end
		if not playerlist[i].ping then
			playerlist[i].ping = 0
		end
		
		if playerlist[i].connected then
			mariohats[playerlist[i].id] = playerlist[i].hats
			mariocolors[playerlist[i].id] = playerlist[i].colors
			portalcolor[playerlist[i].id] = playerlist[i].portalcolors
		end
	end
	message("New playerlist received:")
	
	players = 0
	for i = 1, #playerlist do
		if playerlist[i].connected then
			players = players + 1
		end
	end
	
	printplayerlist()
	
	if gamestate == "onlinemenu" then
		lobby_load()
	end
end

function client_start(s)
	local args = s:split("~")
	players = tonumber(args[1])
	netplayernumber = tonumber(args[2])
	message("Starting the game!")
	net_controls()
	
	print("players: " .. players .. " | my playernumber: " .. netplayernumber)
	
	deltatable = {}
	
	game_load()
	levelscreen_load("initial", nil, true)
end

function client_quit()
	MyClient:disconnect()
end

function client_levelscreen(s)
	message("Levelscreen loading.")
	args = s:split("~")
	levelscreen_load(args[1], tonumber(args[2]) or nil, true)
end

function client_nextlevel(s)
	nextlevel(true)
end

function client_warpzone(s)
	warpzone(s, true)
end

function client_objectsyncreceive(input)
	if objects then
		des = deserialize(input)
		local obj = des[1]
		local j = tonumber(des[2])
		if objects[obj][j] then
			for i = 3, #des, 2 do
				local t = string.sub(des[i], 1, 1)
				local varname = string.sub(des[i], 2, string.len(des[i]))
				local varvalue = des[i+1]
				
				if t == "b" then
					if varvalue == "true" then
						objects[obj][j][varname] = true
					else
						objects[obj][j][varname] = false
					end
				elseif t == "s" then
					objects[obj][j][varname] = varvalue
				elseif t == "n" then
					objects[obj][j][varname] = tonumber(varvalue)
				end
			end
		else
			print("Don't have object: " .. obj .. " " .. (j or "nil") .. "! This might be bad.")
		end
	end
end

function client_ping(s)
	local pingtable = s:split("~")
	local um = usermessage:new("server_pong", pingtable[1])
	um:send()
	table.remove(pingtable, 1)
	for i = 1, #pingtable do
		if not playerlist[i] then --Ping before playerlist update? Baaaaad.
			break
		end
		playerlist[i].ping = tonumber(pingtable[i])
	end
end