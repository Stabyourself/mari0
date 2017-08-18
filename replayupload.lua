toUpload = {}

function addToUpload(short, name, json, frames)
    local repData = {
        short = short,
        name = name,
        json = json,
        frames = frames,
    }
    
    table.insert(toUpload, repData)
end

function processUploads()
    local delete = {}
    print("Processing " .. #toUpload .. " uploads.")
    
    for i, v in ipairs(toUpload) do
        local body = "name=" .. v.name .. "&" ..
            "frames=" .. v.frames .. "&" ..
            "data=" .. v.json .. "&" ..
            "event=" .. "GC2017" .. "&" ..
            "pass=" .. API_PASS .. "&" .. 
            "short=" .. v.short

        -- Upload replay data
        if http.request('http://timetrial.dev/api/replays', body) then
            table.insert(delete, i)
        else
            break
        end
    end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for _, v in ipairs(delete) do
		table.remove(toUpload, v)
	end
end