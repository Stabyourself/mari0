function onlinemenu_load()
	objects = nil
	mappack = "smb"
	
	gamestate = "onlinemenu"
	
	localnicks = {"littlepip", "velvet remedy", "calamity", "homage", "blackjack", "fallen glory", "p21", "rampage", "puppysmiles", "clover", "hired gun", "serenity"}
	localnick = localnicks[math.random(#localnicks)]
	
	guielements = {}
	guielements.nickentry = guielement:new("input", 5, 30, 14, nil, localnick, 14, 1)
	
	guielements.configdecrease = guielement:new("button", 192, 31, "{", configdecrease, 0)
	guielements.configincrease = guielement:new("button", 214, 31, "}", configincrease, 0)
	
	
	guielements.ipentry = guielement:new("input", 6, 87, 23, joingame, "", 23, 1)
	guielements.portentry2 = guielement:new("input", 131, 145, 5, nil, "7331", 5, 1, true)
	
	guielements.portentry = guielement:new("input", 274, 87, 5, nil, "7331", 5, 1, true)
	
	guielements.magiccheckbox = guielement:new("checkbox", 220, 147, togglemagic, true)
	
	guielements.hostbutton = guielement:new("button", 247, 199, "create game", creategame, 2)
	guielements.hostbutton.bordercolor = {255, 0, 0}
	guielements.hostbutton.bordercolorhigh = {255, 127, 127}
	
	guielements.joinbutton = guielement:new("button", 61, 199, "join game", joingame, 2)
	guielements.joinbutton.bordercolor = {0, 255, 0}
	guielements.joinbutton.bordercolorhigh = {127, 255, 127}
	
	runanimationtimer = 0
	runanimationframe = 1
	runanimationdelay = 0.1
	
	playerconfig = 1
	
	usemagic = true
	
	magictimer = 0
	magicdelay = 0.15
	magics = {}
end

function onlinemenu_update(dt)
	runanimationtimer = runanimationtimer + dt
	while runanimationtimer > runanimationdelay do
		runanimationtimer = runanimationtimer - runanimationdelay
		runanimationframe = runanimationframe - 1
		if runanimationframe == 0 then
			runanimationframe = 3
		end
	end
	
	magictimer = magictimer + dt
	while magictimer > magicdelay do
		magictimer = magictimer - magicdelay
		if checkmagic(guielements.ipentry.value) then
			table.insert(magics, magic:new())
		end
	end
	
	local delete = {}
	
	for i, v in pairs(magics) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(magics, v) --remove
	end
	
	localnick = guielements.nickentry.value
end

function onlinemenu_draw()
	--TOP PART
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 3*scale, 3*scale, 394*scale, 52*scale)
	love.graphics.setColor(255, 255, 255)
	
	properprint("online play", 4*scale, 5*scale)
	
	properprint("your nick:", 4*scale, 20*scale)
	guielements.nickentry:draw()
	
	properprint("use config", 140*scale, 20*scale)
	properprint("number  " .. playerconfig , 140*scale, 33*scale)
	guielements.configdecrease:draw()
	guielements.configincrease:draw()
	
	drawplayercard(240, 10, mariocolors[playerconfig], mariohats[playerconfig], localnick)
	
	
	--BOTTOM PART
	
	--LEFT (JOIN)
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 3*scale, 58*scale, 196*scale, 163*scale)
	
	love.graphics.setColor(255, 255, 255)
	properprint("join game", 64*scale, 60*scale)
	
	properprint("address/magicdns", 36*scale, 77*scale)
	guielements.ipentry:draw()
	love.graphics.setColor(150, 150, 150)
	properprint("enter ip, hostname,", 24*scale, 107*scale)
	properprint("domain or magicdns", 28*scale, 117*scale)
	properprint("words to connect.", 32*scale, 127*scale)
	
	love.graphics.setColor(255, 255, 255)
	properprint("optional port:", 21*scale, 148*scale)
	guielements.portentry2:draw()
	
	love.graphics.setColor(150, 150, 150)
	properprint("not needed when", 40*scale, 162*scale)
	properprint("connecting through", 28*scale, 172*scale)
	properprint("magicdns", 68*scale, 182*scale)
	
	guielements.joinbutton:draw()
	
	--RIGHT (HOST)
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 202*scale, 58*scale, 195*scale, 163*scale)
	
	love.graphics.setColor(255, 255, 255)
	properprint("host game", 260*scale, 60*scale)
	properprint("port", 280*scale, 77*scale)
	
	guielements.portentry:draw()
	
	love.graphics.setColor(150, 150, 150)
	properprint("port will need to", 230*scale, 107*scale)
	properprint("be udp forwarded for", 218*scale, 117*scale)
	properprint("internet play!", 242*scale, 127*scale)
	
	guielements.magiccheckbox:draw()
	properprint("use magicdns words", 230*scale, 148*scale)
	love.graphics.setColor(150, 150, 150)
	properprint("allows friends", 238*scale, 162*scale)
	properprint("to join using", 242*scale, 172*scale)
	properprint("two short words", 234*scale, 182*scale)
	
	guielements.hostbutton:draw()
	
	for i, v in pairs(magics) do
		v:draw()
	end
end

function configdecrease()
	playerconfig = math.max(1, playerconfig-1)
end

function configincrease()
	playerconfig = math.min(4, playerconfig+1)
end

function togglemagic()
	usemagic = not usemagic
	guielements.magiccheckbox.var = usemagic
end

function checkmagic(s)
	if string.find(s, " ") then
		return true
	else
		return false
	end
end

function creategame()
	port = tonumber(guielements.portentry.value)
	server_load()
	if usemagic then
		adjective, noun = magicdns_make()
	end
end

function joingame()
	port = tonumber(guielements.portentry2.value)
	local s = guielements.ipentry.value
	if checkmagic(s) then
		usemagic = true
		local split = s:split(" ")
		adjective, noun = split[1], split[2]
		ip, port = magicdns_find(adjective, noun)
		
		if ip == nil then
			return
		end
	else
		usemagic = false
		ip = guielements.ipentry.value
	end
	
	client_load()
end

magicdns_validresponses = {"MADE", "KEPT", "REMOVED", "FOUND", "NOTFOUND", "ERROR"}

function magicdns_make()
	http.PORT = port
	s = http.request("http://dns.stabyourself.net/MAKE/" .. magicdns_identity .. "/" .. magicdns_session .. "/" .. port)
	result = s:split("/")
	magicdns_error(result)
	
	if result[1] == "MADE" then
		return string.lower(result[2]), string.lower(result[3])
	else
		print("MAGICDNS MAKE FAILED HORRIBLY");
		usemagic = false
		return;
	end
end

function magicdns_keep()
	s = http.request("http://dns.stabyourself.net/KEEP/"..magicdns_identity.."/"..magicdns_session)
	result = s:split("/")
	magicdns_error(result)
	if result[1] ~= "KEPT" then
		print("MAGICDNS KEEP FAILED! RETURNED: " .. s)
	elseif result[2] ~= "" then
		print("MAGICDNS EXTERNAL PORT KNOWN = " .. result[2])
	end
end

function magicdns_remove()
	s = http.request("http://dns.stabyourself.net/REMOVE/"..magicdns_identity.."/"..magicdns_session)
	result = s:split("/")
	magicdns_error(result)
	if result[1] ~= "REMOVED" then
		print("MAGICDNS REMOVE FAILED! RETURNED: " .. s)
	end
end
	
function magicdns_find(adjective, noun)
	s = http.request("http://dns.stabyourself.net/FIND/" .. magicdns_identity .. "/" .. string.upper(adjective) .. "/" .. string.upper(noun))
	
	local result = s:split("/")
	magicdns_error(result)
	if result[1] == "FOUND" then
		if result[4] == "" then
		print("MAGICDNS Server external port is not known!")
		end		
		return result[2], result[3], result[4]
	else
		return nil
	end
end

function magicdns_error(result)
	if result[1] == "ERROR" then
		
		print("MAGICDNS ERROR: "..result[2])
		return true
	elseif not tablecontains(magicdns_validresponses, result[1]) then
		print("MAGICDNS: nonstandard response: "..result[1])
		return true
	end
	return false
end