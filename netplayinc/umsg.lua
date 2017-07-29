umsg = {}
umsg.hooknames = {}
umsg.hookfuncs = {}
usermessage = class("usermessage")
function usermessage:initialize(name,message)
	self.sender = nil
	self.name = name
	self.message = (message or nil)
end

function usermessage:send(id)
	local lid
	if id then
		lid = id - 1
	end
	if(SERVER) then
		if self.message == nil then
			MyServer:send("#UMSG#"..self.name, lid)
		else
			MyServer:send("#UMSG#"..self.name.."~"..self.message, lid)
		end
	end
	if(CLIENT) then
		if self.message == nil then
			MyClient:send("#UMSG#"..self.name)
		else
			MyClient:send("#UMSG#"..self.name.."~"..self.message)
		end
	end
end

function umsg.hook(hookname,hookfunction)
	table.insert(umsg.hooknames, #umsg.hooknames + 1, hookname)
	table.insert(umsg.hookfuncs, #umsg.hookfuncs + 1, hookfunction)
end

function umsg.recv(data, id)
	clienttimeouttimer = 0
	
	if lagtime == 0 then
		umsg.recv2(data, id)
	else
		table.insert(lagtable, 1, {0, data, id})
	end
end

function umsg.recv2(data, id)
	if(string.sub(data,1,6) == "#UMSG#") then
		data = string.sub(data,7)
		if string.find(data, "~") == nil then
			um = usermessage:new(data)
			um.message = ""
		else
			local des = deserialize(data)
			um = usermessage:new(des[1])
			um.message = des[2]
			for i = 3, #des do
				um.message = um.message .. "~" .. des[i]
			end
		end
		if(SERVER) then
			um.sender = id+1
		end
		if (CLIENT) then
			um.sender = 1
		end
		for i,v in pairs(umsg.hooknames) do
			if v == um.name then
				umsg.hookfuncs[i](um.message, um.sender)
				return
			end
		end
		if not (um.name == nil) then
			message("UMSG ERROR: Unknown Hookname: "..um.name)
		end
	end
end