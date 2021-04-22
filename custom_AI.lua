

AI = class:new()
ButtonNames = {
	"A",
	"B",
	"Up",
	"Down",
	"Left",
	"Right",
}


BoxRadius = 6
InputSize = (BoxRadius*2+1)*(BoxRadius*2+1)
 
Inputs = InputSize+1
Outputs = #ButtonNames

Population = 300
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
function AI:init(player)
    self.player = player
end

-- this function is called every 10 ticks
function AI:do_action(actions)
    --local randomAction = math.random(0, 10)
  --   for key, value in pairs(controller) do
 	-- 	print('\t', key, value)
 	-- end
    if actions["P1 Left"] then
    	self.player:set_action(2)
    elseif actions["P1 Right"] then
    	self.player:set_action(1)
    elseif actions["P1 Up"] then
    	self.player:set_action(6)
    elseif actions["P1 Down"] then
    	self.player:set_action(2)
    end

    -- print("called every 5 ticks")
end

-- this function is called every tick
function AI:collect_data()
	self:getPositions()
end

function AI:getPositions()
		marioX = self.player.x
		marioY = self.player.y
 
		screenX = marioX
		screenY = marioY
end

function AI:getTile(dx, dy)-- nog uitzoeken wat te doen met readbyte
		local x = marioX + dx + 8
		local y = marioY + dy - 16
		local page = math.floor(x/256)%2
 
		local subx = math.floor((x%256)/16)
		local suby = math.floor((y - 32)/16)
		local addr = 0x500 + page*13*16+suby*16+subx
 
		if suby >= 13 or suby < 0 then
			return 0
		end

		return 1 
		-- if memory.readbyte(addr) ~= 0 then
		-- 	return 1
		-- else
		-- 	return 0
		-- end
end

function AI:getSprites()--nog uitzoeken hoe we sprites kunnen ophalen
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

function AI:getExtendedSprites()
	return {}
end


function AI:getInputs()-- nog aanpassen zodat getTiles werkt
	self:getPositions()
 
	sprites = self:getSprites()
	extended = self:getExtendedSprites()
 
	local inputs = {}
 
	for dy=-BoxRadius*16,BoxRadius*16,16 do
		for dx=-BoxRadius*16,BoxRadius*16,16 do
			inputs[#inputs+1] = 0
 
			tile = self:getTile(dx, dy)
			if tile == 1 and marioY+dy < 0x1B0 then
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
	return inputs
end

function AI:sigmoid(x)
	return 2/(1+math.exp(-4.9*x))-1
end

function AI:newInnovation()
	pool.innovation = pool.innovation + 1
	return pool.innovation
end

function AI:newPool()
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

function AI:newSpecies()
	local species = {}
	species.topFitness = 0
	species.staleness = 0
	species.genomes = {}
	species.averageFitness = 0
 
	return species
end

function AI:newGenome()
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

function AI:copyGenome(genome)
	local genome2 = self:newGenome()
	for g=1,#genome.genes do
		table.insert(genome2.genes, self:copyGene(genome.genes[g]))
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

function AI:basicGenome()
	local genome = self:newGenome()
	local innovation = 1
 
	genome.maxneuron = Inputs
	self:mutate(genome)
 
	return genome
end

function AI:newGene()
	local gene = {}
	gene.into = 0
	gene.out = 0
	gene.weight = 0.0
	gene.enabled = true
	gene.innovation = 0
 
	return gene
end

function AI:copyGene(gene)
	local gene2 = self:newGene()
	gene2.into = gene.into
	gene2.out = gene.out
	gene2.weight = gene.weight
	gene2.enabled = gene.enabled
	gene2.innovation = gene.innovation
 
	return gene2
end

function AI:newNeuron()
	local neuron = {}
	neuron.incoming = {}
	neuron.value = 0.0
 
	return neuron
end

function AI:generateNetwork(genome)
	local network = {}
	network.neurons = {}
 
	for i=1,Inputs do
		network.neurons[i] = self:newNeuron()
	end
 
	for o=1,Outputs do
		network.neurons[MaxNodes+o] = self:newNeuron()
	end
 
	table.sort(genome.genes, function (a,b)
		return (a.out < b.out)
	end)
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if gene.enabled then
			if network.neurons[gene.out] == nil then
				network.neurons[gene.out] = self:newNeuron()
			end
			local neuron = network.neurons[gene.out]
			table.insert(neuron.incoming, gene)
			if network.neurons[gene.into] == nil then
				network.neurons[gene.into] = self:newNeuron()
			end
		end
	end
 
	genome.network = network
end

function AI:evaluateNetwork(network, inputs)
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
			neuron.value = self:sigmoid(sum)
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

function AI:crossover(g1, g2)
	-- Make sure g1 is the higher fitness genome
	if g2.fitness > g1.fitness then
		tempg = g1
		g1 = g2
		g2 = tempg
	end
 
	local child = self:newGenome()
 
	local innovations2 = {}
	for i=1,#g2.genes do
		local gene = g2.genes[i]
		innovations2[gene.innovation] = gene
	end
 
	for i=1,#g1.genes do
		local gene1 = g1.genes[i]
		local gene2 = innovations2[gene1.innovation]
		if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
			table.insert(child.genes, self:copyGene(gene2))
		else
			table.insert(child.genes, self:copyGene(gene1))
		end
	end
 
	child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)
 
	for mutation,rate in pairs(g1.mutationRates) do
		child.mutationRates[mutation] = rate
	end
 
	return child
end

function AI:randomNeuron(genes, nonInput)
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

function AI:containsLink(genes, link)
	for i=1,#genes do
		local gene = genes[i]
		if gene.into == link.into and gene.out == link.out then
			return true
		end
	end
end

function AI:pointMutate(genome)
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

function AI:linkMutate(genome, forceBias)
	local neuron1 = self:randomNeuron(genome.genes, false)
	local neuron2 = self:randomNeuron(genome.genes, true)
 
	local newLink = self:newGene()
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
 
	if self:containsLink(genome.genes, newLink) then
		return
	end
	newLink.innovation = self:newInnovation()
	newLink.weight = math.random()*4-2
 
	table.insert(genome.genes, newLink)
end

function AI:nodeMutate(genome)
	if #genome.genes == 0 then
		return
	end
 
	genome.maxneuron = genome.maxneuron + 1
 
	local gene = genome.genes[math.random(1,#genome.genes)]
	if not gene.enabled then
		return
	end
	gene.enabled = false
 
	local gene1 = self:copyGene(gene)
	gene1.out = genome.maxneuron
	gene1.weight = 1.0
	gene1.innovation = self:newInnovation()
	gene1.enabled = true
	table.insert(genome.genes, gene1)
 
	local gene2 = self:copyGene(gene)
	gene2.into = genome.maxneuron
	gene2.innovation = self:newInnovation()
	gene2.enabled = true
	table.insert(genome.genes, gene2)
end

function AI:enableDisableMutate(genome, enable)
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

function AI:mutate(genome)
	for mutation,rate in pairs(genome.mutationRates) do
		if math.random(1,2) == 1 then
			genome.mutationRates[mutation] = 0.95*rate
		else
			genome.mutationRates[mutation] = 1.05263*rate
		end
	end
 
	if math.random() < genome.mutationRates["connections"] then
		self:pointMutate(genome)
	end
 
	local p = genome.mutationRates["link"]
	while p > 0 do
		if math.random() < p then
			self:linkMutate(genome, false)
		end
		p = p - 1
	end
 
	p = genome.mutationRates["bias"]
	while p > 0 do
		if math.random() < p then
			self:linkMutate(genome, true)
		end
		p = p - 1
	end
 
	p = genome.mutationRates["node"]
	while p > 0 do
		if math.random() < p then
			self:nodeMutate(genome)
		end
		p = p - 1
	end
 
	p = genome.mutationRates["enable"]
	while p > 0 do
		if math.random() < p then
			self:enableDisableMutate(genome, true)
		end
		p = p - 1
	end
 
	p = genome.mutationRates["disable"]
	while p > 0 do
		if math.random() < p then
			self:enableDisableMutate(genome, false)
		end
		p = p - 1
	end
end

function AI:disjoint(genes1, genes2)
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

function AI:weights(genes1, genes2)
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

function AI:sameSpecies(genome1, genome2)
	local dd = DeltaDisjoint*self:disjoint(genome1.genes, genome2.genes)
	local dw = DeltaWeights*self:weights(genome1.genes, genome2.genes) 
	return dd + dw < DeltaThreshold
end

function AI:rankGlobally()
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

function AI:calculateAverageFitness(species)
	local total = 0
 
	for g=1,#species.genomes do
		local genome = species.genomes[g]
		total = total + genome.globalRank
	end
 
	species.averageFitness = total / #species.genomes
end

function AI:totalAverageFitness()
	local total = 0
	for s = 1,#pool.species do
		local species = pool.species[s]
		total = total + species.averageFitness
	end
 
	return total
end

function AI:cullSpecies(cutToOne)
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

function AI:breedChild(species)
	local child = {}
	if math.random() < CrossoverChance then
		g1 = species.genomes[math.random(1, #species.genomes)]
		g2 = species.genomes[math.random(1, #species.genomes)]
		child = self:crossover(g1, g2)
	else
		g = species.genomes[math.random(1, #species.genomes)]
		child = self:copyGenome(g)
	end
 
	self:mutate(child)
 
	return child
end

function AI:removeStaleSpecies()
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

function AI:removeWeakSpecies()
	local survived = {}
 
	local sum = self:totalAverageFitness()
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * Population)
		if breed >= 1 then
			table.insert(survived, species)
		end
	end
 
	pool.species = survived
end

function AI:addToSpecies(child)
	local foundSpecies = false
	for s=1,#pool.species do
		local species = pool.species[s]
		if not foundSpecies and self:sameSpecies(child, species.genomes[1]) then
			table.insert(species.genomes, child)
			foundSpecies = true
		end
	end
 
	if not foundSpecies then
		local childSpecies = self:newSpecies()
		table.insert(childSpecies.genomes, child)
		table.insert(pool.species, childSpecies)
	end
end

function AI:newGeneration()
	self:cullSpecies(false) -- Cull the bottom half of each species
	self:rankGlobally()
	self:removeStaleSpecies()
	self:rankGlobally()
	for s = 1,#pool.species do
		local species = pool.species[s]
		self:calculateAverageFitness(species)
	end
	self:removeWeakSpecies()
	local sum = self:totalAverageFitness()
	local children = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * Population) - 1
		for i=1,breed do
			table.insert(children, self:breedChild(species))
		end
	end
	self:cullSpecies(true) -- Cull all but the top member of each species
	while #children + #pool.species < Population do
		local species = pool.species[math.random(1, #pool.species)]
		table.insert(children, self:breedChild(species))
	end
	for c=1,#children do
		local child = children[c]
		self:addToSpecies(child)
	end
 
	pool.generation = pool.generation + 1
 
	-- writeFile("backup." .. pool.generation .. "." .. forms.gettext(saveLoadFile))
end

function AI:initializePool()
	pool = self:newPool()
 
	for i=1,Population do
		basic = self:basicGenome()
		self:addToSpecies(basic)
	end
 
	self:initializeRun()
end

function AI:clearJoypad()
	controller = {}
	for b = 1,#ButtonNames do
		controller["P1 " .. ButtonNames[b]] = false
	end
	self:do_action(controller)
	-- joypad.set(controller)
end

function AI:initializeRun()
	-- savestate.load(Filename);
	rightmost = 0
	pool.currentFrame = 0
	timeout = TimeoutConstant
	self:clearJoypad()
 
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	self:generateNetwork(genome)
	self:evaluateCurrent()
end

function AI:evaluateCurrent()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
 
	inputs = self:getInputs()
	controller = self:evaluateNetwork(genome.network, inputs)
 
	if controller["P1 Left"] and controller["P1 Right"] then
		controller["P1 Left"] = false
		controller["P1 Right"] = false
	end
	if controller["P1 Up"] and controller["P1 Down"] then
		controller["P1 Up"] = false
		controller["P1 Down"] = false
	end

	self:do_action(controller)

	--joypad.set(controller)
end

-- if pool == nil then
-- 	initializePool()
-- end

function AI:nextGenome()
	pool.currentGenome = pool.currentGenome + 1
	if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
		pool.currentGenome = 1
		pool.currentSpecies = pool.currentSpecies+1
		if pool.currentSpecies > #pool.species then
			self:newGeneration()
			pool.currentSpecies = 1
		end
	end
end

function AI:fitnessAlreadyMeasured()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
 
	return genome.fitness ~= 0
end

function AI:displayGenome(genome)
	local network = genome.network
	local cells = {}
	local i = 1
	local cell = {}
	for dy=-BoxRadius,BoxRadius do
		for dx=-BoxRadius,BoxRadius do
			cell = {}
			cell.x = 50+5*dx
			cell.y = 70+5*dy
			cell.value = network.neurons[i].value
			cells[i] = cell
			i = i + 1
		end
	end
	local biasCell = {}
	biasCell.x = 80
	biasCell.y = 110
	biasCell.value = network.neurons[Inputs].value
	cells[Inputs] = biasCell
 
	for o = 1,Outputs do
		cell = {}
		cell.x = 220
		cell.y = 30 + 8 * o
		cell.value = network.neurons[MaxNodes + o].value
		cells[MaxNodes+o] = cell
		local color
		if cell.value > 0 then
			color = 0xFF0000FF
		else
			color = 0xFF000000
		end
		love.graphics.print(ButtonNames[o], 223, 24+8*o, color, 9)
	end
 
	for n,neuron in pairs(network.neurons) do
		cell = {}
		if n > Inputs and n <= MaxNodes then
			cell.x = 140
			cell.y = 40
			cell.value = neuron.value
			cells[n] = cell
		end
	end
 
	for n=1,4 do
		for _,gene in pairs(genome.genes) do
			if gene.enabled then
				local c1 = cells[gene.into]
				local c2 = cells[gene.out]
				if gene.into > Inputs and gene.into <= MaxNodes then
					c1.x = 0.75*c1.x + 0.25*c2.x
					if c1.x >= c2.x then
						c1.x = c1.x - 40
					end
					if c1.x < 90 then
						c1.x = 90
					end
 
					if c1.x > 220 then
						c1.x = 220
					end
					c1.y = 0.75*c1.y + 0.25*c2.y
 
				end
				if gene.out > Inputs and gene.out <= MaxNodes then
					c2.x = 0.25*c1.x + 0.75*c2.x
					if c1.x >= c2.x then
						c2.x = c2.x + 40
					end
					if c2.x < 90 then
						c2.x = 90
					end
					if c2.x > 220 then
						c2.x = 220
					end
					c2.y = 0.25*c1.y + 0.75*c2.y
				end
			end
		end
	end

	love.graphics.rectangle('line', 50-BoxRadius*5-3,70-BoxRadius*5-3,50+BoxRadius*5+2,70+BoxRadius*5+2,0xFF000000, 0x80808080)
	for n,cell in pairs(cells) do
		if n > Inputs or cell.value ~= 0 then
			local color = math.floor((cell.value+1)/2*256)
			if color > 255 then color = 255 end
			if color < 0 then color = 0 end
			local opacity = 0xFF000000
			if cell.value == 0 then
				opacity = 0x50000000
			end
			color = opacity + color*0x10000 + color*0x100 + color
			love.graphics.rectangle('line', cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
		end
	end
	for _,gene in pairs(genome.genes) do
		if gene.enabled then
			local c1 = cells[gene.into]
			local c2 = cells[gene.out]
			local opacity = 0xA0000000
			if c1.value == 0 then
				opacity = 0x20000000
			end
 
			local color = 0x80-math.floor(math.abs(sigmoid(gene.weight))*0x80)
			if gene.weight > 0 then 
				color = opacity + 0x8000 + 0x10000*color
			else
				color = opacity + 0x800000 + 0x100*color
			end
			love.graphics.line(c1.x+1, c1.y, c2.x-3, c2.y, color)
		end
	end

	love.graphics.rectangle('line', 49,71,51,78,0x00000000,0x80FF0000)
 
	if forms.ischecked(showMutationRates) then
		local pos = 100
		for mutation,rate in pairs(genome.mutationRates) do
			love.graphics.print(mutation .. ": " .. rate, 100, pos, 0xFF000000, 10)
			pos = pos + 8
		end
	end
end

function AI:writeFile(filename)
    local file = io.open(filename, "w")
	file:write(pool.generation .. "\n")
	file:write(pool.maxFitness .. "\n")
	file:write(#pool.species .. "\n")
        for n,species in pairs(pool.species) do
		file:write(species.topFitness .. "\n")
		file:write(species.staleness .. "\n")
		file:write(#species.genomes .. "\n")
		for m,genome in pairs(species.genomes) do
			file:write(genome.fitness .. "\n")
			file:write(genome.maxneuron .. "\n")
			for mutation,rate in pairs(genome.mutationRates) do
				file:write(mutation .. "\n")
				file:write(rate .. "\n")
			end
			file:write("done\n")
 
			file:write(#genome.genes .. "\n")
			for l,gene in pairs(genome.genes) do
				file:write(gene.into .. " ")
				file:write(gene.out .. " ")
				file:write(gene.weight .. " ")
				file:write(gene.innovation .. " ")
				if(gene.enabled) then
					file:write("1\n")
				else
					file:write("0\n")
				end
			end
		end
        end
        file:close()
end

function AI:savePool()
	local filename = forms.gettext(saveLoadFile)
	writeFile(filename)
end

function AI:loadFile(filename)
    local file = io.open(filename, "r")
	pool = newPool()
	pool.generation = file:read("*number")
	pool.maxFitness = file:read("*number")
	forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
        local numSpecies = file:read("*number")
        for s=1,numSpecies do
		local species = newSpecies()
		table.insert(pool.species, species)
		species.topFitness = file:read("*number")
		species.staleness = file:read("*number")
		local numGenomes = file:read("*number")
		for g=1,numGenomes do
			local genome = newGenome()
			table.insert(species.genomes, genome)
			genome.fitness = file:read("*number")
			genome.maxneuron = file:read("*number")
			local line = file:read("*line")
			while line ~= "done" do
				genome.mutationRates[line] = file:read("*number")
				line = file:read("*line")
			end
			local numGenes = file:read("*number")
			for n=1,numGenes do
				local gene = newGene()
				table.insert(genome.genes, gene)
				local enabled
				gene.into, gene.out, gene.weight, gene.innovation, enabled = file:read("*number", "*number", "*number", "*number", "*number")
				if enabled == 0 then
					gene.enabled = false
				else
					gene.enabled = true
				end
 
			end
		end
	end
        file:close()
 
	while self:fitnessAlreadyMeasured() do
		self:nextGenome()
	end
	self:initializeRun()
	pool.currentFrame = pool.currentFrame + 1
end

function AI:loadPool()
	local filename = forms.gettext(saveLoadFile)
	loadFile(filename)
end

function AI:playTop()
	local maxfitness = 0
	local maxs, maxg
	for s,species in pairs(pool.species) do
		for g,genome in pairs(species.genomes) do
			if genome.fitness > maxfitness then
				maxfitness = genome.fitness
				maxs = s
				maxg = g
			end
		end
	end
 
	pool.currentSpecies = maxs
	pool.currentGenome = maxg
	pool.maxFitness = maxfitness
	forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
	self:initializeRun()
	pool.currentFrame = pool.currentFrame + 1
	return
end

function AI:onExit()
	forms.destroy(form)
end

-- writeFile("temp.pool")
 
-- event.onexit(onExit)
 
-- form = forms.newform(200, 260, "Fitness")
-- maxFitnessLabel = forms.label(form, "Max Fitness: " .. math.floor(pool.maxFitness), 5, 8)
-- showNetwork = forms.checkbox(form, "Show Map", 5, 30)
-- showMutationRates = forms.checkbox(form, "Show M-Rates", 5, 52)
-- restartButton = forms.button(form, "Restart", initializePool, 5, 77)
-- saveButton = forms.button(form, "Save", savePool, 5, 102)
-- loadButton = forms.button(form, "Load", loadPool, 80, 102)
-- saveLoadFile = forms.textbox(form, Filename .. ".pool", 170, 25, nil, 5, 148)
-- saveLoadLabel = forms.label(form, "Save/Load:", 5, 129)
-- playTopButton = forms.button(form, "Play Top", playTop, 5, 170)
-- hideBanner = forms.checkbox(form, "Hide Banner", 5, 190)
 

function AI:neatAlgo()
	-- initializePool()
	local counter = 0
	while true do
		local backgroundColor = 0xD0FFFFFF
		-- if not forms.ischecked(hideBanner) then
		-- 	gui.drawBox(0, 0, 300, 26, backgroundColor, backgroundColor)
		-- end
	 
		local species = pool.species[pool.currentSpecies]
		local genome = species.genomes[pool.currentGenome]

--		self:displayGenome(genome)
		-- if forms.ischecked(showNetwork) then
		-- 	displayGenome(genome)
		-- end
	 
		-- if pool.currentFrame%5 == 0 then
		-- 	evaluateCurrent()
		-- end
		self:evaluateCurrent()
	 
		-- joypad.set(controller)
	 
		self:getPositions()
		if marioX > rightmost then
			rightmost = marioX
			timeout = TimeoutConstant
		end
	 
		timeout = timeout - 1
	 
	 
		local timeoutBonus = pool.currentFrame / 4
		if timeout + timeoutBonus <= 0 then
			local fitness = rightmost - pool.currentFrame / 2

			if rightmost > 3186 then
				fitness = fitness + 1000
			end
			if fitness == 0 then
				fitness = -1
			end
			genome.fitness = fitness
	 
			if fitness > pool.maxFitness then
				pool.maxFitness = fitness
				-- forms.settext(maxFitnessLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
				-- writeFile("backup." .. pool.generation .. "." .. forms.gettext(saveLoadFile))
			end
	 
			print("Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " fitness: " .. fitness)
			pool.currentSpecies = 1
			pool.currentGenome = 1
			while self:fitnessAlreadyMeasured() do
				self:nextGenome()
			end
			self:initializeRun()
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
--	 if True then
--	 	gui.drawText(0, 0, "Gen " .. pool.generation .. " species " .. pool.currentSpecies .. " genome " .. pool.currentGenome .. " (" .. math.floor(measured/total*100) .. "%)", 0xFF000000, 11)
--	 	gui.drawText(0, 12, "Fitness: " .. math.floor(rightmost - (pool.currentFrame) / 2 - (timeout + timeoutBonus)*2/3), 0xFF000000, 11)
--	 	gui.drawText(100, 12, "Max Fitness: " .. math.floor(pool.maxFitness), 0xFF000000, 11)
--	 end
 
	pool.currentFrame = pool.currentFrame + 1
 	counter = counter + 1
 	if counter == 10 then
 		return
 	end
	-- emu.frameadvance();
	end
end