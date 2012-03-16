--[[
	STEAL MY SHIT AND I'LL FUCK YOU UP
	PRETTY MUCH EVERYTHING BY MAURICE GUÉGAN AND IF SOMETHING ISN'T BY ME THEN IT SHOULD BE OBVIOUS OR NOBODY CARES

	THIS AWESOME PIECE OF CELESTIAL AMBROSIA IS RELEASED AS NON-COMMERCIAL, SHARE ALIKE, WHATEVER. YOU MAY PRINT OUT THIS CODES AND USE IT AS WALLPAPER IN YOUR BATHROOM.
	FOR SPECIFIC LICENSE (I know you linux users get a hard on when it comes to licenses) SEE http://creativecommons.org/licenses/by-nc-sa/3.0/
	NOW GO AWAY (or stay and modify shit. I don't care as long as you stick to the above license.)
]]

function love.load()
	marioversion = 1006
	versionstring = "version 1.6"
	shaderlist = love.filesystem.enumerate( "shaders/" )
	dlclist = {"dlc_a_portal_tribute", "dlc_acid_trip", "dlc_escape_the_lab", "dlc_scienceandstuff", "dlc_smb2J", "dlc_the_untitled_game"}
	
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
	currentshaderi1 = 1
	currentshaderi2 = 1
	
	hatcount = #love.filesystem.enumerate("graphics/SMB/hats")
	
	if not pcall(loadconfig) then
		players = 1
		defaultconfig()
	end
	
	saveconfig()
	width = 25
	fsaa = 0
	fullscreen = false
	changescale(scale, fullscreen)
	love.graphics.setCaption( "Mari0" )
	
	--version check by checking for a const that was added in 0.8.0
	if love._version_major == nil then error("You have an outdated version of Love! Get 0.8.0 or higher and retry.") end
	
	iconimg = love.graphics.newImage("graphics/icon.gif")
	love.graphics.setIcon(iconimg)
	
	love.graphics.setDefaultImageFilter("nearest", "nearest")
	
	love.graphics.setBackgroundColor(0, 0, 0)
	
	
	fontimage = love.graphics.newImage("graphics/SMB/font.png")
	fontglyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>* !{}?"
	fontquads = {}
	for i = 1, string.len(fontglyphs) do
		fontquads[string.sub(fontglyphs, i, i)] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 512, 8)
	end
	
	math.randomseed(os.time());math.random();math.random()
	
	love.graphics.clear()
	love.graphics.setColor(100, 100, 100)
	loadingtexts = {"reticulating splines..", "loading..", "booting glados..", "growing potatoes..", "voting against acta..", "rendering important stuff..",
					"baking cake..", "happy explosion day..", "raising coolness by 20 percent..", "yay facepunch..", "stabbing myself..", "sharpening knives..",
					"tanaka, thai kick..", "loading game genie.."}
	loadingtext = loadingtexts[math.random(#loadingtexts)]
	properprint(loadingtext, 25*8*scale-string.len(loadingtext)*4*scale, 108*scale)
	love.graphics.present()
	--require ALL the files!
	require "shaders"
	require "variables"
	require "class"
	require "sha1"
	
	require "intro"
	require "menu"
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
	require "musicloader"
	
	http = require("socket.http")
	http.TIMEOUT = 1
	
	love.filesystem.setIdentity("mari0")
	
	updatenotification = false
	if getupdate() then
		updatenotification = true
	end
	http.TIMEOUT = 4
	
	graphicspack = "SMB" --SMB, ALLSTARS
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
	love.graphics.setLineWidth(3*scale)
	
	uispace = math.floor(width*16*scale/4)
	guielements = {}
	
	--Backgroundcolors
	backgroundcolor = {}
	backgroundcolor[1] = {92, 148, 252}
	backgroundcolor[2] = {0, 0, 0}
	backgroundcolor[3] = {32, 56, 236}
	
	--IMAGES--
	
	menuselection = love.graphics.newImage("graphics/" .. graphicspack .. "/menuselect.png")
	mappackback = love.graphics.newImage("graphics/" .. graphicspack .. "/mappackback.png")
	mappacknoicon = love.graphics.newImage("graphics/" .. graphicspack .. "/mappacknoicon.png")
	mappackoverlay = love.graphics.newImage("graphics/" .. graphicspack .. "/mappackoverlay.png")
	mappackhighlight = love.graphics.newImage("graphics/" .. graphicspack .. "/mappackhighlight.png")
	
	mappackscrollbar = love.graphics.newImage("graphics/" .. graphicspack .. "/mappackscrollbar.png")
	
	--tiles
	smbtilesimg = love.graphics.newImage("graphics/" .. graphicspack .. "/smbtiles.png")
	portaltilesimg = love.graphics.newImage("graphics/" .. graphicspack .. "/portaltiles.png")
	entitiesimg = love.graphics.newImage("graphics/" .. graphicspack .. "/entities.png")
	tilequads = {}
	
	rgblist = {}
	
	--add smb tiles
	local imgwidth, imgheight = smbtilesimg:getWidth(), smbtilesimg:getHeight()
	local width = math.floor(imgwidth/17)
	local height = math.floor(imgheight/17)
	local imgdata = love.image.newImageData("graphics/" .. graphicspack .. "/smbtiles.png")
	
	for y = 1, height do
		for x = 1, width do
			table.insert(tilequads, quad:new(smbtilesimg, imgdata, x, y, imgwidth, imgheight))
			local r, g, b = getaveragecolor(imgdata, x, y)
			table.insert(rgblist, {r, g, b})
		end
	end
	smbtilecount = width*height
	
	--add portal tiles
	local imgwidth, imgheight = portaltilesimg:getWidth(), portaltilesimg:getHeight()
	local width = math.floor(imgwidth/17)
	local height = math.floor(imgheight/17)
	local imgdata = love.image.newImageData("graphics/" .. graphicspack .. "/portaltiles.png")
	
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
	local imgwidth, imgheight = entitiesimg:getWidth(), entitiesimg:getHeight()
	local width = math.floor(imgwidth/17)
	local height = math.floor(imgheight/17)
	local imgdata = love.image.newImageData("graphics/" .. graphicspack .. "/entities.png")
	
	for y = 1, height do
		for x = 1, width do
			table.insert(entityquads, entity:new(entitiesimg, x, y, imgwidth, imgheight))
			entityquads[#entityquads]:sett(#entityquads)
		end
	end
	entitiescount = width*height
	
	fontimage2 = love.graphics.newImage("graphics/" .. graphicspack .. "/smallfont.png")
	numberglyphs = "012458"
	font2quads = {}
	for i = 1, 6 do
		font2quads[string.sub(numberglyphs, i, i)] = love.graphics.newQuad((i-1)*4, 0, 4, 8, 32, 8)
	end
	
	oneuptextimage = love.graphics.newImage("graphics/" .. graphicspack .. "/oneuptext.png")
	
	blockdebrisimage = love.graphics.newImage("graphics/" .. graphicspack .. "/blockdebris.png")
	blockdebrisquads = {}
	for y = 1, 4 do
		blockdebrisquads[y] = {}
		for x = 1, 2 do
			blockdebrisquads[y][x] = love.graphics.newQuad((x-1)*8, (y-1)*8, 8, 8, 16, 32)
		end
	end
	
	coinblockanimationimage = love.graphics.newImage("graphics/" .. graphicspack .. "/coinblockanimation.png")
	coinblockanimationquads = {}
	for i = 1, 30 do
		coinblockanimationquads[i] = love.graphics.newQuad((i-1)*8, 0, 8, 52, 256, 64)
	end
	
	coinanimationimage = love.graphics.newImage("graphics/" .. graphicspack .. "/coinanimation.png")
	coinanimationquads = {}
	for j = 1, 4 do
		coinanimationquads[j] = {}
		for i = 1, 3 do
			coinanimationquads[j][i] = love.graphics.newQuad((i-1)*5, (j-1)*8, 5, 8, 16, 32)
		end
	end
	
	--coinblock
	coinblockimage = love.graphics.newImage("graphics/" .. graphicspack .. "/coinblock.png")
	coinblockquads = {}
	for j = 1, 4 do
		coinblockquads[j] = {}
		for i = 1, 3 do
			coinblockquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
		end
	end
	
	--coin
	coinimage = love.graphics.newImage("graphics/" .. graphicspack .. "/coin.png")
	coinquads = {}
	for j = 1, 4 do
		coinquads[j] = {}
		for i = 1, 3 do
			coinquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
		end
	end
	
	--axe
	axeimg = love.graphics.newImage("graphics/" .. graphicspack .. "/axe.png")
	axequads = {}
	for i = 1, 3 do
		axequads[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	--spring
	springimg = love.graphics.newImage("graphics/" .. graphicspack .. "/spring.png")
	springquads = {}
	for i = 1, 4 do
		springquads[i] = {}
		for j = 1, 3 do
			springquads[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*31, 16, 31, 48, 124)
		end
	end
	
	--toad
	toadimg = love.graphics.newImage("graphics/" .. graphicspack .. "/toad.png")
	
	--queen I mean princess
	peachimg = love.graphics.newImage("graphics/" .. graphicspack .. "/peach.png")
	
	platformimg = love.graphics.newImage("graphics/" .. graphicspack .. "/platform.png")
	platformbonusimg = love.graphics.newImage("graphics/" .. graphicspack .. "/platformbonus.png")
	
	seesawimg = love.graphics.newImage("graphics/" .. graphicspack .. "/seesaw.png")
	seesawquad = {}
	for i = 1, 4 do
		seesawquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	titleimage = love.graphics.newImage("graphics/" .. graphicspack .. "/title.png")
	playerselectimg = love.graphics.newImage("graphics/" .. graphicspack .. "/playerselectarrow.png")
	
	starimg = love.graphics.newImage("graphics/" .. graphicspack .. "/star.png")
	starquad = {}
	for i = 1, 4 do
		starquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	flowerimg = love.graphics.newImage("graphics/" .. graphicspack .. "/flower.png")
	flowerquad = {}
	for i = 1, 4 do
		flowerquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	fireballimg = love.graphics.newImage("graphics/" .. graphicspack .. "/fireball.png")
	fireballquad = {}
	for i = 1, 4 do
		fireballquad[i] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 80, 16)
	end
	
	for i = 5, 7 do
		fireballquad[i] = love.graphics.newQuad((i-5)*16+32, 0, 16, 16, 80, 16)
	end
	
	vineimg = love.graphics.newImage("graphics/" .. graphicspack .. "/vine.png")
	vinequad = {}
	for i = 1, 4 do
		vinequad[i] = {}
		for j = 1, 2 do
			vinequad[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*16, 16, 16, 32, 64) 
		end
	end
	
	--enemies
	goombaimage = love.graphics.newImage("graphics/" .. graphicspack .. "/goomba.png")
	goombaquad = {}
	
	for y = 1, 4 do
		goombaquad[y] = {}
		for x = 1, 2 do
			goombaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 32, 64)
		end
	end
	
	spikeyimg = love.graphics.newImage("graphics/" .. graphicspack .. "/spikey.png")
	
	spikeyquad = {}
	for x = 1, 4 do
		spikeyquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 64, 16)
	end
	
	lakitoimg = love.graphics.newImage("graphics/" .. graphicspack .. "/lakito.png")
	lakitoquad = {}
	for x = 1, 2 do
		lakitoquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 24, 32, 24)
	end
	
	koopaimage = love.graphics.newImage("graphics/" .. graphicspack .. "/koopa.png")
	kooparedimage = love.graphics.newImage("graphics/" .. graphicspack .. "/koopared.png")
	beetleimage = love.graphics.newImage("graphics/" .. graphicspack .. "/beetle.png")
	koopaquad = {}
	
	for y = 1, 4 do
		koopaquad[y] = {}
		for x = 1, 5 do
			koopaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, 128, 128)
		end
	end
	
	cheepcheepimg = love.graphics.newImage("graphics/" .. graphicspack .. "/cheepcheep.png")
	cheepcheepquad = {}
	
	cheepcheepquad[1] = {}
	cheepcheepquad[1][1] = love.graphics.newQuad(0, 0, 16, 16, 32, 32)
	cheepcheepquad[1][2] = love.graphics.newQuad(16, 0, 16, 16, 32, 32)
	
	cheepcheepquad[2] = {}
	cheepcheepquad[2][1] = love.graphics.newQuad(0, 16, 16, 16, 32, 32)
	cheepcheepquad[2][2] = love.graphics.newQuad(16, 16, 16, 16, 32, 32)
	
	squidimg = love.graphics.newImage("graphics/" .. graphicspack .. "/squid.png")
	squidquad = {}
	for x = 1, 2 do
		squidquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 24, 32, 32)
	end
	
	bulletbillimg = love.graphics.newImage("graphics/" .. graphicspack .. "/bulletbill.png")
	bulletbillquad = {}
	
	for y = 1, 4 do
		bulletbillquad[y] = love.graphics.newQuad(0, (y-1)*16, 16, 16, 16, 64)
	end
	
	hammerbrosimg = love.graphics.newImage("graphics/" .. graphicspack .. "/hammerbros.png")
	hammerbrosquad = {}
	for y = 1, 4 do
		hammerbrosquad[y] = {}
		for x = 1, 4 do
			hammerbrosquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*34, 16, 34, 64, 256)
		end
	end	
	
	hammerimg = love.graphics.newImage("graphics/" .. graphicspack .. "/hammer.png")
	hammerquad = {}
	for j = 1, 4 do
		hammerquad[j] = {}
		for i = 1, 4 do
			hammerquad[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
		end
	end
	
	plantimg = love.graphics.newImage("graphics/" .. graphicspack .. "/plant.png")
	plantquads = {}
	for j = 1, 4 do
		plantquads[j] = {}
		for i = 1, 2 do
			plantquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*23, 16, 23, 32, 128)
		end
	end
	
	fireimg = love.graphics.newImage("graphics/" .. graphicspack .. "/fire.png")
	firequad = {love.graphics.newQuad(0, 0, 24, 8, 48, 8), love.graphics.newQuad(24, 0, 24, 8, 48, 8)}
	
	upfireimg = love.graphics.newImage("graphics/" .. graphicspack .. "/upfire.png")
	
	bowserimg = love.graphics.newImage("graphics/" .. graphicspack .. "/bowser.png")
	bowserquad = {}
	bowserquad[1] = {love.graphics.newQuad(0, 0, 32, 32, 64, 64), love.graphics.newQuad(32, 0, 32, 32, 64, 64)}
	bowserquad[2] = {love.graphics.newQuad(0, 32, 32, 32, 64, 64), love.graphics.newQuad(32, 32, 32, 32, 64, 64)}
	
	decoysimg = love.graphics.newImage("graphics/" .. graphicspack .. "/decoys.png")
	decoysquad = {}
	for y = 1, 7 do
		decoysquad[y] = love.graphics.newQuad(0, (y-1)*32, 32, 32, 64, 256)
	end
	
	boximage = love.graphics.newImage("graphics/" .. graphicspack .. "/box.png")
	boxquad = love.graphics.newQuad(0, 0, 12, 12, 16, 16)
	
	flagimg = love.graphics.newImage("graphics/" .. graphicspack .. "/flag.png")
	castleflagimg = love.graphics.newImage("graphics/" .. graphicspack .. "/castleflag.png")
	
	bubbleimg = love.graphics.newImage("graphics/" .. graphicspack .. "/bubble.png")
	
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
	
	--GUI
	checkboximg = love.graphics.newImage("graphics/GUI/checkbox.png")
	checkboxquad = {{love.graphics.newQuad(0, 0, 9, 9, 18, 18), love.graphics.newQuad(9, 0, 9, 9, 18, 18)}, {love.graphics.newQuad(0, 9, 9, 9, 18, 18), love.graphics.newQuad(9, 9, 9, 9, 18, 18)}}
	
	dropdownarrowimg = love.graphics.newImage("graphics/GUI/dropdownarrow.png")
	
	--players
	marioanimations = {}
	marioanimations[0] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/marioanimations0.png")
	marioanimations[1] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/marioanimations1.png")
	marioanimations[2] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/marioanimations2.png")
	marioanimations[3] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/marioanimations3.png")
	
	minecraftanimations = {}
	minecraftanimations[0] = love.graphics.newImage("graphics/Minecraft/marioanimations0.png")
	minecraftanimations[1] = love.graphics.newImage("graphics/Minecraft/marioanimations1.png")
	minecraftanimations[2] = love.graphics.newImage("graphics/Minecraft/marioanimations2.png")
	minecraftanimations[3] = love.graphics.newImage("graphics/Minecraft/marioanimations3.png")
	
	marioidle = {}
	mariorun = {}
	marioslide = {}
	mariojump = {}
	mariodie = {}
	marioclimb = {}
	marioswim = {}
	mariogrow = {}
	
	for i = 1, 5 do
		marioidle[i] = love.graphics.newQuad(0, (i-1)*20, 20, 20, 512, 128)
		
		mariorun[i] = {}
		mariorun[i][1] = love.graphics.newQuad(20, (i-1)*20, 20, 20, 512, 128)
		mariorun[i][2] = love.graphics.newQuad(40, (i-1)*20, 20, 20, 512, 128)
		mariorun[i][3] = love.graphics.newQuad(60, (i-1)*20, 20, 20, 512, 128)
		
		marioslide[i] = love.graphics.newQuad(80, (i-1)*20, 20, 20, 512, 128)
		mariojump[i] = love.graphics.newQuad(100, (i-1)*20, 20, 20, 512, 128)
		mariodie[i] = love.graphics.newQuad(120, (i-1)*20, 20, 20, 512, 128)
		
		marioclimb[i] = {}
		marioclimb[i][1] = love.graphics.newQuad(140, (i-1)*20, 20, 20, 512, 128)
		marioclimb[i][2] = love.graphics.newQuad(160, (i-1)*20, 20, 20, 512, 128)
		
		marioswim[i] = {}
		marioswim[i][1] = love.graphics.newQuad(180, (i-1)*20, 20, 20, 512, 128)
		marioswim[i][2] = love.graphics.newQuad(200, (i-1)*20, 20, 20, 512, 128)
		
		mariogrow[i] = love.graphics.newQuad(260, 0, 20, 24, 512, 128)
	end
	
	
	bigmarioanimations = {}
	bigmarioanimations[0] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/bigmarioanimations0.png")
	bigmarioanimations[1] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/bigmarioanimations1.png")
	bigmarioanimations[2] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/bigmarioanimations2.png")
	bigmarioanimations[3] = love.graphics.newImage("graphics/" .. graphicspack .. "/player/bigmarioanimations3.png")
	
	bigminecraftanimations = {}
	bigminecraftanimations[0] = love.graphics.newImage("graphics/Minecraft/bigmarioanimations0.png")
	bigminecraftanimations[1] = love.graphics.newImage("graphics/Minecraft/bigmarioanimations1.png")
	bigminecraftanimations[2] = love.graphics.newImage("graphics/Minecraft/bigmarioanimations2.png")
	bigminecraftanimations[3] = love.graphics.newImage("graphics/Minecraft/bigmarioanimations3.png")
	
	bigmarioidle = {}
	bigmariorun = {}
	bigmarioslide = {}
	bigmariojump = {}
	bigmariofire = {}
	bigmarioclimb = {}
	bigmarioswim = {}
	bigmarioduck = {} --hehe duck.
	
	for i = 1, 5 do
		bigmarioidle[i] = love.graphics.newQuad(0, (i-1)*36, 20, 36, 512, 256)
		
		bigmariorun[i] = {}
		bigmariorun[i][1] = love.graphics.newQuad(20, (i-1)*36, 20, 36, 512, 256)
		bigmariorun[i][2] = love.graphics.newQuad(40, (i-1)*36, 20, 36, 512, 256)
		bigmariorun[i][3] = love.graphics.newQuad(60, (i-1)*36, 20, 36, 512, 256)
		
		bigmarioslide[i] = love.graphics.newQuad(80, (i-1)*36, 20, 36, 512, 256)
		bigmariojump[i] = love.graphics.newQuad(100, (i-1)*36, 20, 36, 512, 256)
		bigmariofire[i] = love.graphics.newQuad(120, (i-1)*36, 20, 36, 512, 256)
		
		bigmarioclimb[i] = {}
		bigmarioclimb[i][1] = love.graphics.newQuad(140, (i-1)*36, 20, 36, 512, 256)
		bigmarioclimb[i][2] = love.graphics.newQuad(160, (i-1)*36, 20, 36, 512, 256)
		
		bigmarioswim[i] = {}
		bigmarioswim[i][1] = love.graphics.newQuad(180, (i-1)*36, 20, 36, 512, 256)
		bigmarioswim[i][2] = love.graphics.newQuad(200, (i-1)*36, 20, 36, 512, 256)
		
		bigmarioduck[i] = love.graphics.newQuad(260, (i-1)*36, 20, 36, 512, 256)
	end
	
	--portals
	portalimage = love.graphics.newImage("graphics/" .. graphicspack .. "/portal.png")
	portal1quad = {}
	for i = 0, 7 do
		portal1quad[i] = love.graphics.newQuad(0, i*4, 32, 4, 64, 32)
	end
	
	portal2quad = {}
	for i = 0, 7 do
		portal2quad[i] = love.graphics.newQuad(32, i*4, 32, 4, 64, 32)
	end
	
	portalglow = love.graphics.newImage("graphics/" .. graphicspack .. "/portalglow.png")
	
	portalparticleimg = love.graphics.newImage("graphics/" .. graphicspack .. "/portalparticle.png")
	portalcrosshairimg = love.graphics.newImage("graphics/" .. graphicspack .. "/portalcrosshair.png")
	portaldotimg = love.graphics.newImage("graphics/" .. graphicspack .. "/portaldot.png")
	portalprojectileimg = love.graphics.newImage("graphics/" .. graphicspack .. "/portalprojectile.png")
	portalprojectileparticleimg = love.graphics.newImage("graphics/" .. graphicspack .. "/portalprojectileparticle.png")
	
	--Menu shit
	huebarimg = love.graphics.newImage("graphics/" .. graphicspack .. "/huebar.png")
	huebarmarkerimg = love.graphics.newImage("graphics/" .. graphicspack .. "/huebarmarker.png")
	volumesliderimg = love.graphics.newImage("graphics/" .. graphicspack .. "/volumeslider.png")
	
	--Portal props
	emanceparticleimg = love.graphics.newImage("graphics/" .. graphicspack .. "/emanceparticle.png")
	emancesideimg = love.graphics.newImage("graphics/" .. graphicspack .. "/emanceside.png")
	
	doorpieceimg = love.graphics.newImage("graphics/" .. graphicspack .. "/doorpiece.png")
	doorcenterimg = love.graphics.newImage("graphics/" .. graphicspack .. "/doorcenter.png")
	
	buttonbaseimg = love.graphics.newImage("graphics/" .. graphicspack .. "/buttonbase.png")
	buttonbuttonimg = love.graphics.newImage("graphics/" .. graphicspack .. "/buttonbutton.png")
	
	pushbuttonimg = love.graphics.newImage("graphics/" .. graphicspack .. "/pushbutton.png")
	pushbuttonquad = {love.graphics.newQuad(0, 0, 16, 16, 32, 16), love.graphics.newQuad(16, 0, 16, 16, 32, 16)}
	
	wallindicatorimg = love.graphics.newImage("graphics/" .. graphicspack .. "/wallindicator.png")
	wallindicatorquad = {love.graphics.newQuad(0, 0, 16, 16, 32, 16), love.graphics.newQuad(16, 0, 16, 16, 32, 16)}
	
	walltimerimg = love.graphics.newImage("graphics/" .. graphicspack .. "/walltimer.png")
	walltimerquad = {}
	for i = 1, 10 do
		walltimerquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 160, 16)
	end
	
	lightbridgeimg = love.graphics.newImage("graphics/" .. graphicspack .. "/lightbridge.png")
	lightbridgesideimg = love.graphics.newImage("graphics/" .. graphicspack .. "/lightbridgeside.png")
	
	laserimg = love.graphics.newImage("graphics/" .. graphicspack .. "/laser.png")
	lasersideimg = love.graphics.newImage("graphics/" .. graphicspack .. "/laserside.png")
	
	faithplateplateimg = love.graphics.newImage("graphics/" .. graphicspack .. "/faithplateplate.png")
	
	laserdetectorimg = love.graphics.newImage("graphics/" .. graphicspack .. "/laserdetector.png")
	
	gel1img = love.graphics.newImage("graphics/" .. graphicspack .. "/gel1.png")
	gel2img = love.graphics.newImage("graphics/" .. graphicspack .. "/gel2.png")
	gel3img = love.graphics.newImage("graphics/" .. graphicspack .. "/gel3.png")
	gelquad = {love.graphics.newQuad(0, 0, 12, 12, 36, 12), love.graphics.newQuad(12, 0, 12, 12, 36, 12), love.graphics.newQuad(24, 0, 12, 12, 36, 12)}
	
	gel1ground = love.graphics.newImage("graphics/" .. graphicspack .. "/gel1ground.png")
	gel2ground = love.graphics.newImage("graphics/" .. graphicspack .. "/gel2ground.png")
	gel3ground = love.graphics.newImage("graphics/" .. graphicspack .. "/gel3ground.png")
	
	geldispenserimg = love.graphics.newImage("graphics/" .. graphicspack .. "/geldispenser.png")
	cubedispenserimg = love.graphics.newImage("graphics/" .. graphicspack .. "/cubedispenser.png")
	
	gradientimg = love.graphics.newImage("graphics/gradient.png");gradientimg:setFilter("linear", "linear")
	
	--optionsmenu
	skinpuppet = {}
	secondskinpuppet = {}
	for i = 0, 3 do
		skinpuppet[i] = love.graphics.newImage("graphics/" .. graphicspack .. "/options/skin" .. i .. ".png")
		secondskinpuppet[i] = love.graphics.newImage("graphics/" .. graphicspack .. "/options/secondskin" .. i .. ".png")
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
	stabsound = love.audio.newSource("sounds/stab.ogg", "static")
	
	
	portal1opensound = love.audio.newSource("sounds/portal1open.ogg", "static");portal1opensound:setVolume(0);portal1opensound:play();portal1opensound:stop();portal1opensound:setVolume(0.3)
	portal2opensound = love.audio.newSource("sounds/portal2open.ogg", "static");portal2opensound:setVolume(0);portal2opensound:play();portal2opensound:stop();portal2opensound:setVolume(0.3)
	portalentersound = love.audio.newSource("sounds/portalenter.ogg", "static");portalentersound:setVolume(0);portalentersound:play();portalentersound:stop();portalentersound:setVolume(0.3)
	portalfizzlesound = love.audio.newSource("sounds/portalfizzle.ogg", "static");portalfizzlesound:setVolume(0);portalfizzlesound:play();portalfizzlesound:stop();portalfizzlesound:setVolume(0.3)
	
	lowtime = love.audio.newSource("sounds/lowtime.ogg", "static");rainboomsound:setVolume(0);rainboomsound:play();rainboomsound:stop();rainboomsound:setVolume(1)
	
	--music
	--[[
	overworldmusic = love.audio.newSource("sounds/overworld.ogg", "stream");overworldmusic:setLooping(true)
	undergroundmusic = love.audio.newSource("sounds/underground.ogg", "stream");undergroundmusic:setLooping(true)
	castlemusic = love.audio.newSource("sounds/castle.ogg", "stream");castlemusic:setLooping(true)
	underwatermusic = love.audio.newSource("sounds/underwater.ogg", "stream");underwatermusic:setLooping(true)
	starmusic = love.audio.newSource("sounds/starmusic.ogg", "stream");starmusic:setLooping(true)
	princessmusic = love.audio.newSource("sounds/princessmusic.ogg", "stream");princessmusic:setLooping(true)
	
	overworldmusicfast = love.audio.newSource("sounds/overworld-fast.ogg", "stream");overworldmusicfast:setLooping(true)
	undergroundmusicfast = love.audio.newSource("sounds/underground-fast.ogg", "stream");undergroundmusicfast:setLooping(true)
	castlemusicfast = love.audio.newSource("sounds/castle-fast.ogg", "stream");castlemusicfast:setLooping(true)
	underwatermusicfast = love.audio.newSource("sounds/underwater-fast.ogg", "stream");underwatermusicfast:setLooping(true)
	starmusicfast = love.audio.newSource("sounds/starmusic-fast.ogg", "stream");starmusicfast:setLooping(true)
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
	
	intro_load()
end

function love.update(dt)
	if music then
		music:update()
	end
	dt = math.min(0.01666667, dt)
	
	--speed
	if speed ~= speedtarget then
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
	
	dt = dt * speed
	gdt = dt
	
	if frameadvance == 1 then
		return
	elseif frameadvance == 2 then
		frameadvance = 1
	end

	if skipupdate then
		skipupdate = false
		return
	end
	
	--netplay_update(dt)
	keyprompt_update()
	
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" then
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
end

function love.draw()
	shaders:predraw()
	
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" then
		menu_draw()
	elseif gamestate == "levelscreen" or gamestate == "gameover" or gamestate == "mappackfinished" then
		levelscreen_draw()
	elseif gamestate == "game" then
		game_draw()
	elseif gamestate == "intro" then
		intro_draw()
	end
	
	shaders:postdraw()
	
	love.graphics.setColor(255, 255,255)
end

function saveconfig()
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
	
	for i = 1, #mariocolors do
		s = s .. "playercolors:" .. i .. ":"
		for j = 1, 3 do
			for k = 1, 3 do
				s = s .. mariocolors[i][j][k]
				if j == 3 and k == 3 then
					s = s .. ";"
				else
					s = s .. ","
				end
			end
		end
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
			mariocolors[tonumber(s2[2])] = {{tonumber(s3[1]), tonumber(s3[2]), tonumber(s3[3])}, {tonumber(s3[4]), tonumber(s3[5]), tonumber(s3[6])}, {tonumber(s3[7]), tonumber(s3[8]), tonumber(s3[9])}}
			
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
					if hatno > hatcount then
						hatno = hatcount
					end
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
			if love.filesystem.exists("mappacks/" .. s2[2] .. "/") then
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
	
	--options
	scale = 2
	volume = 1
	mappack = "smb"
	vsync = false
	
	reachedworlds = {}
end

function suspendgame()
	local s = ""
	if marioworld == "M" then
		marioworld = 8
		mariolevel = 4
	end
	s = s .. "world/" .. marioworld .. "|"
	s = s .. "level/" .. mariolevel .. "|"
	s = s .. "coincount/" .. mariocoincount .. "|"
	s = s .. "score/" .. marioscore .. "|"
	s = s .. "players/" .. players .. "|"
	for i = 1, players do
		if mariolivecount ~= false then
			s = s .. "lives/" .. i .. "/" .. mariolives[i] .. "|"
		end
		if objects["player"][i] then
			s = s .. "size/" .. i .. "/" .. objects["player"][i].size .. "|"
		else
			s = s .. "size/" .. i .."/1|"
		end
	end
	s = s .. "mappack/" .. mappack
	
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
		if split2[1] == "world" then
			marioworld = tonumber(split2[2])
		elseif split2[1] == "level" then
			mariolevel = tonumber(split2[2])
		elseif split2[1] == "coincount" then
			mariocoincount = tonumber(split2[2])
		elseif split2[1] == "score" then
			marioscore = tonumber(split2[2])
		elseif split2[1] == "players" then
			players = tonumber(split2[2])
		elseif split2[1] == "lives" and mariolivecount ~= false then
			mariolives[tonumber(split2[2])] = tonumber(split2[3])
		elseif split2[1] == "size" then
			mariosizes[tonumber(split2[2])] = tonumber(split2[3])
		elseif split2[1] == "mappack" then
			mappack = split2[2]
		end
	end
	
	love.filesystem.remove("suspend.txt")
end

function changescale(s, fullscreen)
	scale = s
	
	if fullscreen then
		fullscreen = true
		scale = 2
		love.graphics.setMode(800, 600, fullscreen, vsync, fsaa)
	end
	
	uispace = math.floor(width*16*scale/4)
	love.graphics.setMode(width*16*scale, 224*scale, fullscreen, vsync, fsaa) --27x14 blocks (15 blocks actual height)
	
	gamewidth = love.graphics.getWidth()
	gameheight = love.graphics.getHeight()
	
	if shaders then
		shaders:refresh()
	end
end

function love.keypressed(key, unicode)
	if keyprompt then
		keypromptenter("key", key)
		return
	end

	for i, v in pairs(guielements) do
		if v:keypress(key) then
			return
		end
	end
	
	if key == "f12" then
		love.mouse.setGrab(not love.mouse.isGrabbed())
	end
	
	if gamestate == "menu" or gamestate == "mappackmenu" or gamestate == "onlinemenu" or gamestate == "options" then
		--konami code
		if key == konami[konamii] then
			konamii = konamii + 1
			if konamii == #konami+1 then
				if konamisound:isStopped() then
					playsound(konamisound)
				end
				gamefinished = true
				saveconfig()
				konamii = 1
			end
		else
			konamii = 1
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
	if not f and gamestate == "game"and not editormode and not levelfinished and not everyonedead  then
		pausemenuopen = true
		love.audio.pause()
	end
end

function openSaveFolder(subfolder) --By Slime
	local path = love.filesystem.getSaveDirectory()
	path = subfolder and path.."/"..subfolder or path
	
	local cmdstr
	local successval = 0
	
	if os.getenv("WINDIR") then -- lolwindows
		--cmdstr = "Explorer /root,%s"
		if path:match("LOVE") then --hardcoded to fix ISO characters in usernames and made sure release mode doesn't mess anything up -saso
			cmdstr = "Explorer %%appdata%%\\LOVE\\mari0"
		else
			cmdstr = "Explorer %%appdata%%\\mari0"
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

function properprint(s, x, y)
	local startx = x
	for i = 1, string.len(tostring(s)) do
		local char = string.sub(s, i, i)
		if char == "|" then
			x = startx-((i)*8)*scale
			y = y + 10*scale
		elseif fontquads[char] then
			love.graphics.drawq(fontimage, fontquads[char], x+((i-1)*8)*scale, y, 0, scale, scale)
		end
	end
end

function loadcustombackground()
	local i = 1
	custombackgroundimg = {}
	custombackgroundwidth = {}
	custombackgroundheight = {}
	--try to load map specific background first
	local levelstring = marioworld .. "-" .. mariolevel
	if mariosublevel ~= 0 then
		levelstring = levelstring .. "_" .. mariosublevel
	end
	
	while love.filesystem.exists("mappacks/" .. mappack .. "/" .. levelstring .. "background" .. i .. ".png") do
		custombackgroundimg[i] = love.graphics.newImage("mappacks/" .. mappack .. "/" .. levelstring .. "background" .. i .. ".png")
		custombackgroundwidth[i] = custombackgroundimg[i]:getWidth()/16
		custombackgroundheight[i] = custombackgroundimg[i]:getHeight()/16
		i = i +1
	end
	
	if #custombackgroundimg == 0 then
		while love.filesystem.exists("mappacks/" .. mappack .. "/background" .. i .. ".png") do
			custombackgroundimg[i] = love.graphics.newImage("mappacks/" .. mappack .. "/background" .. i .. ".png")
			custombackgroundwidth[i] = custombackgroundimg[i]:getWidth()/16
			custombackgroundheight[i] = custombackgroundimg[i]:getHeight()/16
			i = i +1
		end
	end
	
	if #custombackgroundimg == 0 then
		custombackgroundimg[i] = love.graphics.newImage("graphics/SMB/portalbackground.png")
		custombackgroundwidth[i] = custombackgroundimg[i]:getWidth()/16
		custombackgroundheight[i] = custombackgroundimg[i]:getHeight()/16
	end
end