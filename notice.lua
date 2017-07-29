notice = {}
notice.red = {255, 127, 127}
notice.white = {255, 255, 255}
notice.notices = {}
notice.duration = 5 --seconds
notice.fadetime = 0.5

function notice.new(text, color, duration)
	local duration = duration or notice.duration
	local text = text or ""
	local color = color or notice.white
	table.insert(notice.notices, {text=text:lower(), color=color, life=duration, duration=duration})
end

function notice.update(dt)
	for i = #notice.notices, 1, -1 do
		local v = notice.notices[i]
		
		v.life = v.life - dt
		
		if v.life <= 0 then
			table.remove(notice.notices, i)
		end
	end
end

function notice.draw()
	local y = 0
	for i = #notice.notices, 1, -1 do
		local v = notice.notices[i]
		
		--get width by finding longest line
		local split = v.text:split("|")
		local longest = #split[1]
		for i = 2, #split do
			if #split[i] > longest then
				longest = #split[i]
			end
		end
		
		local height = #split*10+3
		
		actualy = notice.gety(y, v.life, height, v.duration)
		
		local targetrect = {width*16 - longest*8-5, actualy, longest*8+5, height}
		local scissor = {(width*16 - longest*8-5)*scale, y*scale, (longest*8+5)*scale, (actualy-y+height)*scale}
		
		love.graphics.setScissor(unpack(scissor))
		
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle("fill", targetrect[1]*scale, targetrect[2]*scale, targetrect[3]*scale, targetrect[4]*scale)
		
		love.graphics.setColor(255, 255, 255, 255)
		drawrectangle(targetrect[1]+1, targetrect[2]+1, targetrect[3]-2, targetrect[4]-2)
		
		love.graphics.setColor(v.color)
		properprint(v.text, (targetrect[1]+2)*scale, (actualy+3)*scale)
		y = actualy+height
		love.graphics.setScissor()
	end
	
	love.graphics.setColor(255, 255, 255)
end

function notice.gety(y, life, height, duration)
	if life > duration-notice.fadetime then
		return y - height*((life-(duration-notice.fadetime))/notice.fadetime)^2
	elseif life < notice.fadetime then
		return y - height*((notice.fadetime-life)/notice.fadetime)^2
	else
		return y
	end
end