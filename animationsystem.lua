function animationsystem_load()
	animations = {}
	
	local dir = love.filesystem.enumerate("mappacks/" .. mappack .. "/animations")
	
	for i = 1, #dir do
		table.insert(animations, animation:new("mappacks/" .. mappack .. "/animations/" .. dir[i]))
	end
end

function animationsystem_update(dt)
	for i, v in pairs(animations) do
		v:update(dt)
	end
end

function animationsystem_draw()
	for i, v in pairs(animations) do
		v:draw()
	end
end