function enemies_load()
	defaultvalues = {quadcount=1, quadno=1}

	enemiesdata = {}
	enemies = {}
	
	--ENEMIIIIEEES
	loaddelayed = {}
	
	local fl = love.filesystem.enumerate("enemies/")
	local fl2 = love.filesystem.enumerate("mappacks/" .. mappack .. "/enemies/")
	
	local realfl = {}
	
	for i = 1, #fl do
		table.insert(realfl, "enemies/" .. fl[i]) --STANDARD ENEMIES
	end
	
	for i = 1, #fl2 do
		table.insert(realfl, "mappacks/" .. mappack .. "/enemies/" .. fl2[i]) --MAPPACK ENEMIES
	end
	
	for i = 1, #realfl do
		if string.sub(realfl[i], -4) == "json" then
			loadenemy(realfl[i])
		end
	end
end

function loadenemy(filename)
	local ss = filename:split("/")
	local folder = ""
	for i = 1, #ss-1 do
		folder = folder .. ss[i] .. "/"
	end
	
	local s = string.sub(ss[#ss], 1, -6):lower()
	
	--CHECK FOR - , ; * AND WHATEVER ELSE WOULD BREAK MAPS
	local skip = false
	local badlist = {",", ";", "-", "*"} --badlist sounds like a movie
	for i = 1, #badlist do
		if s:find(badlist[i]) then
			skip = true
		end
	end
	
	if not skip then --bad letter
		local data = love.filesystem.read(filename)
		data = data:gsub("\r", "")
		
		if string.sub(data, 1, 4) == "base" then
			local split = data:split("\n")
			local base = string.sub(split[1], 6)
			if enemiesdata[base] then
				local newdata = ""
				for i = 2, #split do
					newdata = newdata .. split[i]
					if i ~= #split then
						newdata = newdata .. "\n"
					end
				end
				
				enemiesdata[s] = usebase(enemiesdata[base])
				
				local temp = JSON:decode(newdata)
				
				for i, v in pairs(temp) do
					enemiesdata[s][i] = v
				end
			else
				--Put enemy for later loading because base hasn't been loaded yet
				if not success then
					if not loaddelayed[base] then
						loaddelayed[base] = {}
					end
					table.insert(loaddelayed[base], filename)
				end
				print("DON'T HAVE BASE " .. base .. " FOR " .. s)
				return
			end
		else
			enemiesdata[s] = JSON:decode(data)
		end
		
		--CASE INSENSITVE THING
		for i, v in pairs(enemiesdata[s]) do
			local a = i:lower()
			if a == "offsetx" then
				enemiesdata[s]["offsetX"] = v
			elseif a == "offsety" then
				enemiesdata[s]["offsetY"] = v
			elseif a == "quadcenterx" then
				enemiesdata[s]["quadcenterX"] = v
			elseif a == "quadcentery" then
				enemiesdata[s]["quadcenterY"] = v
			else
				if type(v) == "string" then
					enemiesdata[s][a] = v:lower()
				else
					enemiesdata[s][a] = v
				end
			end
		end
		
		for i, v in pairs(defaultvalues) do
			if enemiesdata[s][i] == nil then
				enemiesdata[s][i] = v
			end
		end
		
		--Load graphics if it exists
		if love.filesystem.exists(folder .. s .. ".png") then
			enemiesdata[s].graphic = love.graphics.newImage(folder .. s .. ".png")
		end
		
		--Set up quads if given
		if enemiesdata[s].graphic and enemiesdata[s].quadcount then
			local imgwidth, imgheight = enemiesdata[s].graphic:getWidth(), enemiesdata[s].graphic:getHeight()
			local quadwidth = imgwidth/enemiesdata[s].quadcount
			local quadheight = imgheight/4
			
			if math.floor(quadwidth) == quadwidth and math.floor(quadheight) == quadheight then
				if enemiesdata[s].nospritesets then
					quadheight = quadheight*4
				end
				
				enemiesdata[s].quadbase = {}
				
				for y = 1, 4 do
					enemiesdata[s].quadbase[y] = {}
					for x = 1, enemiesdata[s].quadcount do
						local realy = (y-1)*quadheight
						if enemiesdata[s].nospritesets then
							realy = 0
						end
						enemiesdata[s].quadbase[y][x] = love.graphics.newQuad((x-1)*quadwidth, realy, quadwidth, quadheight, imgwidth, imgheight)
					end
				end
			end
		end
		
		--check if graphic for enemy exists
		if enemiesdata[s].quadbase and enemiesdata[s].graphic then
			enemiesdata[s].drawable = true
			enemiesdata[s].quadgroup = enemiesdata[s].quadbase[spriteset]
			if enemiesdata[s].animationtype == "frames" then
				enemiesdata[s].quad = enemiesdata[s].quadbase[spriteset][enemiesdata[s].animationstart]
			else
				enemiesdata[s].quad = enemiesdata[s].quadbase[spriteset][enemiesdata[s].quadno]
			end
		end
		
		table.insert(enemies, s)
		
		
		if loaddelayed[s] and #loaddelayed[s] > 0 then
			for j = #loaddelayed[s], 1, -1 do
				loadenemy(loaddelayed[s][j]) --RECURSIVE PROGRAMMING AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH
				table.remove(loaddelayed, j)
			end
		end
	else
		--Bad.
	end
end

function usebase(t)
	local r = {}
	
	for i, v in pairs(t) do
		r[i] = v
	end
	
	return r
end