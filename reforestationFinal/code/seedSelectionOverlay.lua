local seedSelectionOverlay = {}

function seedSelectionOverlay.load()
    -- Load seed images (same as seedSelectionP2)
    seedSelectionOverlay.acaciaSeed = love.graphics.newImage("images/Acacia.png")
    seedSelectionOverlay.cedarSeed = love.graphics.newImage("images/Cedar.png")
    seedSelectionOverlay.africanOliveSeed = love.graphics.newImage("images/African Olive.png")

    -- Selection tracking
    seedSelectionOverlay.selectedSeeds = {}
    seedSelectionOverlay.maxSeedTypes = 3
    seedSelectionOverlay.active = false
    seedSelectionOverlay.completed = false

    -- Visual settings
    seedSelectionOverlay.seedSpacing = 50
    seedSelectionOverlay.seedScale = 0.5
    
    -- Background and UI elements
    seedSelectionOverlay.bgOpacity = 0.7
    seedSelectionOverlay.panelColor = {0.2, 0.2, 0.2, 0.9}
    seedSelectionOverlay.textColor = {1, 1, 1, 1}
    
    -- Font for text
    seedSelectionOverlay.font = love.graphics.newFont(18)
    seedSelectionOverlay.titleFont = love.graphics.newFont(24)
end

function seedSelectionOverlay.update(dt)
    -- No need for updates in this overlay
end

function seedSelectionOverlay.draw()
    if not seedSelectionOverlay.active then
        return
    end
    
    -- Semi-transparent overlay background
    local sw, sh = love.graphics.getDimensions()
    love.graphics.setColor(0, 0, 0, seedSelectionOverlay.bgOpacity)
    love.graphics.rectangle("fill", 0, 0, sw, sh)
    
    -- Panel for seed selection
    local panelWidth = 600
    local panelHeight = 300
    local panelX = (sw - panelWidth) / 2
    local panelY = (sh - panelHeight) / 2
    
    -- Draw panel background
    love.graphics.setColor(unpack(seedSelectionOverlay.panelColor))
    love.graphics.rectangle("fill", panelX, panelY, panelWidth, panelHeight, 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", panelX, panelY, panelWidth, panelHeight, 10, 10)
    
    -- Draw title
    love.graphics.setFont(seedSelectionOverlay.titleFont)
    love.graphics.setColor(unpack(seedSelectionOverlay.textColor))
    local title = "Select Seeds to Plant"
    local titleWidth = seedSelectionOverlay.titleFont:getWidth(title)
    love.graphics.print(title, panelX + (panelWidth - titleWidth) / 2, panelY + 20)
    
    -- Draw seed packets
    love.graphics.setFont(seedSelectionOverlay.font)
    local seedY = panelY + 100
    local totalWidth = (seedSelectionOverlay.acaciaSeed:getWidth() + 
                     seedSelectionOverlay.cedarSeed:getWidth() + 
                     seedSelectionOverlay.africanOliveSeed:getWidth()) * 
                     seedSelectionOverlay.seedScale + 2 * seedSelectionOverlay.seedSpacing
    local startX = panelX + (panelWidth - totalWidth) / 2

    -- Draw all three seed types
    love.graphics.draw(seedSelectionOverlay.acaciaSeed, startX, seedY, 0, seedSelectionOverlay.seedScale, seedSelectionOverlay.seedScale)
    love.graphics.draw(seedSelectionOverlay.cedarSeed, startX + (seedSelectionOverlay.acaciaSeed:getWidth() * seedSelectionOverlay.seedScale) + seedSelectionOverlay.seedSpacing, seedY, 0, seedSelectionOverlay.seedScale, seedSelectionOverlay.seedScale)
    love.graphics.draw(seedSelectionOverlay.africanOliveSeed, startX + (seedSelectionOverlay.acaciaSeed:getWidth() + seedSelectionOverlay.cedarSeed:getWidth()) * seedSelectionOverlay.seedScale + 2 * seedSelectionOverlay.seedSpacing, seedY, 0, seedSelectionOverlay.seedScale, seedSelectionOverlay.seedScale)

    -- Highlight selected seeds
    for _, seedType in ipairs(seedSelectionOverlay.selectedSeeds) do
        love.graphics.setColor(0, 1, 0, 0.5)
        local x = startX
        if seedType == "cedar" then
            x = startX + (seedSelectionOverlay.acaciaSeed:getWidth() * seedSelectionOverlay.seedScale) + seedSelectionOverlay.seedSpacing
        elseif seedType == "africanOlive" then
            x = startX + (seedSelectionOverlay.acaciaSeed:getWidth() + seedSelectionOverlay.cedarSeed:getWidth()) * seedSelectionOverlay.seedScale + 2 * seedSelectionOverlay.seedSpacing
        end
        local img = seedSelectionOverlay[seedType.."Seed"]
        love.graphics.rectangle("fill", x, seedY, img:getWidth() * seedSelectionOverlay.seedScale, img:getHeight() * seedSelectionOverlay.seedScale)
        love.graphics.setColor(1, 1, 1)
    end
    
    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 1)
    local instructions = "Click on seeds to select them. Press SPACE when ready."
    local instructionsWidth = seedSelectionOverlay.font:getWidth(instructions)
    love.graphics.print(instructions, panelX + (panelWidth - instructionsWidth) / 2, panelY + panelHeight - 50)
    
    -- Draw count of selected seeds
    local countText = "Selected: " .. #seedSelectionOverlay.selectedSeeds .. " / " .. seedSelectionOverlay.maxSeedTypes
    love.graphics.print(countText, panelX + 20, panelY + panelHeight - 80)
end

function seedSelectionOverlay.mousepressed(x, y, button, istouch)
    if not seedSelectionOverlay.active then
        return false
    end
    
    -- Get screen dimensions for panel placement
    local sw, sh = love.graphics.getDimensions()
    local panelWidth = 600
    local panelHeight = 300
    local panelX = (sw - panelWidth) / 2
    local panelY = (sh - panelHeight) / 2
    
    local seedY = panelY + 100
    local totalWidth = (seedSelectionOverlay.acaciaSeed:getWidth() + 
                     seedSelectionOverlay.cedarSeed:getWidth() + 
                     seedSelectionOverlay.africanOliveSeed:getWidth()) * 
                     seedSelectionOverlay.seedScale + 2 * seedSelectionOverlay.seedSpacing
    local startX = panelX + (panelWidth - totalWidth) / 2

    -- Check Acacia click
    if x >= startX and x <= startX + seedSelectionOverlay.acaciaSeed:getWidth() * seedSelectionOverlay.seedScale and
       y >= seedY and y <= seedY + seedSelectionOverlay.acaciaSeed:getHeight() * seedSelectionOverlay.seedScale then
        seedSelectionOverlay.toggleSeed("acacia")
        return true
    -- Check Cedar click
    elseif x >= startX + (seedSelectionOverlay.acaciaSeed:getWidth() * seedSelectionOverlay.seedScale) + seedSelectionOverlay.seedSpacing and
           x <= startX + (seedSelectionOverlay.acaciaSeed:getWidth() + seedSelectionOverlay.cedarSeed:getWidth()) * seedSelectionOverlay.seedScale + seedSelectionOverlay.seedSpacing and
           y >= seedY and y <= seedY + seedSelectionOverlay.cedarSeed:getHeight() * seedSelectionOverlay.seedScale then
        seedSelectionOverlay.toggleSeed("cedar")
        return true
    -- Check African Olive click
    elseif x >= startX + (seedSelectionOverlay.acaciaSeed:getWidth() + seedSelectionOverlay.cedarSeed:getWidth()) * seedSelectionOverlay.seedScale + 2 * seedSelectionOverlay.seedSpacing and
           x <= startX + (seedSelectionOverlay.acaciaSeed:getWidth() + seedSelectionOverlay.cedarSeed:getWidth() + seedSelectionOverlay.africanOliveSeed:getWidth()) * seedSelectionOverlay.seedScale + 2 * seedSelectionOverlay.seedSpacing and
           y >= seedY and y <= seedY + seedSelectionOverlay.africanOliveSeed:getHeight() * seedSelectionOverlay.seedScale then
        seedSelectionOverlay.toggleSeed("africanOlive")
        return true
    end
    
    return false
end

function seedSelectionOverlay.keypressed(key)
    if not seedSelectionOverlay.active then
        return false
    end
    
    if key == "space" and #seedSelectionOverlay.selectedSeeds > 0 then
        seedSelectionOverlay.completed = true
        return true
    elseif key == "c" then
        -- Return true to indicate we handled the key press
        -- The main loop will handle setting closeDialogue = true
        return true
    end
    
    return false
end

function seedSelectionOverlay.toggleSeed(seedType)
    -- Play sound effect if available
    if seedClickSound then
        love.audio.play(seedClickSound)
    end
    
    -- Check if already selected
    for i, selected in ipairs(seedSelectionOverlay.selectedSeeds) do
        if selected == seedType then
            table.remove(seedSelectionOverlay.selectedSeeds, i)
            return
        end
    end
    
    -- Add if we have room
    if #seedSelectionOverlay.selectedSeeds < seedSelectionOverlay.maxSeedTypes then
        table.insert(seedSelectionOverlay.selectedSeeds, seedType)
    end
end

function seedSelectionOverlay.show()
    seedSelectionOverlay.active = true
    seedSelectionOverlay.completed = false
    seedSelectionOverlay.selectedSeeds = {}
end

function seedSelectionOverlay.hide()
    seedSelectionOverlay.active = false
end

function seedSelectionOverlay.getSelectedSeeds()
    return seedSelectionOverlay.selectedSeeds
end

return seedSelectionOverlay 