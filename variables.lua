--SETABLE VARS--	
--almost all vars are in "blocks", "blocks per second" or just "seconds". Should be obvious enough what's what.
portalgundelay = 0.2
gellifetime = 2
bulletbilllifetime = 20
playertypelist = {"portal", "minecraft", "gelcannon"}

joystickdeadzone = 0.2
joystickaimdeadzone = 0.5

walkacceleration = 8 --acceleration of walking on ground
runacceleration = 16 --acceleration of running on ground
walkaccelerationair = 8 --acceleration of walking in the air
runaccelerationair = 16 --acceleration of running in the air
minspeed = 0.7 --When friction is in effect and speed falls below this, speed is set to 0
maxwalkspeed = 6.4 --fastest speedx when walking
maxrunspeed = 9.0 --fastest speedx when running
friction = 14 --amount of speed that is substracted when not pushing buttons, as well as speed added to acceleration when changing directions
superfriction = 100 --see above, but when speed is greater than maxrunspeed
frictionair = 0 --see above, but in air
airslidefactor = 0.8 --multiply of acceleration in air when changing direction

mariocombo = {100, 200, 400, 500, 800, 1000, 2000, 4000, 5000, 8000} --combo scores for bouncing on enemies
koopacombo = {500, 800, 1000, 2000, 4000, 5000, 8000} --combo scores for series of koopa kills

--star scores are identical so I'm just gonn be lazy
firepoints = {	goomba = 100,
				koopa = 200,
				plant = 200,
				bowser = 5000,
				squid = 200,
				cheep = 200,
				flyingfish = 200,
				hammerbro = 1000,
				lakito = 200,
				bulletbill = 200}

yacceleration = 80 --gravity
yaccelerationjumping = 30 --gravity while jumping (Only for mario)
maxyspeed = 100 --SMB: 14
--minportalspeedy = 3 --Things exiting floor portals can't be slower than this (REPLACED WITH OBJECT'S HEIGHT (SEE PHYSICS.LUA FUNC "PORTALCOORDS" UP->UP))
jumpforce = 16--SMB: 16, Smaller(For portal?): 12.1
jumpforceadd = 1.9 --how much jumpforce is added at top speed (linear)
headforce = 2 --how fast mario will be sent back down when hitting a block with his head
--bounceforce = 12 --when jumping on an enemy, speedy will be set to this to make mario bounce (negative)
bounceheight = 14/16 --when jumping on enemy, the height that mario will fly up
passivespeed = 4 --speed that mario is moved against the pointing direction when inside blocks (by crouch sliding under low blocks and standing up for example)

--Variables that are different for underwater
uwwalkacceleration = 8

uwrunacceleration = 16
uwwalkaccelerationair = 8
uwmaxairwalkspeed = 5
uwmaxwalkspeed = 3.6
uwmaxrunspeed = 5
uwfriction = 14
uwsuperfriction = 100
uwfrictionair = 0
uwairslidefactor = 0.8
uwjumpforce = 5.9
uwjumpforceadd = 0
uwyacceleration = 9
uwyaccelerationjumping = 12

uwmaxheight = 2.5
uwpushdownspeed = 3

bubblesmaxy = 2.5
bubblesspeed = 2.3
bubblesmargin = 0.5
bubblestime = {1.2, 1.6}

gelmaxrunspeed = 50
gelmaxwalkspeed = 25
gelrunacceleration = 25
gelwalkacceleration = 12.5

horbouncemul = 1.5
horbouncespeedy = 20
horbouncemaxspeedx = 15
horbounceminspeedx = 2

--items
mushroomspeed = 3.6
mushroomtime = 0.7 --time until it fully emerged out the block
mushroomjumpforce = 13
starjumpforce = 13
staranimationdelay = 0.04
mariostarblinkrate = 0.08 --/disco
mariostarblinkrateslow = 0.16 --/disco
mariostarduration = 12
mariostarrunout = 1 --subtracts, doesn't add.

goombaspeed = 2
goombaacceleration = 8
goombaanimationspeed = 0.2
goombadeathtime = 0.5 --the "stomped" animation of goombas will last this long

koopaspeed = 2
koopasmallspeed = 12 --speed of turtle shells
koopaanimationspeed = 0.2
koopajumpforce = 10
koopaflyinggravity = 30

bowseranimationspeed = 0.5
bowserspeedbackwards = 1.875
bowserspeedforwards = 0.875
bowserjumpforce = 7
bowsergravity = 10.9
bowserjumpdelay = 1
bowserfallspeed = 8.25 --for animation

bowserhammertable = {0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.5, 1, 2, 1}
bowserhammerdrawtime = 0.5

bowserhealth = 5

cheepwhitespeed = 1
cheepredspeed = 1.8
cheepyspeed = 0.3
cheepheight = 1
cheepanimationspeed = 0.35

platformverdistance = 8.625
platformhordistance = 3.3125
platformvertime = 6.4
platformhortime = 4
platformbonusspeed = 3.75

platformspawndelay = 2.18 --time between platform spawns

platformjustspeed = 3.5

seesawspeed = 4
seesawgravity = 30
seesawfriction = 4

koopaflyingdistance = 7.5
koopaflyingtime = 7

lakitothrowtime = 4
lakitorespawn = 16
lakitospace = 4
lakitodistancetime = 1.5
lakitohidetime = 0.5
lakitopassivex = 18-4/16 --from the flag (or axe (or right end of map))
lakitopassivespeed = 3

-- loiters between 4 blocks behind and 4 blocks ahead of you (total 9 blocks he goes above)
-- spawns only 3 of the hedgehog things and then hides until they're offscreen/dead
-- in 4-1 he disappears when you touch the first step (not stand on, touch from side while on the ground)
-- can be killed by single fireflower
-- the spiky dudes turn towards you after they fall down

fireballspeed = 15
fireballjumpforce = 10
maxfireballs = 2
fireanimationtime = 0.11

shotspeedx = 4 --X speed (constant) of fire/shell killed enemies
shotjumpforce = 8 --initial speedy (negative) when shot
shotgravity = 60 --how fast enemies that have been killed by fire or shell accellerate downwards

deathanimationjumpforce = 17
deathanimationjumptime = 0.3
deathgravity = 40
deathtotaltime = 4

portalanimationcount = 6 --frame count of portal animation
portalanimation = 1
portalanimationtimer = 0
portalanimationdelay = 0.08 --frame delay of portal animation
portalrotationalignmentspeed = 15 --how fast things return to a rotation of 0 rad(-ical)

scrollrate = 5
superscrollrate = 40
maxscrollrate = maxrunspeed*2
blockbouncetime = 0.2
blockbounceheight = 0.4
coinblocktime = 0.3
coinblockdelay = 0.5/30

runanimationspeed = 10
swimanimationspeed = 10

spriteset = 1
background = 1
speed = 1
speedtarget = 1
speedmodifier = 10

scrollingscoretime = 0.8
scrollingscoreheight = 2.5

portalparticlespeed = 1
portalparticletimer = 0
portalparticletime = 0.05
portalparticleduration = 0.5

portaldotstime = 0.8
portaldotsdistance = 1.2
portaldotsinner = 10
portaldotsouter = 70

portalprojectilespeed = 100
portalprojectilesinemul = 100
portalprojectiledelay = 2
portalprojectilesinesize = 0.3
portalprojectileparticledelay = 0.002

emanceparticlespeed = 3
emanceparticlespeedmod = 0.3
emanceimgwidth = 64
emancelinecolor = {100, 100, 255, 10}

boxfriction = 20
boxfrictionair = 8

faithplatetime = 0.3

spacerunroom = 1.2/16 --How far you can fall but still be allowed onto the top of a block (For running over 1 tile wide gaps)

doorspeed = 2
groundlightdelay = 1

geldispensespeed = 0.05
gelmaxspeed = 30

cubedispensertime = 1

pushbuttontime = 1

bulletbillspeed = 8.0
bulletbilltimemax = 4.5
bulletbilltimemin = 1.0
bulletbillrange = 3

hammerbropreparetime = 0.5
hammerbrotime = {0.6, 1.6}
hammerbrospeed = 1.5
hammerbroanimationspeed = 0.15
hammerbrojumptime = 3
hammerbrojumpforce = 19
hammerbrojumpforcedown = 6

hammerspeed = 4
hammerstarty = 8
hammergravity = 25
hammeranimationspeed = 0.05

squidfallspeed = 0.9
squidxspeed = 3
squidupspeed = 3
squidacceleration = 10
squiddowndistance = 1

firespeed = 4.69
fireverspeed = 2
fireanimationdelay = 0.05

upfirestarty = 8 --not used
upfireforce = 19
upfiregravity = 20

flyingfishgravity = 20
flyingfishforce = 23

userange = 1
usesquaresize = 1

blockdebrisanimationtime = 0.1
blockdebrisgravity = 60

castlefireangleadd = 11.25
castlefiredelay = 3.4/(360/castlefireangleadd) --the number in front of the bracket is how long a full turn takes
castlefireanimationdelay = 0.07

--plants
plantintime = 1.8
plantouttime = 2
plantanimationdelay = 0.15
plantmovedist = 23/16
plantmovespeed = 2.3

vinespeed = 2.13
vinemovespeed = 3.21
vinemovedownspeed = vinemovespeed*2
vineframedelay = 0.15
vineframedelaydown = vineframedelay/2

vineanimationstart = 4
vineanimationgrowheight = 6
vineanimationmariostart = vineanimationgrowheight/vinespeed
vineanimationstop = 1.75
vineanimationdropdelay = 0.5

--animationstuff
pipeanimationtime = 0.7
pipeanimationdelay = 1
pipeanimationdistancedown = 32/16
pipeanimationdistanceright = 16/16
pipeanimationrunspeed = 3
pipeupdelay = 1

growtime = 0.9
shrinktime = 0.9
growframedelay = 0.08
shrinkframedelay = 0.08
invicibleblinktime = 0.02
invincibletime = 3.2

blinktime = 0.5

levelscreentime = 2.4 --2.4
gameovertime = 7
blacktimesub = 0.1
sublevelscreentime = 0.2

--flag animation
flagclimbframedelay = 0.07
scoredelay = 2
flagdescendtime = 0.9
flagydistance = 7+10/16
flaganimationdelay = 0.6
scoresubtractspeed = 1/60
castleflagstarty = 1.5
castleflagspeed = 3
castlemintime = 7
fireworkdelay = 0.55
fireworksoundtime = 0.2
endtime = 2

--spring
springtime = 0.2
springhighforce = 41
springforce = 24
springytable = {0, 0.5, 1}

--flag scores and positions
flagscores = {100, 400, 800, 2000, 5000}
flagvalues = {9.8125, 7.3125, 5.8125, 2.9375}

--castle win animation
castleanimationchaindisappear = 0.38 --delay from axe disappearing to chain disappearing; once this starts, bowser starts tapping feet with a delay of 0.0666666
castleanimationbowserframedelay = 0.0666
castleanimationbridgedisappeardelay = 0.06 --delay between each bridge block disappearing, also delay between chain and first block
--bowser starts falling and stops moving immediately after the last block disappears
castleanimationmariomove = 1.07 --time when mario starts moving after bowser starts falling and is also unfrozen. music also starts playing at this point
castleanimationcameraaccelerate = 1.83 -- time when camera starts moving faster than mario, relative to start of his move
castleanimationmariostop = 2.3 -- when mario stops next to toad, relative to start of his move
castleanimationtextfirstline = 3.2 -- when camera stops and first line of text appears, relative to the start of his move
castleanimationtextsecondline = 5.3 --second line appears
castleanimationnextlevel = 9.47 -- splash screen for next level appears
-- first bowser is white goomba - see http://www.mariowiki.com/False_Bowser
-- first bowser takes 5 fireflower hits and dies as goomba
-- when fireflower killing boss, axe doesn't make bridge disappear

endanimationtextfirstline = 3.2 -- when camera stops and first line of text appears, relative to the start of his move
endanimationtextsecondline = 7.4 --second line appears
endanimationtextthirdline = 8.4 --third line appears
endanimationtextfourthline = 9.4 --fourth line appears
endanimationtextfifthline = 10.4 --fifth line appears
endanimationend = 12 -- user can press any button

drainspeed = 20
drainmax = 10

--minecraft stuff
minecraftrange = 3
minecraftbreaktime = 0.6

rainboomdelay = 0.03
rainboomframes = 49
rainboomspeed = 45
rainboomearthquake = 50

backgroundstripes = 24

konami = {"up", "up", "down", "down", "left", "right", "left", "right", "b", "a"}
konamii = 1

earthquakespeed = 40
bullettime = false
portalknockback = false
bigmario = false
goombaattack = false
sonicrainboom = false
playercollisions = false
scalefactor = 5
gelcannondelay = 0.05
gelcannonspeed = 30
infinitetime = false
infinitelives = false

pausemenuoptions = {"resume", "suspend", "volume", "quit to", "quit to"}
pausemenuoptions2 = {"", "", "", "menu", "desktop"}

guirepeatdelay = 0.07
mappackhorscrollrange = 220

maximumbulletbills = 5
coinblocktime = 4