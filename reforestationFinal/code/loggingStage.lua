-- loggingStage.lua
-- Module for the logging stage of the game

local loggingStage = {}

-- Make sure we can access the global gamestate variable
local function getGamestate()
    return _G.gamestate
end

-- Tables to hold trees and animals
loggingStage.trees = {}
loggingStage.animals = {}
loggingStage.treesToCut = {}
loggingStage.currentTargetTree = nil
loggingStage.cutTreeCount = 0
loggingStage.targetTreeMarker = nil
loggingStage.indicatorAlpha = 1
loggingStage.indicatorFadeDirection = -1
loggingStage.allTreesCut = false
loggingStage.showCompletionMessage = false
loggingStage.allTreesPhase = false
loggingStage.showSeedSelection = false
loggingStage.seedSelectionComplete = false
loggingStage.readyToPlant = false
loggingStage.selectedSeeds = {}
loggingStage.currentSeedForMinigame = nil
loggingStage.minigameBackground = nil
loggingStage.completionBackground = nil

-- Mini-game variables for gamestate 17
loggingStage.minigame = {
    barX = 200,
    barY = 300,
    barWidth = 400,
    barHeight = 40,
    hitZoneWidth = 60,
    hitZoneX = 400, -- Will be calculated to center the hit zone
    markerX = 200,
    markerWidth = 10,
    markerHeight = 50,
    markerSpeed = 200,
    markerDirection = 1,
    success = false,
    active = false,
    backgroundImage = nil -- Will be loaded when needed
}

-- Create a simple target marker using a canvas
local function createTargetMarker()
    local canvas = love.graphics.newCanvas(64, 64)
    love.graphics.setCanvas(canvas)
    
    -- Draw a green glow effect first
    love.graphics.setColor(0, 1, 0, 0.3)
    love.graphics.circle("fill", 32, 32, 30, 20)
    
    -- Draw green circle
    love.graphics.setColor(0, 1, 0, 0.8)
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", 32, 32, 25, 20)
    
    -- Draw X mark in the center
    love.graphics.setColor(1, 0, 0, 0.9)
    love.graphics.setLineWidth(4)
    love.graphics.line(20, 20, 44, 44)
    love.graphics.line(44, 20, 20, 44)
    
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    return canvas
end

-- Initialize the logging stage
function loggingStage.initialize()
    -- Clear any existing objects
    loggingStage.trees = {}
    loggingStage.animals = {}
    loggingStage.treesToCut = {}
    loggingStage.cutTreeCount = 0
    
    -- Load hole image instead of stump
    loggingStage.holeImage = love.graphics.newImage("images/hole2.png")
    
    -- Create tree data
    -- Trees will be positioned in a grid pattern similar to previous stages
    local tilewidth = 36
    local tileheight = 36
    
    -- Add trees in a pattern similar to other stages (moved down by increasing y values)
    local treePositions = {
        {x = 2, y = 4},  -- Top row (moved down)
        {x = 6, y = 4},
        {x = 10, y = 4},
        {x = 14, y = 4},
        {x = 18, y = 4},
        {x = 2, y = 8},  -- Middle row (moved down)
        {x = 6, y = 8},
        {x = 10, y = 8},
        {x = 14, y = 8},
        {x = 18, y = 8},
        {x = 2, y = 12}, -- Bottom row (moved down)
        {x = 6, y = 12},
        {x = 10, y = 12},
        {x = 14, y = 12},
        {x = 18, y = 12}
    }
    
    -- We'll use the fullgrown tree images that should already be loaded in main.lua
    local treeTypes = {
        "Cedar",
        "Acacia",
        "AfricanOlive"
    }
    
    -- Load tree images
    local cedarImage = love.graphics.newImage("images/Cedar Tree.png")
    local acaciaImage = love.graphics.newImage("images/Acacia Tree.png")
    local oliveImage = love.graphics.newImage("images/Olive Tree.png")
    
    -- Create trees
    for i, pos in ipairs(treePositions) do
        -- Randomly select a tree type
        local treeType = treeTypes[love.math.random(1, #treeTypes)]
        local treeImage
        
        if treeType == "Cedar" then
            treeImage = cedarImage
        elseif treeType == "Acacia" then
            treeImage = acaciaImage
        else
            treeImage = oliveImage
        end
        
        -- Add the tree with pixel coordinates
        table.insert(loggingStage.trees, {
            id = i,
            image = treeImage,
            x = pos.x * tilewidth,
            y = pos.y * tileheight - 70, -- Adjust y to account for tree height
            tileX = pos.x,
            tileY = pos.y,
            type = treeType,
            health = 100, -- Could be used for a cutting mechanic later
            marked = false,
            cut = false,
            width = treeImage:getWidth(),
            height = treeImage:getHeight()
        })
    end
    
    -- Load animal images
    local elephantImage = love.graphics.newImage("images/elephant1.png")
    local giraffeImage = love.graphics.newImage("images/giraffe.png")
    local zebraImage = love.graphics.newImage("images/zebra.png")
    local lionImage = love.graphics.newImage("images/lion.png")
    local deerImage = love.graphics.newImage("images/Deer.png")
    
    -- Create animals in various locations
    local animalData = {
        {sprite = elephantImage, x = 100, y = 300},
        {sprite = giraffeImage, x = 320, y = 260},
        {sprite = zebraImage, x = 400, y = 500},
        {sprite = lionImage, x = 600, y = 450},
        {sprite = deerImage, x = 200, y = 150}
    }
    
    -- Add all animals to the stage with more movement
    for _, animal in ipairs(animalData) do
        table.insert(loggingStage.animals, {
            sprite = animal.sprite,
            x = animal.x,
            y = animal.y,
            speedX = love.math.random(-30, 30), -- Faster speeds for more movement
            speedY = love.math.random(-30, 30),
            movementTimer = 0,
            changeDirectionInterval = love.math.random(2, 5) -- Change direction every 2-5 seconds
        })
    end
    
    -- Select half of the trees to be cut
    selectTreesToCut()
    
    -- Load target indicator (using the canvas creation directly)
    loggingStage.targetTreeMarker = createTargetMarker()
    
    -- Load mini-game background image
    local success = false
    local possiblePaths = {
        "images/Minigameback.png",
        "images/MinigameBack.png",
        "images/minigameback.png",
        "images/minigame_back.png",
        "Minigameback.png", -- Try without images/ prefix
        "MinigameBack.png",
        "../images/Minigameback.png", -- Try different relative paths
        "../../images/Minigameback.png"
    }
    
    print("Attempting to load mini-game background image...")
    for _, path in ipairs(possiblePaths) do
        print("Trying path: " .. path)
        success, loggingStage.minigameBackground = pcall(function() 
            return love.graphics.newImage(path) 
        end)
        
        if success then
            print("Successfully loaded mini-game background from: " .. path)
            break
        else
            print("Failed to load from path: " .. path)
        end
    end
    
    if not success then
        print("WARNING: Could not load mini-game background image. Using fallback.")
    end
    
    -- Load completion screen background
    local completionBgPaths = {
        "images/Forest.png",
        "images/forest.png",
        "images/CompletionBackground.png",
        "images/completionbackground.png"
    }
    
    for _, path in ipairs(completionBgPaths) do
        local success, bg = pcall(function() 
            return love.graphics.newImage(path) 
        end)
        
        if success then
            print("Successfully loaded completion background from: " .. path)
            loggingStage.completionBackground = bg
            break
        end
    end
    
    if not loggingStage.completionBackground then
        print("WARNING: Could not load completion background. Will try again when needed.")
    end
    
    -- Set up any other stage variables here
    loggingStage.initialized = true
    
    print("Logging stage initialized with " .. #loggingStage.trees .. " trees and " .. 
          #loggingStage.animals .. " animals")
    print("Selected " .. #loggingStage.treesToCut .. " trees to cut")
    
    -- Select the first tree to cut
    selectNextTargetTree()
end

-- Randomly select half of the trees to be cut
function selectTreesToCut()
    -- Create an array of indices
    local indices = {}
    for i = 1, #loggingStage.trees do
        table.insert(indices, i)
    end
    
    -- Shuffle the indices
    for i = #indices, 2, -1 do
        local j = love.math.random(i)
        indices[i], indices[j] = indices[j], indices[i]
    end
    
    -- Select the first half of the trees
    for i = 1, math.ceil(#loggingStage.trees / 2) do
        local treeIndex = indices[i]
        table.insert(loggingStage.treesToCut, treeIndex)
        loggingStage.trees[treeIndex].marked = true
    end
end

-- Select the next tree to cut as the target
function selectNextTargetTree()
    -- If there are still trees to cut, select the next one
    if #loggingStage.treesToCut > 0 then
        -- Get a random tree from the trees to cut
        local randomIndex = love.math.random(#loggingStage.treesToCut)
        local treeIndex = loggingStage.treesToCut[randomIndex]
        
        -- Mark it as the current target
        loggingStage.currentTargetTree = treeIndex
        
        -- Remove it from the list of trees to cut
        table.remove(loggingStage.treesToCut, randomIndex)
        
        print("Selected tree " .. treeIndex .. " as the next target")
    else
        -- All trees have been cut
        loggingStage.currentTargetTree = nil
        loggingStage.allTreesCut = true
        loggingStage.showCompletionMessage = true
        print("All marked trees have been cut! Showing completion message.")
    end
end

-- Check if a tree is near the player
function loggingStage.isPlayerNearTargetTree(playerX, playerY)
    if not loggingStage.currentTargetTree then return false end
    
    local tree = loggingStage.trees[loggingStage.currentTargetTree]
    if not tree then return false end
    
    -- Debug information
    print("Player position: " .. playerX .. ", " .. playerY)
    print("Target tree tile position: " .. tree.tileX .. ", " .. tree.tileY)
    
    -- Simpler tile-based distance check
    local dx = math.abs(playerX - tree.tileX)
    local dy = math.abs(playerY - tree.tileY)
    
    -- Consider the player close if they're within 2 tiles of the tree's base
    local isNear = dx <= 2 and dy <= 2
    print("Is player near tree? " .. tostring(isNear) .. " (dx=" .. dx .. ", dy=" .. dy .. ")")
    
    return isNear
end

-- Cut the current target tree
function loggingStage.cutTargetTree()
    if not loggingStage.currentTargetTree then 
        print("No target tree selected")
        return false 
    end
    
    local tree = loggingStage.trees[loggingStage.currentTargetTree]
    if not tree then 
        print("Target tree not found")
        return false 
    end
    
    -- Mark the tree as cut
    tree.cut = true
    loggingStage.cutTreeCount = loggingStage.cutTreeCount + 1
    print("Tree cut successfully! Total cut: " .. loggingStage.cutTreeCount)
    
    -- Select the next tree to cut
    selectNextTargetTree()
    
    return true
end

-- Update function to move animals and update visual effects
function loggingStage.update(dt)
    -- Update animal positions
    for _, animal in ipairs(loggingStage.animals) do
        -- Timer for changing direction
        animal.movementTimer = animal.movementTimer + dt
        if animal.movementTimer >= animal.changeDirectionInterval then
            -- Change direction
            animal.speedX = love.math.random(-30, 30)
            animal.speedY = love.math.random(-30, 30)
            animal.movementTimer = 0
        end
        
        -- Move the animal
        animal.x = animal.x + animal.speedX * dt
        animal.y = animal.y + animal.speedY * dt
        
        -- Screen boundaries
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        
        -- Bounce off edges
        if animal.x < 0 then
            animal.x = 0
            animal.speedX = -animal.speedX
        elseif animal.x > screenWidth - animal.sprite:getWidth() then
            animal.x = screenWidth - animal.sprite:getWidth()
            animal.speedX = -animal.speedX
        end
        
        if animal.y < 0 then
            animal.y = 0
            animal.speedY = -animal.speedY
        elseif animal.y > screenHeight - animal.sprite:getHeight() then
            animal.y = screenHeight - animal.sprite:getHeight()
            animal.speedY = -animal.speedY
        end
    end
    
    -- Update target indicator pulsing effect
    loggingStage.indicatorAlpha = loggingStage.indicatorAlpha + loggingStage.indicatorFadeDirection * dt * 2
    if loggingStage.indicatorAlpha <= 0.4 then
        loggingStage.indicatorAlpha = 0.4
        loggingStage.indicatorFadeDirection = 1
    elseif loggingStage.indicatorAlpha >= 1 then
        loggingStage.indicatorAlpha = 1
        loggingStage.indicatorFadeDirection = -1
    end
    
    -- Check for player collision with seeds in gamestate 16
    if getGamestate() == 16 and loggingStage.savedSeeds then
        -- Get player position from global variables
        local playerX = _G.spritePlayer.tile_x
        local playerY = _G.spritePlayer.tile_y
        
        -- Check collision with each seed
        for i, seed in ipairs(loggingStage.savedSeeds) do
            -- Skip seeds that are already grown or triggered
            if seed.isGrown or seed.triggered then
                goto continue
            end
            
            -- Convert tile position to pixel coordinates for seed
            -- This uses the actual coordinates saved in the seed
            local seedTileX = math.floor(seed.x / 36)
            local seedTileY = math.floor(seed.y / 36)
            
            -- Add a margin to make collision detection more forgiving
            local margin = 1
            
            -- Check if player is standing on or very near the seed
            if math.abs(playerX - seedTileX) <= margin and 
               math.abs(playerY - seedTileY) <= margin then
                
                -- Mark this seed as triggered
                seed.triggered = true
                
                -- Set this seed as the current one for the mini-game
                loggingStage.currentSeedForMinigame = i
                
                -- Initialize the mini-game
                loggingStage.initMinigame()
                
                -- Switch to mini-game state
                _G.gamestate = 17
                
                print("Triggered mini-game for seed " .. i .. " at position " .. seedTileX .. "," .. seedTileY)
                
                -- Only trigger one seed at a time
                break
            end
            
            ::continue::
        end
        
        -- Check if all seeds are grown
        local allGrown = loggingStage.checkAllSeedsGrown()
        if allGrown then
            -- Switch to completion screen (gamestate 19)
            print("All trees grown! Moving to completion screen.")
            _G.gamestate = 19
        end
    end
end

-- Draw function to render target indicators and trees
function loggingStage.draw()
    -- If in replay mode (gamestate 16) use the special drawing function
    if getGamestate() == 16 and loggingStage.savedCutTrees then
        loggingStage.drawReplayScene()
        return
    end
    
    -- Draw all trees
    for i, tree in ipairs(loggingStage.trees) do
        -- Only draw trees that haven't been cut (or draw all cut trees in final phase)
        if not tree.cut or (loggingStage.allTreesPhase and tree.marked) then
            love.graphics.draw(tree.image, tree.x, tree.y)
            
            -- Draw target indicator over the current target tree (only when not in final phase)
            if not loggingStage.allTreesPhase and loggingStage.currentTargetTree and i == loggingStage.currentTargetTree then
                -- Draw a highlight around the tree
                love.graphics.setColor(0, 1, 0, 0.2 * loggingStage.indicatorAlpha)
                love.graphics.circle("fill", 
                                tree.x + tree.width/2, 
                                tree.y + tree.height - 30, 
                                50)
                
                -- Draw the target marker on top of the tree
                love.graphics.setColor(1, 1, 1, loggingStage.indicatorAlpha)
                love.graphics.draw(loggingStage.targetTreeMarker, 
                                tree.x + tree.width/2 - loggingStage.targetTreeMarker:getWidth()/2,
                                tree.y - 40)
                love.graphics.setColor(1, 1, 1, 1)
            end
        else
            -- Draw hole image instead of stump
            love.graphics.setColor(1, 1, 1)
            
            -- Position the hole where the tree was
            local holeWidth = loggingStage.holeImage:getWidth()
            local holeHeight = loggingStage.holeImage:getHeight()
            local holeX = tree.x + tree.width/2 - holeWidth/2
            local holeY = tree.y + tree.height - holeHeight/2
            
            love.graphics.draw(loggingStage.holeImage, holeX, holeY)
        end
    end
    
    -- If we're in planting mode, draw the seeds
    if loggingStage.readyToPlant and seedPlantingP2 then
        seedPlantingP2.draw()
    end
    
    -- Show completion message when all trees are cut
    if loggingStage.showCompletionMessage then
        -- Semi-transparent background for the message
        love.graphics.setColor(0, 0, 0, 0.7)
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        local boxWidth = 400
        local boxHeight = 100
        local boxX = (screenWidth - boxWidth) / 2
        local boxY = (screenHeight - boxHeight) / 2
        
        love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", boxX, boxY, boxWidth, boxHeight)
        
        -- Message text
        love.graphics.setFont(love.graphics.newFont(24))
        local message = "All trees cut!"
        local messageWidth = love.graphics.getFont():getWidth(message)
        love.graphics.print(message, screenWidth/2 - messageWidth/2, screenHeight/2 - 30)
        
        -- Press space text
        love.graphics.setFont(love.graphics.newFont(18))
        local spaceMessage = "Press SPACE to continue"
        local spaceMessageWidth = love.graphics.getFont():getWidth(spaceMessage)
        love.graphics.print(spaceMessage, screenWidth/2 - spaceMessageWidth/2, screenHeight/2 + 10)
    end
    
    -- Draw the seed selection overlay if active
    if loggingStage.showSeedSelection and seedSelectionOverlay then
        seedSelectionOverlay.draw()
    end
end

-- Function to handle space key press when all trees are cut
function loggingStage.continueToFinalPhase()
    if loggingStage.allTreesCut and loggingStage.showCompletionMessage then
        loggingStage.showCompletionMessage = false
        loggingStage.allTreesPhase = true
        
        -- Save the current state of trees before proceeding to seed selection
        loggingStage.savedCutTrees = {}
        for i, tree in ipairs(loggingStage.trees) do
            table.insert(loggingStage.savedCutTrees, {
                id = i,
                image = tree.image,
                x = tree.x,
                y = tree.y,
                tileX = tree.tileX,
                tileY = tree.tileY,
                type = tree.type,
                isCut = tree.cut,
                width = tree.width,
                height = tree.height
            })
        end
        
        -- Mark all trees as cut in the final phase
        for _, tree in ipairs(loggingStage.trees) do
            if not tree.marked then
                tree.cut = true
            end
        end
        
        -- Instead of transitioning to a new gamestate, show the seed selection overlay
        loggingStage.showSeedSelection = true
        
        -- Initialize the seed selection overlay if it's not already loaded
        if not seedSelectionOverlay then
            seedSelectionOverlay = require("code.seedSelectionOverlay")
            seedSelectionOverlay.load()
        end
        
        -- Show the seed selection overlay
        seedSelectionOverlay.show()
        
        return true
    end
    return false
end

-- Add a function to handle seed selection completion
function loggingStage.finishSeedSelection()
    if seedSelectionOverlay and seedSelectionOverlay.completed then
        -- Get the selected seeds
        loggingStage.selectedSeeds = seedSelectionOverlay.getSelectedSeeds()
        
        -- Hide the overlay
        seedSelectionOverlay.hide()
        
        -- Set up for planting phase
        loggingStage.seedSelectionComplete = true
        loggingStage.readyToPlant = true
        
        -- Create a structure to record which seeds are planted in which holes
        loggingStage.savedSeeds = {}
        
        -- Identify all cut tree positions (holes)
        local holePositions = {}
        for _, tree in ipairs(loggingStage.savedCutTrees) do
            if tree.isCut then
                -- Calculate hole position
                local holeWidth = loggingStage.holeImage:getWidth()
                local holeHeight = loggingStage.holeImage:getHeight()
                local holeX = tree.x + tree.width/2 - holeWidth/2
                local holeY = tree.y + tree.height - holeHeight/2
                
                table.insert(holePositions, {
                    x = holeX,
                    y = holeY,
                    tileX = tree.tileX,
                    tileY = tree.tileY
                })
            end
        end
        
        -- Associate each hole with a randomly selected seed
        for _, hole in ipairs(holePositions) do
            -- Randomly pick a seed type from the selected ones
            local seedType = loggingStage.selectedSeeds[love.math.random(#loggingStage.selectedSeeds)]
            
            -- Try different image paths to find a valid seed image
            local seedImg
            local attempts = {
                "images/" .. seedType .. "Seed.png",
                "images/" .. seedType .. " Seed.png",
                "images/CedarSeed.png" -- Fallback to default seed if others fail
            }
            
            for _, path in ipairs(attempts) do
                local success, img = pcall(function()
                    return love.graphics.newImage(path)
                end)
                
                if success then
                    seedImg = img
                    break
                end
            end
            
            -- If we still couldn't load an image, create a placeholder
            if not seedImg then
                -- Create a simple circular seed as fallback
                local canvas = love.graphics.newCanvas(16, 16)
                love.graphics.setCanvas(canvas)
                love.graphics.setColor(0.6, 0.4, 0.2)
                love.graphics.circle("fill", 8, 8, 6)
                love.graphics.setCanvas()
                love.graphics.setColor(1, 1, 1)
                seedImg = canvas
            end
            
            table.insert(loggingStage.savedSeeds, {
                x = hole.x,
                y = hole.y,
                tileX = hole.tileX,
                tileY = hole.tileY,
                seedType = seedType,
                image = seedImg,
                isGrown = false,
                triggered = false  -- Add a flag to track if this seed has been interacted with
            })
        end
        
        -- Initialize seedPlantingP2 module
        seedPlantingP2 = require("code.seedPlantingP2")
        seedPlantingP2.load(loggingStage.selectedSeeds)
        seedPlantingP2.spawnSeeds(loggingStage.selectedSeeds, loggingStage)
        
        -- Set up player planting mode
        loggingStage.plantingMode = true
        
        return true
    end
    return false
end

-- Check if player is overlapping with a seed
function loggingStage.checkPlayerSeedCollision(playerX, playerY)
    if not loggingStage.savedSeeds then
        return false
    end
    
    -- Player hitbox dimensions (assuming player sprite is roughly 32x32 pixels)
    local playerWidth = 32
    local playerHeight = 32
    
    for i, seed in ipairs(loggingStage.savedSeeds) do
        -- Skip seeds that are already grown
        if seed.isGrown then
            goto continue
        end
        
        -- Calculate seed hitbox (smaller than the full hole)
        local seedWidth = 20
        local seedHeight = 20
        
        -- Center the seed hitbox in the hole
        local holeWidth = loggingStage.holeImage:getWidth()
        local holeHeight = loggingStage.holeImage:getHeight()
        
        local seedHitboxX = seed.x + (holeWidth - seedWidth) / 2
        local seedHitboxY = seed.y + (holeHeight - seedHeight) / 2
        
        -- Check for collision (simple AABB collision detection)
        if playerX < seedHitboxX + seedWidth and
           playerX + playerWidth > seedHitboxX and
           playerY < seedHitboxY + seedHeight and
           playerY + playerHeight > seedHitboxY then
            
            -- Set this seed as the current one for the mini-game
            loggingStage.currentSeedForMinigame = i
            return true
        end
        
        ::continue::
    end
    
    return false
end

-- Initialize the mini-game for the current seed
function loggingStage.initMinigame()
    -- Reset mini-game state
    local minigame = loggingStage.minigame
    minigame.markerX = minigame.barX
    minigame.markerDirection = 1
    minigame.success = false
    minigame.active = true
    
    -- Share the background image loaded at initialization
    minigame.backgroundImage = loggingStage.minigameBackground
    
    -- Calculate hit zone position (centered in the bar)
    minigame.hitZoneX = minigame.barX + (minigame.barWidth - minigame.hitZoneWidth) / 2
    
    return true
end

-- Update the mini-game state
function loggingStage.updateMinigame(dt)
    local minigame = loggingStage.minigame
    
    -- Only update if the mini-game is active
    if not minigame.active then
        return
    end
    
    -- Move the marker
    minigame.markerX = minigame.markerX + minigame.markerSpeed * minigame.markerDirection * dt
    
    -- Reverse direction if marker hits the edges
    if minigame.markerX <= minigame.barX then
        minigame.markerX = minigame.barX
        minigame.markerDirection = 1
    elseif minigame.markerX >= minigame.barX + minigame.barWidth - minigame.markerWidth then
        minigame.markerX = minigame.barX + minigame.barWidth - minigame.markerWidth
        minigame.markerDirection = -1
    end
    
    -- Update retry message timer if active
    if minigame.showRetryMessage and minigame.retryMessageTimer > 0 then
        minigame.retryMessageTimer = minigame.retryMessageTimer - dt
        if minigame.retryMessageTimer <= 0 then
            minigame.showRetryMessage = false
        end
    end
end

-- Draw the mini-game
function loggingStage.drawMinigame()
    local minigame = loggingStage.minigame
    
    -- Draw the background
    if loggingStage.minigameBackground then
        -- Get the screen dimensions
        local screenWidth = love.graphics.getWidth()
        local screenHeight = love.graphics.getHeight()
        
        -- Scale the background to fit the screen
        local scaleX = screenWidth / loggingStage.minigameBackground:getWidth()
        local scaleY = screenHeight / loggingStage.minigameBackground:getHeight()
        
        -- Draw the background image
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(loggingStage.minigameBackground, 0, 0, 0, scaleX, scaleY)
    else
        -- Fall back to the semi-transparent background if image not loaded
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
    
    -- Draw title
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print("Grow the tree!", minigame.barX, minigame.barY - 50)
    
    -- Draw instructions
    love.graphics.setFont(love.graphics.newFont(18))
    love.graphics.print("Press SPACE when the marker is in the green zone", minigame.barX, minigame.barY - 80)
    
    -- Draw retry message if active
    if minigame.showRetryMessage then
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(1, 0.3, 0.3, 1) -- Red text for retry message
        love.graphics.print("Try again!", minigame.barX + minigame.barWidth/2 - 40, minigame.barY + 60)
        love.graphics.setColor(1, 1, 1, 1) -- Reset color
    end
    
    -- Draw the bar background
    love.graphics.setColor(0.7, 0.2, 0.2, 1) -- Red background
    love.graphics.rectangle("fill", minigame.barX, minigame.barY, minigame.barWidth, minigame.barHeight)
    
    -- Draw the hit zone
    love.graphics.setColor(0, 0.8, 0.2, 1) -- Green hit zone
    love.graphics.rectangle("fill", minigame.hitZoneX, minigame.barY, minigame.hitZoneWidth, minigame.barHeight)
    
    -- Draw the marker
    love.graphics.setColor(1, 1, 1, 1) -- White marker
    love.graphics.rectangle("fill", minigame.markerX, minigame.barY - 5, minigame.markerWidth, minigame.markerHeight)
end

-- Check if the marker is in the hit zone
function loggingStage.isMarkerInHitZone()
    local minigame = loggingStage.minigame
    
    return minigame.markerX >= minigame.hitZoneX and 
           minigame.markerX + minigame.markerWidth <= minigame.hitZoneX + minigame.hitZoneWidth
end

-- Handle the player's input for the mini-game
function loggingStage.handleMinigameInput()
    local minigame = loggingStage.minigame
    
    if loggingStage.isMarkerInHitZone() then
        minigame.success = true
        
        -- Grow the seed into a tree
        if loggingStage.currentSeedForMinigame and loggingStage.savedSeeds then
            local seed = loggingStage.savedSeeds[loggingStage.currentSeedForMinigame]
            if seed then
                seed.isGrown = true
                
                -- Get the original tree type for this position
                local treeType = seed.seedType
                local treeImage = nil
                
                -- Try to load the appropriate tree image
                if treeType == "cedar" then
                    treeImage = love.graphics.newImage("images/Cedar Tree.png")
                elseif treeType == "acacia" then
                    treeImage = love.graphics.newImage("images/Acacia Tree.png")
                elseif treeType == "africanOlive" then
                    treeImage = love.graphics.newImage("images/Olive Tree.png")
                end
                
                -- If we couldn't load the specific tree, use Cedar as fallback
                if not treeImage then
                    treeImage = love.graphics.newImage("images/Cedar Tree.png")
                end
                
                -- Save tree image and calculate exact position
                seed.treeImage = treeImage
                
                -- Get the tree's original width and height for positioning
                seed.treeWidth = treeImage:getWidth()
                seed.treeHeight = treeImage:getHeight()
                
                -- Calculate position to place tree exactly where the hole was
                -- Trees are typically drawn higher up than holes to account for height
                seed.treeX = seed.x - (seed.treeWidth / 2 - loggingStage.holeImage:getWidth() / 2)
                seed.treeY = seed.y - seed.treeHeight + 20 -- Adjust y-position to match base with hole
                
                -- Find the corresponding cut tree in savedCutTrees and update it
                for i, cutTree in ipairs(loggingStage.savedCutTrees) do
                    -- Convert both positions to the same format for comparison
                    local cutTreePosX = cutTree.x + cutTree.width/2 - loggingStage.holeImage:getWidth()/2
                    local cutTreePosY = cutTree.y + cutTree.height - loggingStage.holeImage:getHeight()/2
                    
                    if math.abs(cutTreePosX - seed.x) < 10 and math.abs(cutTreePosY - seed.y) < 10 then
                        -- Mark this tree as regrown, not just cut
                        cutTree.isCut = false
                        cutTree.isRegrown = true
                        cutTree.image = treeImage
                        break
                    end
                end
                
                print("Tree grown at position: " .. seed.treeX .. ", " .. seed.treeY)
            end
        end
        
        -- Play success sound if available
        if _G.taskCompleteNoiseOne then
            _G.taskCompleteNoiseOne:play()
        end
        
        -- Deactivate the mini-game and return to gamestate 16
        minigame.active = false
        return true
    else
        minigame.success = false
        
        -- Play error sound if available
        if _G.errornoise then
            _G.errornoise:play()
        end
        
        -- Reset the marker and stay in gamestate 17 for retry
        loggingStage.resetMinigame()
        
        -- Return false to indicate failure but don't exit the mini-game
        return false
    end
end

-- Reset the mini-game for retry
function loggingStage.resetMinigame()
    local minigame = loggingStage.minigame
    
    -- Reset marker position
    minigame.markerX = minigame.barX
    minigame.markerDirection = 1
    
    -- Keep the mini-game active for retry
    minigame.active = true
    minigame.success = false
    
    -- Show a retry message
    minigame.showRetryMessage = true
    minigame.retryMessageTimer = 2.0 -- Display for 2 seconds
    
    print("Mini-game reset for retry")
end

-- Function to draw the scene for gamestate 16 (replay of tree cutting)
function loggingStage.drawReplayScene()
    -- Draw all trees in their saved state
    if not loggingStage.savedCutTrees then
        return
    end
    
    for _, tree in ipairs(loggingStage.savedCutTrees) do
        if not tree.isCut then
            -- Draw intact tree (either original or regrown)
            love.graphics.draw(tree.image, tree.x, tree.y)
        else
            -- Draw hole image for cut trees
            love.graphics.setColor(1, 1, 1)
            
            -- Position the hole where the tree was
            local holeWidth = loggingStage.holeImage:getWidth()
            local holeHeight = loggingStage.holeImage:getHeight()
            local holeX = tree.x + tree.width/2 - holeWidth/2
            local holeY = tree.y + tree.height - holeHeight/2
            
            love.graphics.draw(loggingStage.holeImage, holeX, holeY)
        end
    end
    
    -- Draw the seeds in the holes or grown trees if they've been cultivated
    if loggingStage.savedSeeds then
        for _, seed in ipairs(loggingStage.savedSeeds) do
            if seed.isGrown and seed.treeImage then
                -- Draw grown tree using exact calculated position
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(seed.treeImage, seed.treeX, seed.treeY)
            else
                -- Only draw seeds in holes that haven't been grown yet
                love.graphics.setColor(1, 1, 1)
                
                -- Calculate position for better hole-centered placement
                -- First get hole dimensions
                local holeWidth = loggingStage.holeImage:getWidth()
                local holeHeight = loggingStage.holeImage:getHeight()
                
                -- Calculate scaled seed dimensions
                local scaledSeedWidth = seed.image:getWidth() * 0.5
                local scaledSeedHeight = seed.image:getHeight() * 0.5
                
                -- Calculate offsets to center the seed in the hole
                local offsetX = (holeWidth - scaledSeedWidth) / 2
                local offsetY = (holeHeight - scaledSeedHeight) / 2
                
                -- Add fine-tuning offsets for visual perfection (+8px horizontally, +4px vertically)
                offsetX = offsetX + 8
                offsetY = offsetY + 4
                
                -- Final seed position
                local seedX = seed.x + offsetX
                local seedY = seed.y + offsetY
                
                -- Draw with smaller scaling (50% of original size)
                love.graphics.draw(
                    seed.image, 
                    seedX, 
                    seedY, 
                    0,  -- rotation
                    0.5, -- scale X (50% of original size)
                    0.5  -- scale Y
                )
            end
        end
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

-- Store player position for debugging
function loggingStage.setPlayerPosition(x, y)
    loggingStage.playerX = x
    loggingStage.playerY = y
end

-- Check if all seeds are grown
function loggingStage.checkAllSeedsGrown()
    if not loggingStage.savedSeeds or #loggingStage.savedSeeds == 0 then
        return false
    end
    
    for _, seed in ipairs(loggingStage.savedSeeds) do
        if not seed.isGrown then
            return false
        end
    end
    
    return true
end

-- Draw the completion screen (gamestate 19)
function loggingStage.drawCompletionScreen()
    -- Get the screen dimensions
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    
    -- Try to load the background image if not already loaded
    if not loggingStage.completionBackground then
        local completionBgPaths = {
            "images/Forest.png",
            "images/forest.png",
            "images/CompletionBackground.png",
            "images/completionbackground.png"
        }
        
        for _, path in ipairs(completionBgPaths) do
            local success, bg = pcall(function() 
                return love.graphics.newImage(path) 
            end)
            
            if success then
                print("Successfully loaded completion background from: " .. path)
                loggingStage.completionBackground = bg
                break
            end
        end
    end
    
    -- Draw the background image
    love.graphics.setColor(1, 1, 1, 1)
    if loggingStage.completionBackground then
        -- Scale the background to fit the screen
        local scaleX = screenWidth / loggingStage.completionBackground:getWidth()
        local scaleY = screenHeight / loggingStage.completionBackground:getHeight()
        
        love.graphics.draw(loggingStage.completionBackground, 0, 0, 0, scaleX, scaleY)
    else
        -- Fallback to a gradient background if image cannot be loaded
        love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    end
    
    -- Calculate text area dimensions (80% of screen width)
    local textAreaWidth = screenWidth * 0.8
    local textAreaX = (screenWidth - textAreaWidth) / 2
    
    -- Use a smaller font for better wrapping
    local font = love.graphics.newFont(24) -- Smaller font than before
    love.graphics.setFont(font)
    
    -- Congratulations text with more details
    local congratsText = "Congratulations! You've fully restored the forest! Your careful management has created a thriving ecosystem where trees and wildlife can flourish for generations to come."
    
    -- Calculate text height based on wrapped text
    local textHeight = font:getHeight() * math.ceil(font:getWidth(congratsText) / textAreaWidth) * 1.5
    
    -- Draw text background
    local padding = 20
    local textBoxX = textAreaX - padding
    local textBoxY = screenHeight/2 - 100
    local textBoxWidth = textAreaWidth + (padding * 2)
    local textBoxHeight = textHeight + (padding * 2)
    
    -- Semi-transparent background for text
    love.graphics.setColor(0, 0, 0, 0.7) -- Black semi-transparent background
    love.graphics.rectangle("fill", textBoxX, textBoxY, textBoxWidth, textBoxHeight, 15, 15) -- Rounded corners
    love.graphics.setColor(0.3, 0.7, 0.3, 1) -- Green border
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", textBoxX, textBoxY, textBoxWidth, textBoxHeight, 15, 15)
    love.graphics.setLineWidth(1)
    
    -- Print wrapped text
    love.graphics.setColor(1, 1, 1, 1) -- White text
    love.graphics.printf(congratsText, textAreaX, textBoxY + padding, textAreaWidth, "center")
    
    -- Draw the Main Menu button
    local buttonWidth = 200
    local buttonHeight = 50
    local buttonX = screenWidth/2 - buttonWidth/2
    local buttonY = textBoxY + textBoxHeight + 30
    
    -- Button background
    loggingStage.mainMenuButtonX = buttonX
    loggingStage.mainMenuButtonY = buttonY
    loggingStage.mainMenuButtonWidth = buttonWidth
    loggingStage.mainMenuButtonHeight = buttonHeight
    
    -- Draw button with gradient and shadow for better appearance
    -- Button shadow
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", buttonX + 3, buttonY + 3, buttonWidth, buttonHeight, 10, 10)
    
    -- Button background
    local buttonGradientTop = {0.8, 0.3, 0.3, 1}
    local buttonGradientBottom = {0.6, 0.2, 0.2, 1}
    
    love.graphics.setColor(buttonGradientTop)
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight/2, 10, 10, 10, 0)
    love.graphics.setColor(buttonGradientBottom)
    love.graphics.rectangle("fill", buttonX, buttonY + buttonHeight/2, buttonWidth, buttonHeight/2, 0, 0, 10, 10)
    
    -- Button border
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight, 10, 10)
    
    -- Button text
    love.graphics.setFont(love.graphics.newFont(24))
    local buttonText = "Exit Game"
    local textWidth = love.graphics.getFont():getWidth(buttonText)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(buttonText, buttonX + (buttonWidth - textWidth)/2, buttonY + 12)
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

-- Check if a point is inside the main menu button
function loggingStage.isPointInMainMenuButton(x, y)
    if not loggingStage.mainMenuButtonX then
        return false
    end
    
    return x >= loggingStage.mainMenuButtonX and
           x <= loggingStage.mainMenuButtonX + loggingStage.mainMenuButtonWidth and
           y >= loggingStage.mainMenuButtonY and
           y <= loggingStage.mainMenuButtonY + loggingStage.mainMenuButtonHeight
end

-- Handle mouse press for the completion screen
function loggingStage.handleCompletionScreenClick(x, y)
    if loggingStage.isPointInMainMenuButton(x, y) then
        print("Main Menu button clicked!")
        _G.gamestate = 0 -- Return to main menu
        return true
    end
    return false
end

-- Additional functions for the logging stage could be added here

return loggingStage 