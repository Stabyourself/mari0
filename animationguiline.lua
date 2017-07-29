animationguiline = class:new()

animationlist = {}
local toenter = {}

--TRIGGERS:

table.insert(toenter, {name = "mapload",
	t = {
		t="trigger",
		nicename="on map load",
		entries={
			
		}
	}
})

table.insert(toenter, {name = "animationtrigger",
	t = {
		t="trigger",
		nicename="animation trigger",
		entries={
			{
				t="text",
				value="with id",
			},
			
			{
				t="input",
				default="animation id",
			},
		}
	}
})

table.insert(toenter, {name = "timepassed",
	t = {
		t="trigger",
		nicename="after seconds:",
		entries={
			{
				t="numinput"
			},
		}
	}
})

table.insert(toenter, {name = "playerxgreater",
	t = {
		t="trigger",
		nicename="player's x position >",
		entries={
			{
				t="numinput"
			},
		}
	}
})

table.insert(toenter, {name = "playerxless",
	t = {
		t="trigger",
		nicename="player's x position <",
		entries={
			{
				t="numinput"
			},
		}
	}
})



--CONDITIONS:

table.insert(toenter, {name = "noprevsublevel", 
	t = {
		t="condition",
		nicename="map started here",
		entries={
			
		}
	}
})

table.insert(toenter, {name = "worldequals", 
	t = {
		t="condition",
		nicename="world is number",
		entries={
			{
				t="worldselection",
			}
		}
	}
})

table.insert(toenter, {name = "levelequals", 
	t = {
		t="condition",
		nicename="level is number",
		entries={
			{
				t="levelselection",
			}
		}
	}
})

table.insert(toenter, {name = "sublevelequals",
	t= {
		t="condition",
		nicename="sublevel is number",
		entries={
			{
				t="sublevelselection",
			}
		}
	}
})

--ACTIONS:

table.insert(toenter, {name = "disablecontrols", 
	t = {
		t="action",
		nicename="disable controls",
		entries={
			{
				t="text",
				value="of"
			},
			
			{
				t="playerselection",
			},
		}
	}
})

table.insert(toenter, {name = "enablecontrols", 
	t = {
		t="action",
		nicename="enable controls",
		entries={
			{
				t="text",
				value="of"
			},
			
			{
				t="playerselection",
			},
		}
	}
})

table.insert(toenter, {name = "sleep", 
	t = {
		t="action",
		nicename="sleep/wait",
		entries={
			{
				t="numinput",
				default="1",
			},
			
			{
				t="text",
				value="seconds",
			},
		}
	}
})

table.insert(toenter, {name = "setcamerax", 
	t = {
		t="action",
		nicename="set camera to x:",
		entries={
			{
				t="numinput",
			},
		}
	}
})

table.insert(toenter, {name = "setcameray", 
	t = {
		t="action",
		nicename="set camera to y:",
		entries={		
			{
				t="numinput",
			},
		}
	}
})

table.insert(toenter, {name = "pancameratox", 
	t = {
		t="action",
		nicename="pan camera to x:",
		entries={
			{
				t="numinput",
			},
			
			{
				t="text",
				value="over",
			},
			
			{
				t="numinput",
			},
			
			{
				t="text",
				value="seconds",
			}
		}
	}
})

table.insert(toenter, {name = "pancameratoy", 
	t = {
		t="action",
		nicename="pan camera to y:",
		entries={
			{
				t="numinput",
			},
			
			{
				t="text",
				value="over",
			},
			
			{
				t="numinput",
			},
			
			{
				t="text",
				value="seconds",
			}
		}
	}
})

table.insert(toenter, {name = "disablescroll", 
	t = {
		t="action",
		nicename="disable scrolling",
		entries={
		
		}
	}
})

table.insert(toenter, {name = "enablescroll", 
	t = {
		t="action",
		nicename="enable scrolling",
		entries={
		
		}
	}
})

table.insert(toenter, {name = "setx", 
	t = {
		t="action",
		nicename="move player to x:",
		entries={
			{
				t="playerselection"
			},
			
			{
				t="text",
				value="to x=",
			},
			
			{
				t="numinput"
			}
		}
	}
})

table.insert(toenter, {name = "sety", 
	t = {
		t="action",
		nicename="move player to y:",
		entries={
			{
				t="playerselection"
			},
			
			{
				t="text",
				value="to y=",
			},
			
			{
				t="numinput"
			}
		}
	}
})

table.insert(toenter, {name = "playerwalk", 
	t = {
		t="action",
		nicename="animate to walk:",
		entries={
			{
				t="playerselection",
			},
			
			{
				t="text",
				value="towards"
			},
			
			{
				t="directionselection",
			}
		}
	}
})

table.insert(toenter, {name = "playeranimationstop", 
	t = {
		t="action",
		nicename="stop playeranimations:",
		entries={
			{
				t="playerselection",
			}
		}
	}
})

table.insert(toenter, {name = "disableanimation", 
	t = {
		t="action",
		nicename="disable this anim",
		entries={
			
		}
	}
})

table.insert(toenter, {name = "enableanimation", 
	t = {
		t="action",
		nicename="enable this anim",
		entries={
			
		}
	}
})

table.insert(toenter, {name = "playerjump", 
	t = {
		t="action",
		nicename="make jump:",
		entries={
			{
				t="playerselection",
			}
		}
	}
})

table.insert(toenter, {name = "playerstopjump", 
	t = {
		t="action",
		nicename="stop jumping:",
		entries={
			{
				t="playerselection",
			}
		}
	}
})

table.insert(toenter, {name = "dialogbox", 
	t = {
		t="action",
		nicename="create dialog",
		entries={
			{
				t="text",
				value="with text"
			},
			
			{
				t="input"
			},
			
			{
				t="text",
				value="and speaker"
			},
			
			{
				t="input"
			},
		}
	}
})

table.insert(toenter, {name = "removedialogbox", 
	t = {
		t="action",
		nicename="destroy dialogs",
		entries={
			
		}
	}
})

table.insert(toenter, {name = "playmusic", 
	t = {
		t="action",
		nicename="play music",
		entries={
			{
				t="musicselection"
			}
		}
	}
})

table.insert(toenter, {name = "screenshake", 
	t = {
		t="action",
		nicename="shake the screen",
		entries={
			{
				t="text",
				value="with"
			},
			
			{
				t="numinput",
			},
			
			{
				t="text",
				value="force",
			}
		}
	}
})

local typelist = {"trigger", "condition", "action"}

local animationstrings = {}

for i = 1, #typelist do
	animationstrings[typelist[i] ] = {}
end

for i, v in pairs(toenter) do
	animationlist[v.name] = v.t
	table.insert(animationstrings[v.t.t], v.t.nicename)
end

function animationguiline:init(tabl, t2)
	self.t = tabl
	self.type = t2
	
	local x = 0
	self.elements = {}
	self.elements[1] = {}
	local start = 1
	for i = 1, #animationstrings[self.type] do
		if animationlist[self.t[1]] and animationlist[self.t[1]].nicename == animationstrings[self.type][i] then
			start = i
		end
	end
	local firstwidth = 22--#animationstrings[self.type][start]
	
	self.deletebutton = guielement:new("button", 0, 0, "x", function() self:delete() end, nil, nil, nil, 8, 0.1)
	self.deletebutton.textcolor = {200, 0, 0}
	
	self.downbutton = guielement:new("button", 0, 0, "_dir6", function() self:movedown() end, nil, nil, nil, 8, 0.1)
	self.downbutton.textcolor = {255, 255, 255}
	
	self.upbutton = guielement:new("button", 0, 0, "_dir4", function() self:moveup() end, nil, nil, nil, 8, 0.1)
	self.upbutton.textcolor = {255, 255, 255}
	
	self.elements[1].gui = guielement:new("dropdown", 0, 0, firstwidth, function(val) self:changemainthing(val) end, start, unpack(animationstrings[self.type]))
	self.elements[1].width = 14+firstwidth*8
	
	if not self.t[1] then
		for i, v in pairs(animationlist) do
			if v.nicename == animationstrings[self.type][1] then
				self.t[1] = i
				break
			end
		end
	end
	
	local tid = 1
	if animationlist[self.t[1] ] then
		for i, v in ipairs(animationlist[self.t[1] ].entries) do
			local temp = {}
			
			if v.t == "text" then
				temp.t = "text"
				temp.value = v.value
				temp.width = #v.value*8
			else
				tid = tid + 1
				
				local dropdown = false
				local dropwidth
				local args
				
				if v.t == "input" then
					local width = 15
					local maxwidth = 30
					temp.gui = guielement:new("input", 0, 0, width, function() end, self.t[tid] or "", maxwidth, nil, nil, 0)
					temp.width = 4+width*8
					
				elseif v.t == "numinput" then
					local width = 5
					local maxwidth = 10
					temp.gui = guielement:new("input", 0, 0, width, function() end, self.t[tid] or "0", maxwidth, nil, true, 0)
					temp.width = 4+width*8
					
				elseif v.t == "playerselection" then
					dropdown = true
					dropwidth = 8
					args = {"everyone", "player 1", "player 2", "player 3", "player 4"}
					
				elseif v.t == "worldselection" then
					dropdown = true
					dropwidth = 1
					args = {"1", "2", "3", "4", "5", "6", "7", "8"}
					
				elseif v.t == "levelselection" then
					dropdown = true
					dropwidth = 1
					args = {"1", "2", "3", "4"}
					
				elseif v.t == "sublevelselection" then
					dropdown = true
					dropwidth = 4
					args = {"main", "1", "2", "3", "4", "5"}
					
				elseif v.t == "directionselection" then
					dropdown = true
					dropwidth = 5
					args = {"right", "left"}
					
				elseif v.t == "musicselection" then
					dropdown = true
					dropwidth = 15
					args = {unpack(musiclist)}
					
				end
				
				if dropdown then
					local j = #self.elements+1
					local starti = 1
					for j, k in pairs(args) do
						if self.t[tid] == k then
							starti = j
						end
					end
					
					temp.gui = guielement:new("dropdown", 0, 0, dropwidth, function(val) self:submenuchange(val, j) end, starti, unpack(args))
					temp.width = dropwidth*8+14
				end
			end
			
			table.insert(self.elements, temp)
		end
	end
end

function animationguiline:update(dt)
	for i = 1, #self.elements do
		if self.elements[i].gui then
			self.elements[i].gui:update(dt)
		end
	end
	self.downbutton:update(dt)
	self.upbutton:update(dt)
end

function animationguiline:draw(x, y)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", x*scale, y*scale, (width*16-x)*scale, 11*scale)
	love.graphics.setColor(255, 255, 255)
	
	local xadd = 0
	self.deletebutton.x = x+xadd
	self.deletebutton.y = y
	self.deletebutton:draw()
	xadd = xadd + 10
	
	self.downbutton.x = x+xadd
	self.downbutton.y = y
	self.downbutton:draw()
	xadd = xadd + 10
	
	self.upbutton.x = x+xadd
	self.upbutton.y = y
	self.upbutton:draw()
	xadd = xadd + 12
	
	for i = 1, #self.elements do
		if self.elements[i].t == "text" then
			love.graphics.setColor(255, 255, 255)
			properprint(self.elements[i].value, (x+xadd-1)*scale, (y+2)*scale)
			xadd = xadd + self.elements[i].width
		else
			if not self.elements[i].gui.extended then
				self.elements[i].gui.x = x+xadd
				self.elements[i].gui.y = y
			end
			xadd = xadd + self.elements[i].width
		end
	end
end

function animationguiline:click(x, y, button)
	if self.deletebutton:click(x, y, button) then
		return true
	end
	
	if self.downbutton:click(x, y, button) then
		return true
	end
	
	if self.upbutton:click(x, y, button) then
		return true
	end
	
	local rettrue
	
	local i = 1
	while i <= #self.elements do
		if self.elements[i].gui then
			if self.elements[i].gui:click(x, y, button) then
				rettrue = true
			end
		end
		i = i + 1
	end
	
	return rettrue
end

function animationguiline:unclick(x, y, button)
	self.downbutton:unclick(x, y, button)
	self.upbutton:unclick(x, y, button)
end

function animationguiline:delete()
	deleteanimationguiline(self.type, self)
end

function animationguiline:moveup()
	moveupanimationguiline(self.type, self)
end

function animationguiline:movedown()
	movedownanimationguiline(self.type, self)
end

function animationguiline:keypressed(key, unicode)
	for i = 1, #self.elements do
		if self.elements[i].gui then
			self.elements[i].gui:keypress(key, unicode)
		end
	end
end

function animationguiline:changemainthing(value)
	local name
	for i, v in pairs(animationlist) do
		if v.nicename == animationstrings[self.type][value] then
			name = i
		end
	end
	self:init({name}, self.type)
end

function animationguiline:submenuchange(value, id)
	self.elements[id].gui.var = value
end

function animationguiline:haspriority()
	for i, v in pairs(self.elements) do
		if v.gui then
			if v.gui.priority then
				return true
			end
		end
	end
	
	return false
end