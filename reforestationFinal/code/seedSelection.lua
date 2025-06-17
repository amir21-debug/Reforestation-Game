local seedSelection = {}

function seedSelection.load()
    -- Load seed packet images
    seedSelection.acaciaSeed = love.graphics.newImage("images/Acacia.png")
    seedSelection.cedarSeed = love.graphics.newImage("images/Cedar.png")
    seedSelection.africanOliveSeed = love.graphics.newImage("images/African Olive.png")

    -- Seed descriptions
    seedSelection.seedDescriptions = {
        acacia = "Great choice! Acacia is a fast-growing and drought-resistant tree. Great for restoring soil fertility.",
        cedar = "Great choice! Cedar provides excellent shade and is resistant to pests.",
        africanOlive = "Great choice! African Olive produces edible fruit and supports local wildlife."
    }

    -- Track the selected seed
    seedSelection.selectedSeed = nil

    -- Spacing and scaling for seed packets
    seedSelection.seedSpacing = 50
    seedSelection.seedScale = 0.5

    -- Load the background image
    seedSelection.background = love.graphics.newImage("images/stage4.png")

    -- Zaki's dialogue for seed selection
    zakiDialoguesSeedSelection = {
        chooseSeed = "Well done! You've dug all the holes with perfect spacing. The trees will thrive here! Now, let's start planting! Click on a seed packet to learn more about it. Press SPACE to confirm your choice."
    }
    currentDialogueSeedSelection = zakiDialoguesSeedSelection.chooseSeed
end

function seedSelection.update(dt)
    -- Add any update logic here
end

function seedSelection.draw()
    -- Draw the background scaled to fit the window
    local bgWidth = seedSelection.background:getWidth()
    local bgHeight = seedSelection.background:getHeight()
    local scaleX = love.graphics.getWidth() / bgWidth
    local scaleY = love.graphics.getHeight() / bgHeight
    love.graphics.draw(seedSelection.background, 0, 0, 0, scaleX, scaleY)

    -- Draw seed packets horizontally
    local seedY = 335  -- Adjusted Y position for all seed packets (moved down)
    local totalWidth = (seedSelection.acaciaSeed:getWidth() + seedSelection.cedarSeed:getWidth() + seedSelection.africanOliveSeed:getWidth()) * seedSelection.seedScale + 2 * seedSelection.seedSpacing
    local startX = (love.graphics.getWidth() - totalWidth) / 2  -- Center horizontally

    -- Draw Acacia seed packet
    love.graphics.draw(seedSelection.acaciaSeed, startX, seedY, 0, seedSelection.seedScale, seedSelection.seedScale)

    -- Draw Cedar seed packet to the right of Acacia
    love.graphics.draw(seedSelection.cedarSeed, startX + (seedSelection.acaciaSeed:getWidth() * seedSelection.seedScale) + seedSelection.seedSpacing, seedY, 0, seedSelection.seedScale, seedSelection.seedScale)

    -- Draw African Olive seed packet to the right of Cedar
    love.graphics.draw(seedSelection.africanOliveSeed, startX + (seedSelection.acaciaSeed:getWidth() + seedSelection.cedarSeed:getWidth()) * seedSelection.seedScale + 2 * seedSelection.seedSpacing, seedY, 0, seedSelection.seedScale, seedSelection.seedScale)

    -- Draw Zaki and his dialogue
    if guideMonkeyVisible then
        love.graphics.draw(guideMonkey, 660, 50, 0, 1.2, 1.2)

        -- Draw Zaki's dialogue in a rectangle
        local rectX = 260
        local rectY = 10  -- Position of Zaki's dialogue box
        local rectWidth = 400
        local rectHeight = 180

        love.graphics.setColor(1, 1, 1)  -- White background
        love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight)
        love.graphics.setColor(0, 0, 0)  -- Black border
        love.graphics.rectangle("line", rectX, rectY, rectWidth, rectHeight)

        love.graphics.setFont(font2)
        love.graphics.setColor(0, 0, 0)  -- Black text
        love.graphics.printf(currentDialogueSeedSelection, rectX + 10, rectY + 10, rectWidth - 20, "left")
        love.graphics.setColor(1, 1, 1)  -- Reset color
    end

    -- Draw the selected seed description if a seed is selected
    if seedSelection.selectedSeed then
        local rectX = 260
        local rectY = 200  -- Adjusted to appear below Zaki's dialogue box
        local rectWidth = 400
        local rectHeight = 120

        love.graphics.setColor(1, 1, 1)  -- White background
        love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight)
        love.graphics.setColor(0, 0, 0)  -- Black border
        love.graphics.rectangle("line", rectX, rectY, rectWidth, rectHeight)

        love.graphics.setFont(font2)
        love.graphics.setColor(0, 0, 0)  -- Black text
        love.graphics.printf(seedSelection.seedDescriptions[seedSelection.selectedSeed], rectX + 10, rectY + 10, rectWidth - 20, "left")
        love.graphics.setColor(1, 1, 1)  -- Reset color
    end
end
function seedSelection.mousepressed(x, y, button, istouch)
    local seedY = 335  -- Adjusted Y position for all seed packets
    local totalWidth = (seedSelection.acaciaSeed:getWidth() + seedSelection.cedarSeed:getWidth() + seedSelection.africanOliveSeed:getWidth()) * seedSelection.seedScale + 2 * seedSelection.seedSpacing
    local startX = (love.graphics.getWidth() - totalWidth) / 2  -- Center horizontally

    -- Check if the player clicked on the Acacia seed packet
    if x >= startX and x <= startX + seedSelection.acaciaSeed:getWidth() * seedSelection.seedScale and
       y >= seedY and y <= seedY + seedSelection.acaciaSeed:getHeight() * seedSelection.seedScale then
        seedSelection.selectedSeed = "acacia"
        love.audio.play(seedClickSound)  -- Play sound
        
    end

    -- Check if the player clicked on the Cedar seed packet
    if x >= startX + (seedSelection.acaciaSeed:getWidth() * seedSelection.seedScale) + seedSelection.seedSpacing and
       x <= startX + (seedSelection.acaciaSeed:getWidth() + seedSelection.cedarSeed:getWidth()) * seedSelection.seedScale + seedSelection.seedSpacing and
       y >= seedY and y <= seedY + seedSelection.cedarSeed:getHeight() * seedSelection.seedScale then
        seedSelection.selectedSeed = "cedar"
        love.audio.play(seedClickSound)  -- Play sound
       
    end

    -- Check if the player clicked on the African Olive seed packet
    if x >= startX + (seedSelection.acaciaSeed:getWidth() + seedSelection.cedarSeed:getWidth()) * seedSelection.seedScale + 2 * seedSelection.seedSpacing and
       x <= startX + (seedSelection.acaciaSeed:getWidth() + seedSelection.cedarSeed:getWidth() + seedSelection.africanOliveSeed:getWidth()) * seedSelection.seedScale + 2 * seedSelection.seedSpacing and
       y >= seedY and y <= seedY + seedSelection.africanOliveSeed:getHeight() * seedSelection.seedScale then
        seedSelection.selectedSeed = "africanOlive"
        love.audio.play(seedClickSound)  -- Play sound
        
    end
end

function seedSelection.keypressed(key)
    if key == "space" and seedSelection.selectedSeed then
      seedPlanting.load(seedSelection.selectedSeed)  --load seed with selected seed type
        gamestate = 5
        gamestate = 5
    end
end

return seedSelection
