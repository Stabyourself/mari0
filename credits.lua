function credits_load()
	credits_pos = 200
	love.graphics.setBackgroundColor(0, 0, 0)
	creditstxt = {}
	for line in love.filesystem.lines("credits.txt") do
		table.insert(creditstxt, line)
	end
end

function credits_update(dt)
	local n = #creditstxt
	if (credits_pos + n * 8 > -8) then
		credits_pos = credits_pos - (10 * dt);
	else
		gamestate = "menu"
		love.graphics.setBackgroundColor(backgroundcolor[1])
	end
end

function credits_draw()
	for i,line in ipairs(creditstxt) do
		if (credits_pos + i * 8 > -8) and (credits_pos + i * 8 < 250) then
			properprint(line, uispace*.5 - 40*scale, (credits_pos + i * 8)*scale)
		end
	end
end

function credits_keypressed(key, unicode)
	gamestate = "menu"
	love.graphics.setBackgroundColor(backgroundcolor[1])
end
