notgate = class:new()

function notgate:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	self.r = r
	
	self.outtable = {}
	self.state = "on"
	self.initial = true
end

function notgate:link()
	if #self.r > 3 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[4]) == v.cox and tonumber(self.r[5]) == v.coy then
					v:addoutput(self)
				end
			end
		end
	end
end

function notgate:addoutput(a)
	table.insert(self.outtable, a)
end

function notgate:update(dt)
	if self.initial then
		self.initial = false
		if self.state == "on" then
			self:input("off")
		end
	end
end

function notgate:draw()
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.drawq(entitiesimg, entityquads[84].quad, math.floor((self.x-1-xscroll)*16*scale), ((self.y-1)*16-8)*scale, 0, scale, scale)
end

function notgate:out(t)
	for i = 1, #self.outtable do
		if self.outtable[i].input then
			self.outtable[i]:input(t)
		end
	end
end

function notgate:input(t)
	if t == "off" then
		self.state = "on"
	elseif t == "on" then
		self.state = "off"
	else
		if self.state == "off" then
			self.state = "on"
		else
			self.state = "off"
		end
	end
	self:out(self.state)
end