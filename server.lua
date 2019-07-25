function server_load()
	SERVER = true
	message("===SERVER===")
	server_createserver()
end

function server_createserver()
	SERVER = true
	allowconnects = true
	
	if not MyServer then
		MyServer = lube.server(port)
		MyServer:setCallback(umsg.recv,server_connect,server_disconnect)
		MyServer:setHandshake("bj")
		MyServer:setPing(true, 2, "PING")
	end
	
	umsg.hook( "playerlistrequest", server_playerlistrequest)
	umsg.hook( "nickname", server_nicknameget)
	umsg.hook( "server_pong", server_pong)
	
	playerlist = {{nick=localnick, id=1, connected=true, ping=0, hats=mariohats[playerconfig], colors=mariocolors[playerconfig], portalcolors=portalcolor[playerconfig]}}
	printplayerlist()
	
	net_messages()
	
	playerupdatetimer = 0
	objectupdatetimer = 0
	pingtimer = 0
	players = 1
	netplayernumber = 1
	netplayerid = 1
	netplay = true
	currentping = 1
	pingtime = {}
	
	message("Server started.")
	lobby_load()
end

function server_update(dt)
	MyServer:update(dt)
	
	playerupdatetimer = playerupdatetimer + dt
	if playerupdatetimer > playerupdatedelay then
		net_playersyncsend()
		playerupdatetimer = math.mod(playerupdatetimer, playerupdatedelay)
	end
	
	objectupdatetimer = objectupdatetimer + dt
	if objectupdatetimer > objectupdatedelay then
		server_objectsyncsend()
		objectupdatetimer = math.mod(objectupdatetimer, objectupdatedelay)
	end
	
	pingtimer = pingtimer + dt
	if pingtimer > pingdelay then
		getpings()
		pingtimer = math.mod(pingtimer, pingdelay)
	end
end

function server_draw()
	
end

function server_connect(id)
	id = id + 1
	message("New client connected: " .. id)
	if not allowconnects then
		local um = usermessage:new("net_error", "game_started")
		um:send(id)
		message(".. but we're not allowing connects right now so I told that guy to fuck off.")
		return
	end
	
	local um = usermessage:new("client_connectconfirm", id .. "~" .. motd)
	um:send(id)
end

function server_playerlistrequest(data, id)
	msg = playerlist[1].id .. "|" .. playerlist[1].nick .. "|" .. tostring(playerlist[1].connected) .. "|"
	--Send the following: hats, colors
	--hats:
	for j = 1, #playerlist[1].hats do
		msg = msg .. playerlist[1].hats[j]
		if j ~= #playerlist[1].hats then
			msg = msg .. ";"
		else
			msg = msg .. "|"
		end
	end
	
	--colors:
	msg = msg .. playerlist[1].colors[1][1] .. "-" .. playerlist[1].colors[1][2] .. "-" .. playerlist[1].colors[1][3] .. ";"
	msg = msg .. playerlist[1].colors[2][1] .. "-" .. playerlist[1].colors[2][2] .. "-" .. playerlist[1].colors[2][3] .. ";"
	msg = msg .. playerlist[1].colors[3][1] .. "-" .. playerlist[1].colors[3][2] .. "-" .. playerlist[1].colors[3][3] .. "|"
	
	--portalcolors
	msg = msg .. playerlist[1].portalcolors[1][1] .. "-" .. playerlist[1].portalcolors[1][2] .. "-" .. playerlist[1].portalcolors[1][3] .. ";"
	msg = msg .. playerlist[1].portalcolors[2][1] .. "-" .. playerlist[1].portalcolors[2][2] .. "-" .. playerlist[1].portalcolors[2][3]
		
	for i = 2, #playerlist do
		if playerlist[i] then
			msg = msg .. "~" .. playerlist[i].id .. "|" .. playerlist[i].nick .. "|" .. tostring(playerlist[i].connected) .. "|"
			--Send the following: hats, colors
			--hats:
			for j = 1, #playerlist[i].hats do
				msg = msg .. playerlist[i].hats[j]
				if j ~= #playerlist[i].hats then
					msg = msg .. ";"
				else
					msg = msg .. "|"
				end
			end
			
			--colors:
			msg = msg .. playerlist[i].colors[1][1] .. "-" .. playerlist[i].colors[1][2] .. "-" .. playerlist[i].colors[1][3] .. ";"
			msg = msg .. playerlist[i].colors[2][1] .. "-" .. playerlist[i].colors[2][2] .. "-" .. playerlist[i].colors[2][3] .. ";"
			msg = msg .. playerlist[i].colors[3][1] .. "-" .. playerlist[i].colors[3][2] .. "-" .. playerlist[i].colors[3][3] .. "|"
		
			--portalcolors
			msg = msg .. playerlist[i].portalcolors[1][1] .. "-" .. playerlist[i].portalcolors[1][2] .. "-" .. playerlist[i].portalcolors[1][3] .. ";"
			msg = msg .. playerlist[i].portalcolors[2][1] .. "-" .. playerlist[i].portalcolors[2][2] .. "-" .. playerlist[i].portalcolors[2][3]
		else
			msg = msg .. "~"
		end
	end
	
	local um = usermessage:new("client_playerlistget", msg)
	um:send(id)
	message("Sent new playerlist to player(s).")
end

function server_playerlistupdated()
	server_playerlistrequest()
	
	players = 0
	for i = 1, #playerlist do
		if playerlist[i].connected then
			mariohats[playerlist[i].id] = playerlist[i].hats
			mariocolors[playerlist[i].id] = playerlist[i].colors
			portalcolor[playerlist[i].id] = playerlist[i].portalcolors
			players = players + 1
		end
	end
	printplayerlist()
end

function server_nicknameget(data, id)
	local arg = data:split("~")
	
	--check if nickname in use
	local nick = arg[1]
	for i = 1, #playerlist do
		if string.lower(nick) == string.lower(playerlist[i].nick) then
			server_disconnect(id-1)
			local um = usermessage:new("net_error", "nickname_in_use")
			um:send(id)
			message("Nickname was already in use..")
			return
		end
	end
	
	--hats
	local hats = arg[2]:split(";")
	for i = 1, #hats do
		hats[i] = tonumber(hats[i])
	end
	
	--colors
	local colors = {}
	local s = arg[3]:split(";")
	for i = 1, 3 do
		colors[i] = {}
		local s2 = s[i]:split("-")
		for j = 1, 3 do
			colors[i][j] = tonumber(s2[j])
		end
	end
		
	--portalcolors
	local colors2 = {}
	local s = arg[4]:split(";")
	for k = 1, 2 do
		colors2[k] = {}
		local s2 = s[k]:split("-")
		for j = 1, 3 do
			colors2[k][j] = tonumber(s2[j])
		end
	end
	
	playerlist[id] = {id=id, nick=tostring(arg[1]), connected=true, ping=0, hats=hats, colors=colors, portalcolors=colors2}
	
	--send to all players
	server_playerlistupdated()
end

function server_disconnect(id)
	id = id + 1
	
	message("Client disconnect: " .. id)
	for i = 2, #playerlist do
		if playerlist[i].id == id then
			playerlist[i].connected = false
			print("removed player " .. i)
			break
		end
	end
	
	server_playerlistupdated()
end

function server_start()
	message("Starting the game!")
	allowconnects = false
	
	--fuck all the people who aren't connected
	print_r(playerlist)
	for i = #playerlist, 2, -1 do
		if not playerlist[i].connected then
			table.remove(playerlist, i)
			print("removed!")
		end
	end
	
	server_playerlistupdated()
	
	for i = 2, #playerlist do
		local um = usermessage:new("client_start", players .. "~" .. i)
		um:send(playerlist[i].id)
	end
	
	deltatable = {}
	
	net_controls()
	game_load()
end

function server_quit()
	
end

function server_objectsyncsend()
	if objects then
		for i, v in pairs(objects) do
			if i ~= "player" and i ~= "tile" and i ~= "screenboundary" and i ~= "lightbridgebody" and i ~= "gel" then
				for j, w in pairs(v) do
					if tonumber(j) ~= nil then
						local s = i .. "~" .. j .. "~" .. "ndummy~1"
						for k, u in pairs(objects[i][j]) do
							if type(u) == "table" then
							
							elseif type(u) == "number" then
								s = s .. "~n" .. k .. "~" .. tostring(u)
							
							elseif type(u) == "string" then
								s = s .. "~s" .. k .. "~" .. tostring(u)
							
							elseif type(u) == "boolean" then
								s = s .. "~b" .. k .. "~" .. tostring(u)
							else
								--s = s .. "~" .. k .. "~" .. tostring(u)
							end
						end
						local um = usermessage:new("client_objectsync", s)
						um:send()
					end
				end
			end
		end
	end
end

function server_pong(data, id)
	local currenttime = love.timer.getTime()
	local ping = (currenttime-pingtime[tonumber(data)])/2
	for i = 1, #playerlist do
		if playerlist[i].id == id then
			playerlist[i].ping = ping
		end
	end
end

function getpings()
	local s = currentping .. "~"
	for i = 1, #playerlist do
		s = s .. playerlist[i].ping
		if i ~= #playerlist then
			s = s .. "~"
		end
	end
	
	local um = usermessage:new("client_ping", s)
	pingtime[currentping] = love.timer.getTime()
	um:send()
	
	currentping = currentping + 1
end