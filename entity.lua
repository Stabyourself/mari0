entity = class:new()

entitylist = {	
	"remove",
	
	"powerup",
	"cheepcheep",
	"musicentity",
	"manycoins",
	"enemyspawner",
	"",
	"spawn",
	"",
	"",
	"flag",
	"",
	"",
	"vine",
	"",
	"",
	"",
	"platform",
	"regiontrigger",
	"box",
	"pipe",
	"",
	"mazestart",
	"mazeend",
	"mazegate",
	"emance",
	"scaffold",
	"door",
	"pedestal",
	"wallindicator",
	"pipespawn",
	"platformfall",
	"bulletbillstart",
	"bulletbillend",
	"drain",
	"lightbridge",
	"portal1",
	"portal2",
	"actionblock",
	"button",
	"platformspawner",
	"animationtrigger",
	"groundlightver",
	"groundlighthor",
	"groundlightupright",
	"groundlightrightdown",
	"groundlightdownleft",
	"groundlightleftup",
	"faithplate",
	"",
	"",
	"laser",
	"",
	"",
	"",
	"laserdetector",
	"",
	"",
	"",
	"bulletbill",
	"geldispenser",
	"",
	"",
	"",
	"",
	"",
	"boxtube",
	"pushbutton",
	"",
	"",
	"",
	"",
	"",
	"timer",
	"",
	"",
	"",
	"",
	"castlefire",
	"seesaw",
	"warppipe",
	"squarewave",
	"lakitoend",
	"notgate",
	"gel",
	"orgate",
	"andgate",
	"",
	"firestart",
	"bowser",
	"axe",
	"platformbonus",
	"spring",
	"",
	"flyingfishstart",
	"flyingfishend",
	"",
	"",
	"",
	"checkpoint",
	"ceilblocker",
	"",
	"",
	"",
	"funnel",
	"",
	"",
	"",
	"panel",
	"textentity"
}

entitydescriptions = {
	"place anywhere - acts as an entity eraser", --"remove",
	"place on a wall - mushroom", --"mushroom",
	"place on a wall - 1-up", --"oneup",
	"place on a wall - star", --"star",
	"place on a non question mark block - gives several coins", --"manycoins",
	"place on empty tile - goomba", --"goomba",
	"place on empty tile - koopa", --"koopa",
	"place on empty tile - mario's starting point", --"spawn",
	"place on empty tile - goomba - more to the right", --"goombahalf",
	"place on empty tile - koopa - more to the right", --"koopahalf",
	"place on a wall - bottom of the flag } end of level", --"flag",
	"place on empty tile - red koopa - will turn around at an edge", --"koopared",
	"place on empty tile - red koopa - more to the right", --"kooparedhalf",
	"place on wall - vine - right click to choose destination", --"vine",
	"place on empty tile - hammer bro", --"hammerbro",
	"place on empty underwater tile - cheep cheep fish - red", --"cheepred",
	"place on empty underwater tile - cheep cheep fish - white", --"cheepwhite",
	"place on empty tile - oscillating platform - right click for width", --"platformup", --my mouse is dying :(
	"place on empty tile - oscillating platform - right click for width", --"platformright",
	"place on empty tile - weighted storage cube", --"box",
	"place on pipe tile - pipe - right click for destination sublevel", --"pipe",
	"place on empty tile - lakito - you can also add a lakito end tile", --"lakito",
	"place on empty tile - logical maze start", --"mazestart",
	"place on empty tile - logical maze end", --"mazeend",
	"place on empty tile - maze gate - right click for the gate number", --"mazegate",
	"place on empty tile - horizontal emancipate grill - stops portals and companion cubes", --"emancehor",
	"",
	"place on empty tile - vertical door - use link tool", --"doorver",
	"place on empty tile - horizontal door - use link tool", --"doorhor",
	"place on a wall - use link tool to show on or off state", --"wallindicator",
	"place on a pipe tile - right click for origin sublevel", --"pipespawn",
	"place on empty tile - falling platforms - right click for width", --"platformfall",
	"place anywhere - beginning of bullet zone", --"bulletbillstart",
	"place anywhere - end of bullet zone", --"bulletbillend",
	"place at the very bottom in an underwater level - drain - attracts mario down", --"drain",
	"place on empty tile - light bridge", --"lightbridgeright",
	"", --"lightbridgeleft",
	"", --"lightbridgedown",
	"", --"lightbridgeup",
	"place on empty tile - floor button - use link", --"button",
	"place on top - down platform spawner - right click for width", --"platformspawnerdown",
	"place at the bottom - up platform spawner - right click for width", --"platformspawnerup",
	"place on wall - use link to show on/off state", --"groundlightver",
	"place on wall - use link to show on/off state", --"groundlighthor",
	"place on wall - use link to show on/off state", --"groundlightupright",
	"place on wall - use link to show on/off state", --"groundlightrightdown",
	"place on wall - use link to show on/off state", --"groundlightdownleft",
	"place on wall - use link to show on/off state", --"groundlightleftup",
	"place on ground wall - faith plate to the sky", --"faithplateup",
	"place on ground wall - faith plate to the right", --"faithplateright",
	"place on ground wall - faith plate to the left", --"faithplateleft",
	"place on empty tile - laser to right", --"laserright",
	"",
	"",
	"",
	"place on right edge wall or empty tile - will send off signal if laser is detected - use link tool", --"laserdetectorright",
	"place on down edge wall or empty tile - will send off signal if laser is detected - use link tool", --"laserdetectordown",
	"place on left edge wall or empty tile - will send off signal if laser is detected - use link tool", --"laserdetectorleft",
	"place on up edge wall or empty tile - will send off signal if laser is detected - use link tool", --"laserdetectorup",
	"place on bulletbill launchers - will make the launcher actually launch bulletbills", --"bulletbill",
	"place on empty tile - will produce blue gel to down - blue gel } jump", --"bluegeldown",
	"place on empty tile - will produce blue gel to right - blue gel } jump", --"bluegelright",
	"place on empty tile - will produce blue gel to left - blue gel } jump", --"bluegelleft",
	"place on empty tile - will produce orange gel to down - orange gel } run", --"orangegeldown",
	"place on empty tile - will produce orange gel to right - orange gel } run", --"orangegelright",
	"place on empty tile - will produce orange gel to left - orange gel } run", --"orangegelleft",
	"place on empty tile - will drop a box and remove previous one - use link tool", --"boxtube",
	"place on empty tile - will send a single on signal when used - use link tool", --"pushbuttonleft",
	"place on empty tile - will send a single on signal when used - use link tool", --"pushbuttonright",
	"place on empty tile - piranha plant will go up and down", --"plant",
	"place on empty tile - will produce white gel to down - white gel } portalable", --"whitegeldown",
	"place on empty tile - will produce white gel to right - white gel } portalable", --"whitegelright",
	"place on empty tile - will produce white gel to left - white gel } portalable", --"whitegelleft",
	"place anywhere - will send on signal for a duration - right click to set duration", --"timer",
	"place on empty tile - beetle - runs fast and resists fireballs", --"beetle",
	"place on empty tile - beetle - more to the right", --"beetlehalf",
	"place on empty tile - red flying koopa, goes up and down", --"kooparedflying",
	"place on empty tile - green flying koopa, jumps around", --"koopaflying",
	"place on wall - counterclockwise rotating fire - right click for length", --"castlefireccw",
	"place on empty tile - see-saw - right click for see-saw type", --"seesaw",
	"place on wall - warp pipe - right click for destination world", --"warppipe",
	"place on wall - clockwise rotating fire - right click for width", --"castlefirecw",
	"place anywhere - defines a right border for lakito - use with lakito", --"lakitoend",
	"place anywhere - turns in input around", --notgate
	"place on tile - creates gel on this block. 1: blue, 2: orange, 3: white",
	"place on tile - creates gel on this block. 1: blue, 2: orange, 3: white",
	"place on tile - creates gel on this block. 1: blue, 2: orange, 3: white",
	"place on tile - creates gel on this block. 1: blue, 2: orange, 3: white",
	"place anywhere - fire start - bowser firethings will regularly cross the screen", --"firestart",
	"place on empty tile preferably on the first block on a bridge with an axe - bowser", --"bowser",
	"place on empty tile preferably behind a bridge - axe } end of level", --"axe",
	"place on empty tile - platform in coin worlds", --"platformbonus",
	"place on empty tile - spring", --"spring",
	"place on empty tile preferably underwater - squid", --"squid",
	"place anywhere - defines the start of a flying cheep cheep zone", --"flyingfishstart",
	"place anywhere - defines the end of a flying cheep cheep zone", --"flyingfishend",
	"place anywhere - a lava ball will jump up and down on this line", --"upfire",
	"place on empty tile - spikey", --"spikey",
	"place on empty tile - spikey - more to the right", --"spikeyhalf",
	"place on empty tile - checkpoint - mario will spawn there if he dies after reaching it", --"checkpoint",
	"place anywhere - makes it impossible to jump over the top row of blocks", --"ceilblocker"
	"place on empty tile - will produce purple gel to down - purple gel } wallwalk", --"purplegeldown",
	"place on empty tile - will produce purple gel to right - purple gel } wallwalk", --"purplegelright",
	"place on empty tile - will produce purple gel to left - purple gel } wallwalk", --"purplegelleft",
	"fuck",
	"piss",
	"ass",
	"vaginalol",
	"what",
	"is",
	"this",
	"shit"
}

rightclickmenues = {}

rightclickmenues.seesaw = {
	{t="text", value="distance:"},
	{t="scrollbar", min=2, max=10, step=1, default=7},
	{t="text", value="left height:"},
	{t="scrollbar", min=1, max=10, step=1, default=4},
	{t="text", value="right height:"},
	{t="scrollbar", min=1, max=10, step=1, default=6},
	{t="text", value="platf. width:"},
	{t="scrollbar", min=1, max=10, step=0.5, default=3},
}

rightclickmenues.spawn = {
	{t="text", value="for players:"},
	{t="checkbox", text="all", default="true"},
	{t="checkbox", text="1", default="false"},
	{t="checkbox", text="2", default="false"},
	{t="checkbox", text="3", default="false"},
	{t="checkbox", text="4", default="false"},
	{t="checkbox", text="the rest", default="false"}
}

rightclickmenues.castlefire = {
	{t="text", value="length:"},
	{t="scrollbar", min=1, max=16, step=1, default=6},
	{t="text", value="delay:"},
	{t="scrollbar", min=0.03, max=1, step=0.01, default=0.11},
	{},
	{t="checkbox", text="counter-cw", default="false"}
}

rightclickmenues.timer = {
	{t="text", value="time:"},
	{t="scrollbar", min=1, max=10, step=0.01, default=1},
	{},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.wallindicator = {
	{t="checkbox", text="reversed", default="false"},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.notgate = {
	{t="checkbox", text="visible", default="true"},
	{},
	{t="linkbutton", value="link in", link="in"}
}

rightclickmenues.orgate = {
	{t="checkbox", text="visible", default="true"},
	{},
	{t="linkbutton", value="link in 1", link="1"},
	{t="linkbutton", value="link in 2", link="2"},
	{t="linkbutton", value="link in 3", link="3"},
	{t="linkbutton", value="link in 4", link="4"}
}

rightclickmenues.andgate = {
	{t="checkbox", text="visible", default="true"},
	{},
	{t="linkbutton", value="link in 1", link="1"},
	{t="linkbutton", value="link in 2", link="2"},
	{t="linkbutton", value="link in 3", link="3"},
	{t="linkbutton", value="link in 4", link="4"}
}

rightclickmenues.musicentity = {
	{t="checkbox", text="visible", default="true"},
	{t="checkbox", text="single use", default="true"},
	{},
	{t="submenu", entries=function() local t = {} for i, v in pairs(musiclist) do table.insert(t, v) end return t end, actualvalue=true, default=1, width=15},
	{},
	{t="linkbutton", value="link trigger", link="trigger"}
}

rightclickmenues.enemyspawner = {
	{t="submenu", entries=function() local t = {} for i, v in pairs(enemies) do table.insert(t, v) end return t end, actualvalue=true, default=1, width=15},
	{},
	{t="text", value="velocity x:"},
	{t="scrollbar", min=-50, max=50, step=0.01, default=0},
	{t="text", value="velocity y:"},
	{t="scrollbar", min=-50, max=50, step=0.01, default=0},
	{},
	{t="linkbutton", value="link trigger", link="trigger"}
}

rightclickmenues.boxtube = {
	{t="text", value="on load:"},
	{t="checkbox", text="drop box", default="true"},
	{},
	{t="text", value="object:"},
	{t="submenu", entries={"cube", "goomba", "koopa"}, default=1, width=6},
	{},
	{t="linkbutton", value="link drop", link="drop"}
}

rightclickmenues.laserdetector = {
	{t="text", value="direction:"},
	{t="directionbuttons", left=true, right=true, up=true, down=true, default="right"}
}

rightclickmenues.pushbutton = {
	{t="text", value="direction:"},
	{t="directionbuttons", left=true, right=true, default="left"},
	{},
	{t="text", value="base:"},
	{t="directionbuttons", left=true, right=true, up=true, down=true, default="down"}
}

rightclickmenues.platformfall = {
	{t="text", value="width:"},
	{t="scrollbar", min=1, max=10, step=0.5, default=3}
}

rightclickmenues.pipe = {
	{t="text", value="destination:"},
	{t="submenu", entries={"main", "sub-1", "sub-2", "sub-3", "sub-4", "sub-5"}, default=1, width=5},
}

rightclickmenues.vine = {
	{t="text", value="destination:"},
	{t="submenu", entries={"main", "sub-1", "sub-2", "sub-3", "sub-4", "sub-5"}, default=1, width=5},
}

rightclickmenues.mazegate = {
	{t="text", value="gatenumber:"},
	{t="submenu", entries={"main", "gate 1", "gate 2", "gate 3", "gate 4", "gate 5"}, default=1, width=6},
}

rightclickmenues.pipespawn = {
	{t="text", value="source:"},
	{t="submenu", entries={"main", "sub-1", "sub-2", "sub-3", "sub-4", "sub-5"}, default=1, width=5},
}

rightclickmenues.warppipe = {
	{t="text", value="world:"},
	{t="submenu", entries={"1", "2", "3", "4", "5", "6", "7", "8"}, default=1, width=1},
	{t="text", value="level:"},
	{t="submenu", entries={"1", "2", "3", "4", "5", "6", "7", "8"}, default=1, width=1},
}

rightclickmenues.funnel = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, up=true, right=true, down=true, default="right"}, 
	{}, 
	{t="text", value="speed:"}, 
	{t="scrollbar", min=funnelminspeed, max=funnelmaxspeed, step=0.01, default=3}, 
	{}, 
	{t="checkbox", text="reverse", default="false"}, 
	{t="checkbox", text="default off", default="false"}, 
	{},
	{t="linkbutton", value="link reverse", link="reverse"},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.emance = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", hor=true, ver=true, default="ver"}, 
	{}, 
	{t="checkbox", text="default off", default="false"}, 
	{}, 
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.laser = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, up=true, right=true, down=true, default="right"}, 
	{}, 
	{t="checkbox", text="default off", default="false"}, 
	{}, 
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.lightbridge = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, up=true, right=true, down=true, default="right"}, 
	{}, 
	{t="checkbox", text="default off", default="false"}, 
	{}, 
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.platformspawner = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", up=true, down=true, default="up"}, 
	{}, 
	{t="text", value="width:"},
	{t="scrollbar", min=1, max=10, step=0.5, default=3},
	{t="text", value="speed:"},
	{t="scrollbar", min=0.5, max=10, step=0.01, default=3.5},
	{t="text", value="delay:"},
	{t="scrollbar", min=1, max=10, step=0.01, default=2.18}
}

rightclickmenues.platform = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", down=true, left=true, default="down"}, 
	{}, 
	{t="text", value="width:"},
	{t="scrollbar", min=1, max=10, step=0.5, default=3},
	{t="text", value="distance:"},
	{t="scrollbar", min=0.5, max=15, step=0.01, default=3.3125},
	{t="text", value="duration:"},
	{t="scrollbar", min=1, max=10, step=0.01, default=4}
}

rightclickmenues.scaffold = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", down=true, left=true, right=true, up=true, default="right"},
	{t="checkbox", text="default off", default="false"}, 
	{t="text", value="width:"},
	{t="scrollbar", min=0.5, max=15, step=0.5, default=3},
	{t="text", value="distance:"},
	{t="scrollbar", min=0.5, max=15, step=0.01, default=3},
	{t="text", value="speed:"},
	{t="scrollbar", min=0.5, max=10, step=0.01, default=5.5},
	{t="text", value="wait start:"},
	{t="scrollbar", min=0, max=10, step=0.01, default=0.5},
	{t="text", value="wait end:"},
	{t="scrollbar", min=0, max=10, step=0.01, default=0.5},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.faithplate = {
	{t="text", value="velocity x:"},
	{t="scrollbar", min=-50, max=50, step=0.01, default=30},
	{t="text", value="velocity y:"},
	{t="scrollbar", min=5, max=50, step=0.01, default=30},
	{},
	{t="checkbox", text="default off", default="false"},
	{},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.door = {
	{t="text", value="direction:"},
	{t="directionbuttons", hor=true, ver=true, default="ver"},
	{},
	{t="checkbox", text="start open", default="false"},
	{t="checkbox", text="force close", default="false"},
	{},
	{t="linkbutton", value="link open", link="open"}
}

rightclickmenues.gel = {
	{t="text", value="type:"},
	{t="submenu", entries={"blue", "orange", "white", "purple"}, default=1, width=6},
	{},
	{t="text", value="direction:"}, 
	{t="checkbox", text="left", default="false"},
	{t="checkbox", text="top", default="true"},
	{t="checkbox", text="right", default="false"},
	{t="checkbox", text="bottom", default="false"}
}

rightclickmenues.geldispenser = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, right=true, down=true, up=true, default="down"}, 
	{},
	{t="text", value="type:"},
	{t="submenu", entries={"blue", "orange", "white", "purple"}, default=1, width=6},
	{},
	{t="checkbox", text="default off", default="false"},
	{},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.panel = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, up=true, right=true, down=true, default="right"}, 
	{}, 
	{t="checkbox", text="start white", default="false"}, 
	{}, 
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.button = {
	{t="text", value="direction:"},
	{t="directionbuttons", left=true, right=true, up=true, down=true, default="down"}
}

rightclickmenues.textentity = {
	{t="input", default="text", max=50},
	{},
	{t="checkbox", text="default off", default="false"},
	{},
	{t="text", value="red:"},
	{t="scrollbar", min=0, max=255, step=1, default=255},
	{t="text", value="green:"},
	{t="scrollbar", min=0, max=255, step=1, default=255},
	{t="text", value="blue:"},
	{t="scrollbar", min=0, max=255, step=1, default=255},
	{},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.squarewave = {
	{t="text", value="off time"},
	{t="scrollbar", min=0.01, max=10, step=0.01, default=2},
	{t="text", value="on time"},
	{t="scrollbar", min=0.01, max=10, step=0.01, default=2},
	{},
	{t="text", value="start time"},
	{t="scrollbar", min=0, max=1, step=0.01, default=0},
	{},
	{t="checkbox", text="visible", default="true"}
}

--[[rightclickmenues.upfire = {
	{t="text", value="height:"},
	{t="scrollbar", min=0.5, max=15, step=0.01, default=7.5},
	{},
	{t="text", value="wait time:"},
	{t="scrollbar"; min=0.1, max=6, step=0.01, default=3},
	{t="text", value="random add:"},
	{t="scrollbar"; min=0, max=6, step=0.01, default=0}
}]]

rightclickmenues.regiontrigger = {
	{t="checkbox", text="players only", default="true"},
	{},
	{t="regionselect", value="select region", region="region", default="region:0:0:1:1"}
}

rightclickmenues.animationtrigger = {
	{t="text", value="animation id"},
	{t="input", default="my_anim", max=12},
	{},
	{t="checkbox", text="players only", default="true"},
	{},
	{t="regionselect", value="select region", region="region", default="region:0:0:1:1"}
}

rightclickmenues.checkpoint = {
	{t="text", value="for players:"},
	{t="checkbox", text="all", default="true"},
	{t="checkbox", text="1", default="false"},
	{t="checkbox", text="2", default="false"},
	{t="checkbox", text="3", default="false"},
	{t="checkbox", text="4", default="false"},
	{t="checkbox", text="the rest", default="false"},
	{},
	{t="checkbox", text="visible", default="false"},
	{},
	{t="regionselect", value="select region", region="region", default="region:0:0:1:1"},
	{},
	{t="linkbutton", value="link trigger", link="trigger"}
}

rightclickmenues.portal1 = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, right=true, down=true, up=true, default="up"}, 
	{},
	{t="text", value="portal id:"},
	{t="submenu", entries={"1", "2", "3", "4", "5", "6", "7", "8"}, default=1, width=1},
	{},
	{t="checkbox", text="default on", default="false"},
	{},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.portal2 = {
	{t="text", value="direction:"}, 
	{t="directionbuttons", left=true, right=true, down=true, up=true, default="up"}, 
	{},
	{t="text", value="portal id:"},
	{t="submenu", entries={"1", "2", "3", "4", "5", "6", "7", "8"}, default=1, width=1},
	{},
	{t="checkbox", text="default on", default="false"},
	{},
	{t="linkbutton", value="link power", link="power"}
}

rightclickmenues.pedestal = {
	{t="text", value="portal:"},
	{t="checkbox", text="blue", default="false"},
	{t="checkbox", text="orange", default="false"}
}

groundlighttable = {"groundlightver", "groundlighthor", "groundlightupright", "groundlightrightdown", "groundlightdownleft", "groundlightleftup"}

for i = 1, #groundlighttable do
rightclickmenues[groundlighttable[i]] = {
	{t="checkbox", text="default on", default="false"},
	{},
	{t="linkbutton", value="link power", link="power"}
}
end

function entity:init(img, x, y, width, height)
	self.image = img
	self.quad = love.graphics.newQuad((x-1)*17, (y-1)*17, 16, 16, width, height)	
end

function entity:sett(i)
	for j = 1, #entitylist do
		if i == j then
			self.t = entitylist[j]
		end
	end
end