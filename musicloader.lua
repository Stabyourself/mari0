music = {
	thread = love.thread.newThread("musicthread", "musicloader_thread.lua"),
	toload = {
		"overworld",
		"overworld-fast",
		"underground",
		"underground-fast",
		"castle",
		"castle-fast",
		"underwater",
		"underwater-fast",
		"starmusic",
		"starmusic-fast",
		"princessmusic",
	},
	loaded = {},
	list = {},
	list_fast = {},
	pitch = 1,
}

music.stringlist = table.concat(music.toload, ";")

for i,v in ipairs(music.toload) do
	music.loaded[v] = false
	if v:match("fast") then
		table.insert(music.list_fast, v)
	elseif not v:match("princessmusic") then
		table.insert(music.list, v)
	end
end

function music:play(name)
	if name and soundenabled then
		if self.loaded[name] == false then
			local source = self.thread:demand(name)
			self:onLoad(name, source)
		end
		if self.loaded[name] then
			playsound(self.loaded[name])
		end
	end
end

function music:playIndex(index, isfast)
	local name = isfast and self.list_fast[index] or self.list[index]
	self:play(name)
end

function music:stop(name)
	if name and self.loaded[name] then
		love.audio.stop(self.loaded[name])
	end
end

function music:stopIndex(index, isfast)
	local name = isfast and self.list_fast[index] or self.list[index]
	self:stop(name)
end

function music:update()
	for i,v in ipairs(self.toload) do
		local source = self.thread:get(v)
		if source then
			self:onLoad(v, source)
		end
	end
	for name, source in pairs(self.loaded) do
		if source ~= false then
			source:setPitch(self.pitch)
		end
	end
end

function music:onLoad(name, source)
	self.loaded[name] = source
	source:setLooping(true)
	source:setPitch(self.pitch)
end


music.thread:start()
music.thread:set("musiclist", music.stringlist)

