function loadToUpload()
    if love.filesystem.exists("toUpload.json") then
        return JSON:decode(love.filesystem.read("toUpload.json"))
    else
        return {}
    end
end

toUpload = loadToUpload()

function saveToUpload()
    love.filesystem.write("toUpload.json", JSON:encode(toUpload))
end

function addToUpload(i)
    table.insert(toUpload, i)
end

function processUploads()
    local delete = {}
    print("Processing " .. #toUpload .. " uploads.")
    
    for i, v in ipairs(toUpload) do
        local json = JSON:decode(love.filesystem.read(v .. ".json"))
    
        print(v, json.name, json.frames, type(json.data), API_PASS, json.short, POST_LINK)
        
        local body = "name=" .. json.name .. "&" ..
            "frames=" .. json.frames .. "&" ..
            "data=" .. JSON:encode(json.data) .. "&" ..
            "event=" .. "GC2017" .. "&" ..
            "pass=" .. API_PASS .. "&" .. 
            "short=" .. json.short

        -- Upload replay data
        local r, e = http.request(POST_LINK, body)
        
        if r == "success" then
            table.insert(delete, i)
            print("Upload was successful!")
        else
            print("Upload failed...")
            break
        end
    end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for _, v in ipairs(delete) do
		table.remove(toUpload, v)
	end
    
    saveToUpload()
end