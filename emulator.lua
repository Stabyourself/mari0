--
-- Created by IntelliJ IDEA.
-- User: Guus Toussaint
-- Date: 4/22/2021
-- Time: 2:53 PM
-- To change this template use File | Settings | File Templates.
--

-- Load the boring functions
require("emulatorFunctions")
counter = 0

ButtonNames = {
    "A",
    "B",
    "Up",
    "Down",
    "Left",
    "Right",
}


BoxRadius = 6
InputSize = (BoxRadius*2+1) * (BoxRadius*2+1)

Inputs = InputSize+1
Outputs = #ButtonNames

Population = 100
DeltaDisjoint = 2.0
DeltaWeights = 0.4
DeltaThreshold = 1.0

StaleSpecies = 15

MutateConnectionsChance = 0.25
PerturbChance = 0.90
CrossoverChance = 0.75
LinkMutationChance = 2.0
NodeMutationChance = 0.50
BiasMutationChance = 0.40
StepSize = 0.1
DisableMutationChance = 0.4
EnableMutationChance = 0.2

TimeoutConstant = 20

MaxNodes = 1000000


function emulator()
    -- for demo purposes
    agents = 1
    pool = createPool()
    initPool()
end

function NEATloop(dt)

    local species = pool.species[pool.currentSpecies]
    local genome = species.genomes[pool.currentGenome]

    -- DO ACTION
    evaluateCurrent()

    getPositions()
    if marioX > rightmost then
        rightmost = marioX
        timeout = TimeoutConstant
    end

    timeout = timeout - 1


    local timeoutBonus = pool.currentFrame / 4
    if timeout + timeoutBonus <= 0 or objects["player"][1].dead == true then
--        local fitness = rightmost - pool.currentFrame / 2
        local fitness = rightmost


        if rightmost > 3186 then
            fitness = fitness + 1000
        end
        if fitness == 0 then
            fitness = -1
        end
        genome.fitness = fitness

        if fitness > pool.maxFitness then
            pool.maxFitness = fitness
        end

        print("Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " fitness: " .. fitness)
        pool.currentSpecies = 1
        pool.currentGenome = 1
        while fitnessAlreadyMeasured() do
            nextGenome()
        end
        initializeRun()
    end

    local measured = 0
    local total = 0
    for _,species in pairs(pool.species) do
        for _,genome in pairs(species.genomes) do
            total = total + 1
            if genome.fitness ~= 0 then
                measured = measured + 1
            end
        end
    end

    pool.currentFrame = pool.currentFrame + 1
    counter = counter + 1
    if counter == 10 then
        return
    end

    game_update(dt)
end

-- run current
function evaluateCurrent()
    local species = pool.species[pool.currentSpecies]
    local genome = species.genomes[pool.currentGenome]



    inputs = getInputs()
    controller = evaluateNetwork(genome.network, inputs)

--    print(dump(controller))

    if controller["P1 Left"] and controller["P1 Right"] then
        controller["P1 Left"] = false
        controller["P1 Right"] = false
    end
    if controller["P1 Up"] and controller["P1 Down"] then
        controller["P1 Up"] = false
        controller["P1 Down"] = false
    end

    do_action(controller)

    --joypad.set(controller)
end

function do_action(actions)
    if actions["P1 Left"] then
        objects["player"][1]:set_action(2)
    elseif actions["P1 Right"] then
        objects["player"][1]:set_action(1)
    elseif actions["P1 Up"] then
        objects["player"][1]:set_action(6)
    elseif actions["P1 Down"] then
        objects["player"][1]:set_action(2)
    end
end

--TODO: nog aanpassen zodat getTiles werkt
function getInputs()
    getPositions()

    sprites = getSprites()
    extended = getExtendedSprites()

    local inputs = {}

    marioX = math.floor(marioX)
    marioY = math.floor(marioY)

--    print(marioX .. "\t" .. marioY)

    startYbox = marioY-BoxRadius
    endYbox = marioY+BoxRadius

    startXbox = marioX-BoxRadius
    endXbox = marioX+BoxRadius
    for dy_=startYbox,endYbox  do
        for dx_=startXbox,endXbox  do
            local dx = math.max(dx_, 0)
            local dy = math.max(dy_, 0)
            inputs[#inputs+1] = 0

            if map[dx] ~= nil and map[dx][dy] ~= nil then
                tile_found = map[dx][dy][1]
            else
                tile_found = 0
            end
--            print(#inputs .. "\t" .. dx_ .. "\t" .. dy_ .. "\t" .. tile_found)

            if tile_found == 1 and marioY+dy < 0x1B0 then
                inputs[#inputs] = 1
            end

            for i = 1,#sprites do
                distx = math.abs(sprites[i]["x"] - (marioX+dx))
                disty = math.abs(sprites[i]["y"] - (marioY+dy))
                if distx <= 8 and disty <= 8 then
                    inputs[#inputs] = -1
                end
            end

            for i = 1,#extended do
                distx = math.abs(extended[i]["x"] - (marioX+dx))
                disty = math.abs(extended[i]["y"] - (marioY+dy))
                if distx < 8 and disty < 8 then
                    inputs[#inputs] = -1
                end
            end
        end
    end
--    print(dump(inputs))
    return inputs
end

--TODO: nog uitzoeken hoe we sprites kunnen ophalen
function getSprites()
    local sprites = {}
    for slot=0,4 do
        -- local enemy = memory.readbyte(0xF+slot)
        if slot == 1 then
            enemy = 1
        else
            enemy = 0
        end
        if enemy ~= 0 then
            -- local ex = memory.readbyte(0x6E + slot)*0x100 + memory.readbyte(0x87+slot)
            -- local ey = memory.readbyte(0xCF + slot)+24
            local ex = marioX + 50
            local ey = marioY + 5
            sprites[#sprites+1] = {["x"]=ex,["y"]=ey}
        end
    end
    return sprites
end

function evaluateNetwork(network, inputs)
    table.insert(inputs, 1)
    if #inputs ~= Inputs then
        console.writeline("Incorrect number of neural network inputs.")
        return {}
    end

    for i=1,Inputs do
        network.neurons[i].value = inputs[i]
    end

    for _,neuron in pairs(network.neurons) do
        local sum = 0
        for j = 1,#neuron.incoming do
            local incoming = neuron.incoming[j]
            local other = network.neurons[incoming.into]
            sum = sum + incoming.weight * other.value
        end

        if #neuron.incoming > 0 then
            neuron.value = sigmoid(sum)
        end
    end

    local outputs = {}
    for o=1,Outputs do
        local button = "P1 " .. ButtonNames[o]
        --		print(network.neurons[MaxNodes+o].value)
        if network.neurons[MaxNodes+o].value > 0 then
            outputs[button] = true
        else
            outputs[button] = false
        end
    end
    -- for key, value in pairs(outputs) do
    --     print('\t', key, value)
    -- end
    return outputs
end

function getExtendedSprites()
    return {}
end

function getPositions()
    marioX = objects["player"][1].x
    marioY = objects["player"][1].y

    screenX = marioX
    screenY = marioY
end

-- Creating the pool
function createPool()
    print("Pool is initializing...")
    local pool = {}
    pool.species = {}
    pool.generation = 0
    pool.innovation = Outputs
    pool.currentSpecies = 1
    pool.currentGenome = 1
    pool.currentFrame = 0
    pool.maxFitness = 0
    return pool
end

-- Initialise the pool
function initPool()
    for i=1,Population do
        basic = basicGenome()
        addToSpecies(basic)
    end

    initializeRun()
end

-- NEAT functions
function nextGenome()
    pool.currentGenome = pool.currentGenome + 1
    if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
        pool.currentGenome = 1
        pool.currentSpecies = pool.currentSpecies+1
        if pool.currentSpecies > #pool.species then
            newGeneration()
            pool.currentSpecies = 1
        end
    end
end

function newGeneration()
    cullSpecies(false) -- Cull the bottom half of each species
    rankGlobally()
    removeStaleSpecies()
    rankGlobally()
    for s = 1,#pool.species do
        local species = pool.species[s]
        calculateAverageFitness(species)
    end
    removeWeakSpecies()
    local sum = totalAverageFitness()
    local children = {}
    for s = 1,#pool.species do
        local species = pool.species[s]
        breed = math.floor(species.averageFitness / sum * Population) - 1
        for i=1,breed do
            table.insert(children, breedChild(species))
        end
    end
    cullSpecies(true) -- Cull all but the top member of each species
    while #children + #pool.species < Population do
        local species = pool.species[math.random(1, #pool.species)]
        table.insert(children, breedChild(species))
    end
    for c=1,#children do
        local child = children[c]
        addToSpecies(child)
    end

    pool.generation = pool.generation + 1

    -- writeFile("backup." .. pool.generation .. "." .. forms.gettext(saveLoadFile))
end

function breedChild(species)
    local child = {}
    if math.random() < CrossoverChance then
        g1 = species.genomes[math.random(1, #species.genomes)]
        g2 = species.genomes[math.random(1, #species.genomes)]
        child = crossover(g1, g2)
    else
        g = species.genomes[math.random(1, #species.genomes)]
        child = copyGenome(g)
    end

    mutate(child)

    return child
end

function crossover(g1, g2)
    -- Make sure g1 is the higher fitness genome
    if g2.fitness > g1.fitness then
        tempg = g1
        g1 = g2
        g2 = tempg
    end

    local child = newGenome()

    local innovations2 = {}
    for i=1,#g2.genes do
        local gene = g2.genes[i]
        innovations2[gene.innovation] = gene
    end

    for i=1,#g1.genes do
        local gene1 = g1.genes[i]
        local gene2 = innovations2[gene1.innovation]
        if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
            table.insert(child.genes, copyGene(gene2))
        else
            table.insert(child.genes, copyGene(gene1))
        end
    end

    child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)

    for mutation,rate in pairs(g1.mutationRates) do
        child.mutationRates[mutation] = rate
    end

    return child
end

function copyGenome(genome)
    local genome2 = newGenome()
    for g=1,#genome.genes do
        table.insert(genome2.genes, copyGene(genome.genes[g]))
    end
    genome2.maxneuron = genome.maxneuron
    genome2.mutationRates["connections"] = genome.mutationRates["connections"]
    genome2.mutationRates["link"] = genome.mutationRates["link"]
    genome2.mutationRates["bias"] = genome.mutationRates["bias"]
    genome2.mutationRates["node"] = genome.mutationRates["node"]
    genome2.mutationRates["enable"] = genome.mutationRates["enable"]
    genome2.mutationRates["disable"] = genome.mutationRates["disable"]

    return genome2
end

function totalAverageFitness()
    local total = 0
    for s = 1,#pool.species do
        local species = pool.species[s]
        total = total + species.averageFitness
    end

    return total
end

function removeWeakSpecies()
    local survived = {}

    local sum = totalAverageFitness()
    for s = 1,#pool.species do
        local species = pool.species[s]
        breed = math.floor(species.averageFitness / sum * Population)
        if breed >= 1 then
            table.insert(survived, species)
        end
    end

    pool.species = survived
end

function calculateAverageFitness(species)
    local total = 0

    for g=1,#species.genomes do
        local genome = species.genomes[g]
        total = total + genome.globalRank
    end

    species.averageFitness = total / #species.genomes
end

function rankGlobally()
    local global = {}
    for s = 1,#pool.species do
        local species = pool.species[s]
        for g = 1,#species.genomes do
            table.insert(global, species.genomes[g])
        end
    end
    table.sort(global, function (a,b)
        return (a.fitness < b.fitness)
    end)

    for g=1,#global do
        global[g].globalRank = g
    end
end

function removeStaleSpecies()
    local survived = {}

    for s = 1,#pool.species do
        local species = pool.species[s]

        table.sort(species.genomes, function (a,b)
            return (a.fitness > b.fitness)
        end)

        if species.genomes[1].fitness > species.topFitness then
            species.topFitness = species.genomes[1].fitness
            species.staleness = 0
        else
            species.staleness = species.staleness + 1
        end
        if species.staleness < StaleSpecies or species.topFitness >= pool.maxFitness then
            table.insert(survived, species)
        end
    end

    pool.species = survived
end

function cullSpecies(cutToOne)
    for s = 1,#pool.species do
        local species = pool.species[s]

        table.sort(species.genomes, function (a,b)
            return (a.fitness > b.fitness)
        end)

        local remaining = math.ceil(#species.genomes/2)
        if cutToOne then
            remaining = 1
        end
        while #species.genomes > remaining do
            table.remove(species.genomes)
        end
    end
end

function fitnessAlreadyMeasured()
    local species = pool.species[pool.currentSpecies]
    local genome = species.genomes[pool.currentGenome]

    return genome.fitness ~= 0
end

function initializeRun()
    load_level()
    print("level loaded")
    gamestate = "NEAT"

    -- savestate.load(Filename);
    rightmost = 0
    pool.currentFrame = 0
    timeout = TimeoutConstant

    local species = pool.species[pool.currentSpecies]
    local genome = species.genomes[pool.currentGenome]
    generateNetwork(genome)
    evaluateCurrent()
end

function generateNetwork(genome)
    local network = {}
    network.neurons = {}

    for i=1,Inputs do
        network.neurons[i] = newNeuron()
    end

    for o=1,Outputs do
        network.neurons[MaxNodes+o] = newNeuron()
    end

    table.sort(genome.genes, function (a,b)
        return (a.out < b.out)
    end)
    for i=1,#genome.genes do
        local gene = genome.genes[i]
        if gene.enabled then
            if network.neurons[gene.out] == nil then
                network.neurons[gene.out] = newNeuron()
            end
            local neuron = network.neurons[gene.out]
            table.insert(neuron.incoming, gene)
            if network.neurons[gene.into] == nil then
                network.neurons[gene.into] = newNeuron()
            end
        end
    end

    genome.network = network
end

function newNeuron()
    local neuron = {}
    neuron.incoming = {}
    neuron.value = 0.0

    return neuron
end

function basicGenome()
    local genome = newGenome()
    local innovation = 1

    genome.maxneuron = Inputs
    mutate(genome)

    return genome
end

function sigmoid(x)
    return 2/(1+math.exp(-4.9*x))-1
end

function addToSpecies(child)
    local foundSpecies = false
    for s=1,#pool.species do
        local species = pool.species[s]
        if not foundSpecies and sameSpecies(child, species.genomes[1]) then
            table.insert(species.genomes, child)
            foundSpecies = true
        end
    end

    if not foundSpecies then
        local childSpecies = newSpecies()
        table.insert(childSpecies.genomes, child)
        table.insert(pool.species, childSpecies)
    end
end

function newGenome()
    local genome = {}
    genome.genes = {}
    genome.fitness = 0
    genome.adjustedFitness = 0
    genome.network = {}
    genome.maxneuron = 0
    genome.globalRank = 0
    genome.mutationRates = {}
    genome.mutationRates["connections"] = MutateConnectionsChance
    genome.mutationRates["link"] = LinkMutationChance
    genome.mutationRates["bias"] = BiasMutationChance
    genome.mutationRates["node"] = NodeMutationChance
    genome.mutationRates["enable"] = EnableMutationChance
    genome.mutationRates["disable"] = DisableMutationChance
    genome.mutationRates["step"] = StepSize

    return genome
end

function sameSpecies(genome1, genome2)
    local dd = DeltaDisjoint*disjoint(genome1.genes, genome2.genes)
    local dw = DeltaWeights*weights(genome1.genes, genome2.genes)
    return dd + dw < DeltaThreshold
end

function mutate(genome)
    for mutation,rate in pairs(genome.mutationRates) do
        if math.random(1,2) == 1 then
            genome.mutationRates[mutation] = 0.95*rate
        else
            genome.mutationRates[mutation] = 1.05263*rate
        end
    end

    if math.random() < genome.mutationRates["connections"] then
        pointMutate(genome)
    end

    local p = genome.mutationRates["link"]
    while p > 0 do
        if math.random() < p then
            linkMutate(genome, false)
        end
        p = p - 1
    end

    p = genome.mutationRates["bias"]
    while p > 0 do
        if math.random() < p then
            linkMutate(genome, true)
        end
        p = p - 1
    end

    p = genome.mutationRates["node"]
    while p > 0 do
        if math.random() < p then
            nodeMutate(genome)
        end
        p = p - 1
    end

    p = genome.mutationRates["enable"]
    while p > 0 do
        if math.random() < p then
            enableDisableMutate(genome, true)
        end
        p = p - 1
    end

    p = genome.mutationRates["disable"]
    while p > 0 do
        if math.random() < p then
            enableDisableMutate(genome, false)
        end
        p = p - 1
    end
end

function pointMutate(genome)
    local step = genome.mutationRates["step"]

    for i=1,#genome.genes do
        local gene = genome.genes[i]
        if math.random() < PerturbChance then
            gene.weight = gene.weight + math.random() * step*2 - step
        else
            gene.weight = math.random()*4-2
        end
    end
end

function linkMutate(genome, forceBias)
    local neuron1 = randomNeuron(genome.genes, false)
    local neuron2 = randomNeuron(genome.genes, true)

    local newLink = newGene()
    if neuron1 <= Inputs and neuron2 <= Inputs then
        --Both input nodes
        return
    end
    if neuron2 <= Inputs then
        -- Swap output and input
        local temp = neuron1
        neuron1 = neuron2
        neuron2 = temp
    end

    newLink.into = neuron1
    newLink.out = neuron2
    if forceBias then
        newLink.into = Inputs
    end

    if containsLink(genome.genes, newLink) then
        return
    end
    newLink.innovation = newInnovation()
    newLink.weight = math.random()*4-2

    table.insert(genome.genes, newLink)
end

function nodeMutate(genome)
    if #genome.genes == 0 then
        return
    end

    genome.maxneuron = genome.maxneuron + 1

    local gene = genome.genes[math.random(1,#genome.genes)]
    if not gene.enabled then
        return
    end
    gene.enabled = false

    local gene1 = copyGene(gene)
    gene1.out = genome.maxneuron
    gene1.weight = 1.0
    gene1.innovation = newInnovation()
    gene1.enabled = true
    table.insert(genome.genes, gene1)

    local gene2 = copyGene(gene)
    gene2.into = genome.maxneuron
    gene2.innovation = newInnovation()
    gene2.enabled = true
    table.insert(genome.genes, gene2)
end

function enableDisableMutate(genome, enable)
    local candidates = {}
    for _,gene in pairs(genome.genes) do
        if gene.enabled == not enable then
            table.insert(candidates, gene)
        end
    end

    if #candidates == 0 then
        return
    end

    local gene = candidates[math.random(1,#candidates)]
    gene.enabled = not gene.enabled
end

function randomNeuron(genes, nonInput)
    local neurons = {}
    if not nonInput then
        for i=1,Inputs do
            neurons[i] = true
        end
    end
    for o=1,Outputs do
        neurons[MaxNodes+o] = true
    end
    for i=1,#genes do
        if (not nonInput) or genes[i].into > Inputs then
            neurons[genes[i].into] = true
        end
        if (not nonInput) or genes[i].out > Inputs then
            neurons[genes[i].out] = true
        end
    end

    local count = 0
    for _,_ in pairs(neurons) do
        count = count + 1
    end
    local n = math.random(1, count)

    for k,v in pairs(neurons) do
        n = n-1
        if n == 0 then
            return k
        end
    end

    return 0
end

function newGene()
    local gene = {}
    gene.into = 0
    gene.out = 0
    gene.weight = 0.0
    gene.enabled = true
    gene.innovation = 0

    return gene
end

function containsLink(genes, link)
    for i=1,#genes do
        local gene = genes[i]
        if gene.into == link.into and gene.out == link.out then
            return true
        end
    end
end

function newInnovation()
    pool.innovation = pool.innovation + 1
    return pool.innovation
end

function copyGene(gene)
    local gene2 = newGene()
    gene2.into = gene.into
    gene2.out = gene.out
    gene2.weight = gene.weight
    gene2.enabled = gene.enabled
    gene2.innovation = gene.innovation

    return gene2
end

function enableDisableMutate(genome, enable)
    local candidates = {}
    for _,gene in pairs(genome.genes) do
        if gene.enabled == not enable then
            table.insert(candidates, gene)
        end
    end

    if #candidates == 0 then
        return
    end

    local gene = candidates[math.random(1,#candidates)]
    gene.enabled = not gene.enabled
end

function disjoint(genes1, genes2)
    local i1 = {}
    for i = 1,#genes1 do
        local gene = genes1[i]
        i1[gene.innovation] = true
    end

    local i2 = {}
    for i = 1,#genes2 do
        local gene = genes2[i]
        i2[gene.innovation] = true
    end

    local disjointGenes = 0
    for i = 1,#genes1 do
        local gene = genes1[i]
        if not i2[gene.innovation] then
            disjointGenes = disjointGenes+1
        end
    end

    for i = 1,#genes2 do
        local gene = genes2[i]
        if not i1[gene.innovation] then
            disjointGenes = disjointGenes+1
        end
    end

    local n = math.max(#genes1, #genes2)

    return disjointGenes / n
end

function weights(genes1, genes2)
    local i2 = {}
    for i = 1,#genes2 do
        local gene = genes2[i]
        i2[gene.innovation] = gene
    end

    local sum = 0
    local coincident = 0
    for i = 1,#genes1 do
        local gene = genes1[i]
        if i2[gene.innovation] ~= nil then
            local gene2 = i2[gene.innovation]
            sum = sum + math.abs(gene.weight - gene2.weight)
            coincident = coincident + 1
        end
    end

    return sum / coincident
end

function newSpecies()
    local species = {}
    species.topFitness = 0
    species.staleness = 0
    species.genomes = {}
    species.averageFitness = 0

    return species
end


-- FUNCTIONS THAT THE AGENT USES
function inmap(x, y)
    if not x or not y then
        return false
    end
    if x >= 1 and x <= mapwidth and y >= 1 and y <= 15 then
        return true
    else
        return false
    end
end

function traceline(sourcex, sourcey, radians)
    local currentblock = {}
    local x, y = sourcex, sourcey
    currentblock[1] = math.floor(x)
    currentblock[2] = math.floor(y+1)

    local emancecollide = false
    for i, v in pairs(emancipationgrills) do
        if v:getTileInvolved(currentblock[1]+1, currentblock[2]) then
            emancecollide = true
        end
    end

    local doorcollide = false
    for i, v in pairs(objects["door"]) do
        if v.dir == "hor" then
            if v.open == false and (v.cox == currentblock[1] or v.cox == currentblock[1]+1) and v.coy == currentblock[2] then
                doorcollide = true
            end
        else
            if v.open == false and v.cox == currentblock[1]+1 and (v.coy == currentblock[2] or v.coy == currentblock[2]+1) then
                doorcollide = true
            end
        end
    end

    if emancecollide or doorcollide then
        return false, false, false, false, x, y
    end

    local side

    while currentblock[1]+1 > 0 and currentblock[1]+1 <= mapwidth and (flagx == false or currentblock[1]+1 <= flagx) and (axex == false or currentblock[1]+1 <= axex) and (currentblock[2] > 0 or currentblock[2] >= math.floor(sourcey+0.5)) and currentblock[2] < 16 do --while in map range
        local oldy = y
        local oldx = x

        --calculate X and Y diff..
        local ydiff, xdiff
        local side1, side2

        if inrange(radians, -math.pi/2, math.pi/2, true) then --up
            ydiff = (y-(currentblock[2]-1)) / math.cos(radians)
            y = currentblock[2]-1
            side1 = "down"
        else
            ydiff = (y-(currentblock[2])) / math.cos(radians)
            y = currentblock[2]
            side1 = "up"
        end

        if inrange(radians, 0, math.pi, true) then --left
            xdiff = (x-(currentblock[1])) / math.sin(radians)
            x = currentblock[1]
            side2 = "right"
        else
            xdiff = (x-(currentblock[1]+1)) / math.sin(radians)
            x = currentblock[1]+1
            side2 = "left"
        end

        --smaller diff wins

        if xdiff < ydiff then
            y = oldy - math.cos(radians)*xdiff
            side = side2
        else
            x = oldx - math.sin(radians)*ydiff
            side = side1
        end

        if side == "down" then
            currentblock[2] = currentblock[2]-1
        elseif side == "up" then
            currentblock[2] = currentblock[2]+1
        elseif side == "left" then
            currentblock[1] = currentblock[1]+1
        elseif side == "right" then
            currentblock[1] = currentblock[1]-1
        end

        local collide, tileno = getTile(currentblock[1]+1, currentblock[2])
        local emancecollide = false
        for i, v in pairs(emancipationgrills) do
            if v:getTileInvolved(currentblock[1]+1, currentblock[2]) then
                emancecollide = true
            end
        end

        local doorcollide = false
        for i, v in pairs(objects["door"]) do
            if v.dir == "hor" then
                if v.open == false and (v.cox == currentblock[1] or v.cox == currentblock[1]+1) and v.coy == currentblock[2] then
                    doorcollide = true
                end
            else
                if v.open == false and v.cox == currentblock[1]+1 and (v.coy == currentblock[2] or v.coy == currentblock[2]+1) then
                    doorcollide = true
                end
            end
        end

        if collide == true then
            break
        elseif emancecollide or doorcollide then
            return false, false, false, false, x, y
        elseif x > xscroll + width or x < xscroll then
            return false, false, false, false, x, y
        end
    end

    if currentblock[1]+1 > 0 and currentblock[1]+1 <= mapwidth and (currentblock[2] > 0 or currentblock[2] >= math.floor(sourcey+0.5))  and currentblock[2] < 16 and currentblock[1] ~= nil then
        local tendency

        --get tendency
        if side == "down" or side == "up" then
            if math.fmod(x, 1) > 0.5 then
                tendency = 1
            else
                tendency = -1
            end
        elseif side == "left" or side == "right" then
            if math.fmod(y, 1) > 0.5 then
                tendency = 1
            else
                tendency = -1
            end
        end

        return currentblock[1]+1, currentblock[2], side, tendency, x, y
    else
        return false, false, false, false, x, y
    end
end

function inrange(i, a, b, include)
    if a > b then
        b, a = a, b
    end

    if include then
        if i >= a and i <= b then
            return true
        else
            return false
        end
    else
        if i > a and i < b then
            return true
        else
            return false
        end
    end
end

function getTile(x, y, portalable, portalcheck, facing) --returns masktable value of block (As well as the ID itself as second return parameter) also includes a portalcheck and returns false if a portal is on that spot.
    --Portal on same tile doesn't work so well yet (collision code, of course), so:
    --facing = nil

    if portalcheck then
        for i, v in pairs(objects["player"]) do
            --Get the extra block of each portal
            local portal1xplus, portal1yplus, portal2xplus, portal2yplus = 0, 0, 0, 0
            if v.portal1facing == "up" then
                portal1xplus = 1
            elseif v.portal1facing == "right" then
                portal1yplus = 1
            elseif v.portal1facing == "down" then
                portal1xplus = -1
            elseif v.portal1facing == "left" then
                portal1yplus = -1
            end

            if v.portal2facing == "up" then
                portal2xplus = 1
            elseif v.portal2facing == "right" then
                portal2yplus = 1
            elseif v.portal2facing == "down" then
                portal2xplus = -1
            elseif v.portal2facing == "left" then
                portal2yplus = -1
            end

            if v.portal1X ~= false then
                if (x == v.portal1X or x == v.portal1X+portal1xplus) and (y == v.portal1Y or y == v.portal1Y+portal1yplus) then--and (facing == nil or v.portal1facing == facing) then
                    return false
                end
            end

            if v.portal2X ~= false then
                if (x == v.portal2X or x == v.portal2X+portal2xplus) and (y == v.portal2Y or y == v.portal2Y+portal2yplus) then--and (facing == nil or v.portal2facing == facing) then
                    return false
                end
            end
        end
    end

    --check for tubes
    for i, v in pairs(objects["geldispenser"]) do
        if (x == v.cox or x == v.cox+1) and (y == v.coy or y == v.coy+1) then
            if portalcheck then
                return false
            else
                return true
            end
        end
    end

    for i, v in pairs(objects["cubedispenser"]) do
        if (x == v.cox or x == v.cox+1) and (y == v.coy or y == v.coy+1) then
            if portalcheck then
                return false
            else
                return true
            end
        end
    end

    --bonusstage thing for keeping it from fucking up.
    if bonusstage then
        if y == 15 and (x == 4 or x == 6) then
            if portalcheck then
                return false
            else
                return true
            end
        end
    end

    if x <= 0 or y <= 0 or y >= 16 or x > mapwidth then
        return false, 1
    end

    if tilequads[map[x][y][1]].invisible then
        return false
    end

    if portalcheck then
        local side
        if facing == "up" then
            side = "top"
        elseif facing == "right" then
            side = "right"
        elseif facing == "down" then
            side = "bottom"
        elseif facing == "left" then
            side = "left"
        end

        --To stop people from portalling under the vine, which caused problems, but was fixed elsewhere (and betterer)
        --[[for i, v in pairs(objects["vine"]) do
            if x == v.cox and y == v.coy and side == "top" then
                return false, 1
            end
        end--]]


        if map[x][y]["gels"][side] == 3 then
            return true, map[x][y][1]
        else
            return tilequads[map[x][y][1]].collision and tilequads[map[x][y][1]].portalable, map[x][y][1]
        end
    else
        return tilequads[map[x][y][1]].collision, map[x][y][1]
    end
end
