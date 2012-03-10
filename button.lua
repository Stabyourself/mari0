button = class:new()

function button:init(x, y)
	self.cox = x
	self.coy = y
	
	--PHYSICS STUFF
	self.x = x-15/16
	self.y = y-3/16
	self.width = 30/16
	self.height = 3/16
	self.static = true
	self.active = false
	self.category = 22
	
	self.mask = {true}
	
	self.drawable = false
	
	self.out = false
	self.outtable = {}
end

function button:update(dt)
	local colls = checkrect(self.x+5/16, self.y-2/16, 20/16, 1, {"player", "goomba", "koopa", "box"})
	
	if (#colls > 0) ~= self.out then
		self.out = not self.out
		for i = 1, #self.outtable do
			if self.outtable[i].input then
				if self.out then
					self.outtable[i]:input("on")
				else
					self.outtable[i]:input("off")
				end
			end
		end
	end
end

function button:draw()
	local ymod = 0
	if self.out then
		ymod = 1
	end
	
	love.graphics.draw(buttonbuttonimg, math.floor((self.x+5/16-xscroll)*16*scale), (self.y*16-10+ymod)*scale, 0, scale, scale)
	
	love.graphics.draw(buttonbaseimg, math.floor((self.x-1/16-xscroll)*16*scale), (self.y*16-8)*scale, 0, scale, scale)
end

function button:addoutput(a)
	table.insert(self.outtable, a)
end