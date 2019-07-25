rightclickmenu = class:new()

rightclickwidth = 110
rightclickcellheight = 9
rightclickcellspacing = 2

rightclickelementslist = {"scrollbar", "input", "checkbox", "directionbuttons", "submenu", "regionselect"}

function rightclickmenu:init(x, y, elements, tx, ty)
	self.elements = elements
	self.x = x
	self.y = y
	
	self.tx = tx
	self.ty = ty
	
	--keep menu in window
	if self.x + rightclickwidth > width*16 then
		self.x = width*16 - rightclickwidth
	end
	
	if self.y + ((rightclickcellheight+rightclickcellspacing)*#self.elements+1) > height*16 then
		self.y = height*16 - ((rightclickcellheight+rightclickcellspacing)*#self.elements+1)
	end
	
	self.t = {}
	self.variables = {}
	local actuali = 1
	for i = 1, #self.elements do
		local v = self.elements[i]
		local set = false
		local variablesadd = {}
		if v.t == "text" then
			table.insert(self.t, guielement:new(v.t, self.x, self.y+2+(rightclickcellheight+rightclickcellspacing)*(i-1), v.value))
			table.insert(self.variables, v)
			
		elseif v.t == "button" then
			table.insert(self.t, guielement:new(v.t, self.x, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), v.value, nil, nil, nil, nil, rightclickwidth-3))
			table.insert(self.variables, v)
			
		elseif v.t == "linkbutton" then
			table.insert(self.t, guielement:new("button", self.x, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), v.value, rightclickmenu.linkcallback, nil, {nil, self, v.link, false}, nil, rightclickwidth-14))
			table.insert(self.t, guielement:new("button", self.x+rightclickwidth-11, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), "x", rightclickmenu.linkcallback, nil, {nil, self, v.link, true}, nil, 8))
			self.t[#self.t].textcolor = {200, 0, 0}
			table.insert(self.variables, v)
			
		elseif v.t == "regionselect" then
			table.insert(self.t, guielement:new("button", self.x, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), v.value, rightclickmenu.regioncallback, nil, {nil, self, v.region}, nil, rightclickwidth-3))
			table.insert(self.variables, v)
			
		elseif v.t == "scrollbar" then
			table.insert(self.t, guielement:new(v.t, self.x+1, self.y+1+(rightclickcellheight+rightclickcellspacing)*(i-1), rightclickwidth-2, 33, rightclickcellheight, map[tx][ty][actuali+2], "hor", true, v.func))
			set = true
			self.t[#self.t].backgroundcolor = {0, 0, 0, 255}
			
		elseif v.t == "input" then
			local default = v.default
			if map[tx][ty][actuali+2] then
				default = map[tx][ty][actuali+2]
			end
			table.insert(self.t, guielement:new(v.t, self.x, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), rightclickwidth/8-5/8, nil, default, v.max))
			set = true
			
		elseif v.t == "checkbox" then
			local start = false
			if map[tx][ty][actuali+2] == "true" then
				start = true
			end
			table.insert(self.t, guielement:new(v.t, self.x+1, self.y+1+(rightclickcellheight+rightclickcellspacing)*(i-1), nil, start, v.text))
			set = true
			
		elseif v.t == "directionbuttons" then
			local j = 0
			local add = {}
			
			for k = 1, 6 do
				local dir
				if k == 1 then
					dir = "hor"
				elseif k == 2 then
					dir = "ver"
				elseif k == 3 then
					dir = "left"
				elseif k == 4 then
					dir = "up"
				elseif k == 5 then
					dir = "right"
				elseif k == 6 then
					dir = "down"
				end
				
				if v[dir] then
					table.insert(add, guielement:new("button", self.x+j*12, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), "_dir" .. k, rightclickmenu.directioncallback, nil, {nil, self, #self.t+1, dir}, nil, rightclickcellheight-1))
					j = j + 1
					
					if map[tx][ty][actuali+2] == dir then
						add[#add].bordercolor = {255, 0, 0}
						add[#add].bordercolorhigh = {255, 127, 127}
						
						
						variablesadd["value"] = dir
					end				
				end
			end
			
			table.insert(self.t, add)
			set = true
			
		elseif v.t == "submenu" then
			table.insert(self.t, guielement:new(v.t, self.x+1, self.y+(rightclickcellheight+rightclickcellspacing)*(i-1), 11, v.width or 6, v.entries, map[tx][ty][actuali+2]))
			set = true
			
		end
		
		if set then
			actuali = actuali + 1
			table.insert(self.variables, v)
			
			for j, k in pairs(variablesadd) do
				self.variables[#self.variables][j] = k
			end
		end
			
		
		self.t[#self.t].active = true
	end
end

function rightclickmenu:update(dt)
	for i = 1, #self.t do
		if type(self.t[i][1]) == "table" then
			for j = 1, #self.t[i] do
				self.t[i][j]:update(dt)
			end
		else
			self.t[i]:update(dt)
		end
	end
end

function rightclickmenu:draw()
	love.graphics.setColor(50, 50, 50, 180*rightclicka)
	--background
	love.graphics.rectangle("fill", self.x*scale, self.y*scale, rightclickwidth*scale, ((rightclickcellheight+rightclickcellspacing)*#self.elements+1)*scale)
	
	for i, v in pairs(self.t) do
		if type(self.t[i][1]) == "table" then
			for j = 1, #self.t[i] do
				self.t[i][j]:draw(rightclicka*255)
			end
		else
			self.t[i]:draw(rightclicka*255)
		end
	end
end

function rightclickmenu:mousepressed(x, y, button)
	local r = false
	for i = 1, #self.t do
		if type(self.t[i][1]) == "table" then
			for j = 1, #self.t[i] do
				if self.t[i][j]:click(x, y, button) then
					r = true
				end
			end
		else
			if self.t[i]:click(x, y, button) then
				r = true
			end
		end
	end
	
	if r then
		return true
	end
	
	if x < self.x*scale or x >= (self.x+rightclickwidth)*scale or y < self.y*scale or y > (self.y+(rightclickcellheight+rightclickcellspacing)*#self.elements+1)*scale then
		return false
	end
	
	return true
end

function rightclickmenu:mousereleased(x, y, button)
	for i = 1, #self.t do
		if type(self.t[i][1]) == "table" then
			for j = 1, #self.t[i] do
				self.t[i][j]:unclick(x, y, button)
			end
		else
			self.t[i]:unclick(x, y, button)
		end
	end
end

function rightclickmenu:keypressed(key, unicode)
	for i = 1, #self.t do
		if self.t[i].type then
			if unicode <= 255 and self.t[i]:keypress(string.lower(string.char(unicode)), key) then
				return
			end
		end
	end
end

function rightclickmenu:linkcallback(self, t, rem)
	if rem then
		removelink(self.tx, self.ty, t)
	else
		startlinking(self.tx, self.ty, t)
	end
end

function rightclickmenu:regioncallback(self, t)
	startregion(self.tx, self.ty, t)
end

function rightclickmenu:directioncallback(self, y, x)
	for i = 1, #self.t[y] do
		self.t[y][i].bordercolor = {127, 127, 127}
		self.t[y][i].bordercolorhigh = {255, 255, 255}
	end
	
	for i = 1, #self.t[y] do
		if self.t[y][i].arguments[4] == x then
			self.t[y][i].bordercolor = {255, 0, 0}
			self.t[y][i].bordercolorhigh = {255, 127, 127}
			break
		end
	end
	
	self.variables[y].value = x
end