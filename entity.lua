entity = class:new()

entitylist = {	
	"remove",
	"mushroom",
	"oneup",
	"star",
	"manycoins",
	"goomba",
	"koopa",
	"spawn",
	"goombahalf",
	"koopahalf",
	"flag",
	"koopared",
	"kooparedhalf",
	"vine",
	"hammerbro",
	"cheepred",
	"cheepwhite",
	"platformup", --my mouse is dying :(
	"platformright",
	"box",
	"pipe",
	"lakito",
	"mazestart",
	"mazeend",
	"mazegate",
	"emancehor",
	"emancever",
	"doorver",
	"doorhor",
	"wallindicator",
	"pipespawn",
	"platformfall",
	"bulletbillstart",
	"bulletbillend",
	"drain",
	"lightbridgeright",
	"lightbridgeleft",
	"lightbridgedown",
	"lightbridgeup",
	"button",
	"platformspawnerdown",
	"platformspawnerup",
	"groundlightver",
	"groundlighthor",
	"groundlightupright",
	"groundlightrightdown",
	"groundlightdownleft",
	"groundlightleftup",
	"faithplateup",
	"faithplateright",
	"faithplateleft",
	"laserright",
	"laserdown",
	"laserleft",
	"laserup",
	"laserdetectorright",
	"laserdetectordown",
	"laserdetectorleft",
	"laserdetectorup",
	"bulletbill",
	"bluegeldown",
	"bluegelright",
	"bluegelleft",
	"orangegeldown",
	"orangegelright",
	"orangegelleft",
	"boxtube",
	"pushbuttonleft",
	"pushbuttonright",
	"plant",
	"whitegeldown",
	"whitegelright",
	"whitegelleft",
	"timer",
	"beetle",
	"beetlehalf",
	"kooparedflying",
	"koopaflying",
	"castlefireccw",
	"seesaw",
	"warppipe",
	"castlefirecw",
	"lakitoend",
	"notgate",
	"geltop",
	"gelleft",
	"gelbottom",
	"gelright",
	"firestart",
	"bowser",
	"axe",
	"platformbonus",
	"spring",
	"squid",
	"flyingfishstart",
	"flyingfishend",
	"upfire",
	"spikey",
	"spikeyhalf",
	"checkpoint"
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
	"place on empty tile - companion cube", --"box",
	"place on pipe tile - pipe - right click for destination sublevel", --"pipe",
	"place on empty tile - lakito - you can also add a lakito end tile", --"lakito",
	"place on empty tile - logical maze start", --"mazestart",
	"place on empty tile - logical maze end", --"mazeend",
	"place on empty tile - maze gate - right click for the gate number", --"mazegate",
	"place on empty tile - horizontal emancipate grill - stops portals and companion cubes", --"emancehor",
	"place on empty tile - vertical emancipate grill - stops portals and companion cubes", --"emancever",
	"place on empty tile - vertical door - use link tool", --"doorver",
	"place on empty tile - horizontal door - use link tool", --"doorhor",
	"place on a wall - use link tool to show on or off state", --"wallindicator",
	"place on a pipe tile - right click for origin sublevel", --"pipespawn",
	"place on empty tile - falling platforms - right click for width", --"platformfall",
	"place anywhere - beginning of bullet zone", --"bulletbillstart",
	"place anywhere - end of bullet zone", --"bulletbillend",
	"place at the very bottom in an underwater level - drain - attracts mario down", --"drain",
	"place on empty tile - light bridge to right", --"lightbridgeright",
	"place on empty tile - light bridge to left", --"lightbridgeleft",
	"place on empty tile - light bridge to down", --"lightbridgedown",
	"place on empty tile - light bridge to up", --"lightbridgeup",
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
	"place on empty tile - laser to bottom", --"laserdown",
	"place on empty tile - laser to left", --"laserleft",
	"place on empty tile - laser to up", --"laserup",
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
	"place on empty tile - checkpoint - mario will spawn there if he dies after reaching it", --"checkpoint"
}

rightclickvalues = {}
rightclickvalues["platformspawnerup"] = {"width", 1.5, 2, 3, 5}
rightclickvalues["platformspawnerdown"] = {"width", 1.5, 2, 3, 5}
rightclickvalues["platformup"] = {"width", 1.5, 2, 3, 5}
rightclickvalues["platformright"] = {"width", 1.5, 2, 3, 5}
rightclickvalues["platformfall"] = {"width", 1.5, 2, 3, 5}
rightclickvalues["timer"] = {"time", 1, 2, 4, 8}
rightclickvalues["seesaw"] = {"type", 1, 2, 3, 4, 5, 6, 7, 8, 9}

rightclickvalues["pipe"] = {"target", 0, 1, 2, 3, 4, 5}
rightclickvalues["pipespawn"] = {"target", 0, 1, 2, 3, 4, 5}
rightclickvalues["warppipe"] = {"target", 1, 2, 3, 4, 5, 6, 7, 8}
rightclickvalues["vine"] = {"target", 0, 1, 2, 3, 4, 5}

rightclickvalues["castlefirecw"] = {"length", 6, 12}
rightclickvalues["castlefireccw"] = {"length", 6, 12}

rightclickvalues["mazegate"] = {"gateno", 1, 2, 3, 4, 5}

rightclickvalues["geltop"] = {"gelid", 1, 2, 3}
rightclickvalues["gelleft"] = {"gelid", 1, 2, 3}
rightclickvalues["gelbottom"] = {"gelid", 1, 2, 3}
rightclickvalues["gelright"] = {"gelid", 1, 2, 3}

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