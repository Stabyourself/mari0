
AI = class:new()

function AI:init(player)
    self.player = player
end

-- this function is called every 10 ticks
function AI:do_action()
    local randomAction = math.random(0, 10)
    self.player:set_action(randomAction)
    print("called every 5 ticks")
end

-- this function is called every tick
function AI:collect_data()
    print("called every fame")
end