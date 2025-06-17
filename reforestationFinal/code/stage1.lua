stage1 = Object:extend()

function stage1:load()
    stage1gamebackground = love.graphics.newImage("images/barrenLand2.png")
    garbage = love.graphics.newImage("images/garbage1.png")
    branch1 = love.graphics.newImage("images/branch1.png")
    branch2 = love.graphics.newImage("images/branch2.png")
    branch3 = love.graphics.newImage("images/branch3.png")
    stump = love.graphics.newImage("images/stump.png")
    treeStump = love.graphics.newImage("images/tree stump.png")
    rock = love.graphics.newImage("images/rock.png")
    redX = love.graphics.newImage("images/redx.png")
    dirt = love.graphics.newImage("images/hole.png")

    stage1gamebackgroundwidth = stage1gamebackground:getWidth()
    stage1gamebackgroundheight = stage1gamebackground:getHeight()
    tilewidth = 36
    tileheight = 36
    garbagewidth = garbage:getWidth()
    garbageheight = garbage:getHeight()
    branch1width = branch1:getWidth()
    branch1height = branch1:getHeight()
    branch2width = branch2:getWidth()
    branch2height = branch2:getHeight()
    branch3height = branch3:getHeight()
    branch3width = branch3:getWidth()
    stumpwidth = stump:getWidth()
    stumpheight = stump:getHeight()
    treeStumpheight = treeStump:getHeight()
    treeStumpwidth = treeStump:getWidth()
    rockwidth = rock:getWidth()
    rockheight = rock:getHeight()

    renderStumpA = 0
    renderStumpB = 0
    renderTreeStumpA = 0
    renderTreeStumpB = 0
    renderTrashA = 0
    renderBranchA = 0
    renderBranchB = 0
    renderTrashB = 0
    renderTrashC = 0
    renderBranchC = 0
    renderBranchD = 0
    renderBranchE = 0
    renderBranchF = 0
    renderBranchG = 0
    renderBranchH = 0
    renderTrashD = 0

    redX1 = true
    redX2 = true
    redX3 = true
    redX4 = true
    redX5 = true
    redX6 = true
    redX7 = true
    redX8 = true
    redX9 = true
    redX10 = true
    redX11 = true
    redX12 = true
    redX13 = true
    redX14 = true
    redX15 = true

    totalRemovedDebris = 0
    totalDugHoles = 0
    stopMenuRender1 = false
    stopMenuRender2 = true
    popOnce = 0
end

function stage1:draw()
    love.graphics.draw(stage1gamebackground, 0, 0)
    drawDebris()

    if guideMonkeyVisible then
        love.graphics.draw(guideMonkey, 660, 50, 0, 1.2, 1.2)
    end

    love.graphics.setFont(font2)

    if stopMenuRender1 == false then
        love.graphics.print("Current Objective: Remove Debris " .. totalRemovedDebris .. " / 16", 355, 0)

        local soilOffsetY = 380
        local playerY = soilOffsetY + (spritePlayer.tile_y - 1) * tileheight

        love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, playerY, 0, 2, 2)
    end

    if stopMenuRender2 == false then
        if popOnce == 0 then
            popOnce = popOnce + 1
        end

        love.graphics.print("Current Objective: Prepare the Ground for Trees: " .. totalDugHoles .. " / 10", 180, 0)
        drawXs()

        local soilOffsetY = 380
        local playerY = soilOffsetY + (spritePlayer.tile_y - 1) * tileheight

        love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, playerY, 0, 2, 2)
    end
end