--Not the hatloader mod.

function loadhat(path)
	local s = love.filesystem.read(path)
	if not s then
		return
	end
	
	local s1 = s:split("|")
	
	if #s1 ~= 8 then
		return
	end
	
	if not love.filesystem.exists("hats/" .. s1[7] .. ".png") or not love.filesystem.exists("hats/" .. s1[8] .. ".png") then
		return
	end
	
	table.insert(hat, {x = s1[1], y = s1[2], height = s1[3], graphic = love.graphics.newImage("hats/" .. s1[7] .. ".png")})
	table.insert(bighat, {x = s1[4], y = s1[5], height = s1[6], graphic = love.graphics.newImage("hats/" .. s1[8] .. ".png")})
	
	hatcount = hatcount + 1
end

local files = love.filesystem.enumerate("hats")

for i, v in pairs(files) do
	if string.sub(v, -3, -1) == "txt" then
		loadhat("hats/" .. v)
	end
end