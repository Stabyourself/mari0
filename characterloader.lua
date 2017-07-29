function loadcharacter(charname)
	local folder = "characters/" .. charname .. "/"
	if not love.filesystem.exists(folder .. "config.txt") then
		return false
	end
	
	local s = love.filesystem.read(folder .. "config.txt")
	
	--------------------
	--VARIABLE LOADING--
	--------------------
	
	local char = JSON:decode(s)
	char.name = string.lower(charname)
	
	-----------------
	--IMAGE LOADING--
	-----------------
	for t = 1, 4 do
		local curtype
		if t == 1 then
			curtype = "animations"
		elseif t == 2 then
			curtype = "biganimations"
		elseif t == 3 then
			curtype = "nogunanimations"
		else
			curtype = "nogunbiganimations"
		end
		
		if char.defaultcolors and love.filesystem.exists(folder .. curtype .. "1.png") then --MULTIPLE IMAGES
			local imagecount = #char.defaultcolors[1]
			for i = 1, imagecount do
				if not love.filesystem.exists(folder .. curtype .. i .. ".png") then
					if t <= 2 then
						return false
					else
						break
					end
				end
				if not char[curtype] then
					char[curtype] = {}
				end
				char[curtype][i] = love.graphics.newImage(folder .. curtype .. i .. ".png")
			end
			
			--0 Image
			if love.filesystem.exists(folder .. curtype .. "0.png") then
				char[curtype][0] = love.graphics.newImage(folder .. curtype .. "0.png")
			end
			
			--Dot Image
			if love.filesystem.exists(folder .. curtype .. "dot.png") then
				char[curtype]["dot"] = love.graphics.newImage(folder .. curtype .. "dot.png")
			end
		else
			if love.filesystem.exists(folder .. curtype .. ".png") then
				char[curtype] = love.graphics.newImage(folder .. curtype .. ".png")
			end
		end
	end
	
	----------------
	--QUAD LOADING--
	----------------
	local quadnum = 5
	if char.nopointing then
		quadnum = 1
	end
	char.idle = {}
	char.run = {}
	char.slide = {}
	char.jump = {}
	char.die = {}
	char.climb = {}
	char.swim = {}
	char.grow = {}
	char.customframe = {}
	
	for i = 1, quadnum do
		local add = 0
		char.idle[i] = love.graphics.newQuad(0, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		
		char.run[i] = {}
		for j = 1, char.runframes do
			char.run[i][j] = love.graphics.newQuad(j*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		end
		add = add + char.runframes
		
		char.slide[i] = love.graphics.newQuad((add+1)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		
		char.jump[i] = {}
		for j = 1, char.jumpframes do
			char.jump[i][j] = love.graphics.newQuad((add+1+j)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		end
		add = add + char.jumpframes
		
		char.die[i] = love.graphics.newQuad((add+2)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		
		char.climb[i] = {}
		char.climb[i][1] = love.graphics.newQuad((add+3)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		char.climb[i][2] = love.graphics.newQuad((add+4)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		
		char.swim[i] = {}
		char.swim[i][1] = love.graphics.newQuad((add+5)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		char.swim[i][2] = love.graphics.newQuad((add+6)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		
		char.grow[i] = love.graphics.newQuad((add+7)*char.smallquadwidth, 0, char.smallquadwidth, char.smallimgheight, char.smallimgwidth, char.smallimgheight)
		
		char.customframe[i] = {}
		for j = 1, (char.customframes or 0) do
			char.customframe[i][j] = love.graphics.newQuad((add+7+j)*char.smallquadwidth, (i-1)*char.smallquadheight, char.smallquadwidth, char.smallquadheight, char.smallimgwidth, char.smallimgheight)
		end
	end
	
	char.bigidle = {}
	char.bigrun = {}
	char.bigslide = {}
	char.bigjump = {}
	char.bigfire = {}
	char.bigclimb = {}
	char.bigswim = {}
	char.bigduck = {} --hehe duck.
	char.bigcustomframe = {}

	for i = 1, quadnum do
		local add = 0
		char.bigidle[i] = love.graphics.newQuad(0, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		
		char.bigrun[i] = {}
		for j = 1, char.runframes do
			char.bigrun[i][j] = love.graphics.newQuad(j*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		end
		add = add + char.runframes
		
		char.bigslide[i] = love.graphics.newQuad((add+1)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		
		char.bigjump[i] = {}
		for j = 1, char.jumpframes do
			char.bigjump[i][j] = love.graphics.newQuad((add+1+j)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		end
		add = add + char.jumpframes
		
		char.bigfire[i] = love.graphics.newQuad((add+2)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		
		char.bigclimb[i] = {}
		char.bigclimb[i][1] = love.graphics.newQuad((add+3)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		char.bigclimb[i][2] = love.graphics.newQuad((add+4)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		
		char.bigswim[i] = {}
		char.bigswim[i][1] = love.graphics.newQuad((add+5)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		char.bigswim[i][2] = love.graphics.newQuad((add+6)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		
		char.bigduck[i] = love.graphics.newQuad((add+7)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		
		char.bigcustomframe[i] = {}
		for j = 1, (char.customframes or 0) do
			char.bigcustomframe[i][j] = love.graphics.newQuad((add+7+j)*char.bigquadwidth, (i-1)*char.bigquadheight, char.bigquadwidth, char.bigquadheight, char.bigimgwidth, char.bigimgheight)
		end
	end
	
	return char
end

characterlist = {}
characters = {}
for i, v in pairs(love.filesystem.enumerate("characters/")) do
	if (love.filesystem.isDirectory("characters/" .. v)) then
		local temp = loadcharacter(v)
		if temp then
			characters[v] = temp
			table.insert(characterlist, v)
		end
	end
end