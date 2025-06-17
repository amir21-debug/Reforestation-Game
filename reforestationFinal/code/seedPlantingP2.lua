local seedPlantingP2 = {}

function seedPlantingP2.load(selectedSeedTypes)
    
    seedPlantingP2.plantedHoles = {}
    seedPlantingP2.seedArray = {}

    seedPlantingP2.selectedSeedTypes = selectedSeedTypes or {"acacia"}

    seedPlantingP2.seedImages = {
        acacia = love.graphics.newImage("images/acaciaSeed.png"),
        africanOlive = love.graphics.newImage("images/africanOliveSeed.png"),
        cedar = love.graphics.newImage("images/cedarSeed.png")
    }

    seedPlantingP2.saplingImages = {
        acacia = love.graphics.newImage("images/acaciaSapling.png"),
        africanOlive = love.graphics.newImage("images/africanOliveSapling.png"),
        cedar = love.graphics.newImage("images/cedarSapling.png")
    }
   

    seedPlantingP2.treeImages = {
        acacia = love.graphics.newImage("images/Acacia Tree.png"),
        africanOlive = love.graphics.newImage("images/Olive Tree.png"),
        cedar = love.graphics.newImage("images/Cedar Tree.png")
    }

    seedPlantingP2.holeImage = love.graphics.newImage("images/hole.png")
    seedPlantingP2.holeImage2 = love.graphics.newImage("images/hole2.png")
    seedPlantingP2.soil = love.graphics.newImage("images/plantedSoil.PNG")

    seedPlantingP2.background = P2S1gamebackground


    seedPlantingP2.plantedSeeds = {}
    seedPlantingP2.coveredHoles = {}
    seedPlantingP2.saplingCount = 0
    seedPlantingP2.gameCompleted = false
end


function seedPlantingP2.draw()
    
    
    -- Draw holes first
    if seedPlantingP2.holePositions then
        for i, hole in ipairs(seedPlantingP2.holePositions) do
            if not seedPlantingP2.plantedHoles[i] then
                if seedPlantingP2.plantedSeeds[i].state ~= "planted" then
                    love.graphics.draw(seedPlantingP2.holeImage, hole.x, hole.y)
                end
            end
        end
    end
    
    -- Then draw seeds over the holes if they're planted
    for _, seed in ipairs(seedPlantingP2.plantedSeeds) do
        local saplingScale = 1
        local offsetX, offsetY = 0, -10

        if seed.type == "cedar" then
            saplingScale = 0.9
            offsetY = -15
        elseif seed.type == "africanOlive" then
            saplingScale = 0.9
            offsetY = -15
        elseif seed.type == "acacia" then
            saplingScale = 0.9
            offsetY = -15
        end

        if seed.state == "seed" then
            love.graphics.draw(seed.image, seed.x + 15, seed.y + 5, 0, 0.5, 0.5) -- scale to 50%
        elseif seed.state == "covered" then
           local scaleX = 36 / seedPlantingP2.soil:getWidth()
           local scaleY = 36 / seedPlantingP2.soil:getHeight()
           love.graphics.draw(seedPlantingP2.soil, seed.x-1, seed.y-5, 0, scaleX * 1.9 , scaleY *1.9)
           -- Draw sapling on top of the soil
           love.graphics.draw(seed.saplingImage, seed.x + offsetX, seed.y + offsetY, 0, saplingScale, saplingScale)
        elseif seed.state =="planted" then
            --do nothing; stop rendering the dirt
        
       -- elseif seed.state == "sapling" then
        --    love.graphics.draw(seed.saplingImage, seed.x + offsetX, seed.y + offsetY, 0, saplingScale, saplingScale)
        end
    end
end

function seedPlantingP2.mousepressed(x, y, button)
    if button == 1 then
        for i, hole in ipairs(seedPlantingP2.holePositions) do
            if not seedPlantingP2.coveredHoles[i] then
                if x >= hole.x and x <= hole.x + 36 and y >= hole.y and y <= hole.y + 36 then
                    local seedOptions = seedPlantingP2.selectedSeedTypes
                    local seedType = seedOptions[math.random(#seedOptions)]

                    table.insert(seedPlantingP2.plantedSeeds, {
                        x = hole.x,
                        y = hole.y,
                        state = "covered",
                        timer = 0,
                        seedType = seedType
                    })

                    seedPlantingP2.coveredHoles[i] = true
                    return
                end
            end
        end
    end
end

function seedPlantingP2.setSelectedSeedType(seedType)
    seedPlantingP2.selectedSeedTypes = {seedType}
end

function seedPlantingP2.spawnSeeds(selectedSeedTypes, loggingStageData)
    local i = 0
    local tilewidth = 36
    local tileheight = 36
    
    local holeCoords = {}
    
    -- If loggingStage is provided, use the hole positions from cut trees
    if loggingStageData and loggingStageData.trees then
        for _, tree in ipairs(loggingStageData.trees) do
            if tree.cut then
                -- Calculate tile coordinates from pixel coordinates
                local tileX = math.floor((tree.x + tree.width/2) / tilewidth)
                local tileY = math.floor((tree.y + tree.height) / tileheight)
                
                table.insert(holeCoords, {x = tileX, y = tileY})
            end
        end
    end
    
    -- If no holes were found from loggingStage (or it wasn't provided), use default positions
    if #holeCoords == 0 then
        holeCoords = {
            {x = 2, y = 2}, {x = 6, y = 2}, {x = 10, y = 2}, {x = 14, y = 2}, {x = 18, y = 2},
            {x = 2, y = 6}, {x = 6, y = 6}, {x = 10, y = 6}, {x = 14, y = 6}, {x = 18, y = 6},
            {x = 2, y = 10}, {x = 6, y = 10}, {x = 10, y = 10}, {x = 14, y = 10}, {x = 18, y = 10}
        }
    end
    
    -- Store the hole positions for reference
    seedPlantingP2.holePositions = {}
    for _, coord in ipairs(holeCoords) do
        table.insert(seedPlantingP2.holePositions, {
            x = coord.x * tilewidth,
            y = coord.y * tileheight
        })
    end

    seedPlantingP2.plantedSeeds = {}

    for _, coord in ipairs(holeCoords) do
        local choice = selectedSeedTypes[math.random(#selectedSeedTypes)]
        seedPlantingP2.seedArray[i] = choice
        table.insert(seedPlantingP2.plantedSeeds, {
            type = choice,
            x = coord.x * tilewidth,
            y = coord.y * tileheight,
            image = seedPlantingP2.seedImages[choice],
            saplingImage = seedPlantingP2.saplingImages[choice],
            treeImage = seedPlantingP2.treeImages[choice],
            state = "seed"
        })
        i = i + 1
    end
end
return seedPlantingP2
