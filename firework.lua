fireworkboom = class:new()

function fireworkboom:init(x)
	self.x = x+(math.random(9)-5)
	self.y = math.random(5)+2
	self.timer = 0
	marioscore = marioscore + 200
end

function fireworkboom:update(dt)
	self.timer = self.timer + dt
	
	if self.timer >= fireworksoundtime and self.timer-dt < fireworksoundtime then
		playsound(boomsound)
	end
	
	if self.timer > fireworkdelay then
		return true
	end
end

function fireworkboom:draw()
	local framelength = fireworkdelay/3
	local frame = 5
	if self.timer > framelength then
		frame = 6
	end
	if self.timer > framelength*2 then
		frame = 7
	end
	
	love.graphics.drawq(fireballimg, fireballquad[frame], math.floor((self.x-xscroll)*16*scale), (self.y-0.5)*16*scale, 0, scale, scale, 8, 8)
end