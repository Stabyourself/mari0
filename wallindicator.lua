wallindicator = class:new()

function wallindicator:init(x, y, r)
	self.x = x
	self.y = y
	self.r = r
	
	self.lighted = false
end

function wallindicator:link()
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

function wallindicator:update()

end

function wallindicator:draw()
	love.graphics.setColor(255, 255, 255)
	local quad = 1
	if self.lighted then
		quad = 2
	end
	
	love.graphics.drawq(wallindicatorimg, wallindicatorquad[quad], math.floor((self.x-1-xscroll)*16*scale), ((self.y-1)*16-8)*scale, 0, scale, scale)
end

function wallindicator:input(t)
	if t == "on" then
		self.lighted = true
	elseif t == "off" then
		self.lighted = false
	elseif t == "toggle" then
		self.lighted = not self.lighted
	end
end