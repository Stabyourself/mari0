notgate = class:new()

function notgate:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	self.visible = false
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	--VISIBLE
	if #self.r > 0 and self.r[1] ~= "link" then
		self.visible = (self.r[1] == "true")
		table.remove(self.r, 1)
	end
	
	self.outtable = {}
	self.input1state = "on"
	self.initial = true
end

function notgate:link()
	while #self.r > 3 do
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[3]) == v.cox and tonumber(self.r[4]) == v.coy then
					v:addoutput(self, self.r[2])
				end
			end
		end
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
	end
end

function notgate:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end

function notgate:update(dt)
	if self.initial then
		self.initial = false
		self:input("off", "power")
	end
end

function notgate:draw()
	if self.visible then
		love.graphics.setColor(255, 255, 255)
		love.graphics.drawq(entitiesimg, entityquads[84].quad, math.floor((self.x-1-xscroll)*16*scale), ((self.y-yscroll-1)*16-8)*scale, 0, scale, scale)
	end
end

function notgate:out(t)
	for i = 1, #self.outtable do
		if self.outtable[i][1].input then
			self.outtable[i][1]:input(t, self.outtable[i][2])
		end
	end
end

function notgate:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self.power = not self.power
		elseif t == "off" and self.input1state == "on" then
			self.power = not self.power
		elseif t == "toggle" then
			self.power = not self.power
		end
		
		self.input1state = t
	
		local out = "on"
		if not self.power then
			out = "off"
		end
		
		self:out(out)
	end
end