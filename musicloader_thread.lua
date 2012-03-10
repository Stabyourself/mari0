local this = love.thread.getThread()

require("love.filesystem")
require("love.sound")
require("love.audio")

love.filesystem.setIdentity("mari0")

local musicpath = "sounds/%s.ogg"

local musiclist = {}
local musictoload = {} -- waiting to be loaded into memory

local musiclist_str = this:demand("musiclist")

-- the music string should have names separated by the ";" character
-- music will be loaded in in the same order as they appear in the string
for musicname in musiclist_str:gmatch("[^;]+") do
	table.insert(musiclist, musicname)
	table.insert(musictoload, musicname)
end

while true do
	if #musictoload > 0 then
		local name = table.remove(musictoload, 1)
		local filename = musicpath:format(name)
		local source = love.audio.newSource(love.sound.newDecoder(filename, 512 * 1024), "static")
		-- print("thread loaded music", name)
		this:set(name, source)
	else
		-- if we loaded all music then we need to make sure to only finish if the main thread has received it
		local keep_waiting = false
		for i,v in ipairs(musiclist) do
			if this:peek(v) then
				keep_waiting = true
			end
		end
		if not keep_waiting then
			break
		end
	end
end
