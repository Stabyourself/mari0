local thisthread = love.thread.getThread()

require("love.filesystem")
require("love.sound")
require("love.audio")
require("love.timer")

local musicpath = "sounds/%s.ogg"

local musiclist = {}
local musictoload = {} -- waiting to be loaded into memory

local function parsemusiclist(musicliststr)
	-- the music string should have names separated by the ";" character
	-- music will be loaded in in the same order as they appear in the string
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
	local filename = (name:match("%.mp3$") or name:match("%.ogg$")) and name or musicpath:format(name) -- mp3 or ogg
	if love.filesystem.exists(filename) and love.filesystem.isFile(filename) then
		return filename
	else
		print(string.format("thread can't load %q: can't find file!", filename))
	end
end

local function loadmusic()
	if #musictoload > 0 then
		local name = table.remove(musictoload, 1)
		local filename = getfilename(name)
		if filename then
			local source = love.audio.newSource(love.sound.newDecoder(filename, 512 * 1024), "static")
			--print("thread loaded music", name)
			thisthread:set(name, source)
		end
		return true
	end
end

while true do
	if not loadmusic() then
		local musicliststr = thisthread:demand("musiclist")
		if type(musicliststr) == "string" then
			parsemusiclist(musicliststr)
		elseif type(musicliststr) == "number" then
			break -- main thread is telling us it needs to quit, so we exit the loop
		end
	end
end
