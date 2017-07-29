quad = class:new()

--COLLIDE?
--INVISIBLE?
--BREAKABLE?
--COINBLOCK?
--COIN?
--_NOT_ PORTALABLE?
--LEFT SLANT?
--RIGHT SLANT?
--MIRROR?
--GRATE?
--PLATFORM TYPE?
--WATER TILE?
--BRIDGE?
--SPIKES?
--FOREGROUND?

function quad:init(img, imgdata, x, y, width, height)
	--get if empty?

	self.image = img
	self.quad = love.graphics.newQuad((x-1)*17, (y-1)*17, 16, 16, width, height)
	self.spikes = {}
	
	--get collision
	self.collision = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17)
	if a > 127 then
		self.collision = true
	end
	
	--get invisible
	self.invisible = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+1)
	if a > 127 then
		self.invisible = true
	end
	
	--get breakable
	self.breakable = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+2)
	if a > 127 then
		self.breakable = true
	end
	
	--get coinblock
	self.coinblock = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+3)
	if a > 127 then
		self.coinblock = true
	end
	
	--get coin
	self.coin = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+4)
	if a > 127 then
		self.coin = true
	end
	
	--get not portalable
	self.portalable = true
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+5)
	if a > 127 then
		self.portalable = false
	end
	
	--get left slant
	self.slantupleft = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+6)
	if a > 127 then
		self.slantupleft = true
	end
	
	--get right slant
	self.slantupright = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+7)
	if a > 127 then
		self.slantupright = true
	end
	
	--get mirror
	self.mirror = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+8)
	if a > 127 then
		self.mirror = true
	end
	
	--get grate
	self.grate = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+9)
	if a > 127 then
		self.grate = true
	end
	
	--get platformtype
	self.platform = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+10)
	if a > 127 then
		self.platform = true
	end
	
	--get watertile
	self.water = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+11)
	if a > 127 then
		self.water = true
	end
	
	--get bridge
	self.bridge = false
	local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+12)
	if a > 127 then
		self.bridge = true
	end
	
	--get spikes
	local t = {"left", "top", "right", "bottom"}
	for i = 1, #t do
		local v = t[i]
		self.spikes[v] = false
		local r, g, b, a = imgdata:getPixel(x*17-1, (y-1)*17+12+i)
		if a > 127 then
			self.spikes[v] = true
		end
	end
	
	--get foreground
	self.foreground = false
	local r, g, b, a = imgdata:getPixel(x*17-2, (y-1)*17+16)
	if a > 127 then
		self.foreground = true
	end
end