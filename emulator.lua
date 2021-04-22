--
-- Created by IntelliJ IDEA.
-- User: Guus Toussaint
-- Date: 4/22/2021
-- Time: 2:53 PM
-- To change this template use File | Settings | File Templates.
--

function emulator()
    -- for demo purposes
    gamestate = "game"
    agents = 2

    load_level()
end

-- This function loads the level
function load_level(suspended)
    scrollfactor = 0
    backgroundcolor = {}
    backgroundcolor[1] = {92/255, 148/255, 252/255}
    backgroundcolor[2] = {0, 0, 0}
    backgroundcolor[3] = {32/255, 56/255, 236/255}
    love.graphics.setBackgroundColor(backgroundcolor[1])

    scrollingstart = 12 --when the scrolling begins to set in (Both of these take the player who is the farthest on the left)
    scrollingcomplete = 10 --when the scrolling will be as fast as mario can run
    scrollingleftstart = 6 --See above, but for scrolling left, and it takes the player on the right-estest.
    scrollingleftcomplete = 4
    superscroll = 100

    --LINK STUFF
    mariocoincount = 0
    marioscore = 0

    --FOR NOW
    mariolivecount = 1

    -- WHERE IS THE PLAYERS OBJECT CREATED -> change players to agents
    mariolives = {}
    for i = 1, agents do
        mariolives[i] = mariolivecount
    end

    mariosizes = {}
    for i = 1, agents do
        mariosizes[i] = 1
    end

    -- DEFAULT LEVEL SHIT
    autoscroll = true

    inputs = { "door", "groundlight", "wallindicator", "cubedispenser", "walltimer", "notgate", "laser", "lightbridge"}
    inputsi = {28, 29, 30, 43, 44, 45, 46, 47, 48, 67, 74, 84, 52, 53, 54, 55, 36, 37, 38, 39}

    outputs = { "button", "laserdetector", "box", "pushbutton", "walltimer", "notgate"}
    outputsi = {40, 56, 57, 58, 59, 20, 68, 69, 74, 84}

    enemies = { "goomba", "koopa", "hammerbro", "plant", "lakito", "bowser", "cheep", "squid", "flyingfish", "goombahalf", "koopahalf", "cheepwhite", "cheepred", "koopared", "kooparedhalf", "koopa", "kooparedflying", "beetle", "beetlehalf", "spikey", "spikeyhalf"}

    jumpitems = { "mushroom", "oneup" }

    marioworld = 1
    mariolevel = 1
    mariosublevel = 0
    respawnsublevel = 0

    -- WHAT IS THE USE OF THIS
    objects = nil
    if suspended == true then
        continuegame()
    elseif suspended then
        marioworld = suspended
    end

    --remove custom sprites
    for i = smbtilecount+portaltilecount+1, #tilequads do
        tilequads[i] = nil
    end

    for i = smbtilecount+portaltilecount+1, #rgblist do
        rgblist[i] = nil
    end

    -- custom tiles
    customtiles = false
    customtilecount = 0

    -- spritebatch
    smbspritebatch = {}
    portalspritebatch = {}
    customspritebatch = {}
    spritebatchX = {}
    for i = 1, players do
        smbspritebatch[i] = love.graphics.newSpriteBatch( smbtilesimg, 1000 )
        portalspritebatch[i] = love.graphics.newSpriteBatch( portaltilesimg, 1000 )
        if customtiles then
            customspritebatch[i] = love.graphics.newSpriteBatch( customtilesimg, 1000 )
        end
        spritebatchX[i] = 0
    end

    --FINALLY LOAD THE DAMN LEVEL
    start_level(marioworld .. "-" .. mariolevel)
end

-- This function start the level
function start_level(level)
    mariosublevel = 0
    prevsublevel = false
    mariotime = 400

    --MISC VARS
    everyonedead = false
    levelfinished = false
    coinanimation = 1
    flagx = false
    levelfinishtype = nil
    firestartx = false
    firestarted = false
    firedelay = math.random(4)
    flyingfishdelay = 1
    flyingfishstarted = false
    flyingfishstartx = false
    flyingfishendx = false
    bulletbilldelay = 1
    bulletbillstarted = false
    bulletbillstartx = false
    bulletbillendx = false
    firetimer = firedelay
    flyingfishtimer = flyingfishdelay
    bulletbilltimer = bulletbilldelay
    axex = false
    axey = false
    lakitoendx = false
    lakitoend = false
    noupdate = false
    xscroll = 0
    splitscreen = {{}}
    checkpoints = {}
    checkpointpoints = {}
    repeatX = 0
    lastrepeat = 0
    displaywarpzonetext = false
    for i = 1, agents do
        table.insert(splitscreen[1], i)
    end
    checkpointi = 0
    mazestarts = {}
    mazeends = {}
    mazesolved = {}
    mazesolved[0] = true
    mazeinprogress = false
    earthquake = 0
    sunrot = 0
    gelcannontimer = 0
    pausemenuselected = 1
    coinblocktimers = {}

    portaldelay = {}
    for i = 1, agents do
        portaldelay[i] = 0
    end

    --Minecraft
    breakingblockX = false
    breakingblockY = false
    breakingblockprogress = 0

    --class tables
    coinblockanimations = {}
    scrollingscores = {}
    portalparticles = {}
    portalprojectiles = {}
    emancipationgrills = {}
    platformspawners = {}
    rocketlaunchers = {}
    userects = {}
    blockdebristable = {}
    fireworks = {}
    seesaws = {}
    bubbles = {}
    rainbooms = {}
    miniblocks = {}
    inventory = {}
    for i = 1, 9 do
        inventory[i] = {}
    end
    mccurrentblock = 1

    blockbouncetimer = {}
    blockbouncex = {}
    blockbouncey = {}
    blockbouncecontent = {}
    blockbouncecontent2 = {}
    warpzonenumbers = {}

    objects = {}
    objects["player"] = {}
    objects["portalwall"] = {}
    objects["tile"] = {}
    objects["goomba"] = {}
    objects["koopa"] = {}
    objects["mushroom"] = {}
    objects["flower"] = {}
    objects["oneup"] = {}
    objects["star"] = {}
    objects["vine"] = {}
    objects["box"] = {}
    objects["door"] = {}
    objects["button"] = {}
    objects["groundlight"] = {}
    objects["wallindicator"] = {}
    objects["walltimer"] = {}
    objects["notgate"] = {}
    objects["lightbridge"] = {}
    objects["lightbridgebody"] = {}
    objects["faithplate"] = {}
    objects["laser"] = {}
    objects["laserdetector"] = {}
    objects["gel"] = {}
    objects["geldispenser"] = {}
    objects["cubedispenser"] = {}
    objects["pushbutton"] = {}
    objects["bulletbill"] = {}
    objects["hammerbro"] = {}
    objects["hammer"] = {}
    objects["fireball"] = {}
    objects["platform"] = {}
    objects["platformspawner"] = {}
    objects["plant"] = {}
    objects["castlefire"] = {}
    objects["castlefirefire"] = {}
    objects["fire"] = {}
    objects["bowser"] = {}
    objects["spring"] = {}
    objects["cheep"] = {}
    objects["flyingfish"] = {}
    objects["upfire"] = {}
    objects["seesawplatform"] = {}
    objects["lakito"] = {}
    objects["squid"] = {}

    objects["screenboundary"] = {}
    objects["screenboundary"]["left"] = screenboundary:new(0)

    splitxscroll = {0}

    startx = 3
    starty = 13
    pipestartx = nil
    pipestarty = nil
    animation = nil

    enemiesspawned = {}

    intermission = false
    haswarpzone = false
    underwater = false
    bonusstage = false
    custombackground = false
    mariotimelimit = 400
    spriteset = 1

    loadmap(level)

    objects["screenboundary"]["right"] = screenboundary:new(mapwidth)

    if flagx then
        objects["screenboundary"]["flag"] = screenboundary:new(flagx+6/16)
    end

    if axex then
        objects["screenboundary"]["axe"] = screenboundary:new(axex+1)
    end

    if intermission then
        animation = "intermission"
    end

    if not sublevel then
        mariotime = mariotimelimit
    end

    --background
    love.graphics.setBackgroundColor(backgroundcolor[background])

    --set startx to checkpoint
    if checkpointx and checkcheckpoint then
        startx = checkpointx
        starty = checkpointpoints[checkpointx] or 13

        --clear enemies from spawning near
        for y = 1, 15 do
            for x = startx-8, startx+8 do
                if inmap(x, y) and #map[x][y] > 1 then
                    if tablecontains(enemies, entityquads[map[x][y][2]].t) then
                        table.insert(enemiesspawned, {x, y})
                    end
                end
            end
        end

        --find which i it is
        for i = 1, #checkpoints do
            if checkpointx == checkpoints[i] then
                checkpointi = i
            end
        end
    end

    -- TODO: change the mario: object to something an agent, but I dont know what the correct class should be
    -- TODO: it should contain the neural net created by NEAT
    local mul = 0 -- offset of players, should be 0 in our case
    objects["player"] = {}
    for i = 1, agents do
        if startx then
            objects["player"][i] = marioAI:new(startx + (i-1)*mul-6/16, starty-1, i, animation, mariosizes[i], playertype)
        else
            objects["player"][i] = marioAI:new(1.5 + (i-1)*mul-6/16+1.5, 13, i, animation, mariosizes[i], playertype)
        end
    end

    generatespritebatch()

end

function loadmap(filename)
    print("Loading " .. "mappacks/" .. mappack .. "/" .. filename .. ".txt")
    if not love.filesystem.getInfo("mappacks/" .. mappack .. "/" .. filename .. ".txt") then
        print("mappacks/" .. mappack .. "/" .. filename .. ".txt not found!")
        return false
    end
    local s = love.filesystem.read( "mappacks/" .. mappack .. "/" .. filename .. ".txt" )
    local s2 = s:split(";")

    --MAP ITSELF
    local t = s2[1]:split(",")

    if math.fmod(#t, 15) ~= 0 then
        print("Incorrect number of entries: " .. #t)
        return false
    end

    mapwidth = #t/15

    map = {}
    unstatics = {}

    for x = 1, #t/15 do
        map[x] = {}
        for y = 1, 15 do
            map[x][y] = {}
            map[x][y]["gels"] = {}

            local r = tostring(t[(y-1)*(#t/15)+x]):split("-")

            if tonumber(r[1]) > smbtilecount+portaltilecount+customtilecount then
                r[1] = 1
            end

            for i = 1, #r do
                if r[i] ~= "link" then
                    map[x][y][i] = tonumber(r[i])
                else
                    map[x][y][i] = r[i]
                end
            end

            --create object for block
            if tilequads[tonumber(r[1])].collision == true then
                objects["tile"][x .. "-" .. y] = tile:new(x-1, y-1, 1, 1, true)
            end
        end
    end

    for y = 1, 15 do
        for x = 1, #t/15 do
            local r = map[x][y]
            if #r > 1 then
                local t = entityquads[r[2]].t
                if t == "spawn" then
                    startx = x
                    starty = y

                elseif not editormode then
                    if t == "warppipe" then
                        table.insert(warpzonenumbers, {x, y, r[3]})

                    elseif t == "manycoins" then
                        map[x][y][3] = 7

                    elseif t == "flag" then
                        flagx = x-1
                        flagy = y

                    elseif t == "pipespawn" and (prevsublevel == r[3] or (mariosublevel == r[3] and blacktime == sublevelscreentime)) then
                        pipestartx = x
                        pipestarty = y

                    elseif t == "emancehor" then
                        table.insert(emancipationgrills, emancipationgrill:new(x, y, "hor"))
                    elseif t == "emancever" then
                        table.insert(emancipationgrills, emancipationgrill:new(x, y, "ver"))

                    elseif t == "doorver" then
                        table.insert(objects["door"], door:new(x, y, r, "ver"))
                    elseif t == "doorhor" then
                        table.insert(objects["door"], door:new(x, y, r, "hor"))

                    elseif t == "button" then
                        table.insert(objects["button"], button:new(x, y))

                    elseif t == "pushbuttonleft" then
                        table.insert(objects["pushbutton"], pushbutton:new(x, y, "left"))
                    elseif t == "pushbuttonright" then
                        table.insert(objects["pushbutton"], pushbutton:new(x, y, "right"))

                    elseif t == "wallindicator" then
                        table.insert(objects["wallindicator"], wallindicator:new(x, y, r))

                    elseif t == "groundlightver" then
                        table.insert(objects["groundlight"], groundlight:new(x, y, 1, r))
                    elseif t == "groundlighthor" then
                        table.insert(objects["groundlight"], groundlight:new(x, y, 2, r))
                    elseif t == "groundlightupright" then
                        table.insert(objects["groundlight"], groundlight:new(x, y, 3, r))
                    elseif t == "groundlightrightdown" then
                        table.insert(objects["groundlight"], groundlight:new(x, y, 4, r))
                    elseif t == "groundlightdownleft" then
                        table.insert(objects["groundlight"], groundlight:new(x, y, 5, r))
                    elseif t == "groundlightleftup" then
                        table.insert(objects["groundlight"], groundlight:new(x, y, 6, r))

                    elseif t == "faithplateup" then
                        table.insert(objects["faithplate"], faithplate:new(x, y, "up"))
                    elseif t == "faithplateright" then
                        table.insert(objects["faithplate"], faithplate:new(x, y, "right"))
                    elseif t == "faithplateleft" then
                        table.insert(objects["faithplate"], faithplate:new(x, y, "left"))

                    elseif t == "laserright" then
                        table.insert(objects["laser"], laser:new(x, y, "right", r))
                    elseif t == "laserdown" then
                        table.insert(objects["laser"], laser:new(x, y, "down", r))
                    elseif t == "laserleft" then
                        table.insert(objects["laser"], laser:new(x, y, "left", r))
                    elseif t == "laserup" then
                        table.insert(objects["laser"], laser:new(x, y, "up", r))

                    elseif t == "lightbridgeright" then
                        table.insert(objects["lightbridge"], lightbridge:new(x, y, "right", r))
                    elseif t == "lightbridgeleft" then
                        table.insert(objects["lightbridge"], lightbridge:new(x, y, "left", r))
                    elseif t == "lightbridgedown" then
                        table.insert(objects["lightbridge"], lightbridge:new(x, y, "down", r))
                    elseif t == "lightbridgeup" then
                        table.insert(objects["lightbridge"], lightbridge:new(x, y, "up", r))

                    elseif t == "laserdetectorright" then
                        table.insert(objects["laserdetector"], laserdetector:new(x, y, "right"))
                    elseif t == "laserdetectordown" then
                        table.insert(objects["laserdetector"], laserdetector:new(x, y, "down"))
                    elseif t == "laserdetectorleft" then
                        table.insert(objects["laserdetector"], laserdetector:new(x, y, "left"))
                    elseif t == "laserdetectorup" then
                        table.insert(objects["laserdetector"], laserdetector:new(x, y, "up"))

                    elseif t == "boxtube" then
                        table.insert(objects["cubedispenser"], cubedispenser:new(x, y, r))

                    elseif t == "timer" then
                        table.insert(objects["walltimer"], walltimer:new(x, y, r[3], r))
                    elseif t == "notgate" then
                        table.insert(objects["notgate"], notgate:new(x, y, r))

                    elseif t == "platformspawnerup" then
                        table.insert(platformspawners, platformspawner:new(x, y, "up", r[3]))
                    elseif t == "platformspawnerdown" then
                        table.insert(platformspawners, platformspawner:new(x, y, "down", r[3]))

                    elseif t == "box" then
                        table.insert(objects["box"], box:new(x, y))

                    elseif t == "firestart" then
                        firestartx = x

                    elseif t == "flyingfishstart" then
                        flyingfishstartx = x
                    elseif t == "flyingfishend" then
                        flyingfishendx = x

                    elseif t == "bulletbillstart" then
                        bulletbillstartx = x
                    elseif t == "bulletbillend" then
                        bulletbillendx = x

                    elseif t == "axe" then
                        axex = x
                        axey = y

                    elseif t == "lakitoend" then
                        lakitoendx = x

                    elseif t == "spring" then
                        table.insert(objects["spring"], spring:new(x, y))

                    elseif t == "seesaw" then
                        table.insert(seesaws, seesaw:new(x, y, r[3]))

                    elseif t == "checkpoint" then
                        if not tablecontains(checkpoints, x) then
                            table.insert(checkpoints, x)
                            checkpointpoints[x] = y
                        end
                    elseif t == "mazestart" then
                        if not tablecontains(mazestarts, x) then
                            table.insert(mazestarts, x)
                        end

                    elseif t == "mazeend" then
                        if not tablecontains(mazeends, x) then
                            table.insert(mazeends, x)
                        end

                    elseif t == "geltop" then
                        if tilequads[map[x][y][1]].collision then
                            map[x][y]["gels"]["top"] = r[3]
                        end
                    elseif t == "gelleft" then
                        if tilequads[map[x][y][1]].collision then
                            map[x][y]["gels"]["left"] = r[3]
                        end
                    elseif t == "gelbottom" then
                        if tilequads[map[x][y][1]].collision then
                            map[x][y]["gels"]["bottom"] = r[3]
                        end
                    elseif t == "gelright" then
                        if tilequads[map[x][y][1]].collision then
                            map[x][y]["gels"]["right"] = r[3]
                        end
                    end
                end
            end
        end
    end

    --sort checkpoints
    table.sort(checkpoints)

    --Add links
    for i, v in pairs(objects) do
        for j, w in pairs(v) do
            if w.link then
                w:link()
            end
        end
    end

    if flagx then
        flagimgx = flagx+8/16
        flagimgy = 3+1/16
    end

    for x = 0, -30, -1 do
        map[x] = {}
        for y = 1, 13 do
            map[x][y] = {1}
        end

        for y = 14, 15 do
            map[x][y] = {2}
            objects["tile"][x .. "-" .. y] = tile:new(x-1, y-1, 1, 1, true)
        end
    end

    --MORE STUFF
    for i = 2, #s2 do
        s3 = s2[i]:split("=")
        if s3[1] == "background" then
            background = tonumber(s3[2])
        elseif s3[1] == "spriteset" then
            spriteset = tonumber(s3[2])
        elseif s3[1] == "intermission" then
            intermission = true
        elseif s3[1] == "haswarpzone" then
            haswarpzone = true
        elseif s3[1] == "underwater" then
            underwater = true
        elseif s3[1] == "music" then
            musici = tonumber(s3[2])
        elseif s3[1] == "bonusstage" then
            bonusstage = true
        elseif s3[1] == "custombackground" or s3[1] == "portalbackground" then
            custombackground = true
        elseif s3[1] == "timelimit" then
            mariotimelimit = tonumber(s3[2])
        elseif s3[1] == "scrollfactor" then
            scrollfactor = tonumber(s3[2])
        end
    end

    if custombackground then
        loadcustombackground()
    end

    return true
end

function generatespritebatch()
    for split = 1, #splitscreen do
        local smbmsb = smbspritebatch[split]
        local portalmsb = portalspritebatch[split]
        local custommsb
        if customtiles then
            custommsb = customspritebatch[split]
        end
        smbmsb:clear()
        portalmsb:clear()
        if customtiles then
            custommsb:clear()
        end

        local xtodraw
        if mapwidth < width+1 then
            xtodraw = math.ceil(mapwidth/#splitscreen)
        else
            if mapwidth > width and splitxscroll[split] < mapwidth-width then
                xtodraw = width+1
            else
                xtodraw = width
            end
        end

        local lmap = map

        for y = 1, 15 do
            for x = 1, xtodraw do
                local bounceyoffset = 0

                local draw = true
                for i, v in pairs(blockbouncex) do
                    if blockbouncex[i] == math.floor(splitxscroll[split])+x and blockbouncey[i] == y then
                        draw = false
                    end
                end
                if draw == true then
                    local t = lmap[math.floor(splitxscroll[split])+x][y]

                    local tilenumber = t[1]
                    if tilenumber ~= 0 and tilequads[tilenumber].invisible == false and tilequads[tilenumber].coinblock == false and tilequads[tilenumber].coin == false then
                        if tilenumber <= smbtilecount then
                            smbmsb:add( tilequads[tilenumber].quad, (x-1)*16*scale, ((y-1)*16-8)*scale, 0, scale, scale )
                        elseif tilenumber <= smbtilecount+portaltilecount then
                            portalmsb:add( tilequads[tilenumber].quad, (x-1)*16*scale, ((y-1)*16-8)*scale, 0, scale, scale )
                        elseif tilenumber <= smbtilecount+portaltilecount+customtilecount then
                            custommsb:add( tilequads[tilenumber].quad, (x-1)*16*scale, ((y-1)*16-8)*scale, 0, scale, scale )
                        end
                    end
                end
            end
        end
    end
end

function game_draw()
    for split = 1, #splitscreen do
        love.graphics.translate((split-1)*width*16*scale/#splitscreen, yoffset*scale)

        --This is just silly
        if earthquake > 0 then
            local colortable = {{242, 111, 51}, {251, 244, 174}, {95, 186, 76}, {29, 151, 212}, {101, 45, 135}, {238, 64, 68}}
            for i = 1, backgroundstripes do
                local r, g, b = unpack(colortable[math.fmod(i-1, 6)+1])
                local a = earthquake/rainboomearthquake*255

                love.graphics.setColor(r, g, b, a)

                local alpha = math.rad((i/backgroundstripes + math.fmod(sunrot/5, 1)) * 360)
                local point1 = {width*8*scale+300*scale*math.cos(alpha), 112*scale+300*scale*math.sin(alpha)}

                local alpha = math.rad(((i+1)/backgroundstripes + math.fmod(sunrot/5, 1)) * 360)
                local point2 = {width*8*scale+300*scale*math.cos(alpha), 112*scale+300*scale*math.sin(alpha)}

                love.graphics.polygon("fill", width*8*scale, 112*scale, point1[1], point1[2], point2[1], point2[2])
            end
        end

        love.graphics.setColor(1, 1, 1, 1)
        --tremoooor!
        if earthquake > 0 then
            tremorx = (math.random()-.5)*2*earthquake
            tremory = (math.random()-.5)*2*earthquake

            love.graphics.translate(round(tremorx), round(tremory))
        end

        local currentscissor = {(split-1)*width*16*scale/#splitscreen, 0, width*16*scale/#splitscreen, 15*16*scale}
        love.graphics.setScissor(unpack(currentscissor))
        xscroll = splitxscroll[split]

        love.graphics.setColor(1, 1, 1, 1)

        local xtodraw
        if mapwidth < width+1 then
            xtodraw = math.ceil(mapwidth/#splitscreen)
        else
            if mapwidth > width and xscroll < mapwidth-width then
                xtodraw = width+1
            else
                xtodraw = width
            end
        end

        --custom background
        if custombackground then
            for i = #custombackgroundimg, 1, -1  do
                local xscroll = xscroll / (i * scrollfactor + 1)
                if reversescrollfactor() == 1 then
                    xscroll = 0
                end
                for y = 1, math.ceil(15/custombackgroundheight[i]) do
                    for x = 1, math.ceil(width/custombackgroundwidth[i])+1 do
                        love.graphics.draw(custombackgroundimg[i], math.floor(((x-1)*custombackgroundwidth[i])*16*scale) - math.floor(math.fmod(xscroll, custombackgroundwidth[i])*16*scale), (y-1)*custombackgroundheight[i]*16*scale, 0, scale, scale)
                    end
                end
            end
        end

        --Mushroom under tiles
        for j, w in pairs(objects["mushroom"]) do
            w:draw()
        end

        --Flowers under tiles
        for j, w in pairs(objects["flower"]) do
            w:draw()
        end

        --Oneupunder tiles
        for j, w in pairs(objects["oneup"]) do
            w:draw()
        end

        --star tiles
        for j, w in pairs(objects["star"]) do
            w:draw()
        end

        --castleflag
        if levelfinished and levelfinishtype == "flag" and not custombackground then
            love.graphics.draw(castleflagimg, math.floor((flagx+6-xscroll)*16*scale), 106*scale+castleflagy*16*scale, 0, scale, scale)
        end

        --TILES
        love.graphics.draw(smbspritebatch[split], math.floor(-math.fmod(xscroll, 1)*16*scale), 0)
        love.graphics.draw(portalspritebatch[split], math.floor(-math.fmod(xscroll, 1)*16*scale), 0)
        if customtiles then
            love.graphics.draw(customspritebatch[split], math.floor(-math.fmod(xscroll, 1)*16*scale), 0)
        end

        local lmap = map

        for y = 1, 15 do
            for x = 1, xtodraw do
                local bounceyoffset = 0
                for i, v in pairs(blockbouncex) do
                    if blockbouncex[i] == math.floor(xscroll)+x and blockbouncey[i] == y then
                        if blockbouncetimer[i] < blockbouncetime/2 then
                            bounceyoffset = blockbouncetimer[i] / (blockbouncetime/2) * blockbounceheight
                        else
                            bounceyoffset = (2 - blockbouncetimer[i] / (blockbouncetime/2)) * blockbounceheight
                        end
                    end
                end

                local t = lmap[math.floor(xscroll)+x][y]

                local tilenumber = t[1]
                if tilequads[tilenumber].coinblock and tilequads[tilenumber].invisible == false then --coinblock
                    love.graphics.draw(coinblockimage, coinblockquads[spriteset][coinframe], math.floor((x-1-math.fmod(xscroll, 1))*16*scale), ((y-1-bounceyoffset)*16-8)*scale, 0, scale, scale)
                elseif tilequads[tilenumber].coin then --coin
                    love.graphics.draw(coinimage, coinquads[spriteset][coinframe], math.floor((x-1-math.fmod(xscroll, 1))*16*scale), ((y-1-bounceyoffset)*16-8)*scale, 0, scale, scale)
                elseif bounceyoffset ~= 0 then
                    if tilequads[tilenumber].invisible == false or editormode then
                        love.graphics.draw(tilequads[tilenumber].image, tilequads[tilenumber].quad, math.floor((x-1-math.fmod(xscroll, 1))*16*scale), ((y-1-bounceyoffset)*16-8)*scale, 0, scale, scale)
                    end
                end

                --Gel overlays!
                if t["gels"] then
                    for i = 1, 4 do
                        local dir = "top"
                        local r = 0
                        if i == 2 then
                            dir = "right"
                            r = math.pi/2
                        elseif i == 3 then
                            dir = "bottom"
                            r = math.pi
                        elseif i == 4 then
                            dir = "left"
                            r = math.pi*1.5
                        end

                        if t["gels"][dir] == 1 then
                            love.graphics.draw(gel1ground, math.floor((x-.5-math.fmod(xscroll, 1))*16*scale), ((y-1-bounceyoffset)*16)*scale, r, scale, scale, 8, 8)
                        elseif t["gels"][dir] == 2 then
                            love.graphics.draw(gel2ground, math.floor((x-.5-math.fmod(xscroll, 1))*16*scale), ((y-1-bounceyoffset)*16)*scale, r, scale, scale, 8, 8)
                        elseif t["gels"][dir] == 3 then
                            love.graphics.draw(gel3ground, math.floor((x-.5-math.fmod(xscroll, 1))*16*scale), ((y-1-bounceyoffset)*16)*scale, r, scale, scale, 8, 8)
                        end
                    end
                end

                if editormode then
                    if tilequads[t[1]].invisible and t[1] ~= 1 then
                        love.graphics.draw(tilequads[t[1]].image, tilequads[t[1]].quad, math.floor((x-1-math.fmod(xscroll, 1))*16*scale), ((y-1)*16-8)*scale, 0, scale, scale)
                    end

                    if #t > 1 and t[2] ~= "link" then
                        tilenumber = t[2]
                        love.graphics.setColor(1, 1, 1, 0.6)
                        love.graphics.draw(entityquads[tilenumber].image, entityquads[tilenumber].quad, math.floor((x-1-math.fmod(xscroll, 1))*16*scale), ((y-1)*16-8)*scale, 0, scale, scale)
                        love.graphics.setColor(1, 1, 1, 1)
                    end
                end
            end
        end

        ---UI
        love.graphics.setColor(1, 1, 1)
        love.graphics.translate(0, -yoffset*scale)
        if yoffset < 0 then
            love.graphics.translate(0, yoffset*scale)
        end

        properprint("mario", uispace*.5 - 24*scale, 8*scale)
        properprint(addzeros(marioscore, 6), uispace*0.5-24*scale, 16*scale)

        properprint("*", uispace*1.5-8*scale, 16*scale)

        love.graphics.draw(coinanimationimage, coinanimationquads[spriteset][coinframe], uispace*1.5-16*scale, 16*scale, 0, scale, scale)
        properprint(addzeros(mariocoincount, 2), uispace*1.5-0*scale, 16*scale)

        properprint("world", uispace*2.5 - 20*scale, 8*scale)
        properprint(marioworld .. "-" .. mariolevel, uispace*2.5 - 12*scale, 16*scale)

        properprint("time", uispace*3.5 - 16*scale, 8*scale)
        if editormode then
            if linktool then
                properprint("link", uispace*3.5 - 16*scale, 16*scale)
            else
                properprint("edit", uispace*3.5 - 16*scale, 16*scale)
            end
        else
            properprint(addzeros(math.ceil(mariotime), 3), uispace*3.5-8*scale, 16*scale)
        end

        if players > 1 then
            for i = 1, players do
                local x = (width*16)/players/2 + (width*16)/players*(i-1)
                if mariolivecount ~= false then
                    properprint("p" .. i .. " * " .. mariolives[i], (x-string.len("p" .. i .. " * " .. mariolives[i])*4+4)*scale, 25*scale)
                    love.graphics.setColor(mariocolors[i][1])
                    love.graphics.rectangle("fill", (x-string.len("p" .. i .. " * " .. mariolives[i])*4-3)*scale, 25*scale, 7*scale, 7*scale)
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
        end

        love.graphics.setColor(1, 1, 1)
        --vines
        for j, w in pairs(objects["vine"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --warpzonetext
        if displaywarpzonetext then
            properprint("welcome to warp zone!", (mapwidth-14-1/16-xscroll)*16*scale, 88*scale)
            for i, v in pairs(warpzonenumbers) do
                properprint(v[3], math.floor((v[1]-xscroll-1-9/16)*16*scale), (v[2]-3)*16*scale)
            end
        end

        love.graphics.setColor(1, 1, 1)
        --platforms
        for j, w in pairs(objects["platform"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --platforms
        for j, w in pairs(objects["seesawplatform"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --seesaws
        for j, w in pairs(seesaws) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --springs
        for j, w in pairs(objects["spring"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --flag
        if flagx then
            love.graphics.draw(flagimg, math.floor((flagimgx-1-xscroll)*16*scale), ((flagimgy)*16-8)*scale, 0, scale, scale)
            if levelfinishtype == "flag" then
                properprint2(flagscore, math.floor((flagimgx+4/16-xscroll)*16*scale), ((14-flagimgy)*16-8)*scale, 0, scale, scale)
            end
        end

        love.graphics.setColor(1, 1, 1)
        --axe
        if axex then
            love.graphics.draw(axeimg, axequads[coinframe], math.floor((axex-1-xscroll)*16*scale), (axey-1.5)*16*scale, 0, scale, scale)

            if marioworld ~= 8 then
                love.graphics.draw(toadimg, math.floor((mapwidth-7-xscroll)*16*scale), 177*scale, 0, scale, scale)
            else
                love.graphics.draw(peachimg, math.floor((mapwidth-7-xscroll)*16*scale), 177*scale, 0, scale, scale)
            end
        end

        love.graphics.setColor(1, 1, 1)
        --levelfinish text and toad
        if levelfinished and levelfinishtype == "castle" then
            if levelfinishedmisc2 == 1 then
                if levelfinishedmisc >= 1 then
                    properprint("thank you mario!", math.floor(((mapwidth-12-xscroll)*16-1)*scale), 72*scale)
                end
                if levelfinishedmisc == 2 then
                    properprint("but our princess is in", math.floor(((mapwidth-13.5-xscroll)*16-1)*scale), 104*scale) --say what
                    properprint("another castle!", math.floor(((mapwidth-13.5-xscroll)*16-1)*scale), 120*scale) --bummer.
                end
            else
                if levelfinishedmisc >= 1 then
                    properprint("thank you mario!", math.floor(((mapwidth-12-xscroll)*16-1)*scale), 72*scale)
                end
                if levelfinishedmisc >= 2 then
                    properprint("your quest is over.", math.floor(((mapwidth-12.5-xscroll)*16-1)*scale), 96*scale)
                end
                if levelfinishedmisc >= 3 then
                    properprint("we present you a new quest.", math.floor(((mapwidth-14.5-xscroll)*16-1)*scale), 112*scale)
                end
                if levelfinishedmisc >= 4 then
                    properprint("push button b", math.floor(((mapwidth-11-xscroll)*16-1)*scale), 136*scale)
                end
                if levelfinishedmisc == 5 then
                    properprint("to play as steve", math.floor(((mapwidth-12-xscroll)*16-1)*scale), 152*scale)
                end
            end

            if marioworld ~= 8 then
                love.graphics.draw(toadimg, math.floor((mapwidth-7-xscroll)*16*scale), 177*scale, 0, scale, scale)
            else
                love.graphics.draw(peachimg, math.floor((mapwidth-7-xscroll)*16*scale), 177*scale, 0, scale, scale)
            end
        end

        love.graphics.setColor(1, 1, 1)
        --Fireworks
        for j, w in pairs(fireworks) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --Buttons
        for j, w in pairs(objects["button"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --Upfires
        for j, w in pairs(objects["upfire"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --Pushbuttons
        for j, w in pairs(objects["pushbutton"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --hardlight bridges
        for j, w in pairs(objects["lightbridgebody"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --laser
        for j, w in pairs(objects["laser"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --laserdetector
        for j, w in pairs(objects["laserdetector"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --lightbridge

        for j, w in pairs(objects["lightbridge"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --Groundlights
        for j, w in pairs(objects["groundlight"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --Faithplates
        for j, w in pairs(objects["faithplate"]) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --Bubbles
        for j, w in pairs(bubbles) do
            w:draw()
        end

        love.graphics.setColor(1, 1, 1)
        --miniblocks
        for i, v in pairs(miniblocks) do
            v:draw()
        end

        --OBJECTS
        for j, w in pairs(objects) do
            if j ~= "tile" then
                for i, v in pairs(w) do
                    if v.drawable then
                        love.graphics.setColor(1, 1, 1)
                        local dirscale

                        if j == "player" then
                            if v.pointingangle > 0 then
                                dirscale = -scale
                            else
                                dirscale = scale
                            end
                            if bigmario then
                                dirscale = dirscale * scalefactor
                            end
                        else
                            if v.animationdirection == "left" then
                                dirscale = -scale
                            else
                                dirscale = scale
                            end
                        end

                        local horscale = scale
                        if v.shot then
                            horscale = -scale
                        end

                        if j == "player" and bigmario then
                            horscale = horscale * scalefactor
                        end

                        local ply, portaly = insideportal(v.x, v.y, v.width, v.height)
                        local entryX, entryY, entryfacing, exitX, exitY, exitfacing

                        --SCISSOR FOR ENTRY
                        if v.static then
                            if v.customscissor then
                                love.graphics.setScissor(math.floor((v.customscissor[1]-xscroll)*16*scale), math.floor((v.customscissor[2]-.5)*16*scale), v.customscissor[3]*16*scale, v.customscissor[4]*16*scale)
                            end
                        end

                        if v.static == false and v.portalable ~= false then
                            if v.customscissor then
                                love.graphics.setScissor(math.floor((v.customscissor[1]-xscroll)*16*scale), math.floor((v.customscissor[2]-.5)*16*scale), v.customscissor[3]*16*scale, v.customscissor[4]*16*scale)
                            elseif ply ~= false and (v.active or v.portaloverride) then
                                if portaly == 1 then
                                    entryX, entryY, entryfacing = objects["player"][ply].portal1X, objects["player"][ply].portal1Y, objects["player"][ply].portal1facing
                                    exitX, exitY, exitfacing = objects["player"][ply].portal2X, objects["player"][ply].portal2Y, objects["player"][ply].portal2facing
                                else
                                    entryX, entryY, entryfacing = objects["player"][ply].portal2X, objects["player"][ply].portal2Y, objects["player"][ply].portal2facing
                                    exitX, exitY, exitfacing = objects["player"][ply].portal1X, objects["player"][ply].portal1Y, objects["player"][ply].portal1facing
                                end

                                if entryfacing == "right" then
                                    love.graphics.setScissor(math.floor((entryX-xscroll)*16*scale), math.floor(((entryY-3.5)*16)*scale), 64*scale, 96*scale)
                                elseif entryfacing == "left" then
                                    love.graphics.setScissor(math.floor((entryX-xscroll-5)*16*scale), math.floor(((entryY-4.5)*16)*scale), 64*scale, 96*scale)
                                elseif entryfacing == "up" then
                                    love.graphics.setScissor(math.floor((entryX-xscroll-3)*16*scale), math.floor(((entryY-5.5)*16)*scale), 96*scale, 64*scale)
                                elseif entryfacing == "down" then
                                    love.graphics.setScissor(math.floor((entryX-xscroll-4)*16*scale), math.floor(((entryY-0.5)*16)*scale), 96*scale, 64*scale)
                                end
                            end
                        end

                        if type(v.graphic) == "table" then
                            for k = 1, #v.graphic do
--                                if v.colors[k] then
--                                    love.graphics.setColor(v.colors[k])
--                                else
                                love.graphics.setColor(1, 1, 1)
--                                end
                                love.graphics.draw(v.graphic[k], v.quad, math.floor(((v.x-xscroll)*16+v.offsetX)*scale), math.floor((v.y*16-v.offsetY)*scale), v.rotation, dirscale, horscale, v.quadcenterX, v.quadcenterY)
                            end

                            if v.graphic[0] then
                                love.graphics.setColor(1, 1, 1)
                                love.graphics.draw(v.graphic[0], v.quad, math.floor(((v.x-xscroll)*16+v.offsetX)*scale), math.floor((v.y*16-v.offsetY)*scale), v.rotation, dirscale, horscale, v.quadcenterX, v.quadcenterY)
                            end
                        else
                            if v.graphic and v.quad then
                                love.graphics.draw(v.graphic, v.quad, math.floor(((v.x-xscroll)*16+v.offsetX)*scale), math.floor((v.y*16-v.offsetY)*scale), v.rotation, dirscale, horscale, v.quadcenterX, v.quadcenterY)
                            end
                        end

                        --portal duplication
                        if v.static == false and (v.active or v.portaloverride) and v.portalable ~= false then
                            if v.customscissor then

                            elseif ply ~= false then
                                love.graphics.setScissor(unpack(currentscissor))
                                local px, py, pw, ph, pr, pad = v.x, v.y, v.width, v.height, v.rotation, v.animationdirection
                                px, py, d, d, pr, pad = portalcoords(px, py, 0, 0, pw, ph, pr, pad, entryX, entryY, entryfacing, exitX, exitY, exitfacing)

                                if pad ~= v.animationdirection then
                                    dirscale = -dirscale
                                end

                                horscale = scale
                                if v.shot then
                                    horscale = -scale
                                end

                                if exitfacing == "right" then
                                    love.graphics.setScissor(math.floor((exitX-xscroll)*16*scale), math.floor(((exitY-3.5)*16)*scale), 64*scale, 96*scale)
                                elseif exitfacing == "left" then
                                    love.graphics.setScissor(math.floor((exitX-xscroll-5)*16*scale), math.floor(((exitY-4.5)*16)*scale), 64*scale, 96*scale)
                                elseif exitfacing == "up" then
                                    love.graphics.setScissor(math.floor((exitX-xscroll-3)*16*scale), math.floor(((exitY-5.5)*16)*scale), 96*scale, 64*scale)
                                elseif exitfacing == "down" then
                                    love.graphics.setScissor(math.floor((exitX-xscroll-4)*16*scale), math.floor(((exitY-0.5)*16)*scale), 96*scale, 64*scale)
                                end

                                if type(v.graphic) == "table" then
                                    for k = 1, #v.graphic do
                                        if v.colors[k] then
                                            love.graphics.setColor(v.colors[k])
                                        else
                                            love.graphics.setColor(1, 1, 1)
                                        end
                                        love.graphics.draw(v.graphic[k], v.quad, math.ceil(((px-xscroll)*16+v.offsetX)*scale), math.ceil((py*16-v.offsetY)*scale), pr, dirscale, horscale, v.quadcenterX, v.quadcenterY)
                                    end

                                    if v.drawhat and hatoffsets[v.animationstate] then
                                        local offsets = {}
                                        if v.graphic == v.biggraphic or v.animationstate == "grow" then
                                            if v.animationstate == "grow" then
                                                offsets = hatoffsets["grow"]
                                            elseif v.fireanimationtimer < fireanimationtime then
                                                offsets = bighatoffsets["fire"]
                                            elseif underwater and (v.animationstate == "jumping" or v.animationstate == "falling") then
                                                offsets = bighatoffsets["swimming"][v.swimframe]
                                            elseif v.ducking then
                                                offsets = bighatoffsets["ducking"]
                                            elseif v.animationstate == "running" or v.animationstate == "falling"  then
                                                offsets = bighatoffsets["running"][v.runframe]
                                            elseif v.animationstate == "climbing" then
                                                offsets = bighatoffsets["climbing"][v.climbframe]
                                            else
                                                offsets = bighatoffsets[v.animationstate]
                                            end
                                        else
                                            if underwater and (v.animationstate == "jumping" or v.animationstate == "falling") then
                                                offsets = hatoffsets["swimming"][v.swimframe]
                                            elseif v.animationstate == "running" or v.animationstate == "falling"  then
                                                offsets = hatoffsets["running"][v.runframe]
                                            elseif v.animationstate == "climbing" then
                                                offsets = hatoffsets["climbing"][v.climbframe]
                                            else
                                                offsets = hatoffsets[v.animationstate]
                                            end
                                        end

                                        if #v.hats > 0 then
                                            local yadd = 0
                                            for i = 1, #v.hats do
                                                if v.hats[i] == 1 then
                                                    love.graphics.setColor(v.colors[1])
                                                else
                                                    love.graphics.setColor(1, 1, 1)
                                                end
                                                if v.graphic == v.biggraphic or v.animationstate == "grow" then
                                                    love.graphics.draw(bighat[v.hats[i]].graphic, math.floor(((px-xscroll)*16+v.offsetX)*scale), math.floor(((py)*16-v.offsetY)*scale), pr, dirscale, horscale, v.quadcenterX - bighat[v.hats[i]].x + offsets[1], v.quadcenterY - bighat[v.hats[i]].y + offsets[2] + yadd)
                                                    yadd = yadd + bighat[v.hats[i]].height
                                                else
                                                    love.graphics.draw(hat[v.hats[i]].graphic, math.floor(((px-xscroll)*16+v.offsetX)*scale), math.floor(((py)*16-v.offsetY)*scale), pr, dirscale, horscale, v.quadcenterX - hat[v.hats[i]].x + offsets[1], v.quadcenterY - hat[v.hats[i]].y + offsets[2] + yadd)
                                                    yadd = yadd + hat[v.hats[i]].height
                                                end
                                            end
                                        end
                                    end

                                    if v.graphic[0] then
                                        love.graphics.setColor(1, 1, 1)
                                        love.graphics.draw(v.graphic[0], v.quad, math.floor(((px-xscroll)*16+v.offsetX)*scale), math.floor((py*16-v.offsetY)*scale), pr, dirscale, horscale, v.quadcenterX, v.quadcenterY)
                                    end
                                else
                                    love.graphics.draw(v.graphic, v.quad, math.ceil(((px-xscroll)*16+v.offsetX)*scale), math.ceil((py*16-v.offsetY)*scale), pr, dirscale, horscale, v.quadcenterX, v.quadcenterY)
                                end
                            end
                        end
                        love.graphics.setScissor(unpack(currentscissor))
                    end
                end
            end
        end

        love.graphics.setColor(1, 1, 1)

        --bowser
        for j, w in pairs(objects["bowser"]) do
            w:draw()
        end

        --lakito
        for j, w in pairs(objects["lakito"]) do
            w:draw()
        end

        --Geldispensers
        for j, w in pairs(objects["geldispenser"]) do
            w:draw()
        end

        --Cubedispensers
        for j, w in pairs(objects["cubedispenser"]) do
            w:draw()
        end

        --Emancipationgrills
        for j, w in pairs(emancipationgrills) do
            w:draw()
        end

        --Doors
        for j, w in pairs(objects["door"]) do
            w:draw()
        end

        --Wallindicators
        for j, w in pairs(objects["wallindicator"]) do
            w:draw()
        end

        --Walltimers
        for j, w in pairs(objects["walltimer"]) do
            w:draw()
        end

        --Notgates
        for j, w in pairs(objects["notgate"]) do
            w:draw()
        end

        --particles
        for j, w in pairs(portalparticles) do
            w:draw()
        end

        --portals
        for i = 1, players do
            if objects["player"][i].portal1X ~= false then
                local rotation = 0
                local offsetx, offsety = 8, -3
                if objects["player"][i].portal1facing == "right" then
                    rotation = math.pi/2
                    offsetx, offsety = 11, 0
                elseif objects["player"][i].portal1facing == "down" then
                    rotation = math.pi
                    offsety = 3
                elseif objects["player"][i].portal1facing == "left" then
                    rotation = math.pi*1.5
                    offsetx, offsety = 5, 0
                end

                local portalframe = portalanimation
                local glowalpha = 100
                if objects["player"][i].portal2X == false then

                else
                    love.graphics.setColor(1, 1, 1, (80 - math.abs(portalframe-3)*10)/255)
                    love.graphics.draw(portalglow, math.floor(((objects["player"][i].portal1X-1-xscroll)*16+offsetx)*scale), math.floor(((objects["player"][i].portal1Y-1)*16+offsety)*scale), rotation, scale, scale, 8, 20)
                    love.graphics.setColor(1, 1, 1, 1)
                end

                love.graphics.setColor(unpack(objects["player"][i].portal1color))
                love.graphics.draw(portalimage, portal1quad[portalframe], math.floor(((objects["player"][i].portal1X-1-xscroll)*16+offsetx)*scale), math.floor(((objects["player"][i].portal1Y-1)*16+offsety)*scale), rotation, scale, scale, 8, 8)
            end

            if objects["player"][i].portal2X ~= false then
                rotation = 0
                offsetx, offsety = 8, -3
                if objects["player"][i].portal2facing == "right" then
                    rotation = math.pi/2
                    offsetx, offsety = 11, 0
                elseif objects["player"][i].portal2facing == "down" then
                    rotation = math.pi
                    offsety = 3
                elseif objects["player"][i].portal2facing == "left" then
                    rotation = math.pi*1.5
                    offsetx, offsety = 5, 0
                end

                local portalframe = portalanimation
                if objects["player"][i].portal1X == false then

                else
                    love.graphics.setColor(1, 1, 1, (80 - math.abs(portalframe-3)*10)/255)
                    love.graphics.draw(portalglow, math.floor(((objects["player"][i].portal2X-1-xscroll)*16+offsetx)*scale), math.floor(((objects["player"][i].portal2Y-1)*16+offsety)*scale), rotation, scale, scale, 8, 20)
                    love.graphics.setColor(1, 1, 1, 1)
                end

                love.graphics.setColor(unpack(objects["player"][i].portal2color))
                love.graphics.draw(portalimage, portal2quad[portalframe], math.floor(((objects["player"][i].portal2X-1-xscroll)*16+offsetx)*scale), math.floor(((objects["player"][i].portal2Y-1)*16+offsety)*scale), rotation, scale, scale, 8, 8)
            end
        end

        love.graphics.setColor(1, 1, 1)

        --COINBLOCKANIMATION
        for i, v in pairs(coinblockanimations) do
            love.graphics.draw(coinblockanimationimage, coinblockanimationquads[coinblockanimations[i].frame], math.floor((coinblockanimations[i].x - xscroll)*16*scale), math.floor((coinblockanimations[i].y*16-8)*scale), 0, scale, scale, 4, 54)
        end

        --SCROLLING SCORE
        for i, v in pairs(scrollingscores) do
            if type(scrollingscores[i].i) == "number" then
                properprint2(scrollingscores[i].i, math.floor((scrollingscores[i].x-0.4)*16*scale), math.floor((scrollingscores[i].y-1.5-scrollingscoreheight*(scrollingscores[i].timer/scrollingscoretime))*16*scale))
            elseif scrollingscores[i].i == "1up" then
                love.graphics.draw(oneuptextimage, math.floor((scrollingscores[i].x)*16*scale), math.floor((scrollingscores[i].y-1.5-scrollingscoreheight*(scrollingscores[i].timer/scrollingscoretime))*16*scale), 0, scale, scale)
            end
        end

        --BLOCK DEBRIS
        for i, v in pairs(blockdebristable) do
            v:draw()
        end

        local minex, miney, minecox, minecoy

        --PORTAL UI STUFF
        if levelfinished == false then
            for pl = 1, players do
                if objects["player"][pl].controlsenabled and objects["player"][pl].t == "portal" and objects["player"][pl].vine == false then
                    local sourcex, sourcey = objects["player"][pl].x+6/16, objects["player"][pl].y+6/16
                    local cox, coy, side, tend, x, y = traceline(sourcex, sourcey, objects["player"][pl].pointingangle)

                    local portalpossible = true
                    if cox == false or getportalposition(1, cox, coy, side, tend) == false then
                        portalpossible = false
                    end

                    love.graphics.setColor(1, 1, 1, 1)

                    local dist = math.sqrt(((x-xscroll)*16*scale - (sourcex-xscroll)*16*scale)^2 + ((y-.5)*16*scale - (sourcey-.5)*16*scale)^2)/16/scale

                    for i = 1, dist/portaldotsdistance+1 do
                        if((i-1+objects["player"][pl].portaldotstimer/portaldotstime)/(dist/portaldotsdistance)) < 1 then
                            local xplus = ((x-xscroll)*16*scale - (sourcex-xscroll)*16*scale)*((i-1+objects["player"][pl].portaldotstimer/portaldotstime)/(dist/portaldotsdistance))
                            local yplus = ((y-.5)*16*scale - (sourcey-.5)*16*scale)*((i-1+objects["player"][pl].portaldotstimer/portaldotstime)/(dist/portaldotsdistance))

                            local dotx = (sourcex-xscroll)*16*scale + xplus
                            local doty = (sourcey-.5)*16*scale + yplus

                            local radius = math.sqrt(xplus^2 + yplus^2)/scale

                            local alpha = 1
                            if radius < portaldotsouter then
                                alpha = (radius-portaldotsinner) * (portaldotsouter-portaldotsinner)
                                if alpha < 0 then
                                    alpha = 0
                                end
                            end


                            if portalpossible == false then
                                love.graphics.setColor(1, 0, 0, alpha)
                            else
                                love.graphics.setColor(0, 1, 0, alpha)
                            end

                            love.graphics.draw(portaldotimg, math.floor(dotx-0.25*scale), math.floor(doty-0.25*scale), 0, scale, scale)
                        end
                    end

                    love.graphics.setColor(1, 1, 1, 1)

                    if cox ~= false then
                        if portalpossible == false then
                            love.graphics.setColor(1, 0, 0)
                        else
                            love.graphics.setColor(0, 1, 0)
                        end

                        local rotation = 0
                        if side == "right" then
                            rotation = math.pi/2
                        elseif side == "down" then
                            rotation = math.pi
                        elseif side == "left" then
                            rotation = math.pi/2*3
                        end
                        love.graphics.draw(portalcrosshairimg, math.floor((x-xscroll)*16*scale), math.floor((y-.5)*16*scale), rotation, scale, scale, 4, 8)
                    end
                end
            end
        end

        --Portal projectile
        for i, v in pairs(portalprojectiles) do
            v:draw()
        end

        love.graphics.setColor(1, 1, 1)

        --nothing to see here
        for i, v in pairs(rainbooms) do
            v:draw()
        end

        --Minecraft
        --black border
        if objects["player"][mouseowner] and playertype == "minecraft" and not levelfinished then
            local v = objects["player"][mouseowner]
            local sourcex, sourcey = v.x+6/16, v.y+6/16
            local cox, coy, side, tend, x, y = traceline(sourcex, sourcey, v.pointingangle)

            if cox then
                local dist = math.sqrt((v.x+v.width/2 - x)^2 + (v.y+v.height/2 - y)^2)
                if dist <= minecraftrange then
                    love.graphics.setColor(0, 0, 0, 0.67)
                    love.graphics.rectangle("line", math.floor((cox-1-xscroll)*16*scale)-.5, (coy-1-.5)*16*scale-.5, 16*scale, 16*scale)

                    if breakingblockX and (cox ~= breakingblockX or coy ~= breakingblockY) then
                        breakingblockX = cox
                        breakingblockY = coy
                        breakingblockprogress = 0
                    elseif not breakingblockX and love.mouse.isDown(1) then
                        breakingblockX = cox
                        breakingblockY = coy
                        breakingblockprogress = 0
                    end
                elseif love.mouse.isDown(1) then
                    breakingblockX = cox
                    breakingblockY = coy
                    breakingblockprogress = 0
                end
            else
                breakingblockX = nil
            end
            --break animation
            if breakingblockX then
                love.graphics.setColor(1, 1, 1, 1)
                local frame = math.ceil((breakingblockprogress/minecraftbreaktime)*10)
                if frame ~= 0 then
                    love.graphics.draw(minecraftbreakimg, minecraftbreakquad[frame], (breakingblockX-1-xscroll)*16*scale, (breakingblockY-1.5)*16*scale, 0, scale, scale)
                end
            end
            love.graphics.setColor(1, 1, 1, 1)

            --gui
            love.graphics.draw(minecraftgui, (width*8-91)*scale, 202*scale, 0, scale, scale)

            love.graphics.setColor(1, 1, 1, 0.8)
            for i = 1, 9 do
                local t = inventory[i].t

                if t ~= nil then
                    local img = customtilesimg
                    if t <= smbtilecount then
                        img = smbtilesimg
                    elseif t <= smbtilecount+portaltilecount then
                        img = portaltilesimg
                    end
                    love.graphics.draw(img, tilequads[t].quad, (width*8-88+(i-1)*20)*scale, 205*scale, 0, scale, scale)
                end
            end

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(minecraftselected, (width*8-92+(mccurrentblock-1)*20)*scale, 201*scale, 0, scale, scale)

            for i = 1, 9 do
                if inventory[i].t ~= nil then
                    local count = inventory[i].count
                    properprint(count, (width*8-72+(i-1)*20-string.len(count)*8)*scale, 205*scale)
                end
            end
        end

        love.graphics.translate(-(split-1)*width*16*scale/#splitscreen, 0)
    end
    love.graphics.setScissor()

    if earthquake > 0 then
        love.graphics.translate(-round(tremorx), -round(tremory))
    end

    for i = 2, #splitscreen do
        love.graphics.line((i-1)*width*16*scale/#splitscreen, 0, (i-1)*width*16*scale/#splitscreen, 15*16*scale)
    end

    if editormode then
        editor_draw()
    end

    --speed gradient
    if speed < 1 then
        love.graphics.setColor(1, 1, 1, 1-speed)
        love.graphics.draw(gradientimg, 0, 0, 0, scale, scale)
    end

    if yoffset < 0 then
        love.graphics.translate(0, -yoffset*scale)
    end
    love.graphics.translate(0, yoffset*scale)

    if testlevel then
        love.graphics.setColor(1, 0, 0)
        properprint("testing level - press esc to return to editor", 0, 0)
    end

    --pause menu
    if pausemenuopen then
        love.graphics.setColor(0, 0, 0, 0.2)
        love.graphics.rectangle("fill", 0, 0, width*16*scale, 224*scale)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", (width*8*scale)-50*scale, (112*scale)-75*scale, 100*scale, 150*scale)
        love.graphics.setColor(1, 1, 1)
        drawrectangle(width*8-49, 112-74, 98, 148)

        for i = 1, #pausemenuoptions do
            love.graphics.setColor(0.4, 0.4, 0.4)
            if pausemenuselected == i and not menuprompt and not desktopprompt then
                love.graphics.setColor(1, 1, 1)
                properprint(">", (width*8*scale)-45*scale, (112*scale)-60*scale+(i-1)*25*scale)
            end
            properprint(pausemenuoptions[i], (width*8*scale)-35*scale, (112*scale)-60*scale+(i-1)*25*scale)
            properprint(pausemenuoptions2[i], (width*8*scale)-35*scale, (112*scale)-50*scale+(i-1)*25*scale)

            if pausemenuoptions[i] == "volume" then
                drawrectangle((width*8)-34, 68+(i-1)*25, 74, 1)
                drawrectangle((width*8)-34, 65+(i-1)*25, 1, 7)
                drawrectangle((width*8)+40, 65+(i-1)*25, 1, 7)
                love.graphics.draw(volumesliderimg, math.floor(((width*8)-35+74*volume)*scale), (112*scale)-47*scale+(i-1)*25*scale, 0, scale, scale)
            end
        end

        if menuprompt then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", (width*8*scale)-100*scale, (112*scale)-25*scale, 200*scale, 50*scale)
            love.graphics.setColor(1, 1, 1)
            drawrectangle((width*8)-99, 112-24, 198, 48)
            properprint("quit to menu?", (width*8*scale)-string.len("quit to menu?")*4*scale, (112*scale)-10*scale)
            if pausemenuselected2 == 1 then
                properprint(">", (width*8*scale)-51*scale, (112*scale)+4*scale)
                love.graphics.setColor(1, 1, 1, 1)
                properprint("yes", (width*8*scale)-44*scale, (112*scale)+4*scale)
                love.graphics.setColor(0.4, 0.4, 0.4)
                properprint("no", (width*8*scale)+28*scale, (112*scale)+4*scale)
            else
                properprint(">", (width*8*scale)+20*scale, (112*scale)+4*scale)
                love.graphics.setColor(0.4, 0.4, 0.4)
                properprint("yes", (width*8*scale)-44*scale, (112*scale)+4*scale)
                love.graphics.setColor(1, 1, 1)
                properprint("no", (width*8*scale)+28*scale, (112*scale)+4*scale)
            end
        end

        if desktopprompt then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", (width*8*scale)-100*scale, (112*scale)-25*scale, 200*scale, 50*scale)
            love.graphics.setColor(1, 1, 1)
            drawrectangle((width*8)-99, 112-24, 198, 48)
            properprint("quit to desktop?", (width*8*scale)-string.len("quit to desktop?")*4*scale, (112*scale)-10*scale)
            if pausemenuselected2 == 1 then
                properprint(">", (width*8*scale)-51*scale, (112*scale)+4*scale)
                love.graphics.setColor(1, 1, 1)
                properprint("yes", (width*8*scale)-44*scale, (112*scale)+4*scale)
                love.graphics.setColor(0.4, 0.4, 0.4)
                properprint("no", (width*8*scale)+28*scale, (112*scale)+4*scale)
            else
                properprint(">", (width*8*scale)+20*scale, (112*scale)+4*scale)
                love.graphics.setColor(0.4, 0.4, 0.4)
                properprint("yes", (width*8*scale)-44*scale, (112*scale)+4*scale)
                love.graphics.setColor(1, 1, 1, 1)
                properprint("no", (width*8*scale)+28*scale, (112*scale)+4*scale)
            end
        end

        if suspendprompt then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", (width*8*scale)-100*scale, (112*scale)-25*scale, 200*scale, 50*scale)
            love.graphics.setColor(1, 1, 1)
            drawrectangle((width*8)-99, 112-24, 198, 48)
            properprint("suspend game? this can", (width*8*scale)-string.len("suspend game? this can")*4*scale, (112*scale)-20*scale)
            properprint("only be loaded once!", (width*8*scale)-string.len("only be loaded once!")*4*scale, (112*scale)-10*scale)
            if pausemenuselected2 == 1 then
                properprint(">", (width*8*scale)-51*scale, (112*scale)+4*scale)
                love.graphics.setColor(1, 1, 1)
                properprint("yes", (width*8*scale)-44*scale, (112*scale)+4*scale)
                love.graphics.setColor(0.4, 0.4, 0.4)
                properprint("no", (width*8*scale)+28*scale, (112*scale)+4*scale)
            else
                properprint(">", (width*8*scale)+20*scale, (112*scale)+4*scale)
                love.graphics.setColor(0.4, 0.4, 0.4)
                properprint("yes", (width*8*scale)-44*scale, (112*scale)+4*scale)
                love.graphics.setColor(1, 1, 1)
                properprint("no", (width*8*scale)+28*scale, (112*scale)+4*scale)
            end
        end
    end
end

function game_update(dt)
    --------
    --GAME--
    --------

    --earthquake reset
    if earthquake > 0 then
        earthquake = math.max(0, earthquake-dt*earthquake*2-0.001)
        sunrot = sunrot + dt
    end

    --pausemenu
    if pausemenuopen then
        return
    end

    --coinanimation
    coinanimation = coinanimation + dt*6.75
    while coinanimation >= 6 do
        coinanimation = coinanimation - 5
    end

    if math.floor(coinanimation) == 4 then
        coinframe = 2
    elseif math.floor(coinanimation) == 5 then
        coinframe = 1
    else
        coinframe = math.max(1, math.floor(coinanimation))
    end

    --SCROLLING SCORES
    local delete = {}

    for i, v in pairs(scrollingscores) do
        if scrollingscores[i]:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(scrollingscores, v) --remove
    end

    --If everyone's dead, just update the players and coinblock timer.
    if everyonedead then
        for i, v in pairs(objects["player"]) do
            v:update(dt)
        end

        return
    end

    --timer
    if editormode == false then
        --get if any player has their controls disabled
        local notime = false
        for i = 1, players do
            if (objects["player"][i].controlsenabled == false and objects["player"][i].dead == false) then
                notime = true
            end
        end

        if notime == false and infinitetime == false and mariotime ~= 0 then
            mariotime = mariotime - 2.5*dt

            if mariotime > 0 and mariotime + 2.5*dt >= 99 and mariotime < 99 then
                love.audio.stop()
                playsound(lowtime)
            end

            if mariotime > 0 and mariotime + 2.5*dt >= 99-7.5 and mariotime < 99-7.5 then
                local star = false
                for i = 1, players do
                    if objects["player"][i].starred then
                        star = true
                    end
                end

                if not star then
                    playmusic()
                else
                    music:play("starmusic")
                end
            end

            if mariotime <= 0 then
                mariotime = 0
                for i, v in pairs(objects["player"]) do
                    v:die("time")
                end
            end
        end
    end

    --check if updates are blocked for whatever reason
    if noupdate then
        for i, v in pairs(objects["player"]) do
            v:update(dt)
        end
        return
    end

    --portalgundelay
    for i = 1, players do
        if portaldelay[i] > 0 then
            portaldelay[i] = math.max(0, portaldelay[i] - dt/speed)
        end
    end

    --coinblockanimation
    local delete = {}

    for i, v in pairs(coinblockanimations) do
        if coinblockanimations[i]:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(coinblockanimations, v) --remove
    end

    --nothing to see here
    local delete = {}

    for i, v in pairs(rainbooms) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(rainbooms, v) --remove
    end

    --userects
    local delete = {}

    for i, v in pairs(userects) do
        if v.delete == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(userects, v) --remove
    end

    --blockbounce
    local delete = {}

    for i, v in pairs(blockbouncetimer) do
        if blockbouncetimer[i] < blockbouncetime then
            blockbouncetimer[i] = blockbouncetimer[i] + dt
            if blockbouncetimer[i] > blockbouncetime then
                blockbouncetimer[i] = blockbouncetime
                if blockbouncecontent then
                    item(blockbouncecontent[i], blockbouncex[i], blockbouncey[i], blockbouncecontent2[i])
                end
                table.insert(delete, i)
            end
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(blockbouncetimer, v)
        table.remove(blockbouncex, v)
        table.remove(blockbouncey, v)
        table.remove(blockbouncecontent, v)
        table.remove(blockbouncecontent2, v)
    end

    if #delete >= 1 then
        generatespritebatch()
    end

    --coinblocktimer things
    for i, v in pairs(coinblocktimers) do
        if v[3] > 0 then
            v[3] = v[3] - dt
        end
    end

    --blockdebris
    local delete = {}

    for i, v in pairs(blockdebristable) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(blockdebristable, v) --remove
    end

    --gelcannon
    if objects["player"][mouseowner] and playertype == "gelcannon" and objects["player"][mouseowner].controlsenabled then
        if gelcannontimer > 0 then
            gelcannontimer = gelcannontimer - dt
            if gelcannontimer < 0 then
                gelcannontimer = 0
            end
        else
            if love.mouse.isDown(1) then
                gelcannontimer = gelcannondelay
                objects["player"][mouseowner]:shootgel(1)
            elseif love.mouse.isDown(2) then
                gelcannontimer = gelcannondelay
                objects["player"][mouseowner]:shootgel(2)
            end
        end
    end

    --seesaws
    for i, v in pairs(seesaws) do
        v:update(dt)
    end

    --platformspawners
    for i, v in pairs(platformspawners) do
        v:update(dt)
    end

    --Bubbles
    local delete = {}

    for i, v in pairs(bubbles) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(bubbles, v) --remove
    end

    --Miniblocks
    local delete = {}

    for i, v in pairs(miniblocks) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(miniblocks, v) --remove
    end

    --Fireworks
    local delete = {}

    for i, v in pairs(fireworks) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(fireworks, v) --remove
    end

    --EMANCIPATION GRILLS
    local delete = {}
    for i, v in pairs(emancipationgrills) do
        if v:update(dt) then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(emancipationgrills, v)
    end

    --BULLET BILL LAUNCHERS
    local delete = {}
    for i, v in pairs(rocketlaunchers) do
        if v:update(dt) then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(rocketlaunchers, v)
    end

    --UPDATE OBJECTS
    for i, v in pairs(objects) do
        if i ~= "tile" and i ~= "portalwall" and i ~= "screenboundary" then
            delete = {}

            for j, w in pairs(v) do
                if w.update and w:update(dt) then
                    table.insert(delete, j)
                elseif w.autodelete then
                    if w.x < xscroll - width or w.y > 16 then
                        table.insert(delete,j)
                    end
                end
            end

            if #delete > 0 then
                table.sort(delete, function(a,b) return a>b end)

                for j, w in pairs(delete) do
                    table.remove(v, w)
                end
            end
        end
    end

    local oldscroll = splitxscroll[1]

    if autoscroll and minimapdragging == false then
        local splitwidth = width/#splitscreen
        for split = 1, #splitscreen do
            local oldscroll = splitxscroll[split]
            --scrolling
            --LEFT
            local i = 1
            while i <= players and objects["player"][i].dead do
                i = i + 1
            end
            local fastestplayer = objects["player"][i]

            if fastestplayer then
                for i = 1, players do
                    if not objects["player"][i].dead and objects["player"][i].x > fastestplayer.x then
                        fastestplayer = objects["player"][i]
                    end
                end

                local oldscroll = splitxscroll[split]

                if fastestplayer.x < splitxscroll[split] + scrollingleftstart and splitxscroll[split] > 0 then

                    if fastestplayer.x < splitxscroll[split] + scrollingleftstart and fastestplayer.speedx < 0 then
                        if fastestplayer.speedx < -scrollrate then
                            splitxscroll[split] = splitxscroll[split] - scrollrate*dt
                        else
                            splitxscroll[split] = splitxscroll[split] + fastestplayer.speedx*dt
                        end
                    end

                    if fastestplayer.x < splitxscroll[split] + scrollingleftcomplete then
                        if fastestplayer.x > splitxscroll[split] + scrollingleftcomplete - 1/16 then
                            splitxscroll[split] = splitxscroll[split] - scrollrate*dt
                        else
                            splitxscroll[split] = splitxscroll[split] - superscrollrate*dt
                        end
                    end

                    if splitxscroll[split] < 0 then
                        splitxscroll[split] = 0
                    end
                end

                --RIGHT

                if fastestplayer.x > splitxscroll[split] + width - scrollingstart and splitxscroll[split] < mapwidth - width then
                    if fastestplayer.x > splitxscroll[split] + width - scrollingstart and fastestplayer.speedx > 0.3 then
                        if fastestplayer.speedx > scrollrate then
                            splitxscroll[split] = splitxscroll[split] + scrollrate*dt
                        else
                            splitxscroll[split] = splitxscroll[split] + fastestplayer.speedx*dt
                        end
                    end

                    if fastestplayer.x > splitxscroll[split] + width - scrollingcomplete then
                        if fastestplayer.x > splitxscroll[split] + width - scrollingcomplete then
                            splitxscroll[split] = splitxscroll[split] + scrollrate*dt
                            if splitxscroll[split] > fastestplayer.x - (width - scrollingcomplete) then
                                splitxscroll[split] = fastestplayer.x - (width - scrollingcomplete)
                            end
                        else
                            splitxscroll[split] = fastestplayer.x - (width - scrollingcomplete)
                        end
                    end
                end

                --just force that shit
                if not levelfinished then
                    if fastestplayer.x > splitxscroll[split] + width - scrollingcomplete then
                        splitxscroll[split] = splitxscroll[split] + superscroll*dt
                        if fastestplayer.x < splitxscroll[split] + width - scrollingcomplete then
                            splitxscroll[split] = fastestplayer.x - width + scrollingcomplete
                        end
                        --splitxscroll[split] = fastestplayer.x + width - scrollingcomplete - width
                    end
                end

                if splitxscroll[split] > mapwidth-width then
                    splitxscroll[split] = math.max(0, mapwidth-width)
                    hitrightside()
                end

                if (axex and splitxscroll[split] > axex-width and axex >= width) then
                    splitxscroll[split] = axex-width
                    hitrightside()
                end
            end
        end

    end

    if players == 2 then
        --updatesplitscreen()
    end

    --SPRITEBATCH UPDATE and CASTLEREPEATS
    if math.floor(splitxscroll[1]) ~= spritebatchX[1] then
        if not editormode then
            for currentx = lastrepeat+1, math.floor(splitxscroll[1])+2 do
                lastrepeat = math.floor(currentx)
                --castlerepeat?
                --get mazei
                local mazei = 0

                for j = 1, #mazeends do
                    if mazeends[j] < currentx+width then
                        mazei = j
                    end
                end

                --check if maze was solved!
                for i = 1, players do
                    if objects["player"][i].mazevar == mazegates[mazei] then
                        local actualmaze = 0
                        for j = 1, #mazestarts do
                            if objects["player"][i].x > mazestarts[j] then
                                actualmaze = j
                            end
                        end
                        mazesolved[actualmaze] = true
                        for j = 1, players do
                            objects["player"][j].mazevar = 0
                        end
                        break
                    end
                end

                if not mazesolved[mazei] or mazeinprogress then --get if inside maze
                    if not mazesolved[mazei] then
                        mazeinprogress = true
                    end

                    local x = math.ceil(currentx)+width

                    if repeatX == 0 then
                        repeatX = mazestarts[mazei]
                    end

                    table.insert(map, x, {{1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}, {1}})
                    for y = 1, 15 do
                        for j = 1, #map[repeatX][y] do
                            map[x][y][j] = map[repeatX][y][j]
                        end
                        map[x][y]["gels"] = {}

                        for cox = mapwidth, x, -1 do
                            --move objects
                            if objects["tile"][cox .. "-" .. y] then
                                objects["tile"][cox + 1 .. "-" .. y] = tile:new(cox, y-1, 1, 1, true)
                                objects["tile"][cox .. "-" .. y] = nil
                            end
                        end

                        --create object for block
                        if tilequads[map[repeatX][y][1]].collision == true then
                            objects["tile"][x .. "-" .. y] = tile:new(x-1, y-1, 1, 1, true)
                        end
                    end
                    mapwidth = mapwidth + 1
                    repeatX = repeatX + 1
                    if flagx then
                        flagx = flagx + 1
                        flagimgx = flagimgx + 1
                        objects["screenboundary"]["flag"].x = objects["screenboundary"]["flag"].x + 1
                    end

                    if axex then
                        axex = axex + 1
                        objects["screenboundary"]["axe"].x = objects["screenboundary"]["axe"].x + 1
                    end

                    if firestartx then
                        firestartx = firestartx + 1
                    end

                    objects["screenboundary"]["right"].x = objects["screenboundary"]["right"].x + 1

                    --move mazestarts and ends
                    for i = 1, #mazestarts do
                        mazestarts[i] = mazestarts[i]+1
                        mazeends[i] = mazeends[i]+1
                    end

                    --check for endblock
                    local x = math.ceil(currentx)+width
                    for y = 1, 15 do
                        if map[x][y][2] and entityquads[map[x][y][2]].t == "mazeend" then
                            if mazesolved[mazei] then
                                repeatX = mazestarts[mazei+1]
                            end
                            mazeinprogress = false
                        end
                    end

                    --reset thingie

                    local x = math.ceil(currentx)+width-1
                    for y = 1, 15 do
                        if map[x][y][2] and entityquads[map[x][y][2]].t == "mazeend" then
                            for j = 1, players do
                                objects["player"][j].mazevar = 0
                            end
                        end
                    end
                end
            end
        end

        generatespritebatch()
        spritebatchX[1] = math.floor(splitxscroll[1])

        if editormode == false and splitxscroll[1] < mapwidth-width then
            for x = math.ceil(oldscroll)+width+1, math.floor(splitxscroll[1])+width+1 do
                for y = 1, 15 do
                    spawnenemy(x, y)
                end
                if goombaattack then
                    local randomtable = {}
                    for y = 1, 15 do
                        table.insert(randomtable, y)
                    end
                    while #randomtable > 0 do
                        local rand = math.random(#randomtable)
                        if tilequads[map[x][randomtable[rand]][1]].collision then
                            table.remove(randomtable, rand)
                        else
                            table.insert(objects["goomba"], goomba:new(x-.5, math.random(13)))
                            break
                        end
                    end
                end
            end
        end
    end

    --portal animation
    portalanimationtimer = portalanimationtimer + dt
    while portalanimationtimer > portalanimationdelay do
        portalanimationtimer = 0
        portalanimation = portalanimation + 1
        if portalanimation > portalanimationcount then
            portalanimation = 1
        end
    end

    --portal particles
    portalparticletimer = portalparticletimer + dt
    while portalparticletimer > portalparticletime do
        portalparticletimer = portalparticletimer - portalparticletime

        for i, v in pairs(objects["player"]) do
            if v.portal1facing ~= nil then
                local x1, y1

                if v.portal1facing == "up" then
                    x1 = v.portal1X + math.random(1, 30)/16 -1
                    y1 = v.portal1Y-1
                elseif v.portal1facing == "down" then
                    x1 = v.portal1X + math.random(1, 30)/16-2
                    y1 = v.portal1Y
                elseif v.portal1facing == "left" then
                    x1 = v.portal1X-1
                    y1 = v.portal1Y + math.random(1, 30)/16-2
                elseif v.portal1facing == "right" then
                    x1 = v.portal1X
                    y1 = v.portal1Y + math.random(1, 30)/16-1
                end

                local color
                if players == 1 then
                    color = {157/255, 222/255, 254/255}
                else
                    color = v.portal1color
                end

                table.insert(portalparticles, portalparticle:new(x1, y1, color, v.portal1facing))
            end

            if v.portal2facing ~= nil then
                local x2, y2

                if v.portal2facing == "up" then
                    x2 = v.portal2X + math.random(1, 30)/16 -1
                    y2 = v.portal2Y-1
                elseif v.portal2facing == "down" then
                    x2 = v.portal2X + math.random(1, 30)/16-2
                    y2 = v.portal2Y
                elseif v.portal2facing == "left" then
                    x2 = v.portal2X-1
                    y2 = v.portal2Y + math.random(1, 30)/16-2
                elseif v.portal2facing == "right" then
                    x2 = v.portal2X
                    y2 = v.portal2Y + math.random(1, 30)/16-1
                end

                local color
                if players == 1 then
                    color = {255/255, 122/255, 66/255}
                else
                    color = v.portal2color
                end

                table.insert(portalparticles, portalparticle:new(x2, y2, color, v.portal2facing))
            end
        end
    end

    delete = {}

    for i, v in pairs(portalparticles) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(portalparticles, v) --remove
    end

    --PORTAL PROJECTILES
    delete = {}

    for i, v in pairs(portalprojectiles) do
        if v:update(dt) == true then
            table.insert(delete, i)
        end
    end

    table.sort(delete, function(a,b) return a>b end)

    for i, v in pairs(delete) do
        table.remove(portalprojectiles, v) --remove
    end

    --FIRE SPAWNING
    if not levelfinished and firestarted and (not objects["bowser"][1] or (objects["bowser"][1].backwards == false and objects["bowser"][1].shot == false and objects["bowser"][1].fall == false)) then
        firetimer = firetimer + dt
        while firetimer > firedelay do
            firetimer = firetimer - firedelay
            firedelay = math.random(4)
            table.insert(objects["fire"], fire:new(splitxscroll[1] + width, math.random(3)+7))
        end
    end

    --FLYING FISH
    if not levelfinished and flyingfishstarted then
        flyingfishtimer = flyingfishtimer + dt
        while flyingfishtimer > flyingfishdelay do
            flyingfishtimer = flyingfishtimer - flyingfishdelay
            flyingfishdelay = math.random(6, 20)/10
            table.insert(objects["flyingfish"], flyingfish:new())
        end
    end

    --BULLET BILL
    if not levelfinished and bulletbillstarted then
        bulletbilltimer = bulletbilltimer + dt
        while bulletbilltimer > bulletbilldelay do
            bulletbilltimer = bulletbilltimer - bulletbilldelay
            bulletbilldelay = math.random(5, 40)/10
            table.insert(objects["bulletbill"], bulletbill:new(splitxscroll[1]+width+2, math.random(4, 12), "left"))
        end
    end

    --minecraft stuff
    if breakingblockX then
        breakingblockprogress = breakingblockprogress + dt
        if breakingblockprogress > minecraftbreaktime then
            breakblock(breakingblockX, breakingblockY)
            breakingblockX = nil
        end
    end

    --Editor
    if editormode then
        editor_update(dt)
    end

    --PHYSICS
    physicsupdate(dt)
end

-- FUNCTIONS THAT THE AGENT USES
function inmap(x, y)
    if not x or not y then
        return false
    end
    if x >= 1 and x <= mapwidth and y >= 1 and y <= 15 then
        return true
    else
        return false
    end
end

function insideportal(x, y, width, height) --returns whether an object is in, and which, portal.
    if width == nil then
        width = 12/16
    end
    if height == nil then
        height = 12/16
    end
    for i, v in pairs(objects["player"]) do
        if v.portal1X ~= false and v.portal2X ~= false then
            for j = 1, 2 do
                local portalx, portaly, portalfacing
                if j == 1 then
                    portalx = v.portal1X
                    portaly = v.portal1Y
                    portalfacing = v.portal1facing
                else
                    portalx = v.portal2X
                    portaly = v.portal2Y
                    portalfacing = v.portal2facing
                end

                if portalfacing == "up" then
                    xplus = 1
                elseif portalfacing == "down" then
                    xplus = -1
                elseif portalfacing == "left" then
                    yplus = -1
                end

                if portalfacing == "right" then
                    if (math.floor(y) == portaly or math.floor(y) == portaly-1) and inrange(x, portalx-width, portalx, false) then
                        return i, j
                    end
                elseif portalfacing == "left" then
                    if (math.floor(y) == portaly-1 or math.floor(y) == portaly-2) and inrange(x, portalx-1-width, portalx-1, false) then
                        return i, j
                    end
                elseif portalfacing == "up" then
                    if inrange(y, portaly-height-1, portaly-1, false) and inrange(x, portalx-1.5-.2, portalx+.5+.2, true) then
                        return i, j
                    end
                elseif portalfacing == "down" then
                    if inrange(y, portaly-height, portaly, false) and inrange(x, portalx-2, portalx-.5, true) then
                        return i, j
                    end
                end

                --widen rect by 3 pixels?

            end
        end
    end

    return false
end


function traceline(sourcex, sourcey, radians)
    local currentblock = {}
    local x, y = sourcex, sourcey
    currentblock[1] = math.floor(x)
    currentblock[2] = math.floor(y+1)

    local emancecollide = false
    for i, v in pairs(emancipationgrills) do
        if v:getTileInvolved(currentblock[1]+1, currentblock[2]) then
            emancecollide = true
        end
    end

    local doorcollide = false
    for i, v in pairs(objects["door"]) do
        if v.dir == "hor" then
            if v.open == false and (v.cox == currentblock[1] or v.cox == currentblock[1]+1) and v.coy == currentblock[2] then
                doorcollide = true
            end
        else
            if v.open == false and v.cox == currentblock[1]+1 and (v.coy == currentblock[2] or v.coy == currentblock[2]+1) then
                doorcollide = true
            end
        end
    end

    if emancecollide or doorcollide then
        return false, false, false, false, x, y
    end

    local side

    while currentblock[1]+1 > 0 and currentblock[1]+1 <= mapwidth and (flagx == false or currentblock[1]+1 <= flagx) and (axex == false or currentblock[1]+1 <= axex) and (currentblock[2] > 0 or currentblock[2] >= math.floor(sourcey+0.5)) and currentblock[2] < 16 do --while in map range
        local oldy = y
        local oldx = x

        --calculate X and Y diff..
        local ydiff, xdiff
        local side1, side2

        if inrange(radians, -math.pi/2, math.pi/2, true) then --up
            ydiff = (y-(currentblock[2]-1)) / math.cos(radians)
            y = currentblock[2]-1
            side1 = "down"
        else
            ydiff = (y-(currentblock[2])) / math.cos(radians)
            y = currentblock[2]
            side1 = "up"
        end

        if inrange(radians, 0, math.pi, true) then --left
            xdiff = (x-(currentblock[1])) / math.sin(radians)
            x = currentblock[1]
            side2 = "right"
        else
            xdiff = (x-(currentblock[1]+1)) / math.sin(radians)
            x = currentblock[1]+1
            side2 = "left"
        end

        --smaller diff wins

        if xdiff < ydiff then
            y = oldy - math.cos(radians)*xdiff
            side = side2
        else
            x = oldx - math.sin(radians)*ydiff
            side = side1
        end

        if side == "down" then
            currentblock[2] = currentblock[2]-1
        elseif side == "up" then
            currentblock[2] = currentblock[2]+1
        elseif side == "left" then
            currentblock[1] = currentblock[1]+1
        elseif side == "right" then
            currentblock[1] = currentblock[1]-1
        end

        local collide, tileno = getTile(currentblock[1]+1, currentblock[2])
        local emancecollide = false
        for i, v in pairs(emancipationgrills) do
            if v:getTileInvolved(currentblock[1]+1, currentblock[2]) then
                emancecollide = true
            end
        end

        local doorcollide = false
        for i, v in pairs(objects["door"]) do
            if v.dir == "hor" then
                if v.open == false and (v.cox == currentblock[1] or v.cox == currentblock[1]+1) and v.coy == currentblock[2] then
                    doorcollide = true
                end
            else
                if v.open == false and v.cox == currentblock[1]+1 and (v.coy == currentblock[2] or v.coy == currentblock[2]+1) then
                    doorcollide = true
                end
            end
        end

        if collide == true then
            break
        elseif emancecollide or doorcollide then
            return false, false, false, false, x, y
        elseif x > xscroll + width or x < xscroll then
            return false, false, false, false, x, y
        end
    end

    if currentblock[1]+1 > 0 and currentblock[1]+1 <= mapwidth and (currentblock[2] > 0 or currentblock[2] >= math.floor(sourcey+0.5))  and currentblock[2] < 16 and currentblock[1] ~= nil then
        local tendency

        --get tendency
        if side == "down" or side == "up" then
            if math.fmod(x, 1) > 0.5 then
                tendency = 1
            else
                tendency = -1
            end
        elseif side == "left" or side == "right" then
            if math.fmod(y, 1) > 0.5 then
                tendency = 1
            else
                tendency = -1
            end
        end

        return currentblock[1]+1, currentblock[2], side, tendency, x, y
    else
        return false, false, false, false, x, y
    end
end

function inrange(i, a, b, include)
    if a > b then
        b, a = a, b
    end

    if include then
        if i >= a and i <= b then
            return true
        else
            return false
        end
    else
        if i > a and i < b then
            return true
        else
            return false
        end
    end
end

function getTile(x, y, portalable, portalcheck, facing) --returns masktable value of block (As well as the ID itself as second return parameter) also includes a portalcheck and returns false if a portal is on that spot.
    --Portal on same tile doesn't work so well yet (collision code, of course), so:
    --facing = nil

    if portalcheck then
        for i, v in pairs(objects["player"]) do
            --Get the extra block of each portal
            local portal1xplus, portal1yplus, portal2xplus, portal2yplus = 0, 0, 0, 0
            if v.portal1facing == "up" then
                portal1xplus = 1
            elseif v.portal1facing == "right" then
                portal1yplus = 1
            elseif v.portal1facing == "down" then
                portal1xplus = -1
            elseif v.portal1facing == "left" then
                portal1yplus = -1
            end

            if v.portal2facing == "up" then
                portal2xplus = 1
            elseif v.portal2facing == "right" then
                portal2yplus = 1
            elseif v.portal2facing == "down" then
                portal2xplus = -1
            elseif v.portal2facing == "left" then
                portal2yplus = -1
            end

            if v.portal1X ~= false then
                if (x == v.portal1X or x == v.portal1X+portal1xplus) and (y == v.portal1Y or y == v.portal1Y+portal1yplus) then--and (facing == nil or v.portal1facing == facing) then
                    return false
                end
            end

            if v.portal2X ~= false then
                if (x == v.portal2X or x == v.portal2X+portal2xplus) and (y == v.portal2Y or y == v.portal2Y+portal2yplus) then--and (facing == nil or v.portal2facing == facing) then
                    return false
                end
            end
        end
    end

    --check for tubes
    for i, v in pairs(objects["geldispenser"]) do
        if (x == v.cox or x == v.cox+1) and (y == v.coy or y == v.coy+1) then
            if portalcheck then
                return false
            else
                return true
            end
        end
    end

    for i, v in pairs(objects["cubedispenser"]) do
        if (x == v.cox or x == v.cox+1) and (y == v.coy or y == v.coy+1) then
            if portalcheck then
                return false
            else
                return true
            end
        end
    end

    --bonusstage thing for keeping it from fucking up.
    if bonusstage then
        if y == 15 and (x == 4 or x == 6) then
            if portalcheck then
                return false
            else
                return true
            end
        end
    end

    if x <= 0 or y <= 0 or y >= 16 or x > mapwidth then
        return false, 1
    end

    if tilequads[map[x][y][1]].invisible then
        return false
    end

    if portalcheck then
        local side
        if facing == "up" then
            side = "top"
        elseif facing == "right" then
            side = "right"
        elseif facing == "down" then
            side = "bottom"
        elseif facing == "left" then
            side = "left"
        end

        --To stop people from portalling under the vine, which caused problems, but was fixed elsewhere (and betterer)
        --[[for i, v in pairs(objects["vine"]) do
            if x == v.cox and y == v.coy and side == "top" then
                return false, 1
            end
        end--]]


        if map[x][y]["gels"][side] == 3 then
            return true, map[x][y][1]
        else
            return tilequads[map[x][y][1]].collision and tilequads[map[x][y][1]].portalable, map[x][y][1]
        end
    else
        return tilequads[map[x][y][1]].collision, map[x][y][1]
    end
end

function playsound(sound)
    if soundenabled then
        sound:stop()
        sound:play()
    end
end


-- NO IDEA WHAT THIS DOES
function addzeros(s, i)
    for j = string.len(s)+1, i do
        s = "0" .. s
    end
    return s
end