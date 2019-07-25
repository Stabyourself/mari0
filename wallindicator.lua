wallindicator = class:new()

function wallindicator:init(x, y, r)
	self.x = x
	self.y = y
	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	self.lighted = false
	
	--default off
	if #self.r > 0 and self.r[1] ~= "link" then
		self.lighted = (self.r[1] == "true")
		table.remove(self.r, 1)
	end
	
	self.input1state = "off"
end

function wallindicator:link()
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

function wallindicator:update()

end

function wallindicator:draw()
	love.graphics.setColor(255, 255, 255)
	local quad = 1
	if self.lighted then
		quad = 2
	end
	
	love.graphics.drawq(wallindicatorimg, wallindicatorquad[quad], math.floor((self.x-1-xscroll)*16*scale), ((self.y-yscroll-1)*16-8)*scale, 0, scale, scale)
end

function wallindicator:input(t, input)
	if input == "power" then
		if t == "on" and self.input1state == "off" then
			self.lighted = not self.lighted
		elseif t == "off" and self.input1state == "on" then
			self.lighted = not self.lighted
		elseif t == "toggle" then
			self.lighted = not self.lighted
		end
		
		self.input1state = t
	end
end