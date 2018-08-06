local function FindNextPO2(x)
	return 2 ^ math.ceil(math.log(x)/math.log(2))
end


shaders = {}
shaders.effects = {}

local function CreateShaderPass()
	local pass = {
		cureffect = "",
		on = false,
		xres = love.graphics.getWidth(),
		yres = love.graphics.getHeight(),
	}

	function pass:useCanvas()
		local po2xr = shaders.xres
		local po2yr = shaders.yres
		local c = self.canvas_npo2

		if not c or c.canvas:getWidth() ~= po2xr or c.canvas:getHeight() ~= po2yr then
			c = {}
			local status, canvas = pcall(love.graphics.newCanvas, po2xr, po2yr)
			if status then
				canvas:setFilter("nearest", "nearest")
				c.canvas = canvas
				c.quad = love.graphics.newQuad(0, 0, shaders.xres, shaders.yres, po2xr, po2yr)
			else
				-- error or something?
				print(string.format("shader error: could not create canvas for %s", self.cureffect or "?"))
				self.on = false
				return
			end
			self.canvas_npo2 = c
		elseif self.xres ~= shaders.xres or self.yres ~= shaders.yres then
			c.quad = love.graphics.newQuad(0, 0, shaders.xres, shaders.yres, po2xr, po2yr)
		end

		self.xres, self.yres = shaders.xres, shaders.yres

		self.defs = {
			["textureSize"] = {po2xr/scale, po2yr/scale},
			-- ["textureSizeReal"] = {po2xr, po2yr},
			["inputSize"] = {shaders.xres/scale, shaders.yres/scale},
			["outputSize"] = {shaders.xres, shaders.yres},
			["time"] = love.timer.getTime()
		}

		self.canvas = c
	end

	function pass:predraw()
		if self.on and self.canvas then
			love.graphics.setCanvas(self.canvas.canvas)
			love.graphics.clear(love.graphics.getBackgroundColor())
			return self.canvas.canvas
		end
	end

	function pass:postdraw()
		local effect = shaders.effects[self.cureffect]
		if self.on and self.cureffect and effect and self.canvas then
			for def in pairs(effect[3]) do
				if self.defs[def] then
					if def == "time" then
						self.defs[def] = love.timer.getTime()
					end
					effect[1]:send(def, self.defs[def])
				end
			end
			if effect.supported == nil then
				effect.supported = pcall(love.graphics.setShader, effect[1])
				if not effect.supported then
					print(string.format("Error setting shader: %s!", self.cureffect))
				end
			elseif effect.supported then
				love.graphics.setShader(effect[1])
			else
				love.graphics.setShader()
			end
			love.graphics.draw(self.canvas.canvas, self.canvas.quad, 0, 0)
		end
	end

	return pass
end


shaders.passes = {}


-- call at the end of love.load
-- numpasses is the max number of concurrent shaders (default 2)
function shaders:init(numpasses)
	numpasses = numpasses or 2

	local files = love.filesystem.getDirectoryItems("shaders")

	for i,v in ipairs(files) do
		local filename, filetype = v:match("(.+)%.(.-)$")
		if filetype == "frag" then
			local name = "shaders".."/"..v
			if love.filesystem.getInfo(name).type == "file" then
				local str = love.filesystem.read(name)
				local success, effect = pcall(love.graphics.newShader, str)
				if success then
					local defs = {}
					for vtype, extern in str:gmatch("extern (%w+) (%w+)") do
						defs[extern] = true
					end
					self.effects[filename] = {effect, str, defs}
				else
					print(string.format("shader (%s) is fucked up, yo:\n", filename), effect)
				end
			end
		end
	end

	for i=1, numpasses do
		self.passes[i] = CreateShaderPass()
	end

	self:refresh()
end



-- call when setting shader for first time and when changing shaders
-- i is the index (1 or 2, unless you specify a different number of max passes on init)
-- pass nil as the second argument to disable that shader pass
-- don't call before shaders:init()
function shaders:set(i, shadername)
	i = i or 1
	local pass = self.passes[i]
	if not pass then return end

	if shadername == nil or not self.effects[shadername] then
		pass.on = false
		pass.cureffect = nil
	else
		pass.on = true
		pass.cureffect = shadername
		pass:useCanvas()
		print(string.format("post-processing shader selected for pass %d: %s", i, shadername))
	end
end


-- for tweaking some of the 'extern' parameters in the shaders
-- returns true if it worked, false with an error message otherwise
function shaders:setParameter(shadername, paramname, ...)
	if self.effects[shadername] then
		local effect = self.effects[shadername][1]
		return pcall(effect.send, effect, paramname, ...)
	end
end


-- automatically called on init
-- should also be called when resolution changes or fullscreen is toggled
function shaders:refresh()
	if not self.scale or self.scale ~= scale
	or not self.xres or not self.yres
	or self.xres ~= love.graphics.getWidth() or self.yres ~= love.graphics.getHeight() then
		self.scale = scale

		self.xres, self.yres = love.graphics.getWidth(), love.graphics.getHeight()
		self.po2xres, self.po2yres = FindNextPO2(self.xres), FindNextPO2(self.yres)

		for i,v in ipairs(self.passes) do
			self:set(i, v.cureffect)
		end
	end

	collectgarbage("collect")
end


-- call in love.draw before drawing whatever you want post-processed
-- note: don't change shaders in between predraw and postdraw!
function shaders:predraw()
	-- only predraw the first available pass here (we'll do the rest in postdraw)
	self.curcanvas = nil
	for i,v in ipairs(self.passes) do
		local canvas = v:predraw()
		if canvas then
			self.curcanvas = {canvas=canvas, index=i}
			break
		end
	end
end


-- call in love.draw after drawing whatever you want post-processed
function shaders:postdraw()
	if not self.curcanvas then return end

	local blendmode, alphamode = love.graphics.getBlendMode()
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setColor(1, 1, 1)

	local activepasses = {}

	for i = self.curcanvas.index, #self.passes do
		local pass = self.passes[i]
		if pass.on and pass.canvas then
			table.insert(activepasses, pass)
		end
	end

	for i,v in ipairs(activepasses) do
		if i < #activepasses then
			activepasses[i+1]:predraw()
		else
			love.graphics.setCanvas()
		end
		v:postdraw()
	end

	love.graphics.setBlendMode(blendmode, alphamode)
	love.graphics.setShader()
end
