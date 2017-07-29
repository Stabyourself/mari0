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
		if not arg[5] or arg[5] == false then
			self.var = false
		else
			self.var = true
		end
		self.text = arg[6]
	elseif arg[1] == "dropdown" then --dropdown(x, y, width (in chars), func, start, {entries})
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.starty = self.y
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
	elseif arg[1] == "button" then --button(x, y, text, func, space, arguments (in a table), height (in lines), width, autorepeat)
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.text = arg[4]
		self.func = arg[5]
		self.space = arg[6] or 0
		if type(arg[7]) ~= "table" then
			self.arguments = {}
		else
			self.arguments = arg[7]
		end
		self.height = arg[8] or 1
		self.width = arg[9] or string.len(self.text)*8
		self.autorepeat = arg[10] or false
		
		self.repeatwait = 0.3
		self.repeatdelay = arg[10] or 0.05
		if arg[10] == true then
			self.repeatdelay = 0.05
		end
		
		self.repeatwaittimer = self.repeatwait
		self.repeatdelaytimer = self.repeatdelay
		
		self.bordercolorhigh = {255, 255, 255}
		self.bordercolor = {127, 127, 127}
		
		self.fillcolor = {0, 0, 0}
		self.textcolor = {255, 255, 255}
	elseif arg[1] == "scrollbar" then --scrollbar(x, y, range, width, height, default, dir, display, min, max, step, mousewheel)
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.range = arg[4]
		self.width = arg[5]
		self.height = arg[6]
		self.value = tonumber(arg[7]) or 0
		self.dir = arg[8] or "ver"
		self.displaynumber = arg[9] or false
		self.min = tonumber(arg[10]) or 0
		self.max = tonumber(arg[11]) or 1
		self.step = tonumber(arg[12]) or 0.01
		self.usemousewheel = arg[13] or false
		
		self.internvalue = (self.value-self.min)/(self.max-self.min)
		
		if self.dir == "ver" then
			self.yrange = self.range - self.height
		else
			self.xrange = self.range - self.width
		end	
		
		self.backgroundcolor = {127, 127, 127}
		self.bordercolorhigh = {255, 255, 255}
		self.bordercolor = {127, 127, 127}
		
		self.fillcolor = {0, 0, 0}
	elseif arg[1] == "input" then --input(x, y, width, enterfunc, start, maxlength, height, numerical, spacing)
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.width = arg[4]
		self.func = arg[5]
		self.value = arg[6] or ""
		self.maxlength = arg[7] or 0
		self.height = arg[8] or 1
		self.numerical = arg[9] or false
		self.spacing = arg[10] or 1
		
		self.timer = 0
		self.cursorblink = true
		self.inputting = false
		self.cursorpos = string.len(self.value)+1
		self.offset = 0
		if self.height == 1 then
			if self.cursorpos > math.ceil(self.width) then
				if self.cursorpos == math.ceil(self.width)+1 or #self.value ~= self.width then
					self.offset = self.cursorpos-math.ceil(self.width)-1
				else
					self.offset = self.cursorpos-math.ceil(self.width)
				end
			end
		end
		
		self.bordercolorhigh = {255, 255, 255}
		self.bordercolor = {127, 127, 127}
		
		self.fillcolor = {0, 0, 0}
		self.textcolor = {255, 255, 255}
	elseif arg[1] == "text" then
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.value = arg[4] or ""
		self.color = arg[5] or {255, 255, 255}
	elseif arg[1] == "submenu" then
		self.type = arg[1]
		self.x = arg[2]
		self.y = arg[3]
		self.width = arg[4]
		self.width2 = arg[5]
		self.entries = arg[6]
		self.value = arg[7] or 1
		
		self.suby = self.y
		self.subx = self.x
		
		if self.y+(#self.entries*10) > height*16 then
			if (#self.entries)*10 > height*16 then
				self.missingy = (#self.entries)*10 - height*16
				self.suby = 0
			else
				self.suby = height*16-(#self.entries)*10
			end
		end
		
		if self.x+12+self.width*8+self.width2*8 > width*16 then
			self.subx = self.x - (self.width+1)*8 - self.width2*8 - 3
		end
		
		self.extended = false
	end
end

function guielement:update(dt)
	if self.active then
		if self.type == "scrollbar" then
			if self.dragging then
				if self.dir == "ver" then
					local y = (mouse.getY()-self.draggingy) - self.y*scale
					local actualyrange = self.yrange*scale
					
					self.internvalue = y / actualyrange
					self.internvalue = math.min(math.max(self.internvalue, 0), 1) --clamp
				else
					local x = (mouse.getX()-self.draggingx) - self.x*scale
					local actualxrange = self.xrange*scale
					
					self.internvalue = x / actualxrange
					self.internvalue = math.min(math.max(self.internvalue, 0), 1) --clamp
				end
				
				--Apply the step
				self.value = round((self.min + (self.max-self.min)*self.internvalue)/self.step)*self.step
			end
		elseif self.type == "input" then
			self.timer = self.timer + dt
			while self.timer > blinktime do
				self.cursorblink = not self.cursorblink
				self.timer = self.timer - blinktime
			end
		elseif self.type == "button" then
			if self.autorepeat then
				if self.holding then
					if self.repeatwaittimer <= 0 then
						self.repeatdelaytimer = self.repeatdelaytimer - dt
						while self.repeatdelaytimer <= 0 do
							if self.func then
								self.func(unpack(self.arguments))
							end
							self.repeatdelaytimer = self.repeatdelaytimer + self.repeatdelay
						end
					else
						self.repeatwaittimer = self.repeatwaittimer - dt
					end
				else
					self.repeatwaittimer = self.repeatwait
					self.repeatdelaytimer = self.repeatdelay
				end
			end
		elseif self.type == "dropdown" then
			if self.scrollbar then
				self.scrollbar:update(dt)
				
				self.y = -self.missingy*self.scrollbar.value
			end
		elseif self.type == "submenu" then
			if self.scrollbar then
				self.scrollbar:update(dt)
				
				self.suby = -self.missingy*self.scrollbar.value
			end
		end
	end
end

function guielement:draw(a, offx, offy)
	local drawx = self.x + (offx or 0)
	local drawy = self.y + (offy or 0)
	
	love.graphics.setColor(255, 255, 255, a)
	if self.type == "checkbox" then
		local quad = 1
		if self.var == true then
			quad = 2
		end
		local high = 1
		if self:inhighlight(mouse.getPosition()) then
			high = 2
		end
		
		love.graphics.drawq(checkboximg, checkboxquad[high][quad], drawx*scale, drawy*scale, 0, scale, scale)
		
		if self.text then
			properprint(self.text, (drawx+10)*scale, (drawy+1)*scale)
		end
	elseif self.type == "dropdown" then
		local high = self:inhighlight(mouse.getPosition()) or (self.scrollbar and self.scrollbar.dragging)
		
		if self.extended then
			love.graphics.setColor(127, 127, 127, a)
			love.graphics.rectangle("fill", (drawx+2)*scale, (drawy+2)*scale, (13+self.width*8)*scale, (10*(#self.entries+1))*scale+2)
		end
		
		love.graphics.setColor(127, 127, 127, a)
		if high then
			love.graphics.setColor(255, 255, 255, a)
		end
		
		love.graphics.rectangle("fill", drawx*scale, drawy*scale, (3+self.width*8)*scale, 11*scale)
		love.graphics.draw(dropdownarrowimg, (drawx+2+self.width*8)*scale, drawy*scale, 0, scale, scale)
		
		love.graphics.setColor(0, 0, 0, a)
		love.graphics.rectangle("fill", (drawx+1)*scale, (drawy+1)*scale, (1+self.width*8)*scale, 9*scale)
		
		love.graphics.setColor(255, 255, 255, a)
		if self.extended then
			love.graphics.setColor(127, 127, 127, a)
		end
		local s = self.entries[self.var]
		if self.cutoff then
			s = string.sub(s, 1, self.width)
		end
		
		properprint(s, (drawx+1)*scale, (drawy+2)*scale)
	
		if self.extended then
			love.graphics.setColor(127, 127, 127, a)
			if high then
				love.graphics.setColor(255, 255, 255, a)
			end
			
			love.graphics.rectangle("fill", drawx*scale, (drawy+11)*scale, (13+self.width*8)*scale, (10*#self.entries)*scale)
			
			for i = 1, #self.entries do
				local s = self.entries[i]
				if self.cutoff then
					s = string.sub(s, 1, self.width+1)
				end
				
				if high ~= i then
					love.graphics.setColor(0, 0, 0, a)
					love.graphics.rectangle("fill", (drawx+1)*scale, (drawy+1+i*10)*scale, (11+self.width*8)*scale, 9*scale)
					love.graphics.setColor(255, 255, 255, a)
					properprint(s, (drawx+1)*scale, (drawy+2+10*i)*scale)
				else
					love.graphics.setColor(0, 0, 0, a)
					properprint(s, (drawx+1)*scale, (drawy+2+10*i)*scale)
				end
			end
			
		end
		
		if self.scrollbar then
			self.scrollbar:draw(a)
		end
		
	elseif self.type == "button" then
		local high = self:inhighlight(mouse.getPosition())
		local r, g, b = unpack(self.bordercolor)
		love.graphics.setColor(r, g, b, a)
		if high then
			local r, g, b = unpack(self.bordercolorhigh)
			love.graphics.setColor(r, g, b, a)
		end
		
		love.graphics.rectangle("fill", drawx*scale, drawy*scale, (3+self.width+self.space*2)*scale, (1+self.height*10+self.space*2)*scale)
		
		local r, g, b = unpack(self.fillcolor)
		love.graphics.setColor(r, g, b, a)
		love.graphics.rectangle("fill", (drawx+1)*scale, (drawy+1)*scale, (1+self.width+self.space*2)*scale, (-1+self.height*10+self.space*2)*scale)
		
		local r, g, b = unpack(self.textcolor)
		love.graphics.setColor(r, g, b, a)
		properprint(self.text, (drawx+1+self.space)*scale, (drawy+2+self.space)*scale)
		
	elseif self.type == "scrollbar" then
		if self.dir == "ver" then
			local high = self:inhighlight(mouse.getPosition())
			
			local r, g, b = unpack(self.backgroundcolor)
			love.graphics.setColor(r, g, b, a)
			love.graphics.rectangle("fill", drawx*scale, drawy*scale, self.width*scale, (self.yrange+self.height)*scale)
		
			local r, g, b = unpack(self.bordercolor)
			love.graphics.setColor(r, g, b, a)
			if self.dragging or high then
			local r, g, b = unpack(self.bordercolorhigh)
			love.graphics.setColor(r, g, b, a)
			end
			
			love.graphics.rectangle("fill", drawx*scale, (drawy+self.yrange*self.internvalue)*scale, (self.width)*scale, (self.height)*scale)
			
			local r, g, b = unpack(self.fillcolor)
			love.graphics.setColor(r, g, b, a)
			love.graphics.rectangle("fill", (drawx+1)*scale, (drawy+1+self.yrange*self.internvalue)*scale, (self.width-2)*scale, (self.height-2)*scale)
		else
			local high = self:inhighlight(mouse.getPosition())
			
			local r, g, b = unpack(self.backgroundcolor)
			love.graphics.setColor(r, g, b, a)
			love.graphics.rectangle("fill", drawx*scale, drawy*scale, (self.xrange+self.width)*scale, self.height*scale)
		
			local r, g, b = unpack(self.bordercolor)
			love.graphics.setColor(r, g, b, a)
			if self.dragging or high then
				local r, g, b = unpack(self.bordercolorhigh)
				love.graphics.setColor(r, g, b, a)
			end
			
			love.graphics.rectangle("fill", (drawx+self.xrange*self.internvalue)*scale, drawy*scale, (self.width)*scale, (self.height)*scale)
			
			local r, g, b = unpack(self.fillcolor)
			love.graphics.setColor(r, g, b, a)
			love.graphics.rectangle("fill", (drawx+1+self.xrange*self.internvalue)*scale, (drawy+1)*scale, (self.width-2)*scale, (self.height-2)*scale)
			
			if self.displaynumber then
				love.graphics.setColor(255, 255, 255, a)
				properprint(formatscrollnumber(self.value), math.floor((drawx+self.xrange*self.internvalue)*scale), (drawy+1)*scale)
			end
		end
	elseif self.type == "input" then
		local high = self:inhighlight(mouse.getPosition())

		local r, g, b = unpack(self.bordercolor)
		love.graphics.setColor(r, g, b, a)
		if self.inputting or high then
			local r, g, b = unpack(self.bordercolorhigh)
			love.graphics.setColor(r, g, b, a)
		end
		
		love.graphics.rectangle("fill", drawx*scale, drawy*scale, (3+self.width*8+2*self.spacing)*scale, (1+self.height*10+2*self.spacing)*scale)
		
		local r, g, b = unpack(self.fillcolor)
		love.graphics.setColor(r, g, b, a)
		love.graphics.rectangle("fill", (drawx+1)*scale, (drawy+1)*scale, (1+self.width*8+2*self.spacing)*scale, (-1+self.height*10+2*self.spacing)*scale)
		
		local r, g, b = unpack(self.textcolor)
		love.graphics.setColor(r, g, b, a)
		--format string
		local oldstring = self.value
		if self.height == 1 then
			oldstring = string.sub(self.value, self.offset+1, self.offset+self.width)
		end
		local newstring = {}
		for i = 1, string.len(oldstring), self.width do
			if math.ceil(i/self.width) > self.height then
				break
			end
			table.insert(newstring, string.sub(oldstring, i, i+self.width-1))
		end
		
		for i = 1, #newstring do
			properprint(newstring[i], (drawx+1+self.spacing)*scale, (drawy+2+self.spacing+(i-1)*10)*scale)
		end
		
		--cursor
		if self.inputting and self.cursorblink then
			local x, y
			if #newstring == 0 then
				x, y = 1, 1
			else
				x, y = #newstring[#newstring]+1, #newstring
			end
			
			if x > self.width then
				if y < self.height and self.height > 1 then
					x = 1
					y = y + 1
				else
					x = x - 1
				end
			end
			
			love.graphics.rectangle("fill", (drawx+1+self.spacing+(x-1)*8)*scale, (drawy+9+self.spacing+(y-1)*10)*scale, 8*scale, 1*scale)
		end
	elseif self.type == "text" then
		local r, g, b = unpack(self.color)
		love.graphics.setColor(r, g, b, a)
		properprint(self.value, drawx*scale, drawy*scale)
		
	elseif self.type == "submenu" then
		local high = self:inhighlight(mouse.getPosition()) or (self.scrollbar and self.scrollbar.dragging)
	
		love.graphics.setColor(127, 127, 127, a)
		if high then
			love.graphics.setColor(255, 255, 255, a)
		end
		
		love.graphics.rectangle("fill", drawx*scale, drawy*scale, (3+self.width*8)*scale, 11*scale)
		
		love.graphics.setColor(0, 0, 0, a)
		love.graphics.rectangle("fill", (drawx+1)*scale, (drawy+1)*scale, (1+self.width*8)*scale, 9*scale)
		
		love.graphics.setColor(255, 255, 255, a)
		if self.extended then
			love.graphics.setColor(127, 127, 127, a)
		end
		
		properprint(string.sub(self.entries[self.value], 1, self.width), (drawx+1)*scale, (drawy+2)*scale)
	
		if self.extended then
			love.graphics.setColor(127, 127, 127, a)
			if high then
				love.graphics.setColor(255, 255, 255, a)
			end
			
			love.graphics.rectangle("fill", (self.subx+9+self.width*8)*scale, (self.suby)*scale, (3+self.width2*8)*scale, (10*#self.entries+1)*scale)
			
			for i = 1, #self.entries do
				if high ~= i then
					love.graphics.setColor(0, 0, 0, a)
					love.graphics.rectangle("fill", (self.subx+10+self.width*8)*scale, (self.suby+1+(i-1)*10)*scale, (1+self.width2*8)*scale, 9*scale)
					love.graphics.setColor(255, 255, 255, a)
					properprint(string.sub(self.entries[i], 1, self.width2), (self.subx+10+self.width*8)*scale, (self.suby+2+10*(i-1))*scale)
				else
					love.graphics.setColor(0, 0, 0, a)
					properprint(string.sub(self.entries[i], 1, self.width2), (self.subx+10+self.width*8)*scale, (self.suby+2+10*(i-1))*scale)
				end
			end
			
			if self.scrollbar then
				self.scrollbar:draw(a)
			end
		end
		
		love.graphics.setColor(127, 127, 127, a)
		if high then
			love.graphics.setColor(255, 255, 255, a)
		end
		love.graphics.draw(dropdownarrowimg, (drawx+5+self.width*8)*scale, (drawy+5)*scale, -math.pi/2, scale, scale, 6, 6)
	end
	love.graphics.setColor(255, 255, 255, a)
end

function guielement:getheight()
	if self.type == "dropdown" then
		return 11+10*#self.entries
	elseif self.type == "submenu" then
		
	end
end

function guielement:click(x, y, button)
	if self.active then
		if self.type == "checkbox" then
			if button == "l" then
				if self:inhighlight(x, y) then
					if not self.func then
						self.var = not self.var
					else
						self.func()
					end
				end
			end
		elseif self.type == "dropdown" then
			if self.scrollbar then
				self.scrollbar:click(x, y, button)
			end
			
			if button == "l" then
				if self.extended == false then
					if self:inhighlight(x, y) then
						self.extended = true
						self.priority = true
						if self.y+self:getheight() > height*16 then
							self.y = height*16-self:getheight()
						end
						
						if self:getheight() > height*16 then
							self.missingy = -self.y
							self.y = 0
							self.scrollbar = guielement:new("scrollbar", self.x-9, 0, height*16, 10, 30, 0, "ver", false, 0, 1, nil, true)
						end
					end
				else
					local high = self:inhighlight(x, y)
					if high == -1 then --scrollbar
						return
					end
					
					self.extended = false
					self.priority = false
					self.y = self.starty
					self.scrollbar = nil
					
					if high then
						if high ~= 0 then
							self.func(high)
						end
						return true
					end
				end
			end
		elseif self.type == "submenu" then
			if self.scrollbar then
				self.scrollbar:click(x, y, button)
			end
			
			if button == "l" then
				if self.extended == false then
					if self:inhighlight(x, y) then
						self.extended = true
						self.priority = true
						
						if self.missingy then
							self.scrollbar = guielement:new("scrollbar", self.subx-9+8+self.width*8, 0, height*16, 10, 30, 0, "ver", false, 0, 1, nil, true)
						end
					end
				else
					local high = self:inhighlight(x, y)
					if high == -1 then --scrollbar
						return true
					end
					
					self.extended = false
					self.priority = false
					
					if high and high ~= 0 then
						self.value = high
						return true
					end
					
					self.scrollbar = nil
				end
			elseif button == "wd" or button == "wu" then
				return true
			end
		elseif self.type == "rightclick" then --Not used anymore I think?
			if button == "l" then
				local high = self:inhighlight(x, y)
				
				if high then
					if high ~= 0 then
						self.func(high)
					end
					return true
				end
			end
		elseif self.type == "button" then
			if button == "l" then
				if self:inhighlight(x, y) then
					self.holding = true
					
					if self.func then
						self.func(unpack(self.arguments))
					end
					return true
				end
			end
		elseif self.type == "scrollbar" then
			if button == "l" then
				if self.dir == "ver" then
					if self:inhighlight(x, y) then
						self.dragging = true
						self.draggingy = y-(self.y+self.yrange*self.internvalue)*scale
					end
				else
					if self:inhighlight(x, y) then
						self.dragging = true
						self.draggingx = x-(self.x+self.xrange*self.internvalue)*scale
					end
				end
			elseif button == "wd" then
				if self.usemousewheel then
					self.internvalue = math.min(1, self.internvalue+0.2)
					self.value = round((self.min + (self.max-self.min)*self.internvalue)/self.step)*self.step
				end
			elseif button == "wu" then
				if self.usemousewheel then
					self.internvalue = math.max(0, self.internvalue-0.2)
					self.value = round((self.min + (self.max-self.min)*self.internvalue)/self.step)*self.step
				end
			end
		elseif self.type == "input" then
			if button == "l" then
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
end

function guielement:keypress(key, key2)
	if self.active then
		if self.type == "input" then
			if self.inputting then
				if key == "-" or key == "," or key == ":" or key == ";" then
					return
				end
				if key2 == "escape" then
					self.inputting = false
				elseif (key2 == "return" or key2 == "enter" or key2 == "kpenter") then
					if self.func then
						self:func()
					else
						self.inputting = false
					end
				elseif key2 == "backspace" then
					self.value = string.sub(self.value, 1, string.len(self.value)-1)
					if self.cursorpos > 1 and self.cursorpos > string.len(self.value)+1 then
						self.cursorpos = self.cursorpos - 1
					end
					if self.offset > 0 and self.offset > string.len(self.value)-self.width+1 then
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
						
						if found and (not self.numerical or tonumber(key) or key == "." or key == ",") then
							if key == "," then
								key = "."
							end
							
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

function guielement:unclick(x, y, button)
	if self.active then
		if self.type == "scrollbar" then
			self.dragging = false
		elseif self.type == "button" then
			self.holding = false
		elseif self.type == "dropdown" then
			if self.scrollbar then
				self.scrollbar:unclick(x, y, button)
			end
		elseif self.type == "submenu" then
			if self.scrollbar then
				self.scrollbar:unclick(x, y, button)
			end
		end
	end
end

function guielement:inhighlight(x, y)
	if self.type == "checkbox" then
		local xadd = 0
		if self.text then
			xadd = string.len(self.text)*8+1
		end
		if x >= self.x*scale and x < (self.x+9+xadd)*scale and y >= self.y*scale and y < (self.y+9)*scale then
			return true
		end
	elseif self.type == "dropdown" then
		if self.extended == false then
			if x >= self.x*scale and x < (self.x+13+self.width*8)*scale and y >= self.y*scale and y < (self.y+11)*scale then
				return true
			end
		else
			local myx, widthadd = self.x, 0
			if self.scrollbar then
				myx = self.x - self.scrollbar.width+1
				widthadd = self.scrollbar.width-1
			end
			
			if x >= myx*scale and x < (myx+13+self.width*8+widthadd)*scale and y >= self.y*scale and y < (self.y+10*#self.entries+11)*scale then
				if x < self.x*scale then
					return -1
				end
				--get which entry
				return math.max(0, math.floor((y-(self.y+1)*scale) / (10*scale)))
			end
		end
	elseif self.type == "submenu" then
		local r = false
		if x >= self.x*scale and x < (self.x+10+self.width*8)*scale and y >= self.y*scale and y < (self.y+11)*scale then
			r = 0
		end
		if self.extended then
			local subx = self.subx
			local widthadd = 0
			if self.scrollbar then
				subx = subx - self.scrollbar.width
				widthadd = self.scrollbar.width
			end
			
			if x >= (subx+9+self.width*8)*scale and x < (subx+12+self.width*8+self.width2*8+widthadd)*scale and y >= self.suby*scale and y < (self.suby+10*#self.entries+1)*scale then
			
				if x < (subx+9+self.width*8+widthadd)*scale then
					return -1
				end
			
				--get which entry
				if math.max(0, math.floor((y-(self.suby+1)*scale) / (10*scale)))+1 then
					r = math.max(0, math.floor((y-(self.suby+1)*scale) / (10*scale)))+1
				end
			end
		end
		
		return r
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
			if x >= self.x*scale and x < (self.x+self.width)*scale and y >= (self.y+self.yrange*self.internvalue)*scale and y < (self.height+self.y+self.yrange*self.internvalue)*scale then
				return true
			end
		else
			if x >= (self.x+self.xrange*self.internvalue)*scale and x < (self.x+self.width+self.xrange*self.internvalue)*scale and y >= self.y*scale and y < (self.height+self.y)*scale then
				return true
			end
		end
	elseif self.type == "input" then
		if x >= self.x*scale and x < (self.x+3+self.width*8+2*self.spacing)*scale and y >= self.y*scale and y < (self.y+1+self.height*10+2*self.spacing)*scale then
			return true
		end
	end
	
	return false
end