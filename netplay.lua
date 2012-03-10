require "netplayinc/MiddleClass"
require "netplayinc/LUBE"
require "netplayinc/umsg"
require "server"
require "client"

motd = "No griefing, no TNT, minecraft servers suck."
chatmessages = {}
playerlist = {}
localnick = "Calamity"
ip = "127.0.0.1"
port = 4000
updatedelay = 0.02
messages = {}

SERVER = false
CLIENT = false
netplay = false

function netplay_update(dt)
	if SERVER then
		server_update(dt)
	elseif CLIENT then
		client_update(dt)
	end
end

function deserialize(str)
	output = str:split("~")
	return output
end

function serialize(str1,str2)
	return str1.."~"..str2
end

function message(s)
	print(os.date("%X", os.time()) .. " " .. s)
	table.insert(messages, os.date("%X", os.time()) .. " " .. s)
end