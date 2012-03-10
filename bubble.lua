bubble = class:new()

--"FUCKING BUBBLES!!!!"
--          -The Nostalgia Critic

function bubble:init(x, y)
	self.x = x
	self.y = y
	
	self.speedy = -bubblesspeed
end

function bubble:update(dt)
	self.speedy = self.speedy + (math.random()-0.5)*dt*100
	
	if self.speedy < -bubblesspeed-bubblesmargin then
		self.speedy = -bubblesspeed-bubblesmargin
	elseif self.speedy > -bubblesspeed+bubblesmargin then
		self.speedy = -bubblesspeed+bubblesmargin
	end
	
	self.y = self.y + self.speedy*dt
	
	if self.y < bubblesmaxy then
		return true
	end
	
	return false
end

function bubble:draw()
	love.graphics.draw(bubbleimg, math.floor((self.x-xscroll)*16*scale), math.floor((self.y-.5)*16*scale), 0, scale, scale, 2, 2)
end