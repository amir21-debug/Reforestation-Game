local seedSelectionP2 = {}

function seedSelectionP2.load()
    -- Load seed images (same as level 1)
    seedSelectionP2.acaciaSeed = love.graphics.newImage("images/Acacia.png")
    seedSelectionP2.cedarSeed = love.graphics.newImage("images/Cedar.png")
    seedSelectionP2.africanOliveSeed = love.graphics.newImage("images/African Olive.png")

    -- Selection tracking
    seedSelectionP2.selectedSeeds = {}
    seedSelectionP2.maxSeedTypes = 3

    -- Visual settings (same as gamestate 4)
    seedSelectionP2.seedSpacing = 50
    seedSelectionP2.seedScale = 0.5

   
    seedSelectionP2.chosenSeedType=""
end







-- Rest of seedSelectionP2 code...
function seedSelectionP2.update(dt)
    -- Add any update logic here
end

function seedSelectionP2.draw()
    -- Draw background
   

    -- Draw seed packets (same layout as gamestate 4)
    local seedY = 420
    local totalWidth = (seedSelectionP2.acaciaSeed:getWidth() + 
                       seedSelectionP2.cedarSeed:getWidth() + 
                       seedSelectionP2.africanOliveSeed:getWidth()) * 
                       seedSelectionP2.seedScale + 2 * seedSelectionP2.seedSpacing
    local startX = (love.graphics.getWidth() - totalWidth) / 2

    -- Draw all three seed types
    love.graphics.draw(seedSelectionP2.acaciaSeed, startX, seedY, 0, seedSelectionP2.seedScale, seedSelectionP2.seedScale)
    love.graphics.draw(seedSelectionP2.cedarSeed, startX + (seedSelectionP2.acaciaSeed:getWidth() * seedSelectionP2.seedScale) + seedSelectionP2.seedSpacing, seedY, 0, seedSelectionP2.seedScale, seedSelectionP2.seedScale)
    love.graphics.draw(seedSelectionP2.africanOliveSeed, startX + (seedSelectionP2.acaciaSeed:getWidth() + seedSelectionP2.cedarSeed:getWidth()) * seedSelectionP2.seedScale + 2 * seedSelectionP2.seedSpacing, seedY, 0, seedSelectionP2.seedScale, seedSelectionP2.seedScale)

    -- Highlight selected seeds
    for _, seedType in ipairs(seedSelectionP2.selectedSeeds) do
        love.graphics.setColor(0, 1, 0, 0.5)
        local x = startX
        if seedType == "cedar" then
            x = startX + (seedSelectionP2.acaciaSeed:getWidth() * seedSelectionP2.seedScale) + seedSelectionP2.seedSpacing
        elseif seedType == "africanOlive" then
            x = startX + (seedSelectionP2.acaciaSeed:getWidth() + seedSelectionP2.cedarSeed:getWidth()) * seedSelectionP2.seedScale + 2 * seedSelectionP2.seedSpacing
        end
        local img = seedSelectionP2[seedType.."Seed"]
        love.graphics.rectangle("fill", x, seedY, img:getWidth() * seedSelectionP2.seedScale, img:getHeight() * seedSelectionP2.seedScale)
        love.graphics.setColor(1, 1, 1)
    end

    -- Draw player
    love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight, 0, 2, 2)
end

function seedSelectionP2.keypressed(key)
    if key == "space" then
        if #seedSelectionP2.selectedSeeds > 0 then
            return true  -- Signal that we're ready to proceed
        end
    end
    return false
end

function seedSelectionP2.mousepressed(x, y, button, istouch)
    local seedY = 420
    local totalWidth = (seedSelectionP2.acaciaSeed:getWidth() + 
                       seedSelectionP2.cedarSeed:getWidth() + 
                       seedSelectionP2.africanOliveSeed:getWidth()) * 
                       seedSelectionP2.seedScale + 2 * seedSelectionP2.seedSpacing
    local startX = (love.graphics.getWidth() - totalWidth) / 2

    -- Check Acacia click
    if x >= startX and x <= startX + seedSelectionP2.acaciaSeed:getWidth() * seedSelectionP2.seedScale and
       y >= seedY and y <= seedY + seedSelectionP2.acaciaSeed:getHeight() * seedSelectionP2.seedScale then
        seedSelectionP2.toggleSeed("acacia")
        seedSelectionP2.chosenSeedType = "acacia"
    -- Check Cedar click
    elseif x >= startX + (seedSelectionP2.acaciaSeed:getWidth() * seedSelectionP2.seedScale) + seedSelectionP2.seedSpacing and
           x <= startX + (seedSelectionP2.acaciaSeed:getWidth() + seedSelectionP2.cedarSeed:getWidth()) * seedSelectionP2.seedScale + seedSelectionP2.seedSpacing and
           y >= seedY and y <= seedY + seedSelectionP2.cedarSeed:getHeight() * seedSelectionP2.seedScale then
        seedSelectionP2.toggleSeed("cedar")
        seedSelectionP2.chosenSeedType = "cedar"
    -- Check African Olive click
    elseif x >= startX + (seedSelectionP2.acaciaSeed:getWidth() + seedSelectionP2.cedarSeed:getWidth()) * seedSelectionP2.seedScale + 2 * seedSelectionP2.seedSpacing and
           x <= startX + (seedSelectionP2.acaciaSeed:getWidth() + seedSelectionP2.cedarSeed:getWidth() + seedSelectionP2.africanOliveSeed:getWidth()) * seedSelectionP2.seedScale + 2 * seedSelectionP2.seedSpacing and
           y >= seedY and y <= seedY + seedSelectionP2.africanOliveSeed:getHeight() * seedSelectionP2.seedScale then
        seedSelectionP2.toggleSeed("africanOlive")
        seedSelectionP2.chosenSeedType = "africanOlive"
    end
end

function seedSelectionP2.toggleSeed(seedType)
    love.audio.play(seedClickSound)
    
    -- Check if already selected
    for i, selected in ipairs(seedSelectionP2.selectedSeeds) do
        if selected == seedType then
            table.remove(seedSelectionP2.selectedSeeds, i)
            return
        end
    end
    
    -- Add if we have room
    if #seedSelectionP2.selectedSeeds < seedSelectionP2.maxSeedTypes then
        table.insert(seedSelectionP2.selectedSeeds, seedType)
    end
end

function seedSelectionP2.getSelectedSeeds()
    return seedSelectionP2.selectedSeeds
end

return seedSelectionP2
