groundlight = class:new()

function groundlight:init(x, y, dir, r)
	self.x = x
	self.y = y
	self.dir = dir
	self.r = r
	
	self.lighted = false
	self.timer = 0
end

function groundlight:link()
	self.outtable = {}
	if #self.r > 2 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[4]) == v.cox and tonumber(self.r[5]) == v.coy then
					v:addoutput(self)
				end
			end
		end
	end
end

function groundlight:update(dt)
	if self.timer > 0 then
		self.timer = self.timer - dt
		if self.timer <= 0 then
			self.timer = 0
			self:input("off")
		end
	end
end

function groundlight:draw()
	if self.lighted then
		love.graphics.setColor(255, 122, 66, 255)
	else
		love.graphics.setColor(60, 188, 252, 255)
	end
	
	love.graphics.drawq(entityquads[42+self.dir].image, entityquads[42+self.dir].quad, math.floor((self.x-1-xscroll)*16*scale), ((self.y-1)*16-8)*scale, 0, scale, scale)
end

function groundlight:input(t)
	if t == "on" then
		self.lighted = true
	elseif t == "off" then
		self.lighted = false
	elseif t == "toggle" then
		self.lighted = true
		self.timer = groundlightdelay
	end
end