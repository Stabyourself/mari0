enemyspawner = class:new()

function enemyspawner:init(x, y, r)
	self.x = x
	self.y = y
	self.cox = x
	self.coy = y
	self.r = {unpack(r)}
	self.xspeed = 0
	self.yspeed = 0
	self.enemytospawn = "goomba"
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	--ENEMY NAME
	if #self.r > 0 and self.r[1] ~= "link" then
		self.enemytospawn = self.r[1]
		table.remove(self.r, 1)
	end
	
	--Xspeed
	if #self.r > 0 then
		if string.sub(self.r[1], 1, 1) == "m" then
			self.xspeed = -tonumber(string.sub(self.r[1], 2))
		else
			self.xspeed = tonumber(self.r[1])
		end
		table.remove(self.r, 1)
	end
	
	--Yspeed
	if #self.r > 0 then
		if string.sub(self.r[1], 1, 1) == "m" then
			self.yspeed = -tonumber(string.sub(self.r[1], 2))
		else
			self.yspeed = tonumber(self.r[1])
		end
		table.remove(self.r, 1)
	end
end

function enemyspawner:link()
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

function enemyspawner:input(t, input)
	if t ~= "off" then
		if enemiesdata[self.enemytospawn] then
			local temp = enemy:new(self.cox, self.coy, self.enemytospawn, {map[self.cox][self.coy][1], self.enemytospawn})
			table.insert(objects["enemy"], temp)
			temp.speedx = self.xspeed
			temp.speedy = self.yspeed
		end
	end
end