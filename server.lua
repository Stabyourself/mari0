function server_load()
	SERVER = true
	message("===SERVER===")
	server_createserver()
	message("Server started.")
	updatetimer = 0
	players = 2
	server_controls()
	netplay = true
end

function server_controls()
	mouseowner = 1
	
	controls = {}
	
	local i = 1
	controls[i] = {}
	controls[i]["right"] = {"d"}
	controls[i]["left"] = {"a"}
	controls[i]["down"] = {"s"}
	controls[i]["run"] = {"lshift"}
	controls[i]["jump"] = {" "}
	controls[i]["aimX"] = {} --mouse aiming, so no need
	controls[i]["aimY"] = {}
	controls[i]["portal1"] = {}
	controls[i]["portal2"] = {}
	controls[i]["reload"] = {"r"}
	controls[i]["use"] = {"e"}
	
	local i = 2 --unbind Player 2
	controls[i] = {}
	controls[i]["right"] = {""}
	controls[i]["left"] = {""}
	controls[i]["down"] = {""}
	controls[i]["run"] = {""}
	controls[i]["jump"] = {""}
	controls[i]["aimX"] = {}
	controls[i]["aimY"] = {}
	controls[i]["portal1"] = {}
	controls[i]["portal2"] = {}
	controls[i]["reload"] = {""}
	controls[i]["use"] = {""}
end

function server_createserver()
	SERVER = true
	MyServer = lube.server(port)
	MyServer:setCallback(umsg.recv,server_connect,server_disconnect)
	MyServer:setHandshake("bj")
	MyServer:setPing(true, 5, "PING")
	
	umsg.hook( "playerlistrequest", server_playerlistrequest)
	umsg.hook( "nickname", server_nicknameget)
	umsg.hook( "server_synctest", server_synctest)
	umsg.hook( "shootportal", server_shootportal)
end

function server_update(dt)
	MyServer:update(dt)
	
	updatetimer = updatetimer + dt
	if updatetimer > updatedelay then
		if objects then
			local s = "ndummy~1"
			for i, v in pairs(objects["player"][1]) do
				if type(v) == "table" then
				
				elseif type(v) == "number" then
					s = s .. "~n" .. i .. "~" .. tostring(v)
				
				elseif type(v) == "string" then
					s = s .. "~s" .. i .. "~" .. tostring(v)
				
				elseif type(v) == "boolean" then
					s = s .. "~b" .. i .. "~" .. tostring(v)
				else
					s = s .. "~" .. i .. "~" .. tostring(v)
				end
			end
			local um = usermessage:new("client_synctest", s)
			um:send()
		end
		
		updatetimer = 0
	end
end

function server_shootportal(args)
	args = args:split("~")
	message("Player 2 shot portal #" .. args[1])
	shootportal(2, tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
end

function server_synctest(input)
	if objects then
		des = deserialize(input)
		for i = 1, #des, 2 do
			local t = string.sub(des[i], 1, 1)
			local varname = string.sub(des[i], 2, string.len(des[i]))
			local varvalue = des[i+1]
			if t == "b" then
				if varvalue == "true" then
					objects["player"][2][varname] = true
				else
					objects["player"][2][varname] = false
				end
			elseif t == "s" then
				objects["player"][2][varname] = varvalue
			elseif t == "n" then
				objects["player"][2][varname] = tonumber(varvalue)
			end
		end
	end
end

function server_connect(id)
	message("New client connected: " .. id)
	local um = usermessage:new("client_connectconfirm", motd)
	um:send(id)
end

function server_playerlistrequest(data, id)
	output = playerlist[1]
	for i = 1, #playerlist do
		output = output .. "~" .. playerlist[i]
	end
	
	local um = usermessage:new("client_playerlistget", output)
	um:send(id)
end

function server_nicknameget(data, id)
	playerlist[id] = tostring(data)
	message("Received player " .. id .. "'s nickname: " .. tostring(data))
end

function server_disconnect(id)
	table.remove(playerlist, id)
	message("Client disconnect: " .. id)
end

function server_start()
	message("Starting the game!")
	for i = 1, #playerlist do
		local um = usermessage:new("client_start", players .. "~" .. i+1)
		um:send()
	end
	game_load()
end

function server_quit()
	
end