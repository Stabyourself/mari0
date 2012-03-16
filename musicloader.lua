music = {
	thread = love.thread.newThread("musicthread", "musicloader_thread.lua"),
	toload = {},
	loaded = {},
	list = {},
	list_fast = {},
	pitch = 1,
}

music.stringlist = table.concat(music.toload, ";")

function music:init()
	self.thread:start()
end

function music:load(musicfile) -- can take a single file string or an array of file strings
	if type(musicfile) == "table" then
		for i,v in ipairs(musicfile) do
			self:preload(v)
		end
	else
		self:preload(musicfile)
	end
	self.stringlist = table.concat(self.toload, ";")
	self.thread:set("musiclist", self.stringlist)
end

function music:preload(musicfile)
	if self.loaded[musicfile] == nil then
		self.loaded[musicfile] = false
		table.insert(self.toload, musicfile)
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
	local err = self.thread:get("error") 
	if err then print(err) end
end

function music:onLoad(name, source)
	self.loaded[name] = source
	source:setLooping(true)
	source:setPitch(self.pitch)
end


music:load{
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
}

-- the original/default music needs to be put in the correct lists
for i,v in ipairs(music.toload) do
	if v:match("fast") then
		table.insert(music.list_fast, v)
	elseif not v:match("princessmusic") then
		table.insert(music.list, v)
	end
end

music:init()

