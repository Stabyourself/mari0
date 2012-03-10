hatoffsets = {}
hatoffsets["idle"] = {0, 0}
hatoffsets["running"] = {{0, 0}, {0, 0}, {-1, -1}}
hatoffsets["sliding"] = {0, 0}
hatoffsets["jumping"] = {0, -1}
hatoffsets["falling"] = {0, 0}
hatoffsets["climbing"] = {{2, 0}, {2, -1}}
hatoffsets["swimming"] = {{1, -1}, {1, -1}}
hatoffsets["dead"] = false
hatoffsets["grow"] = {-6, 0}

local i
hat = {}

i = 1
hat[i] = {}
hat[i].x = 7
hat[i].y = 2
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/standard.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 2
hat[i] = {}
hat[i].x = 5
hat[i].y = -3
hat[i].height = 4
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/tyrolean.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 3
hat[i] = {}
hat[i].x = 5
hat[i].y = -1
hat[i].height = 4
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/towering1.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 4
hat[i] = {}
hat[i].x = 5
hat[i].y = -6
hat[i].height = 8
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/towering2.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 5
hat[i] = {}
hat[i].x = 5
hat[i].y = 1
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/towering3.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 6
hat[i] = {}
hat[i].x = 5
hat[i].y = -7
hat[i].height = 10
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/drseuss.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 7
hat[i] = {}
hat[i].x = 4
hat[i].y = -7
hat[i].height = 8
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/bird.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 8
hat[i] = {}
hat[i].x = 4
hat[i].y = -1
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/banana.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 9
hat[i] = {}
hat[i].x = 7
hat[i].y = -2
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/beanie.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 10
hat[i] = {}
hat[i].x = 7
hat[i].y = -5
hat[i].height = 8
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/toilet.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 11
hat[i] = {}
hat[i].x = 5
hat[i].y = -4
hat[i].height = 5
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/indian.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 12
hat[i] = {}
hat[i].x = 6
hat[i].y = -1
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/officerhat.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 13
hat[i] = {}
hat[i].x = 5
hat[i].y = -3
hat[i].height = 6
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/crown.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 14
hat[i] = {}
hat[i].x = 5
hat[i].y = -5
hat[i].height = 9
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/tophat.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 15
hat[i] = {}
hat[i].x = 6
hat[i].y = 1
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/batter.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 16
hat[i] = {}
hat[i].x = 6
hat[i].y = 0
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/bonk.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 17
hat[i] = {}
hat[i].x = 6
hat[i].y = 0
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/bakerboy.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 18
hat[i] = {}
hat[i].x = 5
hat[i].y = 1
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/troublemaker.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 19
hat[i] = {}
hat[i].x = 7
hat[i].y = 1
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/whoopee.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 20
hat[i] = {}
hat[i].x = 6
hat[i].y = -1
hat[i].height = 4
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/milkman.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 21
hat[i] = {}
hat[i].x = 6
hat[i].y = 1
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/bombingrun.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 22
hat[i] = {}
hat[i].x = 4
hat[i].y = 3
hat[i].height = 0
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/bonkboy.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 23
hat[i] = {}
hat[i].x = 6
hat[i].y = 0
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/flippedtrilby.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 24
hat[i] = {}
hat[i].x = 7
hat[i].y = 0
hat[i].height = 3
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/superfan.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 25
hat[i] = {}
hat[i].x = 6
hat[i].y = -2
hat[i].height = 4
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/familiarfez.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 26
hat[i] = {}
hat[i].x = 3
hat[i].y = 0
hat[i].height = 4
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/santahat.png");hat[i].graphic:setFilter("nearest", "nearest")

i = 27
hat[i] = {}
hat[i].x = 6
hat[i].y = 0
hat[i].height = 2
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/sailor.png")

i = 28
hat[i] = {}
hat[i].x = 3
hat[i].y = -3
hat[i].height = 5
hat[i].graphic = love.graphics.newImage("graphics/SMB/hats/koopa.png")

table.insert(hat, {x = 5, y = -5, height = 5, graphic = love.graphics.newImage("graphics/SMB/hats/blooper.png")})

--30:
table.insert(hat, {x = 7, y = 1, height = 2, graphic = love.graphics.newImage("graphics/SMB/hats/shyguy.png")})

table.insert(hat, {x = 6, y = 4, height = 4, graphic = love.graphics.newImage("graphics/SMB/hats/goodnewseverybody.png")})

table.insert(hat, {x = 5, y = 1, height = 4, graphic = love.graphics.newImage("graphics/SMB/hats/jetset.png")})

table.insert(hat, {x = 6, y = 1, height = 4, graphic = love.graphics.newImage("graphics/SMB/hats/bestpony.png")})