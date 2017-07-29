stats = {}

tracking = {
			"jumps", 
			"enemy_kills", 
			"deaths", 
			"portals_shot_1", 
			"portals_shot_2", 
			"mushrooms_eaten", 
			"flowers_eaten",
			"distance_traveled",
			"boxes_picked_up",
			"portals_entered",
			"blocks_hit",
			"coins_collected",
			"pipes_used",
			"levels_finished",
			"fireballs_shot"
			}
			
trackingshow = {
			true,
			false,
			false,
			true,
			true,
			false,
			false,
			true,
			true,
			true,
			false,
			false,
			false,
			true,
			false
			}
			
trackingtexts = { 
				"total jumps:",
				"enemies killed:",
				"times died:",
				"blue portals shot:",
				"orange portals shot:",
				"mushrooms eaten:",
				"flowers eaten:",
				"distance travelled:",
				"boxes picked up:",
				"portals used:",
				"blocks hit:",
				"collected coins:",
				"pipes used:",
				"levels finished:",
				"fireballs shot:"
				}
				
trackingadd = {
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				" m",
				"",
				"",
				"",
				"",
				"",
				"",
				""
				}

for i = 1, #tracking do
	stats[tracking[i]] = 0
end

function track(t, i)
	if stats[t] then
		stats[t] = stats[t] + (i or 1)
	else
		print("Unknown tracking type: " .. t .. ", I'm gonna add it with standard value 0 though.")
		stats[t] = (i or 1)
	end
end

function loadtrack(s)
	if not s then
		s = "stats.txt"
	end
	
	if love.filesystem.exists(s) then
		local file = love.filesystem.read(s)
		
		local s1 = file:split("\r\n")
		for i = 1, #s1 do
			s2 = s1[i]:split("=")
			stats[s2[1]] = tonumber(s2[2])
		end
	end
end

function savetrack(s)
	if not s then
		s = "stats.txt"
	end
	
	local out = ""
	
	for i, v in pairs(stats) do
		out = out .. i .. "=" .. v .. "\r\n"
	end
	
	love.filesystem.write(s, out)
end