require("love.filesystem")
require("love.sound")
require("love.audio")
require("love.timer")
require("musicloader")

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

local function loadmusic()
	if #musictoload > 0 then
		local name = table.remove(musictoload, 1)
		local source = loadsong(name)
		love.thread.getChannel(name):push(source)
	end
end

while true do
	getmusiclist()
	loadmusic()
	love.timer.sleep(1/60)
end
