music = {
	loaded = {},
	pitch = 1,
	list = {
		"overworld.ogg",
		"underground.ogg",
		"castle.ogg",
		"underwater.ogg",
		"starmusic.ogg",
	},
	list_fast = {
		"overworld-fast.ogg",
		"underground-fast.ogg",
		"castle-fast.ogg",
		"underwater-fast.ogg",
		"starmusic-fast.ogg",
	},
}


function getfilepath(name)
	local musicpaths = {"sounds/", "mappacks/" .. mappack .. "/music/"}
	
	for i = 1, #musicpaths do
		if love.filesystem.isFile(musicpaths[i] .. name) then
			return musicpaths[i] .. name
		end
	end
end

function music:load(name)
	local filepath = getfilepath(name)
	if not filepath then
		print(string.format("can't load music %q: can't find file!", name))
		return false
	end
	
	if not self.loaded[filepath] then
		local loaded, source = pcall(love.audio.newSource, filepath, "stream")
		if loaded then
			-- all music should loop
			source:setLooping(true)
			source:setPitch(self.pitch)
			self.loaded[name] = source
		else
			print(string.format("can't load music %q: can't create source!", filepath))
			return false
		end
	end
	
	return true
end

function music:play(name, fast)
	if fast then
		local newname = name:sub(0, -5) .. "-fast" .. name:sub(-4)
		if getfilepath(newname) then
			name = newname
		end
	end
	
	-- try to load source from disk if it hasn't been loaded already
	if not self.loaded[name] and not self:load(name) then
		return
	end
	
	if self.loaded[name] then
		if soundenabled then
			self.loaded[name]:stop()
			self.loaded[name]:rewind()
			self.loaded[name]:play()
		end
	end
end

function music:stop(name, fast)
	if fast then
		local newname = name:sub(0, -5) .. "-fast" .. name:sub(-4)
		if getfilepath(newname) then
			name = newname
		end
	end
	
	if self.loaded[name] then
		self.loaded[name]:stop()
	end
end

function music:update()
	for filepath, source in pairs(self.loaded) do
		source:setPitch(self.pitch)
	end
end
