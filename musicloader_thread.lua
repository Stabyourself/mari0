require("love.filesystem")
require("love.sound")
require("love.audio")
require("love.timer")

love.filesystem.setIdentity("mari0")

local musicpath = "sounds/%s.ogg"

local musiclist = {}
local musictoload = {} -- waiting to be loaded into memory

local function getmusiclist()
	-- the music string should have names separated by the ";" character
	-- music will be loaded in in the same order as they appear in the string
	local musicliststr = love.thread.getChannel("musiclist"):pop()
	if musicliststr then
		for musicname in musicliststr:gmatch("[^;]+") do
			if not musiclist[musicname] then
				musiclist[musicname] = true
				table.insert(musictoload, musicname)
			end
		end
	end
end

local function getfilename(name)
	local filename = name:match("%.[mo][pg][3g]$") and name or musicpath:format(name) -- mp3 or ogg
	if love.filesystem.getInfo(filename).type == "file" then
		return filename
	else
		print(string.format("thread can't load \"%s\": not a file!", filename))
	end
end

local function loadmusic()
	if #musictoload > 0 then
		local name = table.remove(musictoload, 1)
		local filename = getfilename(name)
		if filename then
			local source = love.audio.newSource(love.sound.newDecoder(filename, 512 * 1024), "static")
			--print("thread loaded music", name)
			love.thread.getChannel(name):push(source)
		end
	end
end

while true do
	getmusiclist()
	loadmusic()
	love.timer.sleep(1/60)
end
