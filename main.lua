--[[
	STEAL MY SHIT AND I'LL FUCK YOU UP
	PRETTY MUCH EVERYTHING BY MAURICE GU�GAN AND IF SOMETHING ISN'T BY ME THEN IT SHOULD BE OBVIOUS OR NOBODY CARES

	Because I have received some emails about the CC license this previously used, and I don't give a shit and find these 
	emails annoying, this game is licensed under WTFPL. Do what the fuck you want to. Except sending me emails about licenses. Don't do that.
]]

function love.errhand()
	love.audio.stop()
	love.run()
end

function love.run()
    math.randomseed(os.time())
    math.random() math.random()

    love.load(arg)

    -- Main loop time.
    while true do
        -- Process events.
		love.event.pump()
		for e,a,b,c,d in love.event.poll() do
			if e == "quit" then
				if not love.quit or not love.quit() then
					love.audio.stop()
					return
				end
			end
			love.handlers[e](a,b,c,d)
		end

        -- Update dt, as we'll be passing it to update
		love.timer.step()
		local dt = love.timer.getDelta()

        -- Call update and draw
        love.update(dt) -- will pass 0 if love.timer is disabled
		love.graphics.clear()
		love.draw()
		
		love.timer.sleep(0.001)
		love.graphics.present()
    end
end

function love.load()
	require "sasorgasm"
	stats_prev = 1
	stats_curr = 1
	stats_timer = 0
	stats_delay = 3
	stats_letterspeed = 0.1
	stats_currletter = 1
	stats_currlettertimer = 0
	
	
	loadtrack()
	savetrack()
	magicdns_session_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	magicdns_session = ""
	for i = 1, 8 do
		rand = math.random(string.len(magicdns_session_chars))
		magicdns_session = magicdns_session .. string.sub(magicdns_session_chars, rand, rand)
	end
	--use love.filesystem.getIdentity() when it works
	magicdns_identity = love.filesystem.getSaveDirectory():split("/")
	magicdns_identity = string.upper(magicdns_identity[#magicdns_identity])

	
	shaderlist = love.filesystem.enumerate( "shaders/" )
	local rem
	for i, v in pairs(shaderlist) do
		if v == "init.lua" then
			rem = i
		else
			shaderlist[i] = string.sub(v, 1, string.len(v)-5)
		end
	end
	
	table.remove(shaderlist, rem)
	table.insert(shaderlist, 1, "none")
	
	if not pcall(loadconfig) then
		players = 1
		defaultconfig()
	end

	physicsdebug = false
	skipintro = true
	portalwalldebug = false
	arcade = true
	mkstation = false
	
	fullscreen = false
	
	width = 24	--! default 24 (25 actually)
	height = 14
	fsaa = 0
	
	if mkstation then
		width = 27
		fullscreen = true
		scale = 4
	end
	
	changescale(scale, fullscreen)
	
	arcadejoystickmaps = {}
	for i = 1, 4 do
		arcadejoystickmaps[i] = i --index is joystick, i is 1-4
	end

	marioversion = 1100
	versionstring = "version 1.0se"
	dlclist = {"dlc_a_portal_tribute", "dlc_acid_trip", "dlc_escape_the_lab", "dlc_scienceandstuff", "dlc_smb2J", "dlc_the_untitled_game"}
	
	hatcount = #love.filesystem.enumerate("graphics/SMB/hats")
	saveconfig()
	love.graphics.setCaption( "Mari0" )
	
	--version check by checking for a const that was added in 0.8.0
	if love._version_major == nil then error("You have an outdated version of Love! Get 0.8.0 or higher and retry.") end
	
	iconimg = love.graphics.newImage("graphics/icon.gif")
	love.graphics.setIcon(iconimg)
	
	love.graphics.setDefaultImageFilter("nearest", "nearest")
	
	love.graphics.setBackgroundColor(0, 0, 0)
	
	
	fontimage = love.graphics.newImage("graphics/font.png")
	fontimageback = love.graphics.newImage("graphics/fontback.png")
	fontglyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>* !{}?"
	fontquads = {}
	for i = 1, string.len(fontglyphs) do
		fontquads[string.sub(fontglyphs, i, i)] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 408, 8)
	end
	fontquadsback = {}
	for i = 1, string.len(fontglyphs) do
		fontquadsback[string.sub(fontglyphs, i, i)] = love.graphics.newQuad((i-1)*9, 0, 9, 9, 459, 9)
	end
	
	love.graphics.clear()
	love.graphics.setColor(100, 100, 100)
	--[[loadingtexts = {"reticulating splines..", "loading..", "booting glados..", "growing potatoes..", "voting against acta..", "rendering important stuff..",
					"baking cake..", "happy explosion day..", "raising coolness by 20 percent..", "yay facepunch..", "stabbing myself..", "sharpening knives..",
					"tanaka, thai kick..", "loading game genie.."}
	--]]				
	loadingtexts = {"game crashed, sorry. wait a few seconds.."}
	loadingtext = loadingtexts[math.random(#loadingtexts)]
	properprint(loadingtext, 25*8*scale-string.len(loadingtext)*4*scale, 108*scale)
	love.graphics.present()
	--require ALL the files!
	require "netplay"
	require "client"
	require "server"
	require "lobby"
	
	require "shaders"
	require "variables"
	require "sha1"
	require "class"
	
	require "animatedquad"
	require "characters"
	require "intro"
	require "menu"
	require "onlinemenu"
	require "levelscreen"
	require "game"
	require "editor"
	require "physics"
	require "quad"
	require "entity"
	require "portalwall"
	require "tile"
	require "mario"
	require "goomba"
	require "koopa"
	require "cheepcheep"
	require "mushroom"
	require "hatconfigs"
	require "bighatconfigs"
	require "customhats"
	require "flower"
	require "star"
	require "oneup"
	require "coinblockanimation"
	require "scrollingscore"
	require "platform"
	require "platformspawner"
	require "portalparticle"
	require "portalprojectile"
	require "box"
	require "emancipationgrill"
	require "door"
	require "button"
	require "groundlight"
	require "wallindicator"
	require "walltimer"
	require "lightbridge"
	require "faithplate"
	require "laser"
	require "laserdetector"
	require "gel"
	require "geldispenser"
	require "cubedispenser"
	require "pushbutton"
	require "screenboundary"
	require "bulletbill"
	require "hammerbro"
	require "fireball"
	require "gui"
	require "blockdebris"
	require "firework"
	require "plant"
	require "castlefire"
	require "fire"
	require "bowser"
	require "vine"
	require "spring"
	require "flyingfish"
	require "upfire"
	require "seesaw"
	require "seesawplatform"
	require "lakito"
	require "bubble"
	require "squid"
	require "rainboom"
	require "miniblock"
	require "notgate"
	require "andgate"
	require "orgate"
	require "musicloader"
	require "magic"
	require "ceilblocker"
	require "funnel"
	require "panel"
	require "rightclickmenu"
	require "emancipateanimation"
	require "emancipationfizzle"
	require "textentity"
	require "squarewave"
	require "scaffold"
	require "animation"
	require "animationsystem"
	require "regiondrag"
	require "regiontrigger"
	require "checkpoint"
	require "portal"
	require "portalent"
	require "pedestal"
	require "actionblock"
	
	http = require("socket.http")
	http.PORT = 55555
	http.TIMEOUT = 1
	
	updatenotification = false
	if getupdate() then
		updatenotification = true
	end
	http.TIMEOUT = 4
	
	playertypei = 1
	playertype = playertypelist[playertypei] --portal, minecraft
	
	if volume == 0 then
		soundenabled = false
	else
		soundenabled = true
	end
	love.filesystem.mkdir( "mappacks" )
	editormode = false
	yoffset = 0
	love.graphics.setPointSize(3*scale)
	love.graphics.setLineWidth(2*scale)
	
	uispace = math.floor(width*16*scale/4)
	guielements = {}
	
	--limit hats
	for playerno = 1, players do
		for i = 1, #mariohats[playerno] do
			if mariohats[playerno][i] > hatcount then
				mariohats[playerno][i] = hatcount
			end
		end
	end
	
	--Backgroundcolors
	backgroundcolor = {}
	backgroundcolor[1] = {92, 148, 252}
	backgroundcolor[2] = {0, 0, 0}
	backgroundcolor[3] = {32, 56, 236}
	
	--IMAGES--
	overwrittenimages = {}
	imagelist = {"blockdebris", "coinblockanimation", "coinanimation", "coinblock", "coin", "axe", "spring", "toad", "peach", "platform", 
	"platformbonus", "scaffold", "seesaw", "star", "flower", "fireball", "vine", "goomba", "spikey", "lakito", "koopa", "koopared", "beetle", "cheepcheep", "squid", "bulletbill", 
	"hammerbros", "hammer", "plant", "fire", "upfire", "bowser", "decoys", "box", "flag", "castleflag", "bubble", "fizzle", "emanceparticle", "emanceside", "doorpiece", "doorcenter", 
	"button", "pushbutton", "wallindicator", "walltimer", "lightbridge", "lightbridgeside", "laser", "laserside", "excursionbase", "excursionfunnel", "excursionfunnel2", 
	"faithplateplate", "laserdetector", "gel1", "gel2", "gel3", "gel4", "gel1ground", "gel2ground", "gel3ground", "gel4ground", "geldispenser", "cubedispenser", "panel", "pedestalbase",
	"pedestalgun", "actionblock"}
	
	for i, v in pairs(imagelist) do
		_G["default" .. v .. "img"] = love.graphics.newImage("graphics/SMB/" .. v .. ".png")
		_G[v .. "img"] = _G["default" .. v .. "img"]
	end
	
	mari0img = love.graphics.newImage("graphics/mari0titel.png");mari0img:setFilter("linear", "linear")
	mari0imgsmall = love.graphics.newImage("graphics/mari0titelsmall.png");mari0imgsmall:setFilter("linear", "linear")
	
	menuselection = love.graphics.newImage("graphics/menuselect.png")
	mappackback = love.graphics.newImage("graphics/mappackback.png")
	mappacknoicon = love.graphics.newImage("graphics/mappacknoicon.png")
	mappackoverlay = love.graphics.newImage("graphics/mappackoverlay.png")
	mappackhighlight = love.graphics.newImage("graphics/mappackhighlight.png")
	
	mappackscrollbar = love.graphics.newImage("graphics/mappackscrollbar.png")
	
	--tiles
	tilequads = {}
	rgblist = {}
	
	--add smb tiles
	smbtilesimg = love.graphics.newImage("graphics/smbtiles.png")
	local imgwidth, imgheight = smbtilesimg:getWidth(), smbtilesimg:getHeight()
	local width = math.floor(imgwidth/17)
	local height = math.floor(imgheight/17)
	local imgdata = love.image.newImageData("graphics/smbtiles.png")
	
	for y = 1, height do
		for x = 1, width do
			table.insert(tilequads, quad:new(smbtilesimg, imgdata, x, y, imgwidth, imgheight))
			local r, g, b = getaveragecolor(imgdata, x, y)
			table.insert(rgblist, {r, g, b})
		end
	end
	smbtilecount = width*height
	
	--add portal tiles
	portaltilesimg = love.graphics.newImage("graphics/portaltiles.png")
	local imgwidth, imgheight = portaltilesimg:getWidth(), portaltilesimg:getHeight()
	local width = math.floor(imgwidth/17)
	local height = math.floor(imgheight/17)
	local imgdata = love.image.newImageData("graphics/portaltiles.png")
	
	for y = 1, height do
		for x = 1, width do
			table.insert(tilequads, quad:new(portaltilesimg, imgdata, x, y, imgwidth, imgheight))
			local r, g, b = getaveragecolor(imgdata, x, y)
			table.insert(rgblist, {r, g, b})
		end
	end
	portaltilecount = width*height
	
	--add entities
	entityquads = {}
	entitiesimg = love.graphics.newImage("graphics/entities.png")
	local imgwidth, imgheight = entitiesimg:getWidth(), entitiesimg:getHeight()
	local width = math.floor(imgwidth/17)
	local height = math.floor(imgheight/17)
	local imgdata = love.image.newImageData("graphics/entities.png")
	
	editorentitylist = {}
	for y = 1, height do
		for x = 1, width do
			table.insert(entityquads, entity:new(entitiesimg, x, y, imgwidth, imgheight))
			entityquads[#entityquads]:sett(#entityquads)
			if entitylist[(y-1)*10+x] and entitylist[(y-1)*10+x] ~= "" then
				table.insert(editorentitylist, (y-1)*10+x)
			end
		end
	end
	entitiescount = width*height
	
	fontimage2 = love.graphics.newImage("graphics/smallfont.png")
	numberglyphs = "012458"
	font2quads = {}
	for i = 1, 6 do
		font2quads[string.sub(numberglyphs, i, i)] = love.graphics.newQuad((i-1)*4, 0, 4, 8, 24, 8)
	end
	
	oneuptextimage = love.graphics.newImage("graphics/oneuptext.png")
	
	linktoolpointerimg = love.graphics.newImage("graphics/linktoolpointer.png")
	
	blockdebrisquads = {}
	for y = 1, 4 do
		blockdebrisquads[y] = {}
		for x = 1, 2 do
			blockdebrisquads[y][x] = love.graphics.newQuad((x-1)*8, (y-1)*8, 8, 8, 16, 32)
		end
	end
	
	coinblockanimationquads = {}
	for i = 1, 30 do
		coinblockanimationquads[i] = love.graphics.newQuad((i-1)*8, 0, 8, 52, 256, 64)
	end
	
	coinanimationquads = {}
	for j = 1, 4 do
		coinanimationquads[j] = {}
		for i = 1, 5 do
			coinanimationquads[j][i] = love.graphics.newQuad((i-1)*5, (j-1)*8, 5, 8, 25, 32)
		end
	end
	
	--coinblock
	coinblockquads = {}
	for j = 1, 4 do
		coinblockquads[j] = {}
		for i = 1, 5 do
			coinblockquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
		end
	end
	
	--coin
	coinquads = {}
	for j = 1, 4 do
		coinquads[j] = {}
		for i = 1, 5 do
			coinquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
		end
	end
	
	--axe
	axequads = {}
	for i = 1, 5 do
		axequads[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 80, 16)
	end
	
	--spring
	springquads = {}
	for i = 1, 4 do
		springquads[i] = {}
		for j = 1, 3 do
			springquads[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*31, 16, 31, 48, 124)
		end
	end
	
	seesawquad = {}
	for i = 1, 4 do
		seesawquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	titleimage = love.graphics.newImage("graphics/title.png")
	playerselectimg = love.graphics.newImage("graphics/playerselectarrow.png")
	
	starquad = {}
	for i = 1, 4 do
		starquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	flowerquad = {}
	for i = 1, 4 do
		flowerquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	fireballquad = {}
	for i = 1, 4 do
		fireballquad[i] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 80, 16)
	end
	
	for i = 5, 7 do
		fireballquad[i] = love.graphics.newQuad((i-5)*16+32, 0, 16, 16, 80, 16)
	end
	
	vinequad = {}
	for i = 1, 4 do
		vinequad[i] = {}
		for j = 1, 2 do
			vinequad[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*16, 16, 16, 32, 64) 
		end
	end
	
	--enemies
	goombaquad = {}
	
	for y = 1, 4 do
		goombaquad[y] = {}
		for x = 1, 2 do
			goombaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 32, 64)
		end
	end
		
	spikeyquad = {}
	for x = 1, 4 do
		spikeyquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 64, 16)
	end
	
	lakitoquad = {}
	for x = 1, 2 do
		lakitoquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 24, 32, 24)
	end
	
	koopaquad = {}
	
	for y = 1, 4 do
		koopaquad[y] = {}
		for x = 1, 5 do
			koopaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, 128, 128)
		end
	end
	cheepcheepquad = {}
	
	cheepcheepquad[1] = {}
	cheepcheepquad[1][1] = love.graphics.newQuad(0, 0, 16, 16, 32, 32)
	cheepcheepquad[1][2] = love.graphics.newQuad(16, 0, 16, 16, 32, 32)
	
	cheepcheepquad[2] = {}
	cheepcheepquad[2][1] = love.graphics.newQuad(0, 16, 16, 16, 32, 32)
	cheepcheepquad[2][2] = love.graphics.newQuad(16, 16, 16, 16, 32, 32)
	
	squidquad = {}
	for x = 1, 2 do
		squidquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 24, 32, 32)
	end
	
	bulletbillquad = {}
	
	for y = 1, 4 do
		bulletbillquad[y] = love.graphics.newQuad(0, (y-1)*16, 16, 16, 16, 64)
	end
	
	hammerbrosquad = {}
	for y = 1, 4 do
		hammerbrosquad[y] = {}
		for x = 1, 4 do
			hammerbrosquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*34, 16, 34, 64, 256)
		end
	end	
	
	hammerquad = {}
	for j = 1, 4 do
		hammerquad[j] = {}
		for i = 1, 4 do
			hammerquad[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
		end
	end
	
	plantquads = {}
	for j = 1, 4 do
		plantquads[j] = {}
		for i = 1, 2 do
			plantquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*23, 16, 23, 32, 128)
		end
	end
	
	firequad = {love.graphics.newQuad(0, 0, 24, 8, 48, 8), love.graphics.newQuad(24, 0, 24, 8, 48, 8)}
	
	
	bowserquad = {}
	bowserquad[1] = {love.graphics.newQuad(0, 0, 32, 32, 64, 64), love.graphics.newQuad(32, 0, 32, 32, 64, 64)}
	bowserquad[2] = {love.graphics.newQuad(0, 32, 32, 32, 64, 64), love.graphics.newQuad(32, 32, 32, 32, 64, 64)}
	
	decoysquad = {}
	for y = 1, 7 do
		decoysquad[y] = love.graphics.newQuad(0, (y-1)*32, 32, 32, 64, 256)
	end
	
	boxquad = {love.graphics.newQuad(0, 0, 12, 12, 32, 16), love.graphics.newQuad(16, 0, 12, 12, 32, 16)}
	
	--eh
	rainboomimg = love.graphics.newImage("graphics/rainboom.png")
	rainboomquad = {}
	for x = 1, 7 do
		for y = 1, 7 do
			rainboomquad[x+(y-1)*7] = love.graphics.newQuad((x-1)*204, (y-1)*182, 204, 182, 1428, 1274)
		end
	end
	
	logo = love.graphics.newImage("graphics/stabyourself.png")
	logoblood = love.graphics.newImage("graphics/stabyourselfblood.png")
	
	--magic!
	magicimg = love.graphics.newImage("graphics/magic.png")
	magicquad = {}
	for x = 1, 6 do
		magicquad[x] = love.graphics.newQuad((x-1)*9, 0, 9, 9, 54, 9)
	end
	
	--GUI
	checkboximg = love.graphics.newImage("graphics/checkbox.png")
	checkboxquad = {{love.graphics.newQuad(0, 0, 9, 9, 18, 18), love.graphics.newQuad(9, 0, 9, 9, 18, 18)}, {love.graphics.newQuad(0, 9, 9, 9, 18, 18), love.graphics.newQuad(9, 9, 9, 9, 18, 18)}}
	
	dropdownarrowimg = love.graphics.newImage("graphics/dropdownarrow.png")
		
	--portals
	portalimage = love.graphics.newImage("graphics/portal.png")
	portal1quad = {}
	for i = 0, 7 do
		portal1quad[i] = love.graphics.newQuad(0, i*4, 32, 4, 64, 28)
	end
	
	portal2quad = {}
	for i = 0, 7 do
		portal2quad[i] = love.graphics.newQuad(32, i*4, 32, 4, 64, 28)
	end
	
	portalglow = love.graphics.newImage("graphics/portalglow.png")
	
	portalparticleimg = love.graphics.newImage("graphics/portalparticle.png")
	portalcrosshairimg = love.graphics.newImage("graphics/portalcrosshair.png")
	portaldotimg = love.graphics.newImage("graphics/portaldot.png")
	portalprojectileimg = love.graphics.newImage("graphics/portalprojectile.png")
	portalprojectileparticleimg = love.graphics.newImage("graphics/portalprojectileparticle.png")
	portalbackgroundimg = love.graphics.newImage("graphics/portalbackground.png")
	
	--Menu shit
	huebarimg = love.graphics.newImage("graphics/huebar.png")
	huebarmarkerimg = love.graphics.newImage("graphics/huebarmarker.png")
	volumesliderimg = love.graphics.newImage("graphics/volumeslider.png")
	
	--Portal props	
	buttonquad = {love.graphics.newQuad(0, 0, 32, 5, 64, 5), love.graphics.newQuad(32, 0, 32, 5, 64, 5)}
	
	pushbuttonquad = {love.graphics.newQuad(0, 0, 16, 16, 32, 16), love.graphics.newQuad(16, 0, 16, 16, 32, 16)}
	
	wallindicatorquad = {love.graphics.newQuad(0, 0, 16, 16, 32, 16), love.graphics.newQuad(16, 0, 16, 16, 32, 16)}
	
	walltimerquad = {}
	for i = 1, 10 do
		walltimerquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 160, 16)
	end
	
	directionsimg = love.graphics.newImage("graphics/directions.png")
	directionsquad = {}
	for x = 1, 6 do
		directionsquad[x] = love.graphics.newQuad((x-1)*7, 0, 7, 7, 42, 7)
	end
	
	excursionquad = {}
	for x = 1, 8 do
		excursionquad[x] = love.graphics.newQuad((x-1)*8, 0, 8, 32, 64, 32)
	end
	
	faithplatequad = {love.graphics.newQuad(0, 0, 32, 16, 32, 32), love.graphics.newQuad(0, 16, 32, 16, 32, 32)}
	
	gelquad = {love.graphics.newQuad(0, 0, 12, 12, 36, 12), love.graphics.newQuad(12, 0, 12, 12, 36, 12), love.graphics.newQuad(24, 0, 12, 12, 36, 12)}
	
	gradientimg = love.graphics.newImage("graphics/gradient.png");gradientimg:setFilter("linear", "linear")
	
	markbaseimg = love.graphics.newImage("graphics/markerbase.png")
	markoverlayimg = love.graphics.newImage("graphics/markeroverlay.png")
	panelquad = {}
	for x = 1, 2 do
		panelquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 32, 16)
	end
		
	--Ripping off
	minecraftbreakimg = love.graphics.newImage("graphics/Minecraft/blockbreak.png")
	minecraftbreakquad = {}
	for i = 1, 10 do
		minecraftbreakquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 160, 16)
	end
	minecraftgui = love.graphics.newImage("graphics/Minecraft/gui.png")
	minecraftselected = love.graphics.newImage("graphics/Minecraft/selected.png")
	
	--AUDIO--
	--sounds
	jumpsound = love.audio.newSource("sounds/jump.ogg", "static");love.audio.stop(jumpsound)
	jumpbigsound = love.audio.newSource("sounds/jumpbig.ogg", "static");love.audio.stop(jumpbigsound)
	stompsound = love.audio.newSource("sounds/stomp.ogg", "static");stompsound:setVolume(0);stompsound:play();stompsound:stop();stompsound:setVolume(1)
	shotsound = love.audio.newSource("sounds/shot.ogg", "static");shotsound:setVolume(0);shotsound:play();shotsound:stop();shotsound:setVolume(1)
	blockhitsound = love.audio.newSource("sounds/blockhit.ogg", "static");blockhitsound:setVolume(0);blockhitsound:play();blockhitsound:stop();blockhitsound:setVolume(1)
	blockbreaksound = love.audio.newSource("sounds/blockbreak.ogg", "static");blockbreaksound:setVolume(0);blockbreaksound:play();blockbreaksound:stop();blockbreaksound:setVolume(1)
	coinsound = love.audio.newSource("sounds/coin.ogg", "static");coinsound:setVolume(0);coinsound:play();coinsound:stop();coinsound:setVolume(1)
	pipesound = love.audio.newSource("sounds/pipe.ogg", "static");pipesound:setVolume(0);pipesound:play();pipesound:stop();pipesound:setVolume(1)
	boomsound = love.audio.newSource("sounds/boom.ogg", "static");boomsound:setVolume(0);boomsound:play();boomsound:stop();boomsound:setVolume(1)
	mushroomappearsound = love.audio.newSource("sounds/mushroomappear.ogg", "static");mushroomappearsound:setVolume(0);mushroomappearsound:play();mushroomappearsound:stop();mushroomappearsound:setVolume(1)
	mushroomeatsound = love.audio.newSource("sounds/mushroomeat.ogg", "static");mushroomeatsound:setVolume(0);mushroomeatsound:play();mushroomeatsound:stop();mushroomeatsound:setVolume(1)
	shrinksound = love.audio.newSource("sounds/shrink.ogg", "static");shrinksound:setVolume(0);shrinksound:play();shrinksound:stop();shrinksound:setVolume(1)
	deathsound = love.audio.newSource("sounds/death.ogg", "static");deathsound:setVolume(0);deathsound:play();deathsound:stop();deathsound:setVolume(1)
	gameoversound = love.audio.newSource("sounds/gameover.ogg", "static");gameoversound:setVolume(0);gameoversound:play();gameoversound:stop();gameoversound:setVolume(1)
	fireballsound = love.audio.newSource("sounds/fireball.ogg", "static");fireballsound:setVolume(0);fireballsound:play();fireballsound:stop();fireballsound:setVolume(1)
	oneupsound = love.audio.newSource("sounds/oneup.ogg", "static");oneupsound:setVolume(0);oneupsound:play();oneupsound:stop();oneupsound:setVolume(1)
	levelendsound = love.audio.newSource("sounds/levelend.ogg", "static");levelendsound:setVolume(0);levelendsound:play();levelendsound:stop();levelendsound:setVolume(1)
	castleendsound = love.audio.newSource("sounds/castleend.ogg", "static");castleendsound:setVolume(0);castleendsound:play();castleendsound:stop();castleendsound:setVolume(1)
	scoreringsound = love.audio.newSource("sounds/scorering.ogg", "static");scoreringsound:setVolume(0);scoreringsound:play();scoreringsound:stop();scoreringsound:setVolume(1);scoreringsound:setLooping(true)
	intermissionsound = love.audio.newSource("sounds/intermission.ogg", "static");intermissionsound:setVolume(0);intermissionsound:play();intermissionsound:stop();intermissionsound:setVolume(1)
	firesound = love.audio.newSource("sounds/fire.ogg", "static");firesound:setVolume(0);firesound:play();firesound:stop();firesound:setVolume(1)
	bridgebreaksound = love.audio.newSource("sounds/bridgebreak.ogg", "static");bridgebreaksound:setVolume(0);bridgebreaksound:play();bridgebreaksound:stop();bridgebreaksound:setVolume(1)
	bowserfallsound = love.audio.newSource("sounds/bowserfall.ogg", "static");bowserfallsound:setVolume(0);bowserfallsound:play();bowserfallsound:stop();bowserfallsound:setVolume(1)
	vinesound = love.audio.newSource("sounds/vine.ogg", "static");vinesound:setVolume(0);vinesound:play();vinesound:stop();vinesound:setVolume(1)
	swimsound = love.audio.newSource("sounds/swim.ogg", "static");swimsound:setVolume(0);swimsound:play();swimsound:stop();swimsound:setVolume(1)
	rainboomsound = love.audio.newSource("sounds/rainboom.ogg", "static");rainboomsound:setVolume(0);rainboomsound:play();rainboomsound:stop();rainboomsound:setVolume(1)
	konamisound = love.audio.newSource("sounds/konami.ogg", "static");konamisound:setVolume(0);konamisound:play();konamisound:stop();konamisound:setVolume(1)
	pausesound = love.audio.newSource("sounds/pause.ogg", "static");pausesound:setVolume(0);pausesound:play();pausesound:stop();pausesound:setVolume(1)
	bulletbillsound = love.audio.newSource("sounds/bulletbill.ogg", "static");pausesound:setVolume(0);pausesound:play();pausesound:stop();pausesound:setVolume(1)
	lowtime = love.audio.newSource("sounds/lowtime.ogg", "static");rainboomsound:setVolume(0);rainboomsound:play();rainboomsound:stop();rainboomsound:setVolume(1)
	stabsound = love.audio.newSource("sounds/stab.ogg", "static")
	portal1opensound = love.audio.newSource("sounds/portal1open.ogg", "static");portal1opensound:setVolume(0);portal1opensound:play();portal1opensound:stop();portal1opensound:setVolume(0.3)
	portal2opensound = love.audio.newSource("sounds/portal2open.ogg", "static");portal2opensound:setVolume(0);portal2opensound:play();portal2opensound:stop();portal2opensound:setVolume(0.3)
	portalentersound = love.audio.newSource("sounds/portalenter.ogg", "static");portalentersound:setVolume(0);portalentersound:play();portalentersound:stop();portalentersound:setVolume(0.3)
	portalfizzlesound = love.audio.newSource("sounds/portalfizzle.ogg", "static");portalfizzlesound:setVolume(0);portalfizzlesound:play();portalfizzlesound:stop();portalfizzlesound:setVolume(0.3)
	
	
	--music
	--[[
	overworldmusic = love.audio.newSource("sounds/overworld.ogg", "static");overworldmusic:setLooping(true)
	undergroundmusic = love.audio.newSource("sounds/underground.ogg", "static");undergroundmusic:setLooping(true)
	castlemusic = love.audio.newSource("sounds/castle.ogg", "static");castlemusic:setLooping(true)
	underwatermusic = love.audio.newSource("sounds/underwater.ogg", "static");underwatermusic:setLooping(true)
	starmusic = love.audio.newSource("sounds/starmusic.ogg", "static");starmusic:setLooping(true)
	princessmusic = love.audio.newSource("sounds/princessmusic.ogg", "static");princessmusic:setLooping(true)
	
	overworldmusicfast = love.audio.newSource("sounds/overworld-fast.ogg", "static");overworldmusicfast:setLooping(true)
	undergroundmusicfast = love.audio.newSource("sounds/underground-fast.ogg", "static");undergroundmusicfast:setLooping(true)
	castlemusicfast = love.audio.newSource("sounds/castle-fast.ogg", "static");castlemusicfast:setLooping(true)
	underwatermusicfast = love.audio.newSource("sounds/underwater-fast.ogg", "static");underwatermusicfast:setLooping(true)
	starmusicfast = love.audio.newSource("sounds/starmusic-fast.ogg", "static");starmusicfast:setLooping(true)
	]]
		
	soundlist = {jumpsound, jumpbigsound, stompsound, shotsound, blockhitsound, blockbreaksound, coinsound, pipesound, boomsound, mushroomappearsound, mushroomeatsound, shrinksound, deathsound, gameoversound,
				fireballsound, oneupsound, levelendsound, castleendsound, scoreringsound, intermissionsound, firesound, bridgebreaksound, bowserfallsound, vinesound, swimsound, rainboomsoud, 
				portal1opensound, portal2opensound, portalentersound, portalfizzlesound, lowtime, konamisound, pausesound, stabsound, bulletbillsound}
	
	-- musiclist = {overworldmusic, undergroundmusic, castlemusic, underwatermusic, starmusic}
	-- musiclistfast = {overworldmusicfast, undergroundmusicfast, castlemusicfast, underwatermusicfast, starmusicfast}
	
	musici = 2
	
	shaders:init()
	shaders:set(1, shaderlist[currentshaderi1])
	shaders:set(2, shaderlist[currentshaderi2])
	
	for i, v in pairs(dlclist) do
		delete_mappack(v)
	end
		
	if skipintro then
		menu_load()
	else
		intro_load()
	end
end

function love.update(dt)
	if music then
		music:update()
	end
	dt = math.min(0.01666667, dt)
	
	stats_currlettertimer = stats_currlettertimer + dt
	if stats_currlettertimer > stats_letterspeed then
		stats_currlettertimer = stats_currlettertimer - stats_letterspeed
		stats_currletter = stats_currletter + 1
	end
	
	local string1, string2
	if trackingtexts[stats_prev] and stats[tracking[stats_prev]] and trackingadd[stats_prev] then
		string1 = trackingtexts[stats_prev] .. " " .. round(stats[tracking[stats_prev]]) .. trackingadd[stats_prev]
		string2 = trackingtexts[stats_curr] .. " " .. round(stats[tracking[stats_curr]]) .. trackingadd[stats_curr]
	else
		string1 = ""
		string2 = ""
	end
	
	local l = math.max(string1:len(), string2:len())
	
	if stats_currletter > l then
		stats_timer = stats_timer + dt
		
		if stats_timer > stats_delay then
			stats_timer = stats_timer - stats_delay
			stats_prev = stats_curr
			
			repeat
				stats_curr = math.random(#tracking)
			until trackingshow[stats_curr] and stats_curr ~= stats_prev
			
			if stats_curr > #tracking then
				stats_curr = 1
			end
			stats_currletter = 0
		end
	end
	
	--speed
	if bullettime and speed ~= speedtarget then
		if speed > speedtarget then
			speed = math.max(speedtarget, speed+(speedtarget-speed)*dt*5)
		elseif speed < speedtarget then
			speed = math.min(speedtarget, speed+(speedtarget-speed)*dt*5)
		end
		
		if math.abs(speed-speedtarget) < 0.02 then
			speed = speedtarget
		end
		
		if speed > 0 then
			for i, v in pairs(soundlist) do
				v:setPitch( speed )
			end
			music.pitch = speed
			love.audio.setVolume(volume)
		else	
			love.audio.setVolume(0)
		end
	end
	
	if frameadvance == 1 then
		return
	elseif frameadvance == 2 then
		frameadvance = 1
	end

	if skipupdate then
		skipupdate = false
		return
	end
	
	keyprompt_update()
	
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" or gamestate == "lobby" then
		menu_update(dt)
	elseif gamestate == "levelscreen" or gamestate == "gameover" or gamestate == "sublevelscreen" or gamestate == "mappackfinished" then
		levelscreen_update(dt)
	elseif gamestate == "game" then
		game_update(dt)	
	elseif gamestate == "intro" then
		intro_update(dt)	
	end
	
	for i, v in pairs(guielements) do
		v:update(dt)
	end
	
	netplay_update(dt)
	
	love.graphics.setCaption(love.timer.getFPS())
end

function love.draw()
	shaders:predraw()
	
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" or gamestate == "lobby" then
		menu_draw()
	elseif gamestate == "levelscreen" or gamestate == "gameover" or gamestate == "mappackfinished" then
		levelscreen_draw()
	elseif gamestate == "game" then
		game_draw()
	elseif gamestate == "intro" then
		intro_draw()
	end
	
	netplay_draw()
	
	shaders:postdraw()
	
	if mkstation then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 896, 1680, 154)
		love.graphics.setColor(255, 255,255)
		love.graphics.draw(mari0imgsmall, gamewidth/2-380, 896, 0, 1, 1, mari0imgsmall:getWidth()/2, 0)
		
		local string1, string2
		if trackingtexts[stats_prev] and stats[tracking[stats_prev]] and trackingadd[stats_prev] then
			string1 = trackingtexts[stats_prev] .. " " .. round(stats[tracking[stats_prev]]) .. trackingadd[stats_prev]
			string2 = trackingtexts[stats_curr] .. " " .. round(stats[tracking[stats_curr]]) .. trackingadd[stats_curr]
		else
			string1 = ""
			string2 = ""
		end
		
		local l = math.max(string1:len(), string2:len())
		
		for i = 1, l do
			local l
			if i < stats_currletter then
				letter = string.sub(string2, i, i)
			elseif i > stats_currletter then
				letter = string.sub(string1, i, i)
			else
				local r = math.random(fontglyphs:len())
				letter = string.sub(fontglyphs, r, r)
			end
			properprint(letter, 600+8*scale*i, 960)
		end
		love.graphics.setColor(255, 127, 127)
		properprint(" knoepfe/kisten benutzen auf e!!", 600, 920)
	end
	
	love.graphics.setColor(255, 255,255)
end

function saveconfig()
	if CLIENT or SERVER then
		return
	end
	
	local s = ""
	for i = 1, #controls do
		s = s .. "playercontrols:" .. i .. ":"
		local count = 0
		for j, k in pairs(controls[i]) do
			local c = ""
			for l = 1, #controls[i][j] do
				c = c .. controls[i][j][l]
				if l ~= #controls[i][j] then
					c = c ..  "-"
				end
			end
			s = s .. j .. "-" .. c
			count = count + 1
			if count == 12 then
				s = s .. ";"
			else
				s = s .. ","
			end
		end
	end	
	
	for i = 1, #mariocolors do --players
		s = s .. "playercolors:" .. i .. ":"
		if #mariocolors[i] > 0 then
			for j = 1, #mariocolors[i] do --colorsets (dynamic)
				for k = 1, 3 do --R, G or B values
					s = s .. mariocolors[i][j][k]
					if j == #mariocolors[i] and k == 3 then
						s = s .. ";"
					else
						s = s .. ","
					end
				end
			end
		else
			s = s .. ";"
		end
	end
	
	for i = 1, #mariocharacter do
		s = s .. "mariocharacter:" .. i .. ":"
		s = s .. mariocharacter[i]
		s = s .. ";"
	end
	
	for i = 1, #portalhues do
		s = s .. "portalhues:" .. i .. ":"
		s = s .. round(portalhues[i][1], 4) .. "," .. round(portalhues[i][2], 4) .. ";"
	end
	
	for i = 1, #mariohats do
		s = s .. "mariohats:" .. i
		if #mariohats[i] > 0 then
			s = s .. ":"
		end
		for j = 1, #mariohats[i] do
			s = s .. mariohats[i][j]
			if j == #mariohats[i] then
				s = s .. ";"
			else
				s = s .. ","
			end
		end
		
		if #mariohats[i] == 0 then
			s = s .. ";"
		end
	end
	
	s = s .. "scale:" .. scale .. ";"
	
	s = s .. "shader1:" .. shaderlist[currentshaderi1] .. ";"
	s = s .. "shader2:" .. shaderlist[currentshaderi2] .. ";"
	
	s = s .. "volume:" .. volume .. ";"
	s = s .. "mouseowner:" .. mouseowner .. ";"
	
	s = s .. "mappack:" .. mappack .. ";"
	
	if vsync then
		s = s .. "vsync;"
	end
	
	if gamefinished then
		s = s .. "gamefinished;"
	end
	
	--reached worlds
	for i, v in pairs(reachedworlds) do
		s = s .. "reachedworlds:" .. i .. ":"
		for j = 1, 8 do
			if v[j] then
				s = s .. 1
			else
				s = s .. 0
			end
			
			if j == 8 then
				s = s .. ";"
			else
				s = s .. ","
			end
		end
	end
	
	love.filesystem.write("options.txt", s)
end

function loadconfig()
	players = 1
	defaultconfig()
	
	if not love.filesystem.exists("options.txt") then
		return
	end
	
	local s = love.filesystem.read("options.txt")
	s1 = s:split(";")
	for i = 1, #s1-1 do
		s2 = s1[i]:split(":")
		
		if s2[1] == "playercontrols" then
			if controls[tonumber(s2[2])] == nil then
				controls[tonumber(s2[2])] = {}
			end
			
			s3 = s2[3]:split(",")
			for j = 1, #s3 do
				s4 = s3[j]:split("-")
				controls[tonumber(s2[2])][s4[1]] = {}
				for k = 2, #s4 do
					if tonumber(s4[k]) ~= nil then
						controls[tonumber(s2[2])][s4[1]][k-1] = tonumber(s4[k])
					else
						controls[tonumber(s2[2])][s4[1]][k-1] = s4[k]
					end
				end
			end
			players = math.max(players, tonumber(s2[2]))
			
		elseif s2[1] == "playercolors" then
			if mariocolors[tonumber(s2[2])] == nil then
				mariocolors[tonumber(s2[2])] = {}
			end
			s3 = s2[3]:split(",")
			mariocolors[tonumber(s2[2])] = {}
			for i = 1, #s3/3 do
				mariocolors[tonumber(s2[2])][i] = {tonumber(s3[1+(i-1)*3]), tonumber(s3[2+(i-1)*3]), tonumber(s3[3+(i-1)*3])}
			end
		elseif s2[1] == "portalhues" then
			if portalhues[tonumber(s2[2])] == nil then
				portalhues[tonumber(s2[2])] = {}
			end
			s3 = s2[3]:split(",")
			portalhues[tonumber(s2[2])] = {tonumber(s3[1]), tonumber(s3[2])}
		
		elseif s2[1] == "mariohats" then
			local playerno = tonumber(s2[2])
			mariohats[playerno] = {}
			
			if s2[3] == "mariohats" then --SAVING WENT WRONG OMG
			
			elseif s2[3] then
				s3 = s2[3]:split(",")
				for i = 1, #s3 do
					local hatno = tonumber(s3[i])
					mariohats[playerno][i] = hatno
				end
			end
			
		elseif s2[1] == "scale" then
			scale = tonumber(s2[2])
			
		elseif s2[1] == "shader1" then
			for i = 1, #shaderlist do
				if shaderlist[i] == s2[2] then
					currentshaderi1 = i
				end
			end
		elseif s2[1] == "shader2" then
			for i = 1, #shaderlist do
				if shaderlist[i] == s2[2] then
					currentshaderi2 = i
				end
			end
		elseif s2[1] == "volume" then
			volume = tonumber(s2[2])
			love.audio.setVolume( volume )
		elseif s2[1] == "mouseowner" then
			mouseowner = tonumber(s2[2])
		elseif s2[1] == "mappack" then
			if love.filesystem.exists("mappacks/" .. s2[2] .. "/settings.txt") then
				mappack = s2[2]
			end
		elseif s2[1] == "gamefinished" then
			gamefinished = true
		elseif s2[1] == "vsync" then
			vsync = true
		elseif s2[1] == "reachedworlds" then
			reachedworlds[s2[2]] = {}
			local s3 = s2[3]:split(",")
			for i = 1, #s3 do
				if tonumber(s3[i]) == 1 then
					reachedworlds[s2[2]][i] = true
				end
			end
		elseif s2[1] == "mariocharacter" then
			mariocharacter[tonumber(s2[2])] = s2[3]
		end
	end
	
	for i = 1, math.max(4, players) do
		portalcolor[i] = {getrainbowcolor(portalhues[i][1]), getrainbowcolor(portalhues[i][2])}
	end
	players = 1
end

function defaultconfig()
	--------------
	-- CONTORLS --
	--------------
	
	-- Joystick stuff:
	-- joy, #, hat, #, direction (r, u, ru, etc)
	-- joy, #, axe, #, pos/neg
	-- joy, #, but, #
	-- You cannot set Hats and Axes as the jump button. Bummer.
	
	mouseowner = 1
	
	controls = {}
	
	local i = 1
	controls[i] = {}
	controls[i]["right"] = {"d"}
	controls[i]["left"] = {"a"}
	controls[i]["down"] = {"s"}
	controls[i]["up"] = {"w"}
	controls[i]["run"] = {"lshift"}
	controls[i]["jump"] = {" "}
	controls[i]["aimx"] = {""} --mouse aiming, so no need
	controls[i]["aimy"] = {""}
	controls[i]["portal1"] = {""}
	controls[i]["portal2"] = {""}
	controls[i]["reload"] = {"r"}
	controls[i]["use"] = {"e"}
	
	for i = 2, 4 do
		controls[i] = {}		
		controls[i]["right"] = {"joy", i-1, "hat", 1, "r"}
		controls[i]["left"] = {"joy", i-1, "hat", 1, "l"}
		controls[i]["down"] = {"joy", i-1, "hat", 1, "d"}
		controls[i]["up"] = {"joy", i-1, "hat", 1, "u"}
		controls[i]["run"] = {"joy", i-1, "but", 3}
		controls[i]["jump"] = {"joy", i-1, "but", 1}
		controls[i]["aimx"] = {"joy", i-1, "axe", 5, "neg"}
		controls[i]["aimy"] = {"joy", i-1, "axe", 4, "neg"}
		controls[i]["portal1"] = {"joy", i-1, "but", 5}
		controls[i]["portal2"] = {"joy", i-1, "but", 6}
		controls[i]["reload"] = {"joy", i-1, "but", 4}
		controls[i]["use"] = {"joy", i-1, "but", 2}
	end
	-------------------
	-- PORTAL COLORS --
	-------------------
	
	portalhues = {}
	portalcolor = {}
	for i = 1, 4 do
		local players = 4
		portalhues[i] = {(i-1)*(1/players), (i-1)*(1/players)+0.5/players}
		portalcolor[i] = {getrainbowcolor(portalhues[i][1]), getrainbowcolor(portalhues[i][2])}
	end
	
	--hats.
	mariohats = {}
	for i = 1, 4 do
		mariohats[i] = {1}
	end
	
	------------------
	-- MARIO COLORS --
	------------------
	--1: hat, pants (red)
	--2: shirt, shoes (brown-green)
	--3: skin (yellow-orange)
	
	mariocolors = {}
	mariocolors[1] = {{224,  32,   0}, {136, 112,   0}, {252, 152,  56}}
	mariocolors[2] = {{255, 255, 255}, {  0, 160,   0}, {252, 152,  56}}
	mariocolors[3] = {{  0,   0,   0}, {200,  76,  12}, {252, 188, 176}}
	mariocolors[4] = {{ 32,  56, 236}, {  0, 128, 136}, {252, 152,  56}}
	for i = 5, players do
		mariocolors[i] = mariocolors[math.random(4)]
	end
	
	--STARCOLORS
	starcolors = {}
	starcolors[1] = {{  0,   0,   0}, {200,  76,  12}, {252, 188, 176}}
	starcolors[2] = {{  0, 168,   0}, {252, 152,  56}, {252, 252, 252}}
	starcolors[3] = {{252, 216, 168}, {216,  40,   0}, {252, 152,  56}}
	starcolors[4] = {{216,  40,   0}, {252, 152,  56}, {252, 252, 252}}
	
	flowercolor = {{252, 216, 168}, {216,  40,   0}, {252, 152,  56}}
	
	--CHARACTERS
	mariocharacter = {"mario", "mario", "mario", "mario"}
	
	--options
	scale = 5
	volume = 1
	mappack = "smb"
	vsync = false
	currentshaderi1 = 1
	currentshaderi2 = 1
	
	reachedworlds = {}
end

function loadcustomimages(path)
	for i = 1, #overwrittenimages do
		local s = overwrittenimages[i]
		_G[s .. "img"] = _G["default" .. s .. "img"]
	end
	overwrittenimages = {}

	local fl = love.filesystem.enumerate(path)
	for i = 1, #fl do
		local v = fl[i]
		if love.filesystem.isFile(path .. "/" .. v) then
			local s = string.sub(v, 1, -5)
			if tablecontains(imagelist, s) then
				_G[s .. "img"] = love.graphics.newImage(path .. "/" .. v)
				table.insert(overwrittenimages, s)
			end
		end
	end
end

function suspendgame()
	local s = ""
	if marioworld == "M" then
		marioworld = 8
		mariolevel = 4
	end
	s = s .. "a/" .. marioworld .. "|"
	s = s .. "b/" .. mariolevel .. "|"
	s = s .. "c/" .. mariocoincount .. "|"
	s = s .. "d/" .. marioscore .. "|"
	s = s .. "e/" .. players .. "|"
	for i = 1, players do
		if mariolivecount ~= false then
			s = s .. "f/" .. i .. "/" .. mariolives[i] .. "|"
		end
		if objects["player"][i] then
			s = s .. "g/" .. i .. "/" .. objects["player"][i].size .. "|"
		else
			s = s .. "g/" .. i .."/1|"
		end
	end
	s = s .. "h/" .. mappack
	
	love.filesystem.write("suspend.txt", s)
	
	love.audio.stop()
	menu_load()
end

function continuegame()
	if not love.filesystem.exists("suspend.txt") then
		return
	end
	
	local s = love.filesystem.read("suspend.txt")
	
	mariosizes = {}
	mariolives = {}
	
	local split = s:split("|")
	for i = 1, #split do
		local split2 = split[i]:split("/")
		if split2[1] == "a" then
			marioworld = tonumber(split2[2])
		elseif split2[1] == "b" then
			mariolevel = tonumber(split2[2])
		elseif split2[1] == "c" then
			mariocoincount = tonumber(split2[2])
		elseif split2[1] == "d" then
			marioscore = tonumber(split2[2])
		elseif split2[1] == "e" then
			players = tonumber(split2[2])
		elseif split2[1] == "f" and mariolivecount ~= false then
			mariolives[tonumber(split2[2])] = tonumber(split2[3])
		elseif split2[1] == "g" then
			mariosizes[tonumber(split2[2])] = tonumber(split2[3])
		elseif split2[1] == "h" then
			mappack = split2[2]
		end
	end
	
	love.filesystem.remove("suspend.txt")
end

function changescale(s, fullscreen)
	scale = s
	
	if fullscreen then
		love.graphics.setMode(1680, 1050, fullscreen, vsync, fsaa)
	else
		uispace = math.floor(width*16*scale/4)
		love.graphics.setMode(width*16*scale, height*16*scale, fullscreen, vsync, fsaa) --27x14 blocks (15 blocks actual height)
	end
	
	gamewidth = love.graphics.getWidth()
	gameheight = love.graphics.getHeight()
	
	if shaders then
		shaders:refresh()
	end
end

function love.keypressed(key, unicode)
	if key == "lctrl" then
		--debug.debug()
		--return
	end
	
	if key == "t" then
		--editormode = not editormode
		--return
	end
	
	if keyprompt then
		keypromptenter("key", key)
		return
	end

	for i, v in pairs(guielements) do
		if unicode <= 255 and v:keypress(string.lower(string.char(unicode)), key) then
			return
		end
	end
	
	if key == "f12" then
		love.mouse.setGrab(not love.mouse.isGrabbed())
	end
	
	if gamestate == "lobby" or gamestate == "onlinemenu" then
		if key == "escape" then
			net_quit()
			return
		end
	end
	
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" then
		--(not) konami code
		--With this you can figure out the new Konami code:

		--SY

		--0..3

		--Have fun.
		
		table.insert(konamitable, key)
		table.remove(konamitable, 1)
		local s = ""
		for i = 1, #konamitable do
			s = s .. konamitable[i]
		end
		
		if sha1(s) == konamihash then
			if konamisound:isStopped() then
				playsound(konamisound)
			end
			gamefinished = true
			saveconfig()
		end
		menu_keypressed(key, unicode)
	elseif gamestate == "game" then
		game_keypressed(key, unicode)
	elseif gamestate == "intro" then
		intro_keypressed()
	end
end

function love.keyreleased(key, unicode)
	if gamestate == "menu" or gamestate == "options" then
		menu_keyreleased(key, unicode)
	elseif gamestate == "game" then
		game_keyreleased(key, unicode)
	end
end

function love.mousepressed(x, y, button)
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" then
		menu_mousepressed(x, y, button)
	elseif gamestate == "game" then
		game_mousepressed(x, y, button)
	elseif gamestate == "intro" then
		intro_mousepressed()
	end
	
	for i, v in pairs(guielements) do
		if v.priority then
			if v:click(x, y, button) then
				return
			end
		end
	end
	
	for i, v in pairs(guielements) do
		if not v.priority then
			if v:click(x, y, button) then
				return
			end
		end
	end
end

function love.mousereleased(x, y, button)
	if gamestate == "menu" or gamestate == "options" then
		menu_mousereleased(x, y, button)
	elseif gamestate == "game" then
		game_mousereleased(x, y, button)
	end
	
	for i, v in pairs(guielements) do
		v:unclick(x, y, button)
	end
end

function love.joystickpressed(joystick, button)
	if keyprompt then
		keypromptenter("joybutton", joystick, button)
		return
	end
	
	if gamestate == "menu" or gamestate == "options" then
		menu_joystickpressed(joystick, button)
	elseif gamestate == "game" then
		game_joystickpressed(joystick, button)
	end
end

function love.joystickreleased(joystick, button)
	if gamestate == "menu" or gamestate == "options" then
		menu_joystickreleased(joystick, button)
	elseif gamestate == "game" then
		game_joystickreleased(joystick, button)
	end
end

function round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function getrainbowcolor(i)
	local whiteness = 255
	local r, g, b
	if i < 1/6 then
		r = 1
		g = i*6
		b = 0
	elseif i >= 1/6 and i < 2/6 then
		r = (1/6-(i-1/6))*6
		g = 1
		b = 0
	elseif i >= 2/6 and i < 3/6 then
		r = 0
		g = 1
		b = (i-2/6)*6
	elseif i >= 3/6 and i < 4/6 then
		r = 0
		g = (1/6-(i-3/6))*6
		b = 1
	elseif i >= 4/6 and i < 5/6 then
		r = (i-4/6)*6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = (1/6-(i-5/6))*6
	end
	
	return {round(r*whiteness), round(g*whiteness), round(b*whiteness), 255}
end

function newRecoloredImage(path, tablein, tableout)
	local imagedata = love.image.newImageData( path )
	local width, height = imagedata:getWidth(), imagedata:getHeight()
	
	for y = 0, height-1 do
		for x = 0, width-1 do
			local oldr, oldg, oldb, olda = imagedata:getPixel(x, y)
			
			if olda > 128 then
				for i = 1, #tablein do
					if oldr == tablein[i][1] and oldg == tablein[i][2] and oldb == tablein[i][3] then
						local r, g, b = unpack(tableout[i])
						imagedata:setPixel(x, y, r, g, b, olda)
					end
				end
			end
		end
	end
	
	return love.graphics.newImage(imagedata)
end

function string:split(delimiter) --Not by me
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function tablecontains(t, entry)
	for i, v in pairs(t) do
		if v == entry then
			return true
		end
	end
	return false
end

function getaveragecolor(imgdata, cox, coy)	
	local xstart = (cox-1)*17
	local ystart = (coy-1)*17
	
	local r, g, b = 0, 0, 0
	
	local count = 0
	
	for x = xstart, xstart+15 do
		for y = ystart, ystart+15 do
			local pr, pg, pb, a = imgdata:getPixel(x, y)
			if a > 127 then
				r, g, b = r+pr, g+pg, b+pb
				count = count + 1
			end
		end
	end
	
	r, g, b = r/count, g/count, b/count
	
	return r, g, b
end

function keyprompt_update()
	if keyprompt then
		for i = 1, prompt.joysticks do
			for j = 1, #prompt.joystick[i].validhats do
				local dir = love.joystick.getHat(i, prompt.joystick[i].validhats[j])
				if dir ~= "c" then
					keypromptenter("joyhat", i, prompt.joystick[i].validhats[j], dir)
					return
				end
			end
			
			for j = 1, prompt.joystick[i].axes do
				local value = love.joystick.getAxis(i, j)
				if value > prompt.joystick[i].axisposition[j] + joystickdeadzone then
					keypromptenter("joyaxis", i, j, "pos")
					return
				elseif value < prompt.joystick[i].axisposition[j] - joystickdeadzone then
					keypromptenter("joyaxis", i, j, "neg")
					return
				end
			end
		end
	end
end

function print_r (t, indent) --Not by me
	local indent=indent or ''
	for key,value in pairs(t) do
		io.write(indent,'[',tostring(key),']') 
		if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
		else io.write(' = ',tostring(value),'\n') end
	end
end

function love.focus(f)
	--[[if not f and gamestate == "game"and not editormode and not levelfinished and not everyonedead  then
		pausemenuopen = true
		love.audio.pause()
	end--]]
end

function openSaveFolder(subfolder) --By Slime
	local path = love.filesystem.getSaveDirectory()
	path = subfolder and path.."/"..subfolder or path
	
	local cmdstr
	local successval = 0
	
	if os.getenv("WINDIR") then -- lolwindows
		--cmdstr = "Explorer /root,%s"
		if path:match("LOVE") then --hardcoded to fix ISO characters in usernames and made sure release mode doesn't mess anything up -saso
			cmdstr = "Explorer %%appdata%%\\LOVE\\mari0_se"
		else
			cmdstr = "Explorer %%appdata%%\\mari0_se"
		end
		path = path:gsub("/", "\\")
		successval = 1
	elseif os.getenv("HOME") then
		if path:match("/Library/Application Support") then -- OSX
			cmdstr = "open \"%s\""
		else -- linux?
			cmdstr = "xdg-open \"%s\""
		end
	end
	
	-- returns true if successfully opened folder
	return cmdstr and os.execute(cmdstr:format(path)) == successval
end

function getupdate()
	local onlinedata, code = http.request("http://server.stabyourself.net/mari0/?mode=mappacks")
	
	if code ~= 200 then
		return false
	elseif not onlinedata then
		return false
	end
	
	local latestversion
	
	local split1 = onlinedata:split("<")
	for i = 2, #split1 do
		local split2 = split1[i]:split(">")
		if split2[1] == "latestversion" then
			latestversion = tonumber(split2[2])
		end
	end
	
	if latestversion and latestversion > marioversion then
		return true
	end
	return false
end

function properprint(s, x, y, sc)
	local scale = sc or scale
	local startx = x
	local skip = 0
	for i = 1, string.len(tostring(s)) do
		if skip > 0 then
			skip = skip - 1
		else
			local char = string.sub(s, i, i)
			if string.sub(s, i, i+3) == "_dir" and tonumber(string.sub(s, i+4, i+4)) then
				love.graphics.drawq(directionsimg, directionsquad[tonumber(string.sub(s, i+4, i+4))], x+((i-1)*8+1)*scale, y, 0, scale, scale)
				skip = 4
			elseif char == "|" then
				x = startx-((i)*8)*scale
				y = y + 10*scale
			elseif fontquads[char] then
				love.graphics.drawq(fontimage, fontquads[char], x+((i-1)*8+1)*scale, y, 0, scale, scale)
			end
		end
	end
end

function properprintbackground(s, x, y, include, color)
	local startx = x
	local skip = 0
	for i = 1, string.len(tostring(s)) do
		if skip > 0 then
			skip = skip - 1
		else
			local char = string.sub(s, i, i)
			if char == "|" then
				x = startx-((i)*8)*scale
				y = y + 10*scale
			elseif fontquadsback[char] then
				love.graphics.drawq(fontimageback, fontquadsback[char], x+((i-1)*8)*scale, y-1*scale, 0, scale, scale)
			end
		end
	end
	
	if include then
		properprint(s, x, y)
	end
end

function loadcustombackgrounds()
	custombackgrounds = {}

	custombackgroundimg = {}
	custombackgroundwidth = {}
	custombackgroundheight = {}
	local fl = love.filesystem.enumerate("mappacks/" .. mappack .. "/background")
	
	for i = 1, #fl do
		local v = "mappacks/" .. mappack .. "/background/" .. fl[i]
		
		if love.filesystem.isFile(v) and string.sub(v, -5, -5) == "1" then
			local name = string.sub(fl[i], 1, -6)
			local bg = string.sub(v, 1, -6)
			local i = 1
			table.insert(custombackgrounds, name)
			
			custombackgroundimg[name] = {}
			custombackgroundwidth[name] = {}
			custombackgroundheight[name] = {}
			
			while love.filesystem.exists(bg .. i .. ".png") do
				custombackgroundimg[name][i] = love.graphics.newImage(bg .. i .. ".png")
				custombackgroundwidth[name][i] = custombackgroundimg[name][i]:getWidth()/16
				custombackgroundheight[name][i] = custombackgroundimg[name][i]:getHeight()/16
				i = i + 1
			end
		end
	end
end

function loadcustommusics()
	local fl = love.filesystem.enumerate("mappacks/" .. mappack .. "/music")
	custommusics = {}
	
	for i = 1, #fl do
		local v = fl[i]
		if v:match(".ogg") or v:match(".mp3") then
			table.insert(custommusics, v)
			music:load("mappacks/" .. mappack .. "/music/" .. v)
		end
	end
end

function loadanimatedtiles() --animated
	if animatedtilecount then
		for i = 1, animatedtilecount do
			tilequads["a" .. i] = nil
		end
	end
	
	animatedtiles = {}
	
	local fl = love.filesystem.enumerate("mappacks/" .. mappack .. "/animated")
	animatedtilecount = 0
	
	local i = 1
	while love.filesystem.isFile("mappacks/" .. mappack .. "/animated/" .. i .. ".png") do
		local v = "mappacks/" .. mappack .. "/animated/" .. i .. ".png"
		if love.filesystem.isFile(v) and string.sub(v, -4) == ".png" then
			if love.filesystem.isFile(string.sub(v, 1, -5) .. ".txt") then
				animatedtilecount = animatedtilecount + 1
				local t = animatedquad:new(v, love.filesystem.read(string.sub(v, 1, -5) .. ".txt"))
				tilequads[animatedtilecount+10000] = t
				table.insert(animatedtiles, t)
			end
		end
		i = i + 1
	end
end

function love.quit() 
	music:exit()
end

function savestate(i)
	serializetable(_G)
end

function serializetable(t)
	tablestodo = {t}
	tableindex = {}
	repeat
		nexttablestodo = {}
		for i, v in pairs(tablestodo) do
			if type(v) == "table" then
				local tableexists = false
				for j, k in pairs(tableindex) do
					if k == v then
						tableexists = true
					end
				end
				
				if tableexists then
					
				else
					table.insert(nexttablestodo, v)
					table.insert(tableindex, v)
				end
			end
		end
		tablestodo = nexttablestodo
	until #tablestodo == 0
end