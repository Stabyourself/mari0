--[[
	Copyright © 2009-2010 BartBes <bart.bes+nospam@gmail.com>

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.



	The above license is the MIT/X11 license, check the license for
	information about distribution.

	Also used:
		-LÖVE (ZLIB license) Copyright (C) 2006-2009 LOVE Development Team
			LÖVE itself depends on:
			-Lua
			-OpenGL
			-SDL
			-SDL_mixer
			-FreeType
			-DevIL
			-PhysicsFS
			-Box2D
			-boost
			-SWIG
		-LuaSocket (MIT license) Copyright © 2004-2007 Diego Nehab. All rights reserved.
		-Lua (MIT license) Copyright © 1994-2008 Lua.org, PUC-Rio.
]]--

socket = require "socket"

lube = {}
lube.version = "0.7.1"

lube.bin = {}
lube.bin.null = string.char(30)
lube.bin.one = string.char(31)
lube.bin.defnull = lube.bin.null
lube.bin.defone = lube.bin.one

--- Set the seperators
-- This allows the user to nest tables, as the seperators won't conflict
-- @param null The first seperator character, if empty set to default
-- @param one The second seperator character, if empty set to default
function lube.bin:setseperators(null, one)
	null = null or self.defnull
	one = one or self.defone
	self.null = null
	self.one = one
end

--- Pack a table
-- Does what you'd expect
-- @param t Table to pack
function lube.bin:pack(t)
	local result = ""
	for i, v in pairs(t) do
		result = result .. self:packvalue(i, v)
	end
	return result
end

--- Pack a single value
-- Internal, do not use
-- @see lube.bin:pack
function lube.bin:packvalue(i, v)
	local id = ""
	local typev = type(v)
	if typev == "string" then id = "S"
	elseif typev == "number" then id = "N"
	elseif typev == "boolean" then id = "B"
	elseif typev == "userdata"  then id = "U"
	elseif typev == "nil" then id = "0"
	else error("Type " .. typev .. " is not supported by lube.bin") return
	end
	return tostring(id .. lube.bin.one .. i .. lube.bin.one .. tostring(v) .. lube.bin.null)
end

--- Unpack a string
-- Does the opposite of pack, table -> string
-- @param s The string, which is generally a result of lub.bin:pack
function lube.bin:unpack(s)
	local t = {}
	local i, v
	for s2 in string.gmatch(s, "[^" .. lube.bin.null .. "]+") do
		i, v = self:unpackvalue(s2)
		t[i] = v
	end
	return t
end

--- Unpack a single value
-- Internal, do not use
-- @see lube.bin:unpack
function lube.bin:unpackvalue(s)
	local id = s:sub(1, 1)
	s = s:sub(3)
	local len = s:find(lube.bin.one)
	local i = s:sub(1, len-1)
	i = tonumber(i) or i
	local v = s:sub(len+1)
	if id == "N" then v = tonumber(v)
	elseif id == "B" then v = (v == "true")
	elseif id == "0" then v = nil
	end
	return i, v
end

lube.client = {}
lube.client.udp = {}
lube.client.udp.protocol = "udp"
lube.client.tcp = {}
lube.client.tcp.protocol = "tcp"
lube.client.ping = {}
lube.client.ping.enabled = false
lube.client.ping.time = 0
lube.client.ping.msg = "ping"
lube.client.ping.queue = {}
lube.client.ping.dt = 0
local client_mt = {}

--- Creates a client object
-- @name lube.client
-- @param ... What to pass to Init
-- @see lube.client:Init
function client_mt:__call(...)
	local t = {}
	local mt = { __index = self }
	setmetatable(t, mt)
	t:Init(...)
	return t
end

setmetatable(lube.client, client_mt)

--- Initialize the client
-- Automatically called when creating a connection object
-- @param socktype Type of socket, tcp/udp/user-created, udp is default
function lube.client:Init(socktype)
	self.host = ""
	self.port = 0
	self.connected = false
	if socktype then
		if self[socktype] then
			self.socktype = socktype
		elseif love.filesystem.exists(socktype .. ".sock") then
			love.filesystem.require(socktype .. ".sock")
			self[socktype] = _G[socktype]
			self.socktype = socktype
		else
			self.socktype = "udp"
		end
	else
		self.socktype = "udp"
	end
	for i, v in pairs(self[self.socktype]) do
		self[i] = v
	end
	self.socket = socket[self.protocol]()
	self.socket:settimeout(0)
	self.callback = function(data) end
	self.handshake = ""
end

--- Set ping
-- Set the options for the ping
-- @see lube.client:doPing
-- @param enabled Is enabled (true/false)
-- @param time How many seconds between pings?
-- @param msg What is the ping package content (should be same between server and client, filtered)
function lube.client:setPing(enabled, time, msg)
	self.ping.enabled = enabled
	if enabled then self.ping.time = time; self.ping.msg = msg; self.ping.dt = time end
end

--- Set callback
-- @param cb A callback called on an incoming message
-- @see lube.server:setCallback
function lube.client:setCallback(cb)
	if cb then
		self.callback = cb
		return true
	else
		self.callback = function(data) end
		return false
	end
end

--- Set handshake
-- Handshake is a string to identify the opening and closing of the connection
-- @param hshake A handshake, shared by server and client
function lube.client:setHandshake(hshake)
	self.handshake = hshake
end

--- Connect to a server
-- @name lube.client:connect
-- @param dns Specify if the host is a name or an IP, if it's a hostname it should do a DNS lookup
function lube.client.udp:connect(host, port, dns)
	if dns then
		host = socket.dns.toip(host)
		assert(host, "Failed to do DNS lookup")
	end
	self.host = host
	self.port = port
	self.connected = true
	if self.handshake ~= "" then self:send(self.handshake) end
	return true
end

--- Disconnect from the server
-- @name lube.client:disconnect
function lube.client.udp:disconnect()
	if self.handshake ~= "" then self:send(self.handshake) end
	self.host = ""
	self.port = 0
	self.connected = false
end

--- Send data to the server
-- @name lube.client:send
function lube.client.udp:send(data)
	if not self.connected then return end
	return self.socket:sendto(data, self.host, self.port)
end

--- Receive data from the server
-- @name lube.client:receive
function lube.client.udp:receive()
	if not self.connected then return false, "Not connected" end
	local data, err = self.socket:receive()
	if err then
		return false, err
	end
	return true, data
end

function lube.client.tcp:connect(host, port, dns)
	if dns then
		host = socket.dns.toip(host)
		if not host then
			return false, "Failed to do DNS lookup"
		end
	end
	self.host = host
	self.port = port
	self.socket:settimeout(5)
	local result = self.socket:connect(self.host, self.port)
	self.socket:settimeout(0)
	if not result then return false end
	self.connected = true
	if self.handshake ~= "" then self:send(self.handshake) end
	return true
end

function lube.client.tcp:disconnect()
	if self.handshake ~= "" then self:send(self.handshake) end
	self.host = ""
	self.port = 0
	self.socket:shutdown()
	self.connected = false
end

function lube.client.tcp:send(data)
	if not self.connected then return end
	if data:sub(-1) ~= "\n" then data = data .. "\n" end
	return self.socket:send(data)
end

function lube.client.tcp:receive()
	if not self.connected then return false, "Not connected" end
	local data, err = self.socket:receive()
	if err then
		return false, err
	end
	return true, data
end

--- Do a ping (according to settings)
-- Does a ping whenever needed
-- @see lube.client:setPing
-- @param dt Delta time, as passed to update
function lube.client:doPing(dt)
	if not self.ping.enabled then return end
	self.ping.dt = self.ping.dt + dt
	if self.ping.dt >= self.ping.time then
		self:send(self.ping.msg)
		self.ping.dt = 0
	end
end

--- Search for new messages and call the appropriate callback
-- Also does ping, since 0.6
-- @param dt Delta-time, since 0.6
-- @see lube.client:setCallback
function lube.client:update(dt)
	if not self.connected then return end
	assert(dt, "LUBE: No dt passed to lube.client:update")
	self:doPing(dt)
	local success, data = self:receive()
	while success do
		self.callback(data)
		success, data = self:receive()
	end
end

--- Enable connecting to the broadcast address
function lube.client:enableBroadcast()
	return self.socket:setoption("broadcast", true)
end

--- Disable connecting to the broadcast address (warning: has direct effect, old connection terminated unclean)
function lube.client:disableBroadcast()
	return self.socket:setoption("broadcast", false)
end

lube.server = {}
lube.server.udp = {}
lube.server.udp.protocol = "udp"
lube.server.tcp = {}
lube.server.tcp.protocol = "tcp"
lube.server.ping = {}
lube.server.ping.enabled = false
lube.server.ping.time = 0
lube.server.ping.msg = "ping"
lube.server.ping.queue = {}
lube.server.ping.dt = 0
lube.server.s_discover = "SERVBROWSER_DISCOVER"
lube.server.s_identify = "SERVER_IDENTIFY"
lube.server.s_poll = "SERVBROWSER_POLL"
lube.server.s_info = "SERVER_INFO"
lube.server.s_mastercheck = "MASTERSERVER_CHECK"
lube.server.s_mastercheckpass = "MASTERSERVER_CHECKPASS"
local server_mt = {}

--- Creates a server object
-- @name lube.server
-- @param ... What to pass to Init
-- @see lube.server:Init
function server_mt:__call(...)
	local t = {}
	local mt = { __index = self }
	setmetatable(t, mt)
	t:Init(...)
	return t
end

setmetatable(lube.server, server_mt)

--- Initializes the server
-- @param port Which port to listen on
-- @param socktype Type of socket, can be udp/tcp/user-created, default is udp
function lube.server:Init(port, socktype)
	self.clients = {}

	if socktype then
		if self[socktype] then
			self.socktype = socktype
		elseif love.filesystem.exists(socktype .. ".sock") then
			love.filesystem.require(socktype .. ".sock")
			self[socktype] = _G[socktype]
			self.socktype = socktype
		else
			self.socktype = "udp"
		end
	else
		self.socktype = "udp"
	end
	for i, v in pairs(self[self.socktype]) do
		self[i] = v
	end
	self.socket = socket[self.protocol]()
	self.socket:settimeout(0)
	self.handshake = ""
	self.recvcallback = function(data, ip, port) end
	self.connectcallback = function(ip, port) end
	self.disconnectcallback = function(ip, port) end
	self:startserver(port)
end

--- Set ping
-- @see lube.client:setPing
function lube.server:setPing(enabled, time, msg)
	self.ping.enabled = enabled
	if enabled then self.ping.time = time; self.ping.msg = msg end
end

--- Receive data from clients
-- @name lube.server:receive
function lube.server.udp:receive()
	return self.socket:receivefrom()
end

--- Send data to clients
-- @name lube.server:send
-- @param rcpt Recipient, if nil then sends to all clients
function lube.server.udp:send(data, rcpt)
	if rcpt then
		if not self.clients[rcpt] then return nil end
		return self.socket:sendto(data, self.clients[rcpt][1], self.clients[rcpt][2])
	else
		local errors = 0
		for i, v in pairs(self.clients) do
			if not pcall(self.socket.sendto, self.socket, data, v[1], v[2]) then errors = errors + 1 end
		end
		return errors
	end
end

--- Start the server
-- Sets the server, is normally called by init
-- @see lube.server:Init
-- @name lube.server:startserver
function lube.server.udp:startserver(port)
	self.socket:setsockname("*", port)
end

function lube.server.tcp:receive()
	for i, v in pairs(self.clientsocks) do
		local data = v:receive()
		if data then return data, v:getpeername() end
	end
end

function lube.server.tcp:send(data, rcpt)
	if data:sub(-1) ~= "\n" then data = data .. "\n" end
	if rcpt then
		if not self.clientsocks[rcpt] then return nil end
		return self.clientsocks[rcpt]:send(data)
	else
		local errors = 0
		for i, v in pairs(self.clientsocks) do
			if not pcall(v.send, v, data) then errors = errors + 1 end
		end
		return errors
	end
end

function lube.server.tcp:startserver(port)
	self.clientsocks = {}
	self.socket:bind("*", port)
	self.socket:listen(5)
end


--- Accepts connecting clients (TCP only)
function lube.server.tcp:acceptAll()
	local client = self.socket:accept()
	if client then
		client:settimeout(0)
		table.insert(self.clientsocks, client)
	end
end

--- Sets a handshake
-- @see lube.client:setHandshake
-- @param hshake A unqiue string, shared by client and server to identify connecting and disconnecting users
function lube.server:setHandshake(hshake)
	self.handshake = hshake
end

--- Sets the callbacks
-- @param recv Callback called on incoming data (filtered): function(data, id)
-- @param connect Callback called when client connects: function(id)
-- @param disconnect Callback called when client disconnects (also called by ping): function(id)
function lube.server:setCallback(recv, connect, disconnect)
	if recv then
		self.recvcallback = recv
	else
		self.recvcallback = function(data, id) end
	end
	if connect then
		self.connectcallback = connect
	else
		self.connectcallback = function(id) end
	end
	if disconnect then
		self.disconnectcallback = disconnect
	else
		self.disconnectcallback = function(id) end
	end
	return (recv ~= nil), (connect ~= nil), (disconnect ~= nil)
end

--- Check for ping messages
-- If clients are timed out, disconnect them
-- @param dt Delta-time as passed to update
function lube.server:checkPing(dt)
	if not self.ping.enabled then return end
	self.ping.dt = self.ping.dt + dt
	if self.ping.dt >= self.ping.time then
		for i, v in pairs(self.ping.queue) do
			self.disconnectcallback(i)
			self.clients[i] = nil
		end
		self.ping.dt = 0
		self.ping.queue = {}
		for i, v in pairs(self.clients) do
			self.ping.queue[i] = true
		end
	end
end

--- Update the server
-- Checks for incoming messages, and classifies as ping, connect, disconnect and raw data
-- Also checks ping (since 0.6)
-- @param dt Delta-time
function lube.server:update(dt)
	assert(dt, "LUBE: No dt passed to lube.server:update")
	local data, ip, port = self:receive()
	while data do
		local index = 0
		for i, v in ipairs(self.clients) do
			if v[1] == ip and v[2] == port then
				index = i
				break
			end
		end
		self.ping.queue[index] = nil
		if data == self.handshake then
			if self.clients[index] then
				self.clients[index] = nil
				return self.disconnectcallback(index)
			else
				index = #self.clients+1
				table.insert(self.clients, index, {ip, port})
				return self.connectcallback(index)
			end
		elseif data == self.ping.msg then
			return
		elseif data == self.s_discover and self.sbrowser then
			self.conn:sendto(self.s_identify, ip, port)
			return
		elseif data == self.s_poll and self.sbrowser then
			self.conn:sendto(string.format(self.s_info .. ":%s:%s:", self.s_table.name or "UnnamedServer", self.s_table.version or "NoVersion"), ip, port)
			return
		elseif data == self.s_mastercheck and self.sbrowser then
			self.conn:sendto(self.s_mastercheckpass, ip, port)
			return
		end
		self.recvcallback(data, index)
		data, ip, port = self:receive()
	end
	self:checkPing(dt)
end

--- Sets if the server should respond to Server Browser requests
-- @param active Should the server respond
-- @param info A table containing the server name and version as named keys
function lube.server:respondToServBrowser(active, info)
	self.sbrowser = active
	self.s_table = info
end

lube.easy = {}
lube.easy.timer = 0
lube.easy.keycharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%*()`~-_=+[]{};:'\",<.>/?\\|"

--- Internal: Generate a key for 'secured' connections
function lube.easy.generateKey(keylength)
	math.randomseed(os.time())
	local key = ""
	for i = 1, keylength do
		local rand = math.random(#lube.easy.keycharset)
		key = key .. lube.easy.keycharset:sub(rand, rand)
	end
	return key
end

--- Internal: Set the converted table
function lube.easy:settable(data)
	local t = self.deserializer(data)
	for i, v in pairs(t) do
		self.table[i] = v
	end
end

--- Internal: Get the converted table
function lube.easy:gettable()
	return self.serializer(self.table)
end

--- Start a server
-- @param table Table to be synchronized
-- @param serializer Serializer used to turn the table into strings
-- @param deserializer Deserializer used to turn strings into tables
-- @param rate Speed at which it's synchronized
-- @param object Connection object
-- @param keylength Optional: Length of the key
function lube.easy:server(port, table, serializer, deserializer, rate, object, keylength)
	keylength = keylength or 512
	self.type = "server"
	self.port = port
	self.table = table
	self.serializer = serializer
	self.deserializer = deserializer
	self.rate = rate
	self.object = object
	self.object:Init(port)
	self.object:setCallback(self.sreceive, self.sconnect)
	self.object:setHandshake("EasyLUBE")
	self.key = self.generateKey(keylength)
end

--- Start a client
-- @see lube.easy:server
function lube.easy:client(host, port, table, serializer, deserializer, rate, object)
	self.type = "client"
	self.port = port
	self.table = table
	self.serializer = serializer
	self.deserializer = deserializer
	self.rate = rate
	self.object = object
	self.object:Init()
	self.object:setCallback(self.creceive)
	self.object:setHandshake("EasyLUBE")
	self.object:connect(host, port, true)
	self.object:send("RequestKeyFromEasyLUBEServer")
end

function lube.easy.sreceive(data, ip, port)
	if data:gfind("(.*)\n\n")() == lube.easy.key then
		lube.easy:settable(data:gfind(".*\n\n(.*)")())
	elseif data == "RequestKeyFromEasyLUBEServer" then
		lube.easy.object:send(lube.easy.key)
	end
end

function lube.easy.creceive(data)
	if not lube.easy.key then
		lube.easy.key = data
	elseif data:gfind("(.*)\n\n")() == lube.easy.key then
		lube.easy:settable(data:gfind(".*\n\n(.*)")())
	end
end

--- Update (runs a synchronization cycle when necessary)
function lube.easy:update(dt)
	self.object:update()
	if not self.key then return end
	self.timer = self.timer + dt
	if self.timer >= self.rate then
		local s = self.key .. "\n\n"
		s = s .. self:gettable()
		self.object:send(s)
		self.timer = 0
	end
end

--- LUBE
module("lube")
