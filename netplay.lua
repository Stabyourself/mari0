require "netplayinc/MiddleClass"
require "netplayinc/LUBE"
require "netplayinc/umsg"
require "server"
require "client"

motd = "No griefing, no TNT, minecraft servers suck."
chatmessages = {}
playerlist = {}
ip = "127.0.0.1"
port = 27644
playerupdatedelay = 0.05
objectupdatedelay = 0.5
pingdelay = 0.5
messages = {}
lagtable = {}
lagtime = 0

clienttimeout = 5 --Amount of time to go by without a new server ping until client decides that it got disconnected.

SERVER = false
CLIENT = false
netplay = false

function net_messages()
	umsg.hook( "net_shootportal", net_shootportal)
	umsg.hook( "net_createportal", net_createportal)
	umsg.hook( "net_playeruse", net_playeruse)
	umsg.hook( "net_removeportals", net_removeportals)
	umsg.hook( "net_pipeenter", net_pipeenter)
	umsg.hook( "net_hitblock", net_hitblock)
	umsg.hook( "net_playerflag", net_playerflag)
	umsg.hook( "net_playerdie", net_playerdie)
	umsg.hook( "net_playersync", net_playersyncreceive)
	umsg.hook( "net_playerstomp", net_playerstomp)
	umsg.hook( "net_reachedx", net_reachedx)
	umsg.hook( "net_mushroomeat", net_mushroomeat)
	umsg.hook( "net_flowereat", net_flowereat)
	umsg.hook( "net_error", net_error)
	umsg.hook( "net_receivechat", net_receivechat)
	umsg.hook( "net_sendchat", net_sendchat)
end

function netplay_update(dt)
	if SERVER then
		server_update(dt)
	elseif CLIENT then
		client_update(dt)
	end
	
	--Artificial lag
	for i = #lagtable, 1, -1 do
		local v = lagtable[i]
		
		v[1] = v[1] + dt
		if v[1] >= lagtime then
			umsg.recv2(v[2], v[3])
			table.remove(lagtable, i)
		end
	end
end

function netplay_draw()
	if SERVER or CLIENT then
		if SERVER then
			server_draw()
		elseif CLIENT then
			client_draw()
		end
	end
end

function net_error(err, id)
	if CLIENT then
		if err == "game_started" then
			message("ERROR! Game is already started.")
			client_disconnect(onlinemenu_load)
		elseif err == "nickname_in_use" then
			message("ERROR! Nickname already in use.")
			client_disconnect(onlinemenu_load)
		end
	elseif SERVER then
	
	end
end

function deserialize(str)
	output = str:split("~")
	return output
end

function serialize(str1,str2)
	return str1.."~"..str2
end

function message(s)
	print(os.date("%X", os.time()) .. " " .. s)
	table.insert(messages, os.date("%X", os.time()) .. " " .. s)
end

function serverforward(netmessage, s, id)
	if SERVER then
		for i = 2, #playerlist do
			if playerlist[i].id ~= id then
				local um = usermessage:new(netmessage, s)
				um:send(playerlist[i].id)
			end
		end
	end
end

function net_controls()
	mouseowner = netplayernumber
	
	controls = {}
	
	for i = 1, players do
		if i == netplayernumber then
			controls[i] = {}
			controls[i]["right"] = {"d"}
			controls[i]["left"] = {"a"}
			controls[i]["down"] = {"s"}
			controls[i]["up"] = {"w"}
			controls[i]["run"] = {"lshift"}
			controls[i]["jump"] = {" "}
			controls[i]["aimx"] = {""}
			controls[i]["aimy"] = {""}
			controls[i]["portal1"] = {""}
			controls[i]["portal2"] = {""}
			controls[i]["reload"] = {"r"}
			controls[i]["use"] = {"e"}
		else
			controls[i] = {}
			controls[i]["right"] = {""}
			controls[i]["left"] = {""}
			controls[i]["down"] = {""}
			controls[i]["up"] = {""}
			controls[i]["run"] = {""}
			controls[i]["jump"] = {""}
			controls[i]["aimx"] = {""}
			controls[i]["aimy"] = {""}
			controls[i]["portal1"] = {""}
			controls[i]["portal2"] = {""}
			controls[i]["reload"] = {""}
			controls[i]["use"] = {""}
		end
	end
end

function net_shootportal(s, id)
	args = s:split("~")
	shootportal(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), tonumber(args[5]), true)
	
	serverforward("net_shootportal", s, id)
end

function net_createportal(s, id)
	args = s:split("~")
	createportal(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), tonumber(args[4]), args[5], tonumber(args[6]), tonumber(args[7]), tonumber(args[8]), true)
	
	if SERVER then
		local um = usermessage:new( "net_createportal", s)	
		um:send()
	end
end

function net_playeruse(s, id)
	args = s:split("~")
	objects["player"][tonumber(args[1])]:use(tonumber(args[2]), tonumber(args[3]))
	
	serverforward("net_playeruse", s, id)
end

function net_removeportals(s, id)
	args = s:split("~")
	objects["player"][tonumber(args[1])]:removeportals(tonumber(args[2]))
	
	serverforward("net_removeportals", s, id)
end

function net_pipeenter(s, id)
	args = s:split("~")
	objects["player"][tonumber(args[1])]:pipe(tonumber(args[2]), tonumber(args[3]), args[4], tonumber(args[5]))
	
	serverforward("net_pipeenter", s, id)
end

function net_hitblock(s, id)
	args = s:split("~")
	hitblock(tonumber(args[2]), tonumber(args[3]), objects["player"][tonumber(args[1])], true)
	
	serverforward("net_hitblock", s, id)
end

function net_playerstomp(s, id)
	args = s:split("~")
	objects["player"][tonumber(args[1])]:stompenemy(args[2], objects[args[2]][tonumber(args[3])], nil, nil, true)
	
	serverforward("net_playerstomp", s, id)
end

function net_mushroomeat(s, id)
	args = s:split("~")
	objects["mushroom"][tonumber(args[1])]:eat(nil, objects["player"][tonumber(args[2])], tonumber(args[1]), tonumber(args[2]), true)
	
	serverforward("net_mushroomeat", s, id)
end

function net_flowereat(s, id)
	args = s:split("~")
	objects["flower"][tonumber(args[1])]:eat(nil, objects["player"][tonumber(args[2])], tonumber(args[1]), tonumber(args[2]), true)
	
	serverforward("net_flowereat", s, id)
end

function net_reachedx(s, id)
	reachedx(tonumber(s))
	serverforward("net_reachedx", s, id)
end

function net_playerflag(s, id)
	args = s:split("~")
	objects["player"][tonumber(args[1])]:flag(true)

	if SERVER then
		local um = usermessage:new("net_playerflag", s)
		um:send()
	end
end

function net_playerdie(s, id)
	args = s:split("~")
	objects["player"][tonumber(args[1])]:die(args[2], true)
	
	serverforward("net_playerdie", s, id)
end

function net_playersyncreceive(s, id)
	if objects then
		des = deserialize(s)
		local player = tonumber(des[1])
		for i = 2, #des, 2 do
			local t = string.sub(des[i], 1, 1)
			local varname = string.sub(des[i], 2, string.len(des[i]))
			local varvalue = des[i+1]
			if t == "b" then
				if varvalue == "true" then
					objects["player"][player][varname] = true
				else
					objects["player"][player][varname] = false
				end
			elseif t == "s" then
				objects["player"][player][varname] = varvalue
			elseif t == "n" then
				objects["player"][player][varname] = tonumber(varvalue)
			end
		end
		
		serverforward("net_playersync", s, id)
	end
end

function net_playersyncsend()
	if objects then
		for player = 1, players do
			if not objects["player"][player].remote then
				local s = player
				for i, v in pairs(objects["player"][player]) do
					
					--delta check
					if not deltatable[player] then
						deltatable[player] = {}
					end
					
					if deltatable[player][i] ~= v then
						local set = false
						
						if type(v) == "table" then
						
						elseif type(v) == "number" then
							s = s .. "~n" .. i .. "~" .. tostring(v)
							deltatable[player][i] = v
							
						elseif type(v) == "string" then
							s = s .. "~s" .. i .. "~" .. tostring(v)
							deltatable[player][i] = v
						
						elseif type(v) == "boolean" then
							s = s .. "~b" .. i .. "~" .. tostring(v)
							deltatable[player][i] = v
							
						else
							--s = s .. "~" .. i .. "~" .. tostring(v)
						end
					end
				end
				
				if not tonumber(s) then
					local um = usermessage:new("net_playersync", s)
					um:send()
				end
			end
		end
	end
end
	
function printplayerlist()
	message("---------------------------")
	for i = 1, #playerlist do
		local disconnected = ""
		if not playerlist[i].connected then
			disconnected = " (DISCONNECTED)"
		end
		message(playerlist[i].id .. ": " .. playerlist[i].nick .. disconnected)
	end
	message("---------------------------")
	message("players: " .. players)
	message("---------------------------")
end

function getpingcolor(ping)
	if ping < 40 then
		return 100, 255, 100
	elseif ping < 80 then
		return 255, 255, 100
	elseif ping < 120 then
		return 255, 178, 120
	else
		return 255, 100, 100
	end
end

function drawplayercard(x, y, colors, hats, name, ping, focus)
	local width = 150
	local height = 38
	
	love.graphics.setColor(0, 0, 0, 200)
	if focus then
		love.graphics.setColor(100, 100, 100, 200)
	end
		
	love.graphics.rectangle("fill", x*scale, y*scale, width*scale, height*scale)
	
	love.graphics.setColor(255, 255, 255)
	drawrectangle(x+1, y+1, width-2, height-2)
	
	----PLAYER
	for k = 1, 3 do
		love.graphics.setColor(unpack(colors[k]))
		love.graphics.drawq(characters.mario.animations[k], characters.mario.run[3][runanimationframe], (x-5)*scale, (y-1)*scale, 0, scale*2, scale*2)
	end
	
	--hats
	offsets = hatoffsets["running"][runanimationframe]
	if #hats > 0 then
		local yadd = 0
		for i = 1, #hats do
			if hats[i] == 1 then
				love.graphics.setColor(colors[1])
			else
				love.graphics.setColor(255, 255, 255)
			end
			
			love.graphics.draw(hat[hats[i]].graphic, (x-5)*scale, (y-1)*scale, 0, scale*2, scale*2, - hat[hats[i]].x + offsets[1], - hat[hats[i]].y + offsets[2] + yadd)
			yadd = yadd + hat[hats[i]].height
		end
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.drawq(characters.mario.animations[0], characters.mario.run[3][runanimationframe], (x-5)*scale, (y-1)*scale, 0, scale*2, scale*2)
	
	properprint(name, (x+34)*scale, (y+9)*scale)
	
	if ping then
		love.graphics.setColor(getpingcolor(ping))
		local pingtext = "ping: "
		if ping < 100 then
			pingtext = pingtext .. " "
		end
		if ping < 10 then
			pingtext = pingtext .. " "
		end
		properprint(pingtext .. ping .. "ms", (x+34)*scale, (y+21)*scale)
	else
		love.graphics.setColor(150, 150, 150)
		properprint("ping: ---ms", (x+34)*scale, (y+21)*scale)
	end	
end

function net_sendchat(s)
	local um = usermessage:new("net_receivechat", s)
	um:send()
	
	if SERVER then
		net_receivechat(s, 1)
	end
end

function net_receivechat(s, id)
	local arg = s:split("~")
	local pid = id
	if arg[2] then
		pid = arg[2]
	end
	chatmessage(arg[1], pid)
	
	if SERVER and id ~= 1 then
		local um = usermessage:new("net_receivechat", arg[1] .. "~" .. pid)
		um:send()
	end
end

function chatmessage(message, id)
	table.insert(chatmessages, {id=tonumber(id), message=message})
end

function net_quit(f)
	netplay = false
	
	if CLIENT then
		MyClient:disconnect()
	end
	
	if SERVER then
		if usemagic then
			magicdns_remove()
		end
	end
	
	SERVER = false
	CLIENT = false
	
	objects = nil
	
	if f then
		f()
	else
		menu_load()
	end
end