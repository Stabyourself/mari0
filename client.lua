function client_load()
	CLIENT = true
	print("===CLIENT===")
	message( "Attempting Connection to " .. ip .. ":" .. port .. ".." )
	client_createclient(ip, port)
	updatetimer = 0
	players = 2
	client_controls()
	netplay = true
end

function client_controls()
	mouseowner = 2
	
	controls = {}
	
	local i = 2
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
	
	local i = 1 --unbind Player 1
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

function client_createclient(ip, port)
	pingtime = love.timer.getTime()
	CLIENT = true
	MyClient = lube.client("udp")
	MyClient:setCallback(umsg.recv)
	MyClient:setHandshake("bj")
	MyClient:connect(ip, port)
	MyClient:setPing(true, 5, "PING")
	
	--umsg.hook( "string", function)
	umsg.hook( "client_connectconfirm", client_connectconfirm)
	umsg.hook( "client_playerlistget", client_playerlistget)
	umsg.hook( "client_start", client_start)
	umsg.hook( "client_synctest", client_synctest)
	umsg.hook( "shootportal", client_shootportal)
end

function client_update(dt)
	MyClient:update(dt)
	
	updatetimer = updatetimer + dt
	if updatetimer > updatedelay then
		if objects then
			local s = "ndummy~1"
			for i, v in pairs(objects["player"][2]) do
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
			local um = usermessage:new("server_synctest", s)
			um:send()
		end
		
		updatetimer = 0
	end
end

function client_shootportal(args)
	args = args:split("~")
	shootportal(1, tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
end

function client_synctest(input)
	if objects then
		des = deserialize(input)
		for i = 1, #des, 2 do
			local t = string.sub(des[i], 1, 1)
			local varname = string.sub(des[i], 2, string.len(des[i]))
			local varvalue = des[i+1]
			if t == "b" then
				if varvalue == "true" then
					objects["player"][1][varname] = true
				else
					objects["player"][1][varname] = false
				end
			elseif t == "s" then
				objects["player"][1][varname] = varvalue
			elseif t == "n" then
				objects["player"][1][varname] = tonumber(varvalue)
			end
		end
	end
end

function client_connectconfirm(s)
	currenttime = love.timer.getTime()
 	message("Successfully Connected! (" .. math.floor((currenttime - pingtime)*1000) .. "ms)")
	message("MotD: " .. s)
	message("Sending nickname..")
	
	local um = usermessage:new( "nickname", localnick)	
	um:send()
	
	message("Entering Lobby..")
	message("Requesting playerlist..")
	message("---------------------------")
	
	local um = usermessage:new( "playerlistrequest" )
	um:send()
end

function client_playerlistget(s)
	playerlist = s:split("~")
	message("Playerlist received:")
	for i = 1, #playerlist do
		message(i .. ": " .. playerlist[i])
	end
	message("---------------------------")
end

function client_start(s)
	message("Starting the game!")
	game_load()
end

function client_quit()
	MyClient:disconnect()
	
end