characters = {}
characterlist = {"mario", "chell", "link", "luigi", "megaman", "awesome", "awesome2"}

--CHARACTERS START--
--mario
if true then
	characters.mario = {}
	local temp = characters.mario
	
	temp.name = "mario"
	temp.colorables = {"hat", "hair", "skin"}
	temp.defaultcolors = {}
	temp.defaultcolors[1] = {{224,  32,   0}, {136, 112,   0}, {252, 152,  56}}
	temp.defaultcolors[2] = {{255, 255, 255}, {  0, 160,   0}, {252, 152,  56}}
	temp.defaultcolors[3] = {{  0,   0,   0}, {200,  76,  12}, {252, 188, 176}}
	temp.defaultcolors[4] = {{ 32,  56, 236}, {  0, 128, 136}, {252, 152,  56}}

	temp.smalloffsetX = 6
	temp.smalloffsetY = 3
	temp.smallquadcenterX = 11
	temp.smallquadcenterY = 10

	temp.shrinkquadcenterX = 9
	temp.shrinkquadcenterY = 32
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations["dot"] = love.graphics.newImage("graphics/player/mario/animationsdot.png")
	temp.animations[0] = love.graphics.newImage("graphics/player/mario/animations0.png")
	temp.animations[1] = love.graphics.newImage("graphics/player/mario/animations1.png")
	temp.animations[2] = love.graphics.newImage("graphics/player/mario/animations2.png")
	temp.animations[3] = love.graphics.newImage("graphics/player/mario/animations3.png")
	
	temp.nogunanimations = {}
	temp.nogunanimations[1] = love.graphics.newImage("graphics/player/mario/nogunanimations1.png")
	temp.nogunanimations[2] = love.graphics.newImage("graphics/player/mario/nogunanimations2.png")
	temp.nogunanimations[3] = love.graphics.newImage("graphics/player/mario/nogunanimations3.png")
	
	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 20
	local quadheight = 20
	local runframes = 3
	local imgwidth = 512
	local imgheight = 128

	temp.runframes = 3
	temp.jumpframes = 1

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations["dot"] = love.graphics.newImage("graphics/player/mario/biganimationsdot.png")
	temp.biganimations[0] = love.graphics.newImage("graphics/player/mario/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/mario/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/mario/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/mario/biganimations3.png")
	
	temp.nogunbiganimations = {}
	temp.nogunbiganimations[1] = love.graphics.newImage("graphics/player/mario/nogunbiganimations1.png")
	temp.nogunbiganimations[2] = love.graphics.newImage("graphics/player/mario/nogunbiganimations2.png")
	temp.nogunbiganimations[3] = love.graphics.newImage("graphics/player/mario/nogunbiganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local runframes = 3
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end

--link
if true then
	characters.link = {}
	local temp = characters.link
	
	temp.name = "link"
	temp.defaultcolors = {}

	temp.smalloffsetX = 6
	temp.smalloffsetY = 3
	temp.smallquadcenterX = 11
	temp.smallquadcenterY = 10

	temp.shrinkquadcenterX = 9
	temp.shrinkquadcenterY = 32
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations = love.graphics.newImage("graphics/player/link/animations.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 20
	local quadheight = 20
	local runframes = 3
	local imgwidth = 512
	local imgheight = 128

	temp.runframes = 3
	temp.jumpframes = 1

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations["dot"] = love.graphics.newImage("graphics/player/mario/biganimationsdot.png")
	temp.biganimations[0] = love.graphics.newImage("graphics/player/mario/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/mario/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/mario/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/mario/biganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local runframes = 3
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end

--luigi
if true then
	characters.luigi = {}
	local temp = characters.luigi
	
	temp.name = "luigi"
	temp.defaultcolors = {}

	temp.smalloffsetX = 6
	temp.smalloffsetY = 3
	temp.smallquadcenterX = 11
	temp.smallquadcenterY = 10

	temp.shrinkquadcenterX = 9
	temp.shrinkquadcenterY = 32
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations = love.graphics.newImage("graphics/player/luigi/animations.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 20
	local quadheight = 20
	local runframes = 3
	local imgwidth = 512
	local imgheight = 128

	temp.runframes = 3
	temp.jumpframes = 1

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations["dot"] = love.graphics.newImage("graphics/player/mario/biganimationsdot.png")
	temp.biganimations[0] = love.graphics.newImage("graphics/player/mario/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/mario/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/mario/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/mario/biganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local runframes = 3
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end

--megaman
if true then
	characters.megaman = {}
	local temp = characters.megaman
	
	temp.name = "mega man"
	temp.defaultcolors = {}
	temp.nopointing = true

	temp.smalloffsetX = 6
	temp.smalloffsetY = 10
	temp.smallquadcenterX = 15
	temp.smallquadcenterY = 15

	temp.shrinkquadcenterX = 15
	temp.shrinkquadcenterY = 15
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations = love.graphics.newImage("graphics/player/megaman/animations.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 30
	local quadheight = 30
	local runframes = 3
	local imgwidth = 512
	local imgheight = 128

	temp.runframes = 4
	temp.rundelay = 4
	temp.jumpframes = 1

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations["dot"] = love.graphics.newImage("graphics/player/mario/biganimationsdot.png")
	temp.biganimations[0] = love.graphics.newImage("graphics/player/mario/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/mario/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/mario/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/mario/biganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local runframes = 3
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end

--mario (minecraft)
if true then
	characters.minecraft = {}
	local temp = characters.minecraft
	
	temp.name = "steve"
	temp.colorables = {"hat", "hair", "skin"}
	temp.defaultcolors = {}
	temp.defaultcolors[1] = {{224,  32,   0}, {136, 112,   0}, {252, 152,  56}}
	temp.defaultcolors[2] = {{255, 255, 255}, {  0, 160,   0}, {252, 152,  56}}
	temp.defaultcolors[3] = {{  0,   0,   0}, {200,  76,  12}, {252, 188, 176}}
	temp.defaultcolors[4] = {{ 32,  56, 236}, {  0, 128, 136}, {252, 152,  56}}

	temp.smalloffsetX = 6
	temp.smalloffsetY = 3
	temp.smallquadcenterX = 11
	temp.smallquadcenterY = 10

	temp.shrinkquadcenterX = 9
	temp.shrinkquadcenterY = 32
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations[0] = love.graphics.newImage("graphics/player/steve/animations0.png")
	temp.animations[1] = love.graphics.newImage("graphics/player/steve/animations1.png")
	temp.animations[2] = love.graphics.newImage("graphics/player/steve/animations2.png")
	temp.animations[3] = love.graphics.newImage("graphics/player/steve/animations3.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 20
	local quadheight = 20
	local runframes = 3
	local imgwidth = 512
	local imgheight = 128

	temp.runframes = 3
	temp.jumpframes = 1

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations[0] = love.graphics.newImage("graphics/player/steve/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/steve/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/steve/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/steve/biganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local runframes = 3
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end

--chell
if true then
	characters.chell = {}
	local temp = characters.chell
	
	temp.name = "chell"
	temp.colorables = {"hair", "skin", "shirt", "pants"}
	temp.defaultcolors = {}
	temp.defaultcolors[1] = {{  0,   0,   0}, {250, 161,  38}, {251, 251, 251}, {217,  17,   0}}
	temp.defaultcolors[2] = {{  0,   0,   0}, {250, 161,  38}, {251, 251, 251}, {217,  17,   0}}
	temp.defaultcolors[3] = {{  0,   0,   0}, {250, 161,  38}, {251, 251, 251}, {217,  17,   0}}
	temp.defaultcolors[4] = {{  0,   0,   0}, {250, 161,  38}, {251, 251, 251}, {217,  17,   0}}

	temp.smalloffsetX = 6
	temp.smalloffsetY = 3
	temp.smallquadcenterX = 11
	temp.smallquadcenterY = 10

	temp.shrinkquadcenterX = 9
	temp.shrinkquadcenterY = 32
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations[0] = love.graphics.newImage("graphics/player/chell/animations0.png")
	temp.animations[1] = love.graphics.newImage("graphics/player/chell/animations1.png")
	temp.animations[2] = love.graphics.newImage("graphics/player/chell/animations2.png")
	temp.animations[3] = love.graphics.newImage("graphics/player/chell/animations3.png")
	temp.animations[4] = love.graphics.newImage("graphics/player/chell/animations4.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 20
	local quadheight = 20
	local runframes = 3
	local imgwidth = 512
	local imgheight = 128

	temp.runframes = 3
	temp.jumpframes = 1

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations[0] = love.graphics.newImage("graphics/player/chell/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/chell/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/chell/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/chell/biganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local runframes = 3
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end

--awesome
if true then
	characters.awesome = {}
	local temp = characters.awesome
	
	temp.name = "rainbow dash"
	temp.defaultcolors = {}
	temp.pony = true

	temp.smalloffsetX = 6
	temp.smalloffsetY = 17
	temp.smallquadcenterX = 26
	temp.smallquadcenterY = 24

	temp.shrinkquadcenterX = 26
	temp.shrinkquadcenterY = 24
	temp.shrinkoffsetY = 17
	temp.shrinkquadcenterY2 = 24

	temp.growquadcenterY = 12
	temp.growquadcenterY2 = 12

	temp.duckquadcenterY = 24
	temp.duckoffsetY = 17

	temp.bigoffsetX = 6
	temp.bigoffsetY = 5
	temp.bigquadcenterX = 26
	temp.bigquadcenterY = 24

	temp.customscale = 1
	temp.nopointing = true

	--players
	temp.animations = love.graphics.newImage("graphics/player/awesome/animations.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 53
	local quadheight = 48
	local imgwidth = 2067
	local imgheight = 48

	temp.runframes = 16
	temp.jumpframes = 16

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.biganimations = love.graphics.newImage("graphics/player/awesome/biganimations.png")

	local quadwidth = 53
	local quadheight = 48
	local imgwidth = 2226
	local imgheight = 48
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end
end

--awesome2
if true then
	characters.awesome2 = {}
	local temp = characters.awesome2
	
	temp.name = "rainbow dash"
	temp.defaultcolors = {}

	temp.smalloffsetX = 6
	temp.smalloffsetY = 12
	temp.smallquadcenterX = 20
	temp.smallquadcenterY = 10

	temp.shrinkquadcenterX = 9
	temp.shrinkquadcenterY = 32
	temp.shrinkoffsetY = -3
	temp.shrinkquadcenterY2 = 16

	temp.growquadcenterY = 4
	temp.growquadcenterY2 = -2

	temp.duckquadcenterY = 22
	temp.duckoffsetY = 7


	--players
	temp.animations = {}
	temp.animations = love.graphics.newImage("graphics/player/awesome2/animations.png")

	temp.idle = {}
	temp.run = {}
	temp.slide = {}
	temp.jump = {}
	temp.die = {}
	temp.climb = {}
	temp.swim = {}
	temp.grow = {}

	local quadwidth = 36
	local quadheight = 31
	local imgwidth = 648
	local imgheight = 31
	temp.nopointing = true

	temp.runframes = 6
	temp.rundelay = 7
	temp.jumpframes = 5
	temp.jumpdelay = 5

	for i = 1, 5 do
		local add = 0
		temp.idle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.run[i] = {}
		for j = 1, temp.runframes do
			temp.run[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.slide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.jump[i] = {}
		for j = 1, temp.jumpframes do
			temp.jump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.die[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.climb[i] = {}
		temp.climb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.climb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.swim[i] = {}
		temp.swim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.swim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.grow[i] = love.graphics.newQuad((add+9)*quadwidth, 0, quadwidth, imgheight, imgwidth, imgheight)
	end

	temp.bigquadcenterY = 20
	temp.bigquadcenterX = 9
	temp.bigoffsetY = -3
	temp.bigoffsetX = 6

	temp.biganimations = {}
	temp.biganimations["dot"] = love.graphics.newImage("graphics/player/mario/biganimationsdot.png")
	temp.biganimations[0] = love.graphics.newImage("graphics/player/mario/biganimations0.png")
	temp.biganimations[1] = love.graphics.newImage("graphics/player/mario/biganimations1.png")
	temp.biganimations[2] = love.graphics.newImage("graphics/player/mario/biganimations2.png")
	temp.biganimations[3] = love.graphics.newImage("graphics/player/mario/biganimations3.png")

	local quadwidth = 20
	local quadheight = 36
	local imgwidth = 512
	local imgheight = 256
	
	temp.bigidle = {}
	temp.bigrun = {}
	temp.bigslide = {}
	temp.bigjump = {}
	temp.bigfire = {}
	temp.bigclimb = {}
	temp.bigswim = {}
	temp.bigduck = {} --hehe duck.

	for i = 1, 5 do
		local add = 0
		temp.bigidle[i] = love.graphics.newQuad(0, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigrun[i] = {}
		for j = 1, temp.runframes do
			temp.bigrun[i][j] = love.graphics.newQuad(j*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.runframes
		
		temp.bigslide[i] = love.graphics.newQuad((add+1)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigjump[i] = {}
		for j = 1, temp.jumpframes do
			temp.bigjump[i][j] = love.graphics.newQuad((add+1+j)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		end
		add = add + temp.jumpframes
		
		temp.bigfire[i] = love.graphics.newQuad((add+2)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigclimb[i] = {}
		temp.bigclimb[i][1] = love.graphics.newQuad((add+3)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigclimb[i][2] = love.graphics.newQuad((add+4)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigswim[i] = {}
		temp.bigswim[i][1] = love.graphics.newQuad((add+5)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		temp.bigswim[i][2] = love.graphics.newQuad((add+6)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
		
		temp.bigduck[i] = love.graphics.newQuad((add+9)*quadwidth, (i-1)*quadheight, quadwidth, quadheight, imgwidth, imgheight)
	end
end