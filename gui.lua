guielement = class:new()

function guielement:init(...)
	local arg = {...}
	self.active = true
	self.priority = false
	if arg[1] == "checkbox" then --checkbox(x, y, func, start)
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.func = arg[4]
		if arg[5] or arg[5] == false then
			self.var = arg[5]
		else
			self.var = true
		end
	elseif arg[1] == "dropdown" then --dropdown(x, y, width (in chars), func, start, {entries})
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.width = arg[4]
		self.func = arg[5]
		self.var = arg[6] or 1
		self.entries = {}
		for i = 7, #arg do
			table.insert(self.entries, arg[i])
		end
		self.extended = false
	elseif arg[1] == "rightclick" then --rightclick(x, y, width (in chars), func, start, {entries})
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.width = arg[4]
		self.func = arg[5]
		self.var = arg[6] or nil
		self.entries = {}
		for i = 7, #arg do
			table.insert(self.entries, arg[i])
		end
		self.priority = true
		
		if self.y > 112 then
			self.direction = "up"
		else
			self.direction = "down"
		end
	elseif arg[1] == "button" then --button(x, y, text, func, space, arguments (in a table), height (in lines))
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.text = arg[4]
		self.func = arg[5]
		self.space = arg[6]
		if type(arg[7]) ~= "table" then
			self.arguments = {}
		else
			self.arguments = arg[7]
		end
		self.height = arg[8] or 1
		self.width = arg[9] or string.len(self.text)*8
		
		self.bordercolorhigh = {255, 255, 255}
		self.bordercolor = {127, 127, 127}
		
		self.fillcolor = {0, 0, 0}
		self.textcolor = {255, 255, 255}
	elseif arg[1] == "scrollbar" then --scrollbar(x, y, yrange, width, height, start)
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.range = arg[4]
		self.width = arg[5]
		self.height = arg[6]
		self.value = arg[7] or 0
		self.dir = arg[8] or "ver"
		
		if self.dir == "ver" then
			self.yrange = self.range - self.height
		else
			self.xrange = self.range - self.width
		end	
		
		self.backgroundcolor = {127, 127, 127}
		self.bordercolorhigh = {255, 255, 255}
		self.bordercolor = {127, 127, 127}
		
		self.fillcolor = {0, 0, 0}
	elseif arg[1] == "input" then --input(x, y, width, enterfunc, start, maxlength)
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.width = arg[4]
		self.func = arg[5]
		self.value = arg[6] or ""
		self.maxlength = arg[7] or 0
		self.height = arg[8] or 1
		
		self.timer = 0
		self.cursorblink = true
		self.inputting = false
		self.cursorpos = string.len(self.value)+1
		self.offset = 0
		
		self.bordercolorhigh = {255, 255, 255}
		self.bordercolor = {127, 127, 127}
		
		self.fillcolor = {0, 0, 0}
		self.textcolor = {255, 255, 255}
	end
end

function guielement:update(dt)
	if self.active then
		if self.type == "scrollbar" then
			if self.dragging then
				if self.dir == "ver" then
					local y = (love.mouse.getY()-self.draggingy) - self.y*scale
					local actualyrange = self.yrange*scale
					
					self.value = y / actualyrange
					self.value = math.min(math.max(self.value, 0), 1) --clamp
				else
					local x = (love.mouse.getX()-self.draggingx) - self.x*scale
					local actualxrange = self.xrange*scale
					
					self.value = x / actualxrange
					self.value = math.min(math.max(self.value, 0), 1) --clamp
				end
			end
		elseif self.type == "input" then
			self.timer = self.timer + dt
			while self.timer > blinktime do
				self.cursorblink = not self.cursorblink
				self.timer = self.timer - blinktime
			end
		end
	end
end

function guielement:draw()
	love.graphics.setColor(255, 255, 255)
	if self.type == "checkbox" then
		local quad = 1
		if self.var == true then
			quad = 2
		end
		local high = 1
		if self:inhighlight(love.mouse.getPosition()) then
			high = 2
		end
		
		love.graphics.drawq(checkboximg, checkboxquad[high][quad], self.x*scale, self.y*scale, 0, scale, scale)
	elseif self.type == "dropdown" then
		local high = self:inhighlight(love.mouse.getPosition())
	
		love.graphics.setColor(127, 127, 127)
		if high then
			love.graphics.setColor(255, 255, 255)
		end
		
		love.graphics.rectangle("fill", self.x*scale, self.y*scale, (3+self.width*8)*scale, 11*scale)
		love.graphics.draw(dropdownarrowimg, (self.x+2+self.width*8)*scale, self.y*scale, 0, scale, scale)
		
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1)*scale, (1+self.width*8)*scale, 9*scale)
		
		love.graphics.setColor(255, 255, 255)
		if self.extended then
			love.graphics.setColor(127, 127, 127)
		end
			
		properprint(self.entries[self.var], (self.x+1)*scale, (self.y+2)*scale)
	
		if self.extended then
			love.graphics.setColor(127, 127, 127)
			if high then
				love.graphics.setColor(255, 255, 255)
			end
			
			love.graphics.rectangle("fill", self.x*scale, (self.y+11)*scale, (13+self.width*8)*scale, (10*#self.entries)*scale)
			
			for i = 1, #self.entries do
				if high ~= i then
					love.graphics.setColor(0, 0, 0)
					love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1+i*10)*scale, (11+self.width*8)*scale, 9*scale)
					love.graphics.setColor(255, 255, 255)
					properprint(self.entries[i], (self.x+1)*scale, (self.y+2+10*i)*scale)
				else
					love.graphics.setColor(0, 0, 0)
					properprint(self.entries[i], (self.x+1)*scale, (self.y+2+10*i)*scale)
				end
			end
			
		end
	elseif self.type == "rightclick" then
		local high = self:inhighlight(love.mouse.getPosition())
	
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.rectangle("fill", self.x*scale, self.y*scale, (3+self.width*8)*scale, 11*scale)
		
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1)*scale, (1+self.width*8)*scale, 9*scale)
		
		love.graphics.setColor(255, 255, 255)
			
		properprint(self.entries[1], (self.x+1)*scale, (self.y+2)*scale)
	
		love.graphics.setColor(127, 127, 127)
		if high then
			love.graphics.setColor(255, 255, 255)
		end
		
		if self.direction == "down" then
			love.graphics.rectangle("fill", self.x*scale, (self.y+11)*scale, (3+self.width*8)*scale, (10*(#self.entries-1))*scale)
		else
			love.graphics.rectangle("fill", self.x*scale, (self.y+10-(#self.entries)*10)*scale, (3+self.width*8)*scale, (10*(#self.entries-1))*scale)
		end
		
		for i = 2, #self.entries do
			if high ~= i then
				if self.var == self.entries[i] then
					love.graphics.setColor(0, 127, 0)
				else
					love.graphics.setColor(0, 0, 0)
				end
				if self.direction == "down" then
					love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1+(i-1)*10)*scale, (1+self.width*8)*scale, 9*scale)
					love.graphics.setColor(255, 255, 255)
					properprint(self.entries[i], (self.x+1)*scale, (self.y+2+10*(i-1))*scale)
				else
					love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1-(i-1)*10)*scale, (1+self.width*8)*scale, 9*scale)
					love.graphics.setColor(255, 255, 255)
					properprint(self.entries[i], (self.x+1)*scale, (self.y+2-10*(i-1))*scale)
				end
			else
				if self.var == self.entries[i] then
					love.graphics.setColor(0, 127, 0)
				else
					love.graphics.setColor(0, 0, 0)
				end
				
				if self.direction == "down" then
					properprint(self.entries[i], (self.x+1)*scale, (self.y+2+10*(i-1))*scale)
				else
					properprint(self.entries[i], (self.x+1)*scale, (self.y+2-10*(i-1))*scale)
				end
			end
		end
			
	elseif self.type == "button" then
		local high = self:inhighlight(love.mouse.getPosition())
	
		love.graphics.setColor(self.bordercolor)
		if high then
			love.graphics.setColor(self.bordercolorhigh)
		end
		
		love.graphics.rectangle("fill", self.x*scale, self.y*scale, (3+self.width+self.space*2)*scale, (1+self.height*10+self.space*2)*scale)
		
		love.graphics.setColor(self.fillcolor)
		love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1)*scale, (1+self.width+self.space*2)*scale, (-1+self.height*10+self.space*2)*scale)
		
		love.graphics.setColor(self.textcolor)
		properprint(self.text, (self.x+1+self.space)*scale, (self.y+2+self.space)*scale)
		
	elseif self.type == "scrollbar" then
		if self.dir == "ver" then
			local high = self:inhighlight(love.mouse.getPosition())
			
			love.graphics.setColor(self.backgroundcolor)
			love.graphics.rectangle("fill", self.x*scale, self.y*scale, self.width*scale, (self.yrange+self.height)*scale)
		
			love.graphics.setColor(self.bordercolor)
			if self.dragging or high then
				love.graphics.setColor(self.bordercolorhigh)
			end
			
			love.graphics.rectangle("fill", self.x*scale, (self.y+self.yrange*self.value)*scale, (self.width)*scale, (self.height)*scale)
			
			love.graphics.setColor(self.fillcolor)
			love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1+self.yrange*self.value)*scale, (self.width-2)*scale, (self.height-2)*scale)
		else
			local high = self:inhighlight(love.mouse.getPosition())
			
			love.graphics.setColor(self.backgroundcolor)
			love.graphics.rectangle("fill", self.x*scale, self.y*scale, (self.xrange+self.width)*scale, self.height*scale)
		
			love.graphics.setColor(self.bordercolor)
			if self.dragging or high then
				love.graphics.setColor(self.bordercolorhigh)
			end
			
			love.graphics.rectangle("fill", (self.x+self.xrange*self.value)*scale, self.y*scale, (self.width)*scale, (self.height)*scale)
			
			love.graphics.setColor(self.fillcolor)
			love.graphics.rectangle("fill", (self.x+1+self.xrange*self.value)*scale, (self.y+1)*scale, (self.width-2)*scale, (self.height-2)*scale)
		end
	elseif self.type == "input" then
		local high = self:inhighlight(love.mouse.getPosition())
	
		love.graphics.setColor(self.bordercolor)
		if self.inputting or high then
			love.graphics.setColor(self.bordercolorhigh)
		end
		
		love.graphics.rectangle("fill", self.x*scale, self.y*scale, (3+self.width*8+2)*scale, (1+self.height*10+2)*scale)
		
		love.graphics.setColor(self.fillcolor)
		love.graphics.rectangle("fill", (self.x+1)*scale, (self.y+1)*scale, (1+self.width*8+2)*scale, (-1+self.height*10+2)*scale)
		
		love.graphics.setColor(self.textcolor)
		--format string
		local oldstring = self.value--string.sub(self.value, self.offset+1, self.offset+self.width)
		local newstring = {}
		for i = 1, string.len(oldstring), self.width do
			if math.ceil(i/self.width) > self.height then
				break
			end
			table.insert(newstring, string.sub(oldstring, i, i+self.width-1))
		end
		
		for i = 1, #newstring do
			properprint(newstring[i], (self.x+2)*scale, (self.y+2+1+(i-1)*10)*scale)
		end
		
		--cursor
		if self.height == 1 then
			if self.inputting and self.cursorblink then
				love.graphics.rectangle("fill", (self.x+2+(self.cursorpos-1-self.offset)*8)*scale, (self.y+10)*scale, 8*scale, 1*scale)
			end
		end
	end
	love.graphics.setColor(255, 255, 255)
end

function guielement:click(x, y, button)
	if self.active then
		if self.type == "checkbox" then
			if self:inhighlight(x, y) then
				self.func()
			end
		elseif self.type == "dropdown" then
			if self.extended == false then
				if self:inhighlight(x, y) then
					self.extended = true
					self.priority = true
				end
			else
				local high = self:inhighlight(x, y)
				self.extended = false
				self.priority = false
				
				if high then
					if high ~= 0 then
						self.func(high)
					end
					return true
				end
			end
		elseif self.type == "rightclick" then
			local high = self:inhighlight(x, y)
			
			if high then
				if high ~= 0 then
					self.func(high)
				end
				return true
			end
		elseif self.type == "button" then
			if self:inhighlight(x, y) and self.func then
				self.func(unpack(self.arguments))
			end
		elseif self.type == "scrollbar" then
			if self.dir == "ver" then
				if self:inhighlight(x, y) then
					self.dragging = true
					self.draggingy = y-(self.y+self.yrange*self.value)*scale
				end
			else
				if self:inhighlight(x, y) then
					self.dragging = true
					self.draggingx = x-(self.x+self.xrange*self.value)*scale
				end
			end
			if button == "wd" then
				self.value = math.min(1, self.value+0.2)
			elseif button == "wu" then
				self.value = math.max(0, self.value-0.2)
			end
		elseif self.type == "input" then
			if self:inhighlight(x, y) then
				self.inputting = true
				self.timer = 0
				self.cursorblink = true
			else
				self.inputting = false
			end
		end
	end
end

function guielement:keypress(key)
	if self.active then
		if self.type == "input" then
			if self.inputting then
				if key == "-" or key == "," or key == ":" or key == ";" then
					return
				end
				if key == "escape" then
					self.inputting = false
				elseif (key == "return" or key == "enter" or key == "kpenter") then
					if self.func then
						self:func()
					else
						self.inputting = false
					end
				elseif key == "backspace" then
					self.value = string.sub(self.value, 1, string.len(self.value)-1)
					if self.cursorpos > 1 and self.cursorpos > string.len(self.value)+1 then
						self.cursorpos = self.cursorpos - 1
					end
					if self.offset > 0 and self.offset > string.len(self.value)-self.width then
						self.offset = self.offset - 1
					end
				else
					if string.len(self.value) < self.maxlength or self.maxlength == 0 then
						local found = false
						for i = 1, string.len(fontglyphs) do
							if key == string.sub(fontglyphs, i, i) then
								found = true
								break
							end
						end
						
						if found then
							self.value = self.value .. key
							if self.cursorpos ~= self.maxlength then
								self.cursorpos = self.cursorpos + 1
							end
							if self.cursorpos > self.offset+self.width then
								self.offset = self.offset + 1
							end
						end
					end
				end
				
				return true
			end
		end
	end
end

function guielement:unclick(x, y)
	if self.active then
		if self.type == "scrollbar" then
			self.dragging = false
		end
	end
end

function guielement:inhighlight(x, y)
	if self.type == "checkbox" then
		if x >= self.x*scale and x < (self.x+9)*scale and y >= self.y*scale and y < (self.y+9)*scale then
			return true
		end
	elseif self.type == "dropdown" then
		if self.extended == false then
			if x >= self.x*scale and x < (self.x+13+self.width*8)*scale and y >= self.y*scale and y < (self.y+11)*scale then
				return true
			end
		else			
			if x >= self.x*scale and x < (self.x+13+self.width*8)*scale and y >= self.y*scale and y < (self.y+10*#self.entries+11)*scale then
				--get which entry
				return math.max(0, math.floor((y-(self.y+1)*scale) / (10*scale)))
			end
		end
	elseif self.type == "rightclick" then
		if self.direction == "down" then
			if x >= self.x*scale and x < (self.x+3+self.width*8)*scale and y >= self.y*scale and y < (self.y+10*#self.entries+1)*scale then
				--get which entry
				return math.max(0, math.floor((y-(self.y+1)*scale) / (10*scale))+1)
			end
		else
			if x >= self.x*scale and x < (self.x+3+self.width*8)*scale and y >= (self.y-10*(#self.entries-1))*scale and y < (self.y+11)*scale then
				--get which entry
				return math.max(0, math.floor((self.y*scale-y) / (10*scale))+2)
			end
		end
	elseif self.type == "button" then
		if x >= self.x*scale and x < (self.x+3+self.width+self.space*2)*scale and y >= self.y*scale and y < (self.y+1+self.height*10+self.space*2)*scale then
			return true
		end
	elseif self.type == "scrollbar" then
		if self.dir == "ver" then
			if x >= self.x*scale and x < (self.x+self.width)*scale and y >= (self.y+self.yrange*self.value)*scale and y < (self.height+self.y+self.yrange*self.value)*scale then
				return true
			end
		else
			if x >= (self.x+self.xrange*self.value)*scale and x < (self.x+self.width+self.xrange*self.value)*scale and y >= self.y*scale and y < (self.height+self.y)*scale then
				return true
			end
		end
	elseif self.type == "input" then
		if x >= self.x*scale and x < (self.x+3+self.width*8+2)*scale and y >= self.y*scale and y < (self.y+1+self.height*10+2)*scale then
			return true
		end
	end
	
	return false
end