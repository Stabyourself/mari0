pedestal = class:new()

function pedestal:init(x, y, r)
	self.cox = x
	self.coy = y
	self.x = x-12/16
	self.y = y-1
	
	self.progress = 0
	self.pickedup = false
	
	self.blue = false
	self.orange = false
	
	self.r = {unpack(r)}
	
	if #r >= 4 then
		print(r[2])
		self.blue = r[3] == "true"
		self.orange = r[4] == "true"
	end
end

function pedestal:update(dt)
	if not self.pickedup then
		local col = checkrect(self.x, self.y, 8/16, 8/16, {"player"})
		
		if #col > 0 then
			for i = 2, #col, 2 do
				if self.blue then
					if not objects["player"][col[i]].portalsavailable[1] then
						self.pickedup = true
						objects["player"][col[i]]:portalpickup(1)
					end
				end
				
				if self.orange then
					if not objects["player"][col[i]].portalsavailable[2] then
						self.pickedup = true
						objects["player"][col[i]]:portalpickup(2)
					end
				end
			
				if self.pickedup then
					break
				end
			end
		end
	elseif self.progress < pedestaltime then
		self.progress = math.min(pedestaltime, self.progress + dt)
	end
end

function pedestal:draw()
	love.graphics.setColor(255, 255, 255)
	if self.pickedup then
		local prog = self.progress / pedestaltime
		love.graphics.setScissor(math.floor((self.cox-1-xscroll)*16*scale), math.floor((self.coy-1.5-yscroll)*16*scale)+14*prog*scale, 16*scale, (14*(1-prog)+2)*scale)
	end
	love.graphics.draw(pedestalbaseimg, math.floor((self.cox-1-xscroll)*16*scale), math.floor((self.coy-1.5-yscroll)*16*scale), 0, scale, scale)
	love.graphics.setScissor()
	
	if not self.pickedup then
		love.graphics.draw(pedestalgunimg, math.floor((self.cox-1-xscroll)*16*scale), math.floor((self.coy-1.5-yscroll)*16*scale), 0, scale, scale)
	
		if self.blue or self.orange then
			if self.blue then
				love.graphics.setColor(objects["player"][1].portal1color)
			elseif self.orange then
				love.graphics.setColor(objects["player"][1].portal2color)
			end
			love.graphics.rectangle("fill", math.floor((self.cox-1-xscroll+7/16)*16*scale), math.floor((self.coy-1.5-yscroll+2/16)*16*scale), scale, scale)
		end
	end
end