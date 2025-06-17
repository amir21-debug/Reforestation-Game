local seedPlanting = {}


function seedPlanting.load(selectedSeedType)
    -- Define tile dimensions
    local tilewidth = 36  
    local tileheight = 36  
    
    -- Load images
    
    if selectedSeedType == "acacia" then
        seedPlanting.seed = love.graphics.newImage("images/acaciaSeed.png")
         seedPlanting.sapling = love.graphics.newImage("images/acaciaSapling.png")
    elseif selectedSeedType == "africanOlive" then
        seedPlanting.seed = love.graphics.newImage("images/africanOliveSeed.png")
        seedPlanting.sapling = love.graphics.newImage("images/africanOliveSapling.png")
    elseif selectedSeedType == "cedar" then
        seedPlanting.seed = love.graphics.newImage("images/cedarSeed.png")
        seedPlanting.sapling = love.graphics.newImage("images/cedarSapling.png")
    end
    seedPlanting.soil = love.graphics.newImage("images/plantedSoil.PNG")
    seedPlanting.background = love.graphics.newImage("images/stage5.png")  
    seedPlanting.pestsDestroyed = 0  -- Track how many pests have been destroyed
    seedPlanting.maxPestsDestroyed = 7  -- Set the target number of pests to destroy

    seedPlanting.gamestate5seedtype=""
    local flag=0

    -- Track planted seeds
    seedPlanting.plantedSeeds = {}
    -- track covered holes
    seedPlanting.plantedHoles = {}

    -- Pest mechanics
    seedPlanting.pests = {}
    seedPlanting.pestSpawnRate = 2 
    seedPlanting.pestSpawnTimer = 0
    seedPlanting.pestImages = {
        goat = love.graphics.newImage("images/goat.png"),
        locust = love.graphics.newImage("images/locust.png"),
        termite = love.graphics.newImage("images/termite.png")
    }
    seedPlanting.pestSpeed = 40
    seedPlanting.pestDamageTime = 2
    seedPlanting.pestsSpawned = false  
    
    -- Game state
    seedPlanting.saplingCount = 0
    seedPlanting.targetSaplings = 10
    seedPlanting.gameCompleted = false

    -- Animation timing
    seedPlanting.seedCoverDelay = 0.2
    seedPlanting.saplingGrowTime = 0.2
    
    -- Hole positions
    seedPlanting.holePositions = {
        {x = 36, y = 380 + 72, redX = "redX1"},   
        {x = 216, y = 380 + 72, redX = "redX2"},  
        {x = 324, y = 380 + 72, redX = "redX3"},  
        {x = 504, y = 380 + 72, redX = "redX4"},  
        {x = 648, y = 380 + 72, redX = "redX5"},  
        {x = 36, y = 380 + 144, redX = "redX11"},  
        {x = 216, y = 380 + 144, redX = "redX12"}, 
        {x = 324, y = 380 + 144, redX = "redX13"}, 
        {x = 504, y = 380 + 144, redX = "redX14"}, 
        {x = 648, y = 380 + 144, redX = "redX15"}  
    }

    -- Dialogue
    seedPlanting.dialogue = "Great! Now click on the holes to plant your seeds."

    -- Seed tracking
    seedPlanting.selectedSeedType = "acacia" -- will be updated
    --co;unter visibility tag
    seedPlanting.showCounter = false
end

function seedPlanting.update(dt)
    for _, seed in ipairs(seedPlanting.plantedSeeds) do
        if seed.state == "covered" and seed.timer then
            seed.timer = seed.timer + dt
            if seed.timer >= 0.2 then
                seed.state = "sapling"
                if not seed.counted then
                    seedPlanting.saplingCount = seedPlanting.saplingCount + 1
                    seed.counted = true
                end
            end
        end
    end

    -- Check if all seeds are planted
    if seedPlanting.saplingCount >= seedPlanting.targetSaplings and not seedPlanting.explanationShown then
        seedPlanting.dialogue = "All seeds planted! Now, watch out for pests that can destroy your forest!"
        seedPlanting.explanationShown = true
        seedPlanting.dialogueTimer = 0
    end

    -- Display pest explanation dialogue
    if seedPlanting.explanationShown and seedPlanting.dialogueTimer < 4 then
        seedPlanting.dialogue = "Pests can destroy our hard work. Goats eat saplings, locusts eat leaves, and termites dig deep into the ground to destroy tree roots. Click on the pests to remove them and protect your forest!"
        seedPlanting.dialogueTimer = seedPlanting.dialogueTimer + dt
    elseif seedPlanting.explanationShown and seedPlanting.dialogueTimer >= 4 then
        -- After the explanation, allow pests to spawn and the player to interact
        seedPlanting.pestsSpawned = true
       -- seedPlanting.dialogue = "All seeds planted! Now protect your saplings from pests!"
    end
    
    -- Stop spawning pests if target pests are destroyed
    if seedPlanting.pestsDestroyed >= seedPlanting.maxPestsDestroyed then
        seedPlanting.dialogue = "Great job! You've protected the saplings. Proceeding to the next stage."
        seedPlanting.pestsSpawned = false
        seedPlanting.gameCompleted = true
        return
    end
    -- Update pests if they have spawned
    if seedPlanting.pestsSpawned then
        seedPlanting.pestSpawnTimer = seedPlanting.pestSpawnTimer + dt
        if seedPlanting.pestSpawnTimer >= seedPlanting.pestSpawnRate then
            seedPlanting.spawnPest()
            seedPlanting.pestSpawnTimer = 0
        end

        for i = #seedPlanting.pests, 1, -1 do
            local pest = seedPlanting.pests[i]
            if pest.targetSapling then
                local dx = pest.targetSapling.x - pest.x
                local dy = pest.targetSapling.y - pest.y
                local dist = math.sqrt(dx * dx + dy * dy)

                if dist > 5 then
                    pest.x = pest.x + (dx / dist) * seedPlanting.pestSpeed * dt
                    pest.y = pest.y + (dy / dist) * seedPlanting.pestSpeed * dt
                else
                    pest.timer = pest.timer + dt
                    if pest.timer >= seedPlanting.pestDamageTime then
                        seedPlanting.damageSapling(pest.targetSapling)
                        table.remove(seedPlanting.pests, i)
                    end
                end
            end
        end
    end
end

function seedPlanting.draw()
    -- Draw background
    love.graphics.draw(seedPlanting.background, 0, 0, 0, love.graphics.getWidth() / seedPlanting.background:getWidth(), love.graphics.getHeight() / seedPlanting.background:getHeight())

    for i, hole in ipairs(seedPlanting.holePositions) do
        if seedPlanting.plantedHoles[i] then
            love.graphics.draw(seedPlanting.soil, hole.x, hole.y)
        else
            love.graphics.draw(seedPlanting.seed, hole.x, hole.y)
        end
    end

    for _, seed in ipairs(seedPlanting.plantedSeeds) do
      
      local saplingScale = 1;
      local offsetX, offsetY = 0, -10
      if seedPlanting.selectedSeedType == "cedar" then
        saplingScale = 0.9
        offsetY = -15
    
    elseif seedPlanting.selectedSeedType == "africanOlive" then
        saplingScale = 0.9
        offsetY = -15

    elseif seedPlanting.selectedSeedType == "acacia" then
        saplingScale = 0.9
        offsetY = -15
  
    end
    
        if seed.state == "seed" then
            love.graphics.draw(seedPlanting.seed, seed.x, seed.y)
        elseif seed.state == "covered" then
            love.graphics.draw(seedPlanting.soil, seed.x, seed.y)
        end
        if seed.state == "sapling" then
         love.graphics.draw(seedPlanting.sapling, seed.x + offsetX, seed.y + offsetY, 0, saplingScale, saplingScale)
        end
    end

    -- Draw pests
    for _, pest in ipairs(seedPlanting.pests) do
        local scale = 1
        if pest.type == "locust" then
            scale = 0.2 
        elseif pest.type == "termite" then
            scale = 0.2
        elseif pest.type == "goat" then
            scale = 0.3 
        end
        love.graphics.draw(seedPlanting.pestImages[pest.type], pest.x, pest.y, 0, scale, scale)
    end
      
    -- Display the counter in the top-left corner
    local counterText = "Pests Removed: " .. seedPlanting.pestsDestroyed .. "/7"
    local x, y = 10, 10
    love.graphics.setFont(font2)
    
    -- Draw black shadow for outline effect
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(counterText, x - 1, y - 1)
    love.graphics.print(counterText, x + 1, y - 1)
    love.graphics.print(counterText, x - 1, y + 1)
    love.graphics.print(counterText, x + 1, y + 1)
    
    -- Draw white text on top
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(counterText, x, y)
    love.graphics.setColor(1, 1, 1)
    
    -- Dialogue box
    if guideMonkeyVisible then
        love.graphics.draw(guideMonkey, 660, 50, 0, 1.2, 1.2)

        -- Default size of the text box
        local textWidth = 400
        local textHeight = 120  -- Default height

        -- If the dialogue is the one explaining pests, increase the height
        if seedPlanting.dialogue == "Pests can destroy our hard work. Goats eat saplings, locusts eat leaves, and termites dig deep into the ground to destroy tree roots. Click on the pests to remove them and protect your forest!" then
            textHeight = 170  -- Increase height for this specific dialogue
        end

        -- Position of the rectangle
        local rectX, rectY = 260, 30

        -- Draw rectangle for dialogue box
        love.graphics.setColor(1, 1, 1)  -- White background for the box
        love.graphics.rectangle("fill", rectX, rectY, textWidth, textHeight)  -- Rectangle for the dialogue box
        love.graphics.setColor(0, 0, 0)  -- Black border
        love.graphics.rectangle("line", rectX, rectY, textWidth, textHeight)  -- Border of the box

        -- Set the font for the dialogue
        love.graphics.setFont(font2)

        -- Draw the dialogue text inside the box with wrapping
        love.graphics.setColor(0, 0, 0)  -- Black text
        love.graphics.printf(seedPlanting.dialogue, rectX + 10, rectY + 10, textWidth - 20, "left")
        love.graphics.setColor(1, 1, 1)  -- Reset color
    end

    -- Completion message
    if seedPlanting.gameCompleted then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 200, 230, 400, 150)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(font4)
        love.graphics.print("FOREST RESTORED!", 200, 250)
        love.graphics.setFont(font3)
        love.graphics.print("Press SPACE to continue", 220, 300)
    end
end

function seedPlanting.spawnPest()
    local pestTypes = { "goat", "goat", "locust", "termite" }
    local pestType = pestTypes[math.random(#pestTypes)]

    -- Get random soil position
    local hole = seedPlanting.holePositions[math.random(#seedPlanting.holePositions)]
    local x = hole.x
    local y = hole.y

    local targetSapling
    if #seedPlanting.plantedSeeds > 0 then
        targetSapling = seedPlanting.plantedSeeds[math.random(#seedPlanting.plantedSeeds)]
    end

    table.insert(seedPlanting.pests, {
        type = pestType,
        x = x,
        y = y,  -- Keep pests on the soil level
        targetSapling = targetSapling,
        timer = 0
    })
end
function seedPlanting.mousepressed(x, y, button)
    if button == 1 then
      for _, seed in ipairs(seedPlanting.plantedSeeds) do
            if seed.state == "seed" and x >= seed.x and x <= seed.x + 36 and y >= seed.y and y <= seed.y + 36 then
                seed.state = "covered"
                seed.timer = 0
                return
            end
        end
        -- Check if player clicked on a pest
        for i = #seedPlanting.pests, 1, -1 do
            local pest = seedPlanting.pests[i]
            local scale = 1
            if pest.type == "locust" then
                scale = 0.2
            elseif pest.type == "termite" then
                scale = 0.2
            elseif pest.type == "goat" then
                scale = 0.3
            end

            -- Adjust the pest's size based on the scale
            local pestWidth = seedPlanting.pestImages[pest.type]:getWidth() * scale
            local pestHeight = seedPlanting.pestImages[pest.type]:getHeight() * scale

            -- Check if mouse click is within the pest's bounding box
            if x >= pest.x and x <= pest.x + pestWidth and
               y >= pest.y and y <= pest.y + pestHeight then
                -- Remove pest if clicked
                table.remove(seedPlanting.pests, i)
                seedPlanting.pestsDestroyed = seedPlanting.pestsDestroyed + 1  -- Increment destroyed pests count
                break
            end
        end
        
        -- Handle planting seeds if no pests were clicked
        for i, hole in ipairs(seedPlanting.holePositions) do
            if not seedPlanting.plantedHoles[i] then
                if x >= hole.x - 20 and x <= hole.x + 60 and 
                   y >= hole.y - 20 and y <= hole.y + 60 then
                    table.insert(seedPlanting.plantedSeeds, {
                        x = hole.x,
                        y = hole.y,
                        state = "covered",  -- Show soil first
                        timer = 0,
                        counted = false,
                        holeIndex = i,
                        replanted = true,
                        waitingForReplant = false
                    })
                    seedPlanting.plantedHoles[i] = true  -- Mark the hole as covered
                    return
                end
            end
        end
    end
end

function seedPlanting.setSelectedSeedType(seedType)
    seedPlanting.selectedSeedType = seedType
end
function seedPlanting.damageSapling(sapling)
     if sapling then
        sapling.state = "seed"
        sapling.timer = 0
        sapling.counted = false
        sapling.replanted = false
        
        sapling.image = seedPlanting.seed
        
        -- Decrease pest counter if a sapling is destroyed
        seedPlanting.pestsDestroyed = math.max(0, seedPlanting.pestsDestroyed - 1)
    end

end
return seedPlanting