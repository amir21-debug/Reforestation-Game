local seedSelection = require("code.seedSelection")
local seedSelectionP2 = require("code.seedSelectionP2")
local seedPlantingP2 = require("code.seedPlantingP2")



function love.load()

    Object = require "code.classic"
    require "code.player"
    require "code.stage1"
    settings = require "code.settings"
    Dialove = require('code.Dialove')
   
--local seedSelectionDialogShown = false
    allHolesDug = false

    seedSelection.load()
-- seed selection for level 2
seedSelectionP2.load()
    player = Player()
    
    seedSelection.load()
    seedPlanting = require("code.seedPlanting")
    seedPlantingP2 = require("code.seedPlantingP2")

    seedPlanting.load()

    soilOffsetY = 380

    -- Load animal sprites
     elephant1 = love.graphics.newImage("images/elephant1.png")
    giraffe = love.graphics.newImage("images/giraffe.png")
    zebra = love.graphics.newImage("images/zebra.png")
    hyena = love.graphics.newImage("images/hyena.png")
    lion = love.graphics.newImage("images/lion.png")
    cheeta = love.graphics.newImage("images/cheeta.png")
    rhino = love.graphics.newImage("images/rhino.png")
    eagle = love.graphics.newImage("images/eagle.png")
    eagle2 = love.graphics.newImage("images/eagle.png")
    eagle3 = love.graphics.newImage("images/eagle.png")
    deer = love.graphics.newImage("images/Deer.png")

    -- Define animals for stage 1 (thriving forest)
    animalsStage1 = {
        {sprite = elephant1, x = 10, y = 100, visible = true},
        {sprite = giraffe, x = 320, y = 260, visible = true},
        {sprite = zebra, x = 250, y = 500, visible = true},
        {sprite = hyena, x = 90, y = 200, visible = true},
        {sprite = cheeta, x = 600, y = 100, visible = true},
        {sprite = lion, x = 640, y = 420, visible = true},
        {sprite = rhino, x = 350, y = 380, visible = true},
        {sprite = eagle, x = 290, y = 200, visible = true},
        {sprite = eagle2, x = 100, y = 300, visible = true}
    }

    -- Define animals for stage 2 (degraded forest)
    animalsStage2 = {
        {sprite = zebra, x = 230, y = 420, visible = true},
        {sprite = rhino, x = 350, y = 440, visible = true},
        {sprite = lion, x = 640, y = 420, visible = true},
        {sprite = elephant1, x = 300, y = 500, visible = true},
        {sprite = eagle, x = 290, y = 200, visible = true},
        {sprite = eagle2, x = 400, y = 300, visible = true},
        {sprite = eagle3, x = 300, y = 400, visible = true}
    }
    
animalsStage3 = {
    {sprite = elephant1, x = 10, y = 100, visible = false},
    {sprite = giraffe, x = 320, y = 260, visible = false},
    {sprite = zebra, x = 400, y = 300, visible = false},
    {sprite = hyena, x = 110, y = 200, visible = false},
    {sprite = cheeta, x = 600, y = 100, visible = false},
    {sprite = lion, x = 640, y = 420, visible = false},
    {sprite = rhino, x = 350, y = 450, visible = false},
    {sprite = zebra, x = 200, y = 400, visible = false},
    {sprite = giraffe, x = 100, y = 430, visible = false},
    {sprite = deer, x = 500, y = 360, visible = false}
}

animalsStage4 = {
    {sprite = elephant1, x = 10, y = 100, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = giraffe, x = 320, y = 260, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = zebra, x = 250, y = 500, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = hyena, x = 90, y = 200, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = cheeta, x = 600, y = 100, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = lion, x = 640, y = 420, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = rhino, x = 350, y = 380, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = eagle, x = 290, y = 200, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = eagle2, x = 100, y = 300, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false},
    {sprite = deer, x = 500, y = 360, visible = false, speedX = 0, speedY = 0, saved = false, escaped = false}
}


animalSpawnTimer = 0
animalSpawnInterval = 1 -- seconds between animal appearances
animalsToSpawn = 0
animalsSpawned = 0
allAnimalsArrived = false
allAnimalsVisibleTimer = 0
allAnimalsVisibleDelay = 3

savingAnimalsDelayTimer = 0
savingAnimalsDelayMax = 4 -- seconds before animals move (adjust if you want more time)

savingAnimalsTimer = 0
savingAnimalsMaxTime = 15 -- how much time they have to save
savingAnimalsTimeUp = false
timerFont = love.graphics.newFont(32)
animalsSaved = 0
animalsLost = 0

animalsSpawned14 = 0
animalSpawnTimer14 = 0
allAnimalsArrived14 = false
allAnimalsVisibleTimer14 = 0
animalSpawnInterval14 = 1  -- seconds between animal appearances 

    guideMonkey = love.graphics.newImage("images/Monkey.png")
    guideMonkeyVisible = true

    xclick = 0
    yclick = 0
    gamestate = 0
    forestState = 1

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    love.graphics.setDefaultFilter('nearest', 'nearest', 1)
  banner1 = love.graphics.newImage("images/banner1.png")
    background = love.graphics.newImage("images/MenuBackground.png")
    forest1 = love.graphics.newImage("images/Forest.png")
    forest2 = love.graphics.newImage("images/Forest2.png")
    forest3 = love.graphics.newImage("images/barrenland1.png")

    NextButton = love.graphics.newImage("images/next button.png")
    PreviousButton = love.graphics.newImage("images/previous button.png")

    -- (Most) Stage 1 variables
    stage1:load()

    music = love.audio.newSource("sounds/junglesounds.mp3", "stream")

    spritePlayer = {
        AVATAR = love.graphics.newImage("images/boy2.png"),
        tile_x = 1,
        tile_y = 4,
    }
    


    width = banner1:getWidth()
    height = banner1:getHeight()
    


    love.graphics.setBackgroundColor(0, 0, 0)
    font1 = love.graphics.newFont("CCRedAlert.ttf", 60)
    font2 = love.graphics.newFont("CCRedAlert.ttf", 25)
    font3 = love.graphics.newFont("CCRedAlert.ttf", 14)
    font4 = love.graphics.newFont("CCRedAlert.ttf", 40)
    
     debrisSound = love.audio.newSource("sounds/debris_removed.wav", "static")
    diggingSound = love.audio.newSource("sounds/digging.wav", "static")
    seedClickSound = love.audio.newSource("sounds/seed_click.wav", "static")

    zakiDialoguesForest = {
        forest1 = "Hi there! I'm Zaki, your guide. This forest was once home to many animals and provided for the people living nearby. But things are changing...",
        forest2 = "People started cutting down trees for resources. Slowly, the animals began to leave their homes. It's heartbreaking to see...",
        forest3 = "Now, the forest is just debris. Nothing is left. Can you help me restore it to its former glory?"
    }

    zakiDialoguesStage1 = {
        cleanDebris = "First, let's clean up the debris. Walk over each pile and pick it up.",
        debrisCleared = "Fantastic work! The area is clear, and we're ready for digging the holes! Spacing is key for healthy trees! Walk to the marked spots and press 'E' to dig the planting holes."
    }

    zakiDialoguesSeedSelection = {
        chooseSeed = "Well done! You've dug all the holes with perfect spacing. The trees will thrive here! Now, let's start planting! Click on a seed packet to learn more about it. Press SPACE to confirm your choice."
    }

    zakiDialogueWatering = {
        waterDialouge = "Now, to water those saplings stand on the spot where you planted the sapling and stop the bar in the green region. Be careful though! Stopping it in the red 3 times will require you to start the level over again! "
    }


    currentDialogue = ""
    currentDialogueForest = zakiDialoguesForest.forest1
    -- Initialize settings
    settings.load(banner1)

    

    --gamestate 6 stuff
    movingBarX=40;
    barDirection=200;
    stopBar=false;
    totalWateredTrees=0;
    stopBar=false;
    taskCompleteNoiseOne = love.audio.newSource("sounds/ping5.mp3", "stream")
    errornoise = love.audio.newSource("sounds/errornoise.mp3", "stream")
    tree1 = love.graphics.newImage("images/tree1.png")
    missPenalty=false;
    overWatered=0;
    respawn=0;
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
    flag=false
    gamestate6objectiveShow=true
    barSpeedModifier=200

    --Part 2 stuff
     P2S1gamebackground = love.graphics.newImage("images/stardewPLACEHOLDERbackground.png")
    grassBackground = love.graphics.newImage("images/grass.png")
    dryGrassBackground = love.graphics.newImage("images/dryGrass.png")
    --dialogue manager / dialogue tree
    dialogManager = Dialove.init({
        font = love.graphics.newFont('CCRedAlert.ttf', 16)
      })

    dialogManager:show({
        text = ([[Alrighty! Now you're ready for the big leagues kid! 
        Are you ready to bring this forest back to life?
        You already know how this goes- pick up the debris to clean the area and we can get started!
    {press c to close dialogue}]]),
      title = 'Zaki',
      image = love.graphics.newImage('images/zaki.png')
    })

   
    dialogManager:push({
        text = [[Press E on the X's to dig holes! {press c to close dialogue} ]],
        title = 'Zaki',
        image = love.graphics.newImage('images/zaki.png')
    })
    dialogManager:push({
        text = [[Choose 1-3 seed types to plant. 
        Click to select/deselect. 
        Each seed has unique properties that can help restore the forest.
        Press SPACE when you're ready to plant!
        {press c to close}]],
        title = 'Zaki',
        image = love.graphics.newImage('images/zaki.png')
    })
    dialogManager:push({
      text = [[Great job picking your seeds! Now walk over the holes and press E to plant them. {press c to close dialogue} ]],
      title = 'Zaki',
      image = love.graphics.newImage('images/zaki.png')
  })

    dialogManager:push({
      text = [[Water the trees to help them grow! {press c to close dialogue} ]],
      title = 'Zaki',
      image = love.graphics.newImage('images/zaki.png')
  })
 dialogManager:push({
            text = [[The animals are back! But the dry season is creating fires! Click on the animals to save them! {press c to close}]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })

        dialogManager:push({
            text = [[Quick! The fires are spreading! Extinguish them by stannding next to the tree and  pressing SPACE when the bar is green! {press c to close} ]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })
        dialogManager:push({
            text = [[The animals have returned again! Thanks to you, the forest is alive! ]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })
   
    P2resetflag=0
    P2resetflag2=0
    P2resetflag3=0
    allAnimalsVisibleTimer = 0
animalSpawnTimer = 0
animalsSpawned = 0
allAnimalsArrived = false
animalsFleeing = false


for _, animal in ipairs(animalsStage3) do
    animal.visible = false
end
    P2resetBarflag=0
    renderObjectives=true
    popOnce=0
    treeStateSquare1=0
    treeStateSquare2=0
    treeStateSquare3=0
    treeStateSquare4=0
    treeStateSquare5=0
    treeStateSquare6=0
    treeStateSquare7=0
    treeStateSquare8=0
    treeStateSquare9=0
    treeStateSquare10=0
    treeStateSquare11=0
    treeStateSquare12=0
    treeStateSquare13=0
    treeStateSquare14=0
    treeStateSquare15=0
    

  fullgrowncedar = love.graphics.newImage("images/Cedar Tree.png")
    fullgrownacacia = love.graphics.newImage("images/Acacia Tree.png")
    fullgrownafricanolive = love.graphics.newImage("images/Olive Tree.png")
    chosenSeed =""
    
burningTrees = {}  -- Table to track which trees are burning
smokeImages = {}   -- Table to hold smoke/fire particle systems
birdData = {}      -- Table to hold bird data for each burning tree
maxBurningTrees = 5
 fireSound = love.audio.newSource("sounds/fireSound.mp3", "stream") 

    birdSprites = {
        love.graphics.newImage("images/wingsDown.png"),
        love.graphics.newImage("images/wingsUp.png")
    }
birdFlapSound = love.audio.newSource("sounds/wingFlap.mp3", "static")
fireSound = love.audio.newSource("sounds/fireSound.mp3", "stream")
showAnimalSummary = false
previousPlayerOnTree = false

-- Add this at the top with other global variables, after the existing variables
-- Random green zone positions for each tree hole
treeGreenZonePositions = {}

end


function love.update(dt)
    player:update(dt)
    -- Update volume for all audio sources
    if music then music:setVolume(settings.getVolume()) end
    if debrisSound then debrisSound:setVolume(settings.getVolume()) end
    if diggingSound then diggingSound:setVolume(settings.getVolume()) end
    if seedClickSound then seedClickSound:setVolume(settings.getVolume()) end
    

    if totalRemovedDebris == 16 and stopMenuRender1 == false then
        stopMenuRender1 = true
        stopMenuRender2 = false
        currentDialogue = zakiDialoguesStage1.debrisCleared
    end

    if totalDugHoles == 10 and stopMenuRender2 == false then
        stopMenuRender2 = true
        gamestate = 4
        currentDialogue = zakiDialoguesSeedSelection.chooseSeed
        print("Gamestate changed to 4.")
    end

    if allHolesDug then
        currentDialogue = zakiDialoguesStage1.holesDug
        updateCurrentDialogue(gamestate)
        allHolesDug = false
    end

    if not music:isPlaying() then
        love.audio.play(music)
    end

    if gamestate == 4 then
        seedSelection.update(dt)
    end
    if gamestate == 5 then
        seedPlanting.update(dt)
    end
    if gamestate == 5 and seedPlanting.gameCompleted then
        gamestate = 6  -- Move to the next stage
    end
    if gamestate==7 or gamestate==8 or gamestate == 9 or gamestate == 10 or gamestate == 11 or gamestate == 12 or gamestate == 13 or gamestate == 14 then
        dialogManager:update(dt)
    end
    
    if gamestate == 2 then
        settings.update(dt)
    end

    --watering task bar moving thing
    if gamestate==6 or gamestate==11 or gamestate==12 then
        
        moveBar(dt)
     end
     
    if gamestate == 9 then
     
        seedSelectionP2.update(dt)

    end
    if gamestate == 10 then
        seedPlantingP2.update(dt)
        local allCovered = true
        for _, seed in ipairs(seedPlantingP2.plantedSeeds) do
            if seed.state ~= "covered" then
                allCovered = false
                break
            end
        end

    if allCovered and gamestate == 10 then
    gamestate = 11
    popOnce = 1
    closeDialogue = false
end

    end
  if gamestate == 11 and totalWateredTrees == 15 then
    if not allAnimalsArrived then
        animalSpawnTimer = animalSpawnTimer + dt
        if animalSpawnTimer >= animalSpawnInterval and animalsSpawned < #animalsStage3 then
            animalsStage3[animalsSpawned + 1].visible = true
            animalsSpawned = animalsSpawned + 1
            animalSpawnTimer = 0
            
            if animalsSpawned == #animalsStage3 then
                allAnimalsArrived = true
            end
        end
    else
        -- Count time after all animals have arrived
        allAnimalsVisibleTimer = allAnimalsVisibleTimer + dt
    end
end
if gamestate == 12 then
    if not savingAnimalsStarted then
        savingAnimalsDelayTimer = savingAnimalsDelayTimer + dt
        if savingAnimalsDelayTimer >= savingAnimalsDelayMax then
            savingAnimalsStarted = true
            savingAnimalsTimer = savingAnimalsMaxTime -- Start countdown for frantic animal movement
        end
    end
    if savingAnimalsStarted and not savingAnimalsTimeUp then
        savingAnimalsTimer = savingAnimalsTimer - dt
        if savingAnimalsTimer <= 0 then
            savingAnimalsTimeUp = true
            savingAnimalsTimer = 0
            animalsFleeing = true
            -- Force all unsaved animals to flee randomly
            for _, animal in ipairs(animalsStage3) do
                if animal.visible and not animal.saved then
                    local angle = love.math.random() * (2 * math.pi)
                    local speed = love.math.random(300, 400)
                    animal.speedX = math.cos(angle) * speed
                    animal.speedY = math.sin(angle) * speed
                    animal.fleeing = true
                end
            end
        end
    end
    
if #burningTrees == 0 then  -- Initialize burning trees when first entering state 12
    initBurningTrees()
end
updateBurningTrees(dt)
end
-- Move animals frantically if fire is active
if savingAnimalsStarted then
for _, animal in ipairs(animalsStage3) do
    if animal.visible and animal.speedX and not animal.saved then
      if animal.fleeing then
          --  Animal is fleeing OFF screen
          animal.x = animal.x + animal.speedX * dt
          animal.y = animal.y + animal.speedY * dt
      else
          animal.x = animal.x + animal.speedX * dt
          animal.y = animal.y + animal.speedY * dt

          -- Bounce off edges
          if animal.x < 0 or animal.x > screenWidth then
              animal.speedX = -animal.speedX
          end
          if animal.y < 0 or animal.y > screenHeight then
              animal.speedY = -animal.speedY
          end
end
    elseif animal.saved then
        -- If animal is saved, make it run off screen to the right
        animal.x = animal.x + 300 * dt
    end

    -- If animal escapes off-screen without being saved
    if not animal.saved and not animal.escaped and (animal.x < -50 or animal.x > screenWidth + 50 or animal.y < -50 or animal.y > screenHeight + 50) then
        animal.visible = false
        animal.escaped = true
        animalsLost = animalsLost + 1
    end
end
end
-- Check if saving is complete
if savingAnimalsStarted and not animalSavingComplete then
    local totalHandled = animalsSaved + animalsLost
    if totalHandled == #animalsStage3 then
        animalSavingComplete = true
    end
end
if animalSavingComplete and not fireExtinguishingStarted then
    fireExtinguishingStarted = true
    fireExtinguishingComplete = false
    extinguishedFires = 0
end

if fireExtinguishingStarted then
    updateFireExtinguishing(dt)
end

    if gamestate == 13 then
        -- Reset stopBar when player moves to a new burning tree
       for i, tree in ipairs(burningTrees) do
        if tree.active then
            tree.particles:update(dt)
        end
    end
    
    -- Ensure this line is executing and not being blocked by any conditions
    if not stopBar then
        moveBar(dt)
    end
    local playerOnTree = false
        local currentTreeIndex = nil
        
        for i, tree in ipairs(burningTrees) do
            local treeX = math.floor(tree.position.x / tilewidth)
            local treeY = math.floor(tree.position.y / tileheight)
            
            if spritePlayer.tile_x == treeX and spritePlayer.tile_y == treeY then
                playerOnTree = true
                currentTreeIndex = i
                
                -- Reset bar only when stepping on a new tree that's still burning
                if (not previousPlayerOnTree or previousTreeIndex ~= currentTreeIndex) and tree.active then
                    stopBar = false
                    movingBarX = 40
                    barDirection = 200
                end
                
                break
            end
        end
        
        previousPlayerOnTree = playerOnTree
        previousTreeIndex = currentTreeIndex
        
        -- Check if all fires are extinguished
        if extinguishedFires == #burningTrees and fireSound and fireSound:isPlaying() then
            fireSound:stop()
        end
    elseif gamestate == 14 then
        if popOnce == 0 then
            dialogManager:show({
                text = [[The forest is thriving again! The animals have returned and the ecosystem is restored. Your hard work has paid off! {press c to close}]],
                title = 'Zaki',
                image = love.graphics.newImage('images/zaki.png')
            })
            popOnce = 1
            closeDialogue = false
        end
        if not allAnimalsArrived14 then
            animalSpawnTimer14 = animalSpawnTimer14 + dt
            if animalSpawnTimer14 >= animalSpawnInterval14 and animalsSpawned14 < #animalsStage4 then
                animalsStage4[animalsSpawned14 + 1].visible = true
                -- Give animals gentle wandering movement
                animalsStage4[animalsSpawned14 + 1].speedX = love.math.random(-20, 20)
                animalsStage4[animalsSpawned14 + 1].speedY = love.math.random(-20, 20)
                animalsSpawned14 = animalsSpawned14 + 1
                animalSpawnTimer14 = 0
                
                if animalsSpawned14 == #animalsStage4 then
                    allAnimalsArrived14 = true
                end
            end
        else
            -- Count time after all animals have arrived
            allAnimalsVisibleTimer14 = allAnimalsVisibleTimer14 + dt
            
            -- Update animal positions (gentle wandering)
            for _, animal in ipairs(animalsStage4) do
                if animal.visible then
                    animal.x = animal.x + animal.speedX * dt
                    animal.y = animal.y + animal.speedY * dt
                    
                    -- Gentle bouncing off edges
                    if animal.x < 0 or animal.x > screenWidth - animal.sprite:getWidth() then
                        animal.speedX = -animal.speedX
                    end
                    if animal.y < 0 or animal.y > screenHeight - animal.sprite:getHeight() then
                        animal.speedY = -animal.speedY
                    end
                end
            end
        end
end
end
function updateBurningTrees(dt)
    for i, tree in ipairs(burningTrees) do
        if tree.active then
            tree.particles:update(dt)
            tree.fireTimer = tree.fireTimer + dt
            -- Update fire stages
            if tree.fireTimer >= 5 and tree.fireStage == 0 then
                tree.particles:setEmissionRate(7)
                tree.particles:setColors(0.7, 0.7, 0.7, 0.5, 0.4, 0.4, 0.4, 0.8)
                tree.fireStage = 1
                -- Activate bird for this tree
                tree.bird.visible = true
                tree.bird.flying = true
            end
            if tree.fireTimer >= 8 and tree.fireStage == 1 then
                tree.particles:setEmissionRate(14)
                tree.particles:setColors(0.3, 0.3, 0.3, 0.8, 0.1, 0.1, 0.1, 1)
                tree.fireStage = 2
            end
            if tree.fireTimer >= 13 and tree.fireStage == 2 then
                tree.particles:setEmissionRate(30)
                tree.particles:setLinearAcceleration(-10, -50, 20, -80)
                tree.particles:setColors(0.9, 0.4, 0.1, 1, 1, 0, 0, 0.8)
                tree.fireStage = 3
            end
            -- Update bird movement and animation
            if tree.bird.flying then
                tree.bird.x = tree.bird.x + tree.bird.speedX * dt
                tree.bird.y = tree.bird.y + tree.bird.speedY * dt
                tree.bird.animationTimer = tree.bird.animationTimer + dt
                if tree.bird.animationTimer >= 0.2 then
                    tree.bird.animationTimer = 0
                    tree.bird.animationFrame = (tree.bird.animationFrame == 1) and 2 or 1
                    -- Fix: Use clone() to play the sound multiple times simultaneously
                    local flapSound = birdFlapSound:clone()
                    flapSound:play()
                end
                -- Remove bird when off screen
                if tree.bird.x < -50 or tree.bird.y < -50 then
                    tree.bird.flying = false
                    tree.bird.visible = false
                end
            end
        end
    end
end



function updateBurningTrees(dt)
    for i, tree in ipairs(burningTrees) do
        if tree.active then
            tree.particles:update(dt)
            tree.fireTimer = tree.fireTimer + dt
            -- Update fire stages
            if tree.fireTimer >= 5 and tree.fireStage == 0 then
                tree.particles:setEmissionRate(7)
                tree.particles:setColors(0.7, 0.7, 0.7, 0.5, 0.4, 0.4, 0.4, 0.8)
                tree.fireStage = 1
                -- Activate bird for this tree
                tree.bird.visible = true
                tree.bird.flying = true
            end
            if tree.fireTimer >= 8 and tree.fireStage == 1 then
                tree.particles:setEmissionRate(14)
                tree.particles:setColors(0.3, 0.3, 0.3, 0.8, 0.1, 0.1, 0.1, 1)
                tree.fireStage = 2
            end
            if tree.fireTimer >= 13 and tree.fireStage == 2 then
                tree.particles:setEmissionRate(30)
                tree.particles:setLinearAcceleration(-10, -50, 20, -80)
                tree.particles:setColors(0.9, 0.4, 0.1, 1, 1, 0, 0, 0.8)
                tree.fireStage = 3
            end
            -- Update bird movement and animation
            if tree.bird.flying then
                tree.bird.x = tree.bird.x + tree.bird.speedX * dt
                tree.bird.y = tree.bird.y + tree.bird.speedY * dt
                tree.bird.animationTimer = tree.bird.animationTimer + dt
                if tree.bird.animationTimer >= 0.2 then
                    tree.bird.animationTimer = 0
                    tree.bird.animationFrame = (tree.bird.animationFrame == 1) and 2 or 1
                    -- Fix: Use clone() to play the sound multiple times simultaneously
                    local flapSound = birdFlapSound:clone()
                    flapSound:play()
                end
                -- Remove bird when off screen
                if tree.bird.x < -50 or tree.bird.y < -50 then
                    tree.bird.flying = false
                    tree.bird.visible = false
                end
            end
        end
    end
end
function initBurningTrees()
    -- Load resources if not already loaded
    movingBarX = 40
    barDirection = 200
    stopBar = false
    if not smokeImage then
        smokeImage = love.graphics.newImage("images/fire4.png")
        birdSprites = {
            love.graphics.newImage("images/wingsDown.png"),
            love.graphics.newImage("images/wingsUp.png")
        }
        birdFlapSound = love.audio.newSource("sounds/wingFlap.mp3", "static")
        birdFlapSound:setVolume(0.9)  -- Set volume like in the working example
        fireSound = love.audio.newSource("sounds/fireSound.mp3", "stream")
    end
-- Ensure the sound is always loaded
if not birdFlapSound then
     love.audio.play(birdFlapSound)
end
    -- Get specific tree positions (2 on bottom, 1 middle, 2 top)
    local treePositions = {
        -- Bottom row (y=10)
        {x = tilewidth*7, y = tileheight*10},
        {x = tilewidth*15, y = tileheight*10},
        -- Middle row (y=6)
        {x = tilewidth*11, y = tileheight*6},
        -- Top row (y=2)
        {x = tilewidth*3, y = tileheight*2},
        {x = tilewidth*19, y = tileheight*2}
    }
    -- Create particle systems for each burning tree
    for i, pos in ipairs(treePositions) do
        local particles = love.graphics.newParticleSystem(smokeImage, 500)
        particles:setParticleLifetime(3, 6)
        particles:setEmissionRate(15)
        particles:setSizeVariation(1)
    particles:setLinearAcceleration(-20, -10, 10, -40)
        particles:setSizes(0.2, 0.5, 1)
        particles:setColors(1, 1, 1, 0.3, 0.7, 0.7, 0.7, 0.5)
        particles:setPosition(pos.x + 20, pos.y - 30)
        local bird = {
            x = pos.x,
            y = pos.y - 40,
            speedX = love.math.random(-200, -100),
            speedY = love.math.random(-150, -80),
            visible = false,
            animationTimer = 0,
            animationFrame = 1,
            flying = false,
            timer = 0
        }
        table.insert(burningTrees, {
            position = pos,
            particles = particles,
            bird = bird,
            active = true,
            fireTimer = 0,
            fireStage = 0
        })
    end
    fireSound:setLooping(true)
    fireSound:play()
    for _, animal in ipairs(animalsStage3) do
    animal.speedX = love.math.random(40, 80) * (love.math.random(0, 1) == 0 and -1 or 1)
    animal.speedY = love.math.random(40, 80) * (love.math.random(0, 1) == 0 and -1 or 1)
    animal.saved = false
    animal.escaped = false
end
    savingAnimalsDelayTimer = 0
    savingAnimalsStarted = false -- don't start yet
    savingAnimalsTimeUp = false
    animalSavingComplete = false
end

function love.draw()
    local scaleX = screenWidth / forest1:getWidth()
    local scaleY = screenHeight / forest1:getHeight()
    local scale = math.max(scaleX, scaleY)

    local offsetX = (screenWidth - forest1:getWidth() * scale) / 2
    local offsetY = (screenHeight - forest1:getHeight() * scale) / 2

    if gamestate == 0 then
        -- Main menu state
        love.graphics.draw(background, 0, 0, 0, 2.2, 2.2)
        love.graphics.draw(banner1, 330, 250, 0, 3, 3)
        love.graphics.draw(banner1, 330, 325, 0, 3, 3)
        love.graphics.draw(banner1, 330, 400, 0, 3, 3)
        love.graphics.draw(banner1, 330, 475, 0, 3, 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font1)
        love.graphics.print("FOREST", 340, 100)
        love.graphics.print("BUILDER", 330, 160)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(font2)
        love.graphics.print("START", 380, 264)
        love.graphics.print("STAGE 2", 376, 338)
        love.graphics.print("STAGE 3", 376, 414)
        love.graphics.print("SETTINGS", 374, 488)
        love.graphics.setColor(1, 1, 1)

    elseif gamestate == 2 then -- Settings screen
        settings.draw()
        
    elseif gamestate == 1 then
        -- Forest viewing state
        if forestState == 1 then
            love.graphics.draw(forest1, 0, 0, 0, screenWidth / forest1:getWidth(), screenHeight / forest1:getHeight())
            for _, animal in ipairs(animalsStage1) do
                if animal.visible then
                    love.graphics.draw(animal.sprite, animal.x, animal.y)
                end
            end
            currentDialogue = zakiDialoguesForest.forest1

        elseif forestState == 2 then
            love.graphics.draw(forest2, 0, 0, 0, screenWidth / forest2:getWidth(), screenHeight / forest2:getHeight())
            for _, animal in ipairs(animalsStage2) do
                if animal.visible then
                    love.graphics.draw(animal.sprite, animal.x, animal.y)
                end
            end
            currentDialogue = zakiDialoguesForest.forest2

        elseif forestState == 3 then
            love.graphics.draw(forest3, 0, 0, 0, screenWidth / forest3:getWidth(), screenHeight / forest3:getHeight())
            currentDialogue = zakiDialoguesForest.forest3
        end

        -- Draw the guide monkey
        if guideMonkeyVisible then
            love.graphics.draw(guideMonkey, 670, 50, 0, 1.4, 1.4)
        end

        -- Draw the player in the forest stages
        local playerX, playerY = getPlayerPosition()
        love.graphics.draw(spritePlayer.AVATAR, playerX, playerY, 0, 2, 2)

        -- Draw dialogue box
        local rectX = 260
        local rectY = 30
        local rectWidth = 400
        local rectHeight = 150

        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", rectX, rectY, rectWidth, rectHeight)

        love.graphics.setFont(font2)
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(currentDialogue, rectX + 10, rectY + 10, rectWidth - 20, "left")
        love.graphics.setColor(1, 1, 1)

        -- Draw navigation buttons
        local buttonScale = 0.6
        local buttonWidth = PreviousButton:getWidth() * buttonScale
        local buttonHeight = PreviousButton:getHeight() * buttonScale
        local buttonX = 20
        local buttonY = screenHeight - buttonHeight - 200

        love.graphics.draw(PreviousButton, buttonX, buttonY, 0, buttonScale, buttonScale)

        local nextButtonWidth = NextButton:getWidth() * buttonScale
        local nextButtonHeight = NextButton:getHeight() * buttonScale
        local nextButtonX = screenWidth - nextButtonWidth - 20
        local nextButtonY = screenHeight - nextButtonHeight - 200

        love.graphics.draw(NextButton, nextButtonX, nextButtonY, 0, buttonScale, buttonScale)

        
        if forestState == 4 then
            gamestate = 3
            updateCurrentDialogue(gamestate)
        end

    elseif gamestate == 3 then
        -- Stage 1 - clean up debris
        stage1:draw()  -- Player is rendered inside stage1:draw()

        if guideMonkeyVisible then
            love.graphics.draw(guideMonkey, 660, 50, 0, 1.2, 1.2)

            local rectX = 260
            local rectY = 30
            local rectWidth = 400
            local rectHeight = 180

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", rectX, rectY, rectWidth, rectHeight)

            love.graphics.setFont(font2)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(currentDialogue, rectX + 10, rectY + 10, rectWidth - 20, "left")
            love.graphics.setColor(1, 1, 1)

            print("Drawing dialogue: " .. currentDialogue)
        end

    elseif gamestate == 4 then
        -- Seed selection stage
        seedSelection.draw()

        -- Draw the player in the seed selection stage
        local playerX, playerY = getPlayerPosition()
        love.graphics.draw(spritePlayer.AVATAR, playerX, playerY, 0, 2, 2)

    elseif gamestate == 5 then
        -- Seed planting stage
        seedPlanting.draw()

        -- Draw the player in the seed planting stage
        local playerX, playerY = getPlayerPosition()
        love.graphics.draw(spritePlayer.AVATAR, playerX, playerY, 0, 2, 2)

    
    elseif gamestate == 6 then
        currentDialogue = zakiDialogueWatering.waterDialouge
        --only trigger this once to correct player y spawn in 
        local tilewidth = 36
        local tileheight = 36
        --only trigger this once to correct player y spawn in 
        if flag==false then
            spritePlayer.tile_y=6
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
            flag=true
            flag2=true
        end

        --draw background
        love.graphics.draw(seedPlanting.background, 0, 0, 0, love.graphics.getWidth() / seedPlanting.background:getWidth(), love.graphics.getHeight() / seedPlanting.background:getHeight())
        gamestate6TreeDrawBackground()
        --draw da monkey
        if guideMonkeyVisible then
            love.graphics.setLineWidth(1)
            love.graphics.draw(guideMonkey, 660, 50, 0, 1.2, 1.2)

            local rectX = 260
            local rectY = 30
            local rectWidth = 400
            local rectHeight = 200

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight)
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", rectX, rectY, rectWidth, rectHeight)

            love.graphics.setFont(font2)
            love.graphics.setColor(0, 0, 0)
            love.graphics.printf(currentDialogue, rectX + 10, rectY + 10, rectWidth - 20, "left")
            love.graphics.setColor(1, 1, 1)

            print("Drawing dialogue: " .. currentDialogue)
        end
        
        --draw player
        local soilOffsetY = 380
        local playerY = soilOffsetY+0.1 + (spritePlayer.tile_y - 1) * tileheight
        love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, playerY, 0, 2, 2)
        --love.graphics.print(spritePlayer.tile_x ..",".. spritePlayer.tile_y , 20)
        gamestate6TreeDrawForefront()
        love.graphics.setFont(font2)

        if gamestate6objectiveShow==true then
            love.graphics.print("Current Objective: Water Trees: " .. totalWateredTrees.. " / 10", 5, 0)
            love.graphics.setColor(230,0,0,255)
            love.graphics.print("Overwatered Trees " .. overWatered.. " / 3", 5, 25)
            love.graphics.setColor(255,255,255,255)
        end

        if totalWateredTrees==10 then
            gamestate6objectiveShow=false
            love.graphics.rectangle("line", 200, 250, 400, 150)
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", 200, 250, 400, 150)
            love.graphics.setColor(1,1,1)
            love.graphics.setFont(font4)
            love.graphics.print("Trees",340,280)
            love.graphics.print("Watered!",303,320)
            love.graphics.setFont(font3)
            love.graphics.print("press space to continue",326,360)
        end

        if onRedX2(0) and missPenalty==false then
            if flag2==true then 
                movingBarX=40;
                flag2=false
            end
            drawWateringMinigame();
        end

        if onRedX2(0)==false then
            flag2=true
            missPenalty=false
           
        end

        if overWatered==3 then
            love.graphics.rectangle("line", 200, 250, 400, 150)
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", 200, 250, 400, 150)
            love.graphics.setColor(1,1,1)
            love.graphics.setFont(font4)
            love.graphics.print("TRY",362,280)
            love.graphics.print("AGAIN!",340,320)
            love.graphics.setFont(font3)
            love.graphics.print("press space to continue",326,360)
        end
    elseif gamestate == 7 then
        
    --variable resets - i only need to do this once so use flag
    if P2resetflag==0 then
        stopMenuRender1=false
        totalDugHoles=0;
        P2reset()
        spritePlayer.AVATAR=love.graphics.newImage("images/boy3.png")
        --update flag so it doesnt run this code again  
        P2resetflag=100
    end
    --draw background
    love.graphics.draw(P2S1gamebackground, 0, 0,0,2.2,2.2)
    --draw debris sprites
    drawDebrisP2()

    
    love.graphics.setFont(font2)
   --love.graphics.print(spritePlayer.tile_x .. "," .. spritePlayer.tile_y)
   if stopMenuRender1==false then
       love.graphics.print("Current Objective: Remove Debris ".. totalRemovedDebris .. " / 10 ",355,0)
       love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight,0 ,2,2 )   
   end 

    if closeDialogue==false and totalRemovedDebris<10 then 
       dialogManager:draw()
    end


    if totalRemovedDebris==10 and stopMenuRender1==false then
        love.graphics.rectangle("line", 200, 250, 400, 150)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 200, 250, 400, 150)
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(font4)
        love.graphics.print("RUBBLE",334,280)
        love.graphics.print("CLEARED!",318,320)
        love.graphics.setFont(font3)
        love.graphics.print("press space to continue",326,360)
        closeDialogue=false
     end

    elseif gamestate == 8 then
     
        if P2resetflag2==0 then
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
            P2resetflag2=100
        end
        --draw background
        love.graphics.draw(P2S1gamebackground, 0, 0,0,2.2,2.2)
        spritePlayer.AVATAR=love.graphics.newImage("images/boy3.png")
        
        love.graphics.setFont(font2)
        --change back to false
        if stopMenuRender2==true then
            --pop dialog once
            if popOnce==0 then
                popOnce=popOnce+1
                dialogManager:pop()
            end
           if closeDialogue==false and totalDugHoles<15 then
               dialogManager:draw()
           end
           love.graphics.print("Current Objective: Prepare the Ground for Trees: ".. totalDugHoles .. " / 15",180,0)
           drawXsP2()
           love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight,0 ,2,2 )
           --love.graphics.print(spritePlayer.tile_x ..",".. spritePlayer.tile_y , 20)
        end 

        --if player completes level~
        if totalDugHoles==15 then
            love.graphics.rectangle("line", 200, 250, 400, 150)
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", 200, 250, 400, 150)
            love.graphics.setColor(1,1,1)
            love.graphics.setFont(font4)
            love.graphics.print("HOLES",334,280)
            love.graphics.print("DUG!",353,320)
            love.graphics.setFont(font3)
            love.graphics.print("press space to continue",326,360)
         end
         
    elseif gamestate == 9 then
    -- Draw the same background as gamestate 10
    love.graphics.draw(P2S1gamebackground, 0, 0, 0, 2.2, 2.2)
    drawXsP2()
    -- Draw seed selection UI
    seedSelectionP2.draw()
    
    -- Only draw dialog if closeDialogue is false
    if closeDialogue == false then
        dialogManager:draw()
    end

    elseif gamestate == 10 then
      love.graphics.draw(P2S1gamebackground, 0, 0, 0, 2.2, 2.2)
      spritePlayer.AVATAR = love.graphics.newImage("images/boy3.png")
      love.graphics.setFont(font2)

      seedPlantingP2.draw()

      love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight, 0 ,2,2)
      
      if popOnce == 0 then
        dialogManager:pop()      -- shows the stage 10 seed planting message
        closeDialogue = false
        popOnce = 1
    end 


    if closeDialogue == false then
        dialogManager:draw()
    end


      
    elseif gamestate == 11 then
        if P2resetflag3==0 then
            renderObjectives=true
            totalWateredTrees=0
            overWatered=0
            P2resetflag3=100
        end
       
        -- draw background
        love.graphics.draw(grassBackground, 0, 0, 0, 1.7, 1.7)
        spritePlayer.AVATAR = love.graphics.newImage("images/boy3.png")
        love.graphics.setFont(font2)
  
      --  drawXsP2() -- ⬅️ draw holes (red X or dirt)
  
        seedPlantingP2.draw() -- ⬅️ draw planted seeds and saplings
  
        --temp line
        
        chosenSeed=seedSelectionP2.chosenSeedType
  
        gamestate11TreeDrawBackground()
        for _, animal in ipairs(animalsStage3) do
      if animal.visible then
          love.graphics.draw(animal.sprite, animal.x, animal.y, 0, 0.7,0.7)
      end
  end
  
        love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight, 0 ,2,2)
  
        -- dialogue handling
        if popOnce == 1 then
          popOnce = 2
          dialogManager:pop()      -- shows the stage 11 watering message
          closeDialogue = false
      end
        if closeDialogue == false and totalWateredTrees < 15 then
            dialogManager:draw()
        end
        
        if renderObjectives==true then
              love.graphics.print("Watered Trees: ".. totalWateredTrees.. " / 15 ",546,2)
              love.graphics.setColor(1,0,0)
              love.graphics.print("Underwatered / Overwatered Trees : ".. overWatered.. " / 3 ",312,30)
              love.graphics.setColor(1,1,1)
          end
  
          --if the player enters this stage while standing on a hole,
          --it will start the game when dialogue is closed and start the bar in the correct spot
          if closeDialogue==false then
              movingBarX=40
          end
  
           --if player is on a tree, and a miss penalty isnt active, start the game event. 
           if treeLocation(0) and missPenalty==false and stopBar==false and closeDialogue==true then
              stopBar=false
              drawWateringMinigameP2()
          end
  
          if onRedXP2()==false then
              --once player steps off tree area, reset flag so when player steps back on, bar resets once more
              P2resetBarflag=0
              missPenalty=false
              stopBar=false
          end

          if overWatered==3 then
            love.graphics.rectangle("line", 200, 250, 400, 150)
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", 200, 250, 400, 150)
            love.graphics.setColor(1,1,1)
            love.graphics.setFont(font4)
            love.graphics.print("TRY",362,280)
            love.graphics.print("AGAIN!",340,320)
            love.graphics.setFont(font3)
            love.graphics.print("press space to continue",326,360)
          end
  
         if totalWateredTrees == 15 then
      if allAnimalsArrived then
          if allAnimalsVisibleTimer >= allAnimalsVisibleDelay then
              -- Show completion message after delay
            love.graphics.rectangle("line", 200, 250, 400, 150)
              love.graphics.setColor(0,0,0)
              love.graphics.rectangle("fill", 200, 250, 400, 150)
              love.graphics.setColor(1,1,1)
              love.graphics.setFont(font4)
              love.graphics.print("Wildlife",340,280)
              love.graphics.print("Returned!",303,320)
              love.graphics.setFont(font3)
              love.graphics.print("press space to continue",326,360)
         end
      end
  end
  
      
elseif gamestate == 12 then
    -- Draw the background
    love.graphics.draw(dryGrassBackground, 0, 0, 0, 2.2, 2.2)
    
    -- Draw the player
    love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight, 0, 2, 2)
    
    -- Draw the trees (same as stage 11)
    gamestate11TreeDrawBackground()
    
    -- Handle dialogue
    if popOnce == 0 then
        dialogManager:pop()  -- shows the stage 10 seed planting message
        closeDialogue = false
        popOnce = 1
    end 

    if closeDialogue == false then
        dialogManager:draw()
    end
    
    -- Draw burning effects for selected trees
    for i, tree in ipairs(burningTrees) do
        local treeX = math.floor(tree.position.x / tilewidth)
        local treeY = math.floor(tree.position.y / tileheight)
        
        if spritePlayer.tile_x == treeX and spritePlayer.tile_y == treeY then
            drawWateringMinigameP2() -- Shows moving bar
          end
    end

    -- Draw particles and birds for active trees
    for i, tree in ipairs(burningTrees) do
        if tree.active then
            love.graphics.draw(tree.particles)
            
            -- Draw the flying bird if visible
            if tree.bird.visible then
                love.graphics.draw(birdSprites[tree.bird.animationFrame], 
                                 tree.bird.x, tree.bird.y, 0, 0.5, 0.5)
            end
        end
    end
    
    -- Draw all animals (make them all visible)
    for _, animal in ipairs(animalsStage3) do
        animal.visible = true
        love.graphics.draw(animal.sprite, animal.x, animal.y, 0, 0.7, 0.7)
    end
    
    -- Check if all animals are either saved or lost
    if allAnimalsArrived then
        local allHandled = true
        for _, animal in ipairs(animalsStage3) do
            if animal.visible and not (animal.saved or animal.escaped) then
                allHandled = false
                break
            end
        end
        if gamestate == 12 and savingAnimalsStarted and not savingAnimalsTimeUp then
            love.graphics.setColor(1, 0, 0) -- Red
            love.graphics.setFont(timerFont)
            love.graphics.print("Time Left: " .. math.ceil(savingAnimalsTimer), 20, 20)
            love.graphics.setColor(1, 1, 1) -- Reset color
        end

        if allHandled then
            showAnimalSummary = true
            -- Draw completion message
            if showAnimalSummary then
            local padding = 20
            love.graphics.setFont(font4)
            local mainText = animalsLost > 0 and "Warning! Some animals escaped!" or "All animals saved!"
            local mainTextWidth = love.graphics.getFont():getWidth(mainText)
            local mainTextHeight = love.graphics.getFont():getHeight()
        
            love.graphics.setFont(font3)
            local secondaryTextWidth = love.graphics.getFont():getWidth("press space to continue")
            local secondaryTextHeight = love.graphics.getFont():getHeight()
        
            local boxWidth = math.max(mainTextWidth, secondaryTextWidth) + padding * 2
            local boxHeight = mainTextHeight + secondaryTextHeight + padding * 3
        
            local boxX = (screenWidth - boxWidth) / 2
            local boxY = (screenHeight - boxHeight) / 2
        
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", boxX, boxY, boxWidth, boxHeight)
        
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight)
        
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(font4)
            love.graphics.print(mainText, boxX + (boxWidth - mainTextWidth) / 2, boxY + padding)
        
            love.graphics.setFont(font3)
            love.graphics.print("press space to continue", boxX + (boxWidth - secondaryTextWidth) / 2, boxY + padding + mainTextHeight + padding / 2)
        end
    end
end

    -- Draw animals saved counter
    love.graphics.setFont(font2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Animals Saved: ".. animalsSaved .." / " .. #animalsStage3, 520, 2)



elseif gamestate == 13 then
    -- Draw the background
    love.graphics.draw(dryGrassBackground, 0, 0, 0, 2.2, 2.2)
    
    -- Draw the player
    love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight, 0, 2, 2)
    
    -- Draw the trees
    gamestate11TreeDrawBackground()
    
    -- Draw burning effects for active fires
    for i, tree in ipairs(burningTrees) do
        if tree.active then
            love.graphics.draw(tree.particles)
        end
    end
    
    -- Draw extinguishing minigame if player is near a burning tree
    local nearBurningTree = false
    for i, tree in ipairs(burningTrees) do
        local treeX = math.floor(tree.position.x / tilewidth)
        local treeY = math.floor(tree.position.y / tileheight)
        
        if spritePlayer.tile_x == treeX and spritePlayer.tile_y == treeY and tree.active then
            drawWateringMinigameP2() -- Reuse the watering minigame UI for extinguishing
            nearBurningTree = true
            break
        end
    end
    
    -- Draw extinguishing progress
    love.graphics.setFont(font2)
    if fireExtinguishingComplete then
        love.graphics.print("Fires Extinguished: " .. #burningTrees .. " / " .. #burningTrees, 520, 2)
    else
        love.graphics.print("Fires Extinguished: " .. extinguishedFires .. " / " .. #burningTrees, 520, 2)
    end
    -- Draw dialogue if open
    if closeDialogue == false then
        dialogManager:draw()
    end
    
    -- Show completion message when all fires are out
    if fireExtinguishingComplete then
        local padding = 20
        love.graphics.setFont(font4)
        local mainText = "Fires Extinguished!"
        local mainTextWidth = love.graphics.getFont():getWidth(mainText)
        local mainTextHeight = love.graphics.getFont():getHeight()
    
        love.graphics.setFont(font3)
        local secondaryText = "press space to continue"
        local secondaryTextWidth = love.graphics.getFont():getWidth(secondaryText)
        local secondaryTextHeight = love.graphics.getFont():getHeight()
    
        local boxWidth = math.max(mainTextWidth, secondaryTextWidth) + padding * 2
        local boxHeight = mainTextHeight + secondaryTextHeight + padding * 3
    
        local boxX = (screenWidth - boxWidth) / 2
        local boxY = (screenHeight - boxHeight) / 2
    
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", boxX, boxY, boxWidth, boxHeight)
    
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight)
    
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font4)
        love.graphics.print(mainText, boxX + (boxWidth - mainTextWidth) / 2, boxY + padding)
    
        love.graphics.setFont(font3)
        love.graphics.print(secondaryText, boxX + (boxWidth - secondaryTextWidth) / 2, boxY + padding + mainTextHeight + padding / 2)
    end
    elseif gamestate == 14 then
        -- Draw green background
        love.graphics.draw(grassBackground, 0, 0, 0, 1.7, 1.7)
        
        -- Draw trees
        gamestate11TreeDrawBackground()
        
        -- Draw all animals
        for _, animal in ipairs(animalsStage4) do
            if animal.visible then
                love.graphics.draw(animal.sprite, animal.x, animal.y, 0, 0.7, 0.7)
            end
        end
        
        -- Draw player
        love.graphics.draw(spritePlayer.AVATAR, spritePlayer.tile_x * tilewidth, spritePlayer.tile_y * tileheight, 0, 2, 2)
        
        -- Draw dialogue
        dialogManager:draw()
        
        -- Show completion message after all animals have been visible for a while
        if allAnimalsArrived14 and allAnimalsVisibleTimer14 >= 3 then
            local padding = 20
            love.graphics.setFont(font4)
            local mainText = "Wildlife Returned!"
            local mainTextWidth = love.graphics.getFont():getWidth(mainText)
            local mainTextHeight = love.graphics.getFont():getHeight()
        
            love.graphics.setFont(font3)
            local subtext = "press space to continue"
            local subtextWidth = love.graphics.getFont():getWidth(subtext)
            local subtextHeight = love.graphics.getFont():getHeight()
        
            local boxWidth = math.max(mainTextWidth, subtextWidth) + padding * 2
            local boxHeight = mainTextHeight + subtextHeight + padding * 3
        
            local boxX = (screenWidth - boxWidth) / 2
            local boxY = (screenHeight - boxHeight) / 2
        
            -- Draw box background
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", boxX, boxY, boxWidth, boxHeight)
            
            -- Draw box border
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", boxX, boxY, boxWidth, boxHeight)
            love.graphics.setLineWidth(1)
        
            -- Draw main text
            love.graphics.setFont(font4)
            love.graphics.print(mainText, boxX + (boxWidth - mainTextWidth) / 2, boxY + padding)
        
            -- Draw subtext
            love.graphics.setFont(font3)
            love.graphics.print(subtext, boxX + (boxWidth - subtextWidth) / 2, boxY + padding + mainTextHeight + padding/2)
            
            -- Reset color
            love.graphics.setColor(1, 1, 1)
        end
end
end




function love.mousepressed(x, y, button, istouch)
    if gamestate == 4 then
        seedSelection.mousepressed(x, y, button, istouch)
    end
    if gamestate == 5 then
      seedPlanting.mousepressed(x, y, button)
    end
    
if gamestate == 9 then
    seedSelectionP2.mousepressed(x, y, button, istouch)
end
if gamestate == 10 then
    if button == 1 and closeDialogue == true then  -- prevent planting while dialogue is showing
        for i, hole in ipairs(seedPlantingP2.holePositions) do
            if not seedPlantingP2.plantedHoles[i] then
                if x >= hole.x - 20 and x <= hole.x + 60 and 
                   y >= hole.y - 20 and y <= hole.y + 60 then

                    -- Randomly pick a seed type from selected
                    local selectedSeeds = seedSelectionP2.selectedSeeds
                    if #selectedSeeds > 0 then
                        local chosenSeed = selectedSeeds[math.random(#selectedSeeds)]

                        local seedImg = love.graphics.newImage(chosenSeed .. "images/Seed.png")

                        table.insert(seedPlantingP2.plantedSeeds, {
                            x = hole.x,
                            y = hole.y,
                            state = "seed",
                            timer = 0,
                            counted = false,
                            image = seedImg,
                            type = chosenSeed
                        })

                        seedPlantingP2.plantedHoles[i] = true
                    end

                    break
                end
            end
        end
    end

end
  if button == 1 and gamestate == 12 and savingAnimalsStarted then
      for _, animal in ipairs(animalsStage3) do
          if animal.visible and not animal.saved then
              -- check if clicked inside animal bounds
              if x >= animal.x and x <= animal.x + animal.sprite:getWidth() * 0.7 and
                 y >= animal.y and y <= animal.y + animal.sprite:getHeight() * 0.7 then
                  animal.saved = true
                  animalsSaved = animalsSaved + 1
                  break
              end
          end
      end
  end

    if button == 1 then
        xclick = x
        yclick = y

        if gamestate == 0 then
            if xclick > 300 and yclick > 250 and xclick < 300 + width * 3 and yclick < 300 + height * 3 then
                gamestate = 1
            end
            if xclick > 300 and yclick > 325 and xclick < 300 + width * 3 and yclick < 375 + height * 3 then
                gamestate = 7
            end
            if xclick > 300 and yclick > 400 and xclick < 300 + width * 3 and yclick < 375 + height * 3 then
                gamestate = 12
            end
            if xclick > 300 and yclick > 475 and xclick < 300 + width * 3 and yclick < 375 + height * 3 then
                gamestate = 2
            end
        elseif gamestate == 6.5 then
            -- Handle click on "START LEVEL 2" button
            if xclick > 300 and yclick > 325 and xclick < 300 + width * 3 and yclick < 375 + height * 3 then
                gamestate = 7  -- Start Level 2
            end
        elseif gamestate == 2 then
            gamestate = settings.mousepressed(x, y, button)
        elseif gamestate == 1 then
            local buttonScale = 0.5
            local buttonWidth = PreviousButton:getWidth() * buttonScale
            local buttonHeight = PreviousButton:getHeight() * buttonScale
            local buttonX = 20
            local buttonY = love.graphics.getHeight() - buttonHeight - 200

            if xclick > buttonX and yclick > buttonY and xclick < buttonX + buttonWidth and yclick < buttonY + buttonHeight then
                forestState = forestState - 1
                if forestState < 1 then
                    forestState = 7
                end
            end

            local nextButtonWidth = NextButton:getWidth() * buttonScale
            local nextButtonHeight = NextButton:getHeight() * buttonScale
            local nextButtonX = love.graphics.getWidth() - nextButtonWidth - 20
            local nextButtonY = love.graphics.getHeight() - nextButtonHeight - 200

            if xclick > nextButtonX and yclick > nextButtonY and xclick < nextButtonX + nextButtonWidth and yclick < nextButtonY + nextButtonHeight then
                forestState = forestState + 1
                if forestState > 7 then
                    forestState = 1
                end
            end
        end
    end
    


end
function love.mousereleased(x, y, button)
    if gamestate == 2 then
        settings.mousereleased(x, y, button)
    end
end
function love.mousemoved(x, y)
    if gamestate == 2 then
        settings.mousemoved(x, y)
    end
end

function getPlayerPosition()
    local playerX, playerY

    if gamestate == 1 then
        -- Forest viewing state
        playerX = spritePlayer.tile_x * 32  -- Horizontal position
        playerY = screenHeight - 115 + (spritePlayer.tile_y - 4) * 34  -- Adjust Y position based on tile_y
    elseif gamestate == 3 then
        -- Stage 1 - clean up debris
        playerX = spritePlayer.tile_x * 32
        playerY = spritePlayer.tile_y * 32
    elseif gamestate == 4 then
        -- Seed selection stage
        playerX = spritePlayer.tile_x * 32
        playerY = screenHeight - 115 + (spritePlayer.tile_y - 4) * 34
    elseif gamestate == 5 then
        -- Seed planting stage
        playerX = spritePlayer.tile_x * tilewidth
        playerY = soilOffsetY + (spritePlayer.tile_y - 1) * tileheight
    end

    return playerX, playerY
end

function treeLocation(state )
    if spritePlayer.tile_x==2 and spritePlayer.tile_y==2 then
        if state==0 and treeStateSquare1==0 then
            return true
        elseif state==1 then
            treeStateSquare1=treeStateSquare1+1;
        end
    end
    if spritePlayer.tile_x==6 and spritePlayer.tile_y==2  then
        if state==0 and treeStateSquare2==0 then
            return true
        elseif state==1 then
            treeStateSquare2=treeStateSquare2+1;
        end
        
    end
    if spritePlayer.tile_x==10 and spritePlayer.tile_y==2 then
        if state==0 and treeStateSquare3==0 then
            return true
        elseif state==1 then
            treeStateSquare3=treeStateSquare3+1;
        end
        
    end
    if spritePlayer.tile_x==14 and spritePlayer.tile_y==2 then
        if state==0 and treeStateSquare4==0 then
            return true
        elseif state==1 then
            treeStateSquare4=treeStateSquare4+1;
        end
       
    end
    if spritePlayer.tile_x==18 and spritePlayer.tile_y==2 then
        if state==0 and treeStateSquare5==0 then
            return true
        elseif state==1 then
            treeStateSquare5=treeStateSquare5+1;
        end
        
    end
    if spritePlayer.tile_x==2 and spritePlayer.tile_y==6  then
        if state==0 and treeStateSquare6==0 then
            return true
        elseif state==1 then
            treeStateSquare6=treeStateSquare6+1;
        end
        
    end
    if spritePlayer.tile_x==6 and spritePlayer.tile_y==6  then
        if state==0 and treeStateSquare7==0 then
            return true
        elseif state==1 then
            treeStateSquare7=treeStateSquare7+1;
        end
        
    end
    if spritePlayer.tile_x==10 and spritePlayer.tile_y==6 then
        if state==0 and treeStateSquare8==0 then
            return true
        elseif state==1 then
            treeStateSquare8=treeStateSquare8+1;
        end
       
    end
    if spritePlayer.tile_x==14 and spritePlayer.tile_y==6 then
        if state==0 and treeStateSquare9==0 then
            return true
        elseif state==1 then
            treeStateSquare9=treeStateSquare9+1;
        end
        
    end
    if spritePlayer.tile_x==18 and spritePlayer.tile_y==6 then
        if state==0 and treeStateSquare10==0 then
            return true
        elseif state==1 then
            treeStateSquare10=treeStateSquare10+1;
        end
    end
    if spritePlayer.tile_x==2 and spritePlayer.tile_y==10  then
        if state==0 and treeStateSquare11==0 then
            return true
        elseif state==1 then
            treeStateSquare11=treeStateSquare11+1;
        end
       
    end
    if spritePlayer.tile_x==6 and spritePlayer.tile_y==10 then
        if state==0 and treeStateSquare12==0 then
            return true
        elseif state==1 then
            treeStateSquare12=treeStateSquare12+1;
        end
        
    end
    if spritePlayer.tile_x==10 and spritePlayer.tile_y==10 then
        if state==0 and treeStateSquare13==0 then
            return true
        elseif state==1 then
            treeStateSquare13=treeStateSquare13+1;
        end
        
    end
    if spritePlayer.tile_x==14 and spritePlayer.tile_y==10 then
        if state==0 and treeStateSquare14==0 then
            return true
        elseif state==1 then
            treeStateSquare14=treeStateSquare14+1;
        end
       
    end
    if spritePlayer.tile_x==18 and spritePlayer.tile_y==10 then
        if state==0 and treeStateSquare15==0 then
            return true
        elseif state==1 then
            treeStateSquare15=treeStateSquare15+1;
        end
    end
end


function getPlayerBoundaries()
    local minX, maxX, minY, maxY

    if gamestate == 1 then
        -- Forest viewing state
        minX = 0
        maxX = math.floor(screenWidth / 34) - 1
        minY = 0
        maxY = math.floor(screenHeight / 120) - 1
    elseif gamestate == 3 then
        -- Stage 1 - clean up debris
        minX = 0
        maxX = 20
        minY = 1
        maxY = 5
    elseif gamestate == 4 then
        -- Seed selection - allow movement within a small area
        minX = 0
        maxX = 20
        minY = 1
        maxY = 5
    elseif gamestate == 5 then
        -- Seed planting - restrict to planting area
        minX = 0
        maxX = 20
        minY = 1
        maxY = 5
    elseif gamestate == 6 then
        -- Seed planting - restrict to planting area
        minX = 0
        maxX = 20
        minY = 1
        maxY = 5
    else
        minX = 0
        maxX = 800
        minY = 0
        maxY = 600
    end

    return minX, maxX, minY, maxY
end

function love.keypressed(key)
    -- Handle seed selection keypresses
    if gamestate == 4 then
        seedSelection.keypressed(key)  -- Handle seed selection logic first

        -- Handle player movement in seed selection stage
        local x = spritePlayer.tile_x
        local y = spritePlayer.tile_y

        if key == "left" then
            x = x - 1
        elseif key == "right" then
            x = x + 1
        elseif key == "up" then
            y = y - 1
        elseif key == "down" then
            y = y + 1
        end

        -- Get dynamic boundaries for the current gamestate
        local minX, maxX, minY, maxY = getPlayerBoundaries()

        -- Clamp the player's position within the bounds
        x = math.max(minX, math.min(maxX, x))
        y = math.max(minY, math.min(maxY, y))

        -- Update the player's position
        spritePlayer.tile_x = x
        spritePlayer.tile_y = y

        
        return  -- Exit early to avoid conflicting movement logic
    end

    -- Handle player movement for all other game states
    local x = spritePlayer.tile_x
    local y = spritePlayer.tile_y

    -- Handle movement
    if key == "left" then
        x = x - 1
    elseif key == "right" then
        x = x + 1
    elseif key == "up" then
        y = y - 1
    elseif key == "down" then
        y = y + 1
    elseif key == 'c' then
        closeDialogue=true
    elseif key == 'e' and gamestate<8 then
        print("Player Position - X: " .. spritePlayer.tile_x .. ", Y: " .. spritePlayer.tile_y)
        if onRedX() then
            print("Player is on Red X")
            digHoles()
        else
            print("Player is NOT on Red X")
        end
    elseif key== "space" and gamestate==6 then
        if withinGreen() and onRedX2(0) then
            treeLocation(spritePlayer.tile_x,spritePlayer.tile_y, 1)
            stopBar=true
            onRedX2P2(1)
            totalWateredTrees=totalWateredTrees+1
            barSpeedModifier=barSpeedModifier+20
           
            taskCompleteNoiseOne:play()
        elseif onRedX2() and withinGreen()==false then
            --activate misspenalty variable, play error noise, add to error count and hide the bar minigame until the player steps off and steps back on the tile
            if overWatered==3 then
                gamestate6reset()
                barSpeedModifier=0
            else
                errornoise:play()
                overWatered=overWatered+1
                missPenalty=true
            end
        elseif overWatered>=3 then
            --reset overwatered counter and the level
            gamestate6reset()
        elseif totalWateredTrees==10 and overWatered~=3 then
            --go back to start menu??
            gamestate=7
            guideMonkeyVisible=false

        end


    elseif key=="space" and gamestate==6.5 then
        gamestate = 7
    elseif key=="space" and gamestate==7 and totalRemovedDebris==10 then
        gamestate=8
    elseif key=='e' and onRedXP2() and gamestate == 8 then
        digHolesP2()
   elseif key=="space" and gamestate==8 and totalDugHoles==15 then
        gamestate = 9
        
        dialogManager:show({
            text = [[Choose 1-3 seed types to plant...]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })
      
        popOnce = 0
        closeDialogue = false
   elseif key=="space" and gamestate==9 then
    if #seedSelectionP2.selectedSeeds > 0 then
        gamestate=10
        seedPlantingP2.load(seedSelectionP2.selectedSeeds)
        seedPlantingP2.spawnSeeds(seedPlantingP2.selectedSeedTypes)
        popOnce=0
        closeDialogue=false

        --clear the previous dialogue from Stage 9
        dialogManager.dialogueQueue = {}
        dialogManager.activeDialogue = nil

        -- show dialogue for Stage 10
        dialogManager:show({
            text = [[Great job picking your seeds! Now walk over the holes and press E to plant them. {press c to close dialogue}]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })
      
      popOnce=0
        closeDialogue=false


  end
    elseif key == 'c' and gamestate == 9 then
    closeDialogue = true
    
    elseif key == 'c' and gamestate == 12 then
        closeDialogue = true
    elseif key == 'e' and gamestate == 10 then
      for _, seed in ipairs(seedPlantingP2.plantedSeeds) do
        local seedTileX = math.floor(seed.x / 36)
        local seedTileY = math.floor(seed.y / 36)

        if spritePlayer.tile_x == seedTileX and spritePlayer.tile_y == seedTileY and seed.state == "seed" then
            seed.state = "covered"
            break
        end
    end
    if allCovered then
        gamestate = 11
        popOnce = 0
        closeDialogue = false

        dialogManager.dialogueQueue = {}
        dialogManager.activeDialogue = nil

        dialogManager:show({
            text = [[Awesome! All your seeds are safely planted. Now it's time to water them.]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })
    end
    elseif key == "space" and gamestate == 11 then
        if withinGreen() and onRedXP2() == true and missPenalty == false then
            stopBar = true
            treeLocation(1)
            totalWateredTrees = totalWateredTrees + 1
            gamestate11TreeDrawBackground()
            gamestate11TreeDrawForeground()
            barSpeedModifier=barSpeedModifier+20
            taskCompleteNoiseOne:play()
            missPenalty = true
        elseif onRedXP2() == true and withinGreen() == false and missPenalty == false then
            errornoise:play()
            overWatered = overWatered + 1
            missPenalty = true
        elseif overWatered == 3 then
            -- Reset 
            overWatered=0
            totalWateredTrees=0
            treeStateSquare1=0
            treeStateSquare2=0
            treeStateSquare3=0
            treeStateSquare4=0
            treeStateSquare5=0
            treeStateSquare6=0
            treeStateSquare7=0
            treeStateSquare8=0
            treeStateSquare9=0
            treeStateSquare10=0
            treeStateSquare11=0
            treeStateSquare12=0
            treeStateSquare13=0
            treeStateSquare14=0
            treeStateSquare15=0
        
    elseif totalWateredTrees == 15 and overWatered ~= 3 and 
           allAnimalsArrived and allAnimalsVisibleTimer >= allAnimalsVisibleDelay then
        -- Only allow continuing after all animals have arrived AND delay has passed
         gamestate = 12
          popOnce=0
        closeDialogue=false

        --clear the previous dialogue from Stage 9
        dialogManager.dialogueQueue = {}
        dialogManager.activeDialogue = nil
        
        dialogManager:show({
            text = [[The animals are back! But the dry season is creating fires! Click on the animals to save them! {press c to close}]],
            title = 'Zaki',
            image = love.graphics.newImage('images/zaki.png')
        })
       popOnce = 0
        closeDialogue = false
    end
elseif gamestate == 12 and showAnimalSummary and key == "space" then
    showAnimalSummary = false
    gamestate = 13  -- Move to fire extinguishing state
    popOnce = 0
    closeDialogue = false
    
    -- Clear previous dialogue and show fire extinguishing instructions
    dialogManager.dialogueQueue = {}
    dialogManager.activeDialogue = nil
    
    dialogManager:show({
        text = [[Quick! The fires are spreading! Extinguish them by pressing SPACE when the bar is green!}]],
        title = 'Zaki',
        image = love.graphics.newImage('images/zaki.png')
    })
    popOnce = 0
    closeDialogue = false
    -- Initialize fire extinguishing state
    fireExtinguishingStarted = true
    extinguishedFires = 0
    movingBarX = 40
    barDirection = 200
    stopBar = false
    
    -- Keep the burning trees from state 12 (don't reinitialize them)
    -- Just make sure the fire sound is playing
    if fireSound and not fireSound:isPlaying() then
        fireSound:play()
    end

elseif gamestate == 12 and showAnimalSummary and key == "space" then
    showAnimalSummary = false
    gamestate = 13  -- Move to fire extinguishing state
    popOnce = 0
    closeDialogue = false
    
    -- Clear previous dialogue and show fire extinguishing instructions
    dialogManager.dialogueQueue = {}
    dialogManager.activeDialogue = nil
    
    dialogManager:show({
        text = [[Quick! The fires are spreading! Extinguish them by pressing SPACE when the bar is green!}]],
        title = 'Zaki',
        image = love.graphics.newImage('images/zaki.png')
    })
    popOnce = 0
    closeDialogue = false
    -- Initialize fire extinguishing state
    fireExtinguishingStarted = true
    extinguishedFires = 0
    fireExtinguishingComplete = false  -- Add this flag to track completion
    movingBarX = 40
    barDirection = 200
    stopBar = false
    
    -- Keep the burning trees from state 12 (don't reinitialize them)
    -- Just make sure the fire sound is playing
    if fireSound and not fireSound:isPlaying() then
        fireSound:play()
    end

elseif gamestate == 13 then
    if key == "space" then
        -- Check if player is near a burning tree and the bar is in the green zone
        local nearBurningTree = false
        for i, tree in ipairs(burningTrees) do
            local treeX = math.floor(tree.position.x / tilewidth)
            local treeY = math.floor(tree.position.y / tileheight)
            
            if spritePlayer.tile_x == treeX and spritePlayer.tile_y == treeY and tree.active then
                nearBurningTree = true
                if withinGreen() then
                    tree.active = false
                    tree.particles:stop()
                    extinguishedFires = extinguishedFires + 1
                    taskCompleteNoiseOne:play()
                    stopBar = true
                    
                    -- Mark this tree as extinguished so it won't be drawn
                    tree.extinguished = true
                    
                    -- Check if all fires are extinguished
                    if extinguishedFires >= #burningTrees then
                        fireExtinguishingComplete = true
                    end
                else
                    errornoise:play()
                end
                break
            end
        end
        
        -- If all fires are extinguished and player presses space on the completion message
        if fireExtinguishingComplete and not nearBurningTree then
            gamestate = 14  -- Return to menu
        end
    elseif key == 'c' then
        closeDialogue = true
    end


    elseif gamestate == 13 and extinguishedFires == #burningTrees and key == "space" then
    -- Move to next state or back to menu
    gamestate = 14
    popOnce = 0
    closeDialogue = false
    elseif gamestate == 14 then

        if key == "c" then
            -- Close the dialogue
            closeDialogue = true
        elseif key == "space" then
            if closeDialogue == true and allAnimalsArrived14 and allAnimalsVisibleTimer14 >= 3 then
                -- Only move to main menu if dialogue is closed and animals have been visible
                -- Clear any remaining dialogues before returning to menu
            dialogManager.dialogueQueue = {}
            dialogManager.activeDialogue = nil

                gamestate = 0
                -- Reset state variables
            popOnce = 0
            closeDialogue = false
            allAnimalsArrived14 = false
            allAnimalsVisibleTimer14 = 0
            for _, animal in ipairs(animalsStage4) do
                animal.visible = false
            end
            elseif not closeDialogue then
                -- Pop dialogue if still showing
               -- dialogManager:pop()
                closeDialogue = true
                dialogManager.activeDialogue = nil
            end
    end
end

    
    -- Get dynamic boundaries for the current gamestate
    local minX, maxX, minY, maxY = getPlayerBoundaries()

    -- Clamp the player's position within the bounds
    x = math.max(minX, math.min(maxX, x))
    y = math.max(minY, math.min(maxY, y))

    -- Update the player's position
    spritePlayer.tile_x = x
    spritePlayer.tile_y = y

    -- Handle debris removal
    if gamestate == 3 then
        removeDebris()
    end
    if gamestate == 7 then
        removeDebrisP2()
    
end
end

  
function updateFireExtinguishing(dt)
    for i, tree in ipairs(burningTrees) do
        if tree.active then
            tree.particles:update(dt)
        end
    end

    -- Check if all fires are extinguished without modifying extinguishedFires
    if not fireExtinguishingComplete then
        local allExtinguished = true
        for i, tree in ipairs(burningTrees) do
            if tree.active then
                allExtinguished = false
                break
            end
        end
        
        if allExtinguished and #burningTrees > 0 then
            fireExtinguishingComplete = true
            fireExtinguishingStarted = false
            
            -- Stop fire sound
            if fireSound and fireSound:isPlaying() then
                fireSound:stop()
            end
        end
    end
end


function extinguishFire()
    -- Logic to extinguish fire when space is pressed
    if withinGreen() then
        for i, tree in ipairs(burningTrees) do
            if tree.active and not tree.extinguished and treeLocation(tree.position.x, tree.position.y) then
                tree.extinguished = true
                extinguishedFires = extinguishedFires + 1
                tree.particles:stop()
                -- Remove tree sprite
                tree.sprite = nil
                taskCompleteNoiseOne:play()
            end
        end
    else
        errornoise:play()
    end

end

    

    


function drawWateringMinigame()
    --draw all the trees in their proper location
       --drawSaplings()
       love.graphics.setColor(1,.1,.2)
       --background of watering task bar
       love.graphics.rectangle("fill", 40, 300, 720, 75)
       --zone
       love.graphics.setColor(0,.9,.4)
       love.graphics.rectangle("fill", 710 ,300, 50, 75)
       --bar 
       love.graphics.setColor(0,0,0)
       love.graphics.rectangle("fill", movingBarX, 300, 10, 75)
       --border
       love.graphics.setColor(0,0,0)
       love.graphics.setLineWidth(10)
       love.graphics.rectangle("line", 40, 300, 720, 75)
       
       love.graphics.setColor(1,1,1)
end

function drawWateringMinigameP2()
    --draw all the trees in their proper location
        --drawSaplings()
        love.graphics.setColor(1,.1,.2)
        --background of watering task bar
        love.graphics.rectangle("fill", 40, 500, 720, 75)
        
        --zone - find which tree position the player is on
        local treeIndex = 0
        for i = 1, 15 do
            if isPlayerOnTreePosition(i) then
                treeIndex = i
                break
            end
        end
        
        -- Get the green zone position for this tree
        local greenZoneX = 710 -- default position
        if treeIndex > 0 and treeGreenZonePositions[treeIndex] then
            greenZoneX = treeGreenZonePositions[treeIndex]
        end
        
        -- Draw green zone at the random position
        love.graphics.setColor(0,.9,.4)
        love.graphics.rectangle("fill", greenZoneX, 500, 50, 75)
        
        --bar 
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", movingBarX, 500, 10, 75)
        --border
        love.graphics.setColor(0,0,0)
        love.graphics.setLineWidth(10)
        love.graphics.rectangle("line", 40, 500, 720, 75)
        
        love.graphics.setColor(1,1,1)
end


function P2reset()
totalRemovedDebris=0
    closeDialogue=false
    renderTrashA=0
    renderBranchA=0
    renderBranchB=0
    renderTrashB=0
    renderTrashC=0
    renderBranchC=0
    renderBranchD=0
    renderBranchE=0
    renderBranchF=0
    renderTrashD=0
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
    
    -- Initialize random green zone positions for each tree
    treeGreenZonePositions = {}
    for i = 1, 15 do
        -- Generate a random position along the bar (40 to 710)
        local randomPos = math.random(40, 710)
        table.insert(treeGreenZonePositions, randomPos)
    end
end

function moveBar(dt)
    if movingBarX<740 then
        movingBarX = (movingBarX + barDirection * dt)
        if movingBarX < 39 then
            barDirection= barSpeedModifier
            movingBarX = 41
        end
    else
        barDirection= -1*barSpeedModifier
        movingBarX = 739
    end
end
function withinGreen()
   --if the bar is withing the green zone on the watering mini game return true
   
   -- Find which tree position the player is on
   local treeIndex = 0
   for i = 1, 15 do
       if isPlayerOnTreePosition(i) then
           treeIndex = i
           break
       end
   end
   
   -- Get the green zone position for this tree
   local greenZoneX = 695 -- default position
   if treeIndex > 0 and treeGreenZonePositions[treeIndex] then
       greenZoneX = treeGreenZonePositions[treeIndex]
   end
   
   if movingBarX >= greenZoneX and movingBarX < (greenZoneX + 50) then
       return true
   else
       return false
   end
end
function onRedX2(mode)
   --this function detects if player is standing in the right spot to water a tree. If they are, it returns true
   --to save space, mode determines that if player is ON a tree space AND finished watering do something

   if (spritePlayer.tile_x == 1 or spritePlayer.tile_x == 0) and spritePlayer.tile_y == 3 and redX1==true  then
       if mode==1 then
           redX1=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 1 or spritePlayer.tile_x == 0) and spritePlayer.tile_y == 1 and redX2==true  then
       if mode==1 then
           redX2=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 4 or spritePlayer.tile_x == 5) and  spritePlayer.tile_y == 3 and redX3==true  then
       if mode==1 then
           redX3=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 5 or spritePlayer.tile_x == 4) and spritePlayer.tile_y == 1 and redX4==true  then
       if mode==1 then
           redX4=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 8 or spritePlayer.tile_x == 9) and spritePlayer.tile_y == 1 and redX5==true  then   
       if mode==1 then
           redX5=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 9 or spritePlayer.tile_y == 8) and spritePlayer.tile_y == 3 and redX6==true then
       
       if mode==1 then
           redX6=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 12 or spritePlayer.tile_x == 13 or spritePlayer.tile_x == 14) and spritePlayer.tile_y == 1 and redX7==true then
       if mode==1 then
           redX7=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 12 or spritePlayer.tile_x == 13 or spritePlayer.tile_x == 14) and spritePlayer.tile_y == 3 and redX8==true then
       if mode==1 then
           redX8=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 16 or spritePlayer.tile_x == 17 or spritePlayer.tile_x == 18) and spritePlayer.tile_y == 1 and redX9==true then
       if mode==1 then
           redX9=false
           return false
       else
           return true
       end
   elseif (spritePlayer.tile_x == 16 or spritePlayer.tile_x == 17 or spritePlayer.tile_x == 18) and spritePlayer.tile_y == 3 and redX10==true then
       if mode==1 then
           redX10=false
           return false
       else
           return true
       end
   else
       return false
   end
          

end
function onRedX2P2(mode)
    --this function detects if player is standing in the right spot to water a tree. If they are, it returns true
    --to save space, mode determines that if player is ON a tree space AND finished watering do something
 
    if (spritePlayer.tile_x == 1 or spritePlayer.tile_x == 0) and spritePlayer.tile_y == 3 and redX1==true  then
        if mode==1 then
            redX1=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 1 or spritePlayer.tile_x == 0) and spritePlayer.tile_y == 1 and redX2==true  then
        if mode==1 then
            redX2=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 4 or spritePlayer.tile_x == 5) and  spritePlayer.tile_y == 3 and redX3==true  then
        if mode==1 then
            redX3=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 5 or spritePlayer.tile_x == 4) and spritePlayer.tile_y == 1 and redX4==true  then
        if mode==1 then
            redX4=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 8 or spritePlayer.tile_x == 9) and spritePlayer.tile_y == 1 and redX5==true  then   
        if mode==1 then
            redX5=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 9 or spritePlayer.tile_y == 8) and spritePlayer.tile_y == 3 and redX6==true then
        
        if mode==1 then
            redX6=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 12 or spritePlayer.tile_x == 13 or spritePlayer.tile_x == 14) and spritePlayer.tile_y == 1 and redX7==true then
        if mode==1 then
            redX7=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 12 or spritePlayer.tile_x == 13 or spritePlayer.tile_x == 14) and spritePlayer.tile_y == 3 and redX8==true then
        if mode==1 then
            redX8=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 16 or spritePlayer.tile_x == 17 or spritePlayer.tile_x == 18) and spritePlayer.tile_y == 1 and redX9==true then
        if mode==1 then
            redX9=false
            return false
        else
            return true
        end
    elseif (spritePlayer.tile_x == 16 or spritePlayer.tile_x == 17 or spritePlayer.tile_x == 18) and spritePlayer.tile_y == 3 and redX10==true then
        if mode==1 then
            redX10=false
            return false
        else
            return true
        end
    else
        return false
    end
           
 
 end
function gamestate11TreeDrawBackground() 
    
        if treeStateSquare1~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[1].treeImage, (tilewidth*2)-7,(tileheight*2)-38)
        end
        if treeStateSquare2~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[2].treeImage, (tilewidth*6)-7,(tileheight*2)-38)
        end
        if treeStateSquare3~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[3].treeImage, (tilewidth*10)-7,(tileheight*2)-38)
        end
        if treeStateSquare4~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[4].treeImage, (tilewidth*14)-7,(tileheight*2)-38)
        end
        if treeStateSquare5~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[5].treeImage, (tilewidth*18)-7,(tileheight*2)-38)
        end
        if treeStateSquare6~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[6].treeImage, (tilewidth*2)-7,(tileheight*6)-38)
        end
        if treeStateSquare7~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[7].treeImage, (tilewidth*6)-7,(tileheight*6)-38)
        end
        if treeStateSquare8~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[8].treeImage, (tilewidth*10)-7,(tileheight*6)-38)
        end
        if treeStateSquare9~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[9].treeImage, (tilewidth*14)-7,(tileheight*6)-38)
        end
        if treeStateSquare10~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[10].treeImage, (tilewidth*18)-7,(tileheight*6)-38)
        end
        if treeStateSquare11~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[11].treeImage, (tilewidth*2)-7,(tileheight*10)-38)
        end
        if treeStateSquare12~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[12].treeImage, (tilewidth*6)-7,(tileheight*10)-38)
        end
        if treeStateSquare13~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[13].treeImage, (tilewidth*10)-7,(tileheight*10)-38)
        end
        if treeStateSquare14~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[14].treeImage, (tilewidth*14)-7,(tileheight*10)-38)
        end
        if treeStateSquare15~=0 then
            love.graphics.draw(seedPlantingP2.plantedSeeds[15].treeImage, (tilewidth*18)-7,(tileheight*10)-38)
     
    end
    for i, tree in ipairs(burningTrees) do
        local treeX = math.floor(tree.position.x / tilewidth)
        local treeY = math.floor(tree.position.y / tileheight)
        
    end
end

function gamestate11TreeDrawForeground() 
    --haha get pranked theres nothing here
    if chosenSeed== "cedar" then
    
    elseif chosenSeed == "acacia" then

    elseif chosenSeed == "africanOlive" then
      
    end
end


function gamestate6TreeDrawForefront()
   if redX1==false then
       love.graphics.draw(tree1, 33, 410,0,3,3)
   end
   if redX3==false then
       love.graphics.draw(tree1, 190, 410,0,3,3)
   end
   if redX6==false then
       love.graphics.draw(tree1, 320, 410,0,3,3)
   end
   if redX8==false then
       love.graphics.draw(tree1, 485, 410,0,3,3)
   end
   if redX10==false then
       love.graphics.draw(tree1, 630, 410,0,3,3)
   end
end
function gamestate6TreeDrawBackground()
   if redX2==false then
       love.graphics.draw(tree1, 33, 340,0,3,3)
   end
   if redX4==false then
       love.graphics.draw(tree1, 190, 340,0,3,3)
   end
   if redX5==false then
       love.graphics.draw(tree1, 320, 340,0,3,3)
   end
   if redX7==false then
       love.graphics.draw(tree1, 485, 340,0,3,3)
   end
   if redX9==false then
       love.graphics.draw(tree1, 630, 340,0,3,3)
   end
end
function gamestate6reset()
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
    flag=true
    flag2=true
    totalWateredTrees=0
    overWatered=0
    gamestate6objectiveShow=true
    missPenalty=false
    barSpeedModifier=200
 end

function drawDebris()
    if renderStumpA == 0 then
        love.graphics.draw(stump, tilewidth * 17, soilOffsetY + tileheight * 1)
    end
    if renderStumpB == 0 then
        love.graphics.draw(stump, tilewidth * 20, soilOffsetY + tileheight * 4)
    end

    if renderTreeStumpA == 0 then
        love.graphics.draw(treeStump, tilewidth * 4, soilOffsetY + tileheight * 1)
    end
    if renderTreeStumpB == 0 then
        love.graphics.draw(treeStump, tilewidth * 15, soilOffsetY + tileheight * 1)
    end

    if renderTrashA == 0 then
        love.graphics.draw(garbage, tilewidth * 9, soilOffsetY + tileheight * 1)
    end
    if renderTrashB == 0 then
        love.graphics.draw(garbage, tilewidth * 20, soilOffsetY + tileheight * 2)
    end
    if renderTrashC == 0 then
        love.graphics.draw(garbage, tilewidth * 0, soilOffsetY + tileheight * 3)
    end
    if renderTrashD == 0 then
        love.graphics.draw(garbage, tilewidth * 12, soilOffsetY + tileheight * 3)
    end

    if renderBranchA == 0 then
        love.graphics.draw(branch1, tilewidth * 5, soilOffsetY + tileheight * 3)
    end
    if renderBranchB == 0 then
        love.graphics.draw(branch2, tilewidth * 9, soilOffsetY + tileheight * 4)
    end
    if renderBranchC == 0 then
        love.graphics.draw(branch1, tilewidth * 14, soilOffsetY + tileheight * 2)
    end
    if renderBranchD == 0 then
        love.graphics.draw(branch2, tilewidth * 2, soilOffsetY + tileheight * 5)
    end
    if renderBranchE == 0 then
        love.graphics.draw(branch2, tilewidth * 3, soilOffsetY + tileheight * 2)
    end
    if renderBranchF == 0 then
        love.graphics.draw(branch2, tilewidth * 17, soilOffsetY + tileheight * 3)
    end
    if renderBranchG == 0 then
        love.graphics.draw(branch3, tilewidth * 0, soilOffsetY + tileheight * 1)
    end
    if renderBranchH == 0 then
        love.graphics.draw(branch3, tilewidth * 10, soilOffsetY + tileheight * 1)
    end
end

function drawDebrisP2()
    if renderTrashA==0 then
        love.graphics.draw(garbage,tilewidth*9,tileheight*12)
    end
    if renderBranchA==0 then
        love.graphics.draw(branch1,tilewidth*5,tileheight*9)
    end
    if renderBranchB==0 then
        love.graphics.draw(branch2,tilewidth*17,tileheight*12)
    end
    if renderTrashB==0 then
        love.graphics.draw(garbage,tilewidth*18,tileheight*7)
    end
    if renderBranchC==0 then
        love.graphics.draw(branch1,tilewidth*7,tileheight*3)
    end
    if renderTrashC==0 then
        love.graphics.draw(garbage,tilewidth*2,tileheight*2)
    end
    if renderBranchD==0 then
        love.graphics.draw(branch2,tilewidth*17,tileheight)
    end
    if renderBranchE==0 then
        love.graphics.draw(branch2,tilewidth*11,tileheight*7)
    end
    if renderTrashD==0 then
        love.graphics.draw(garbage,tileheight*15,tileheight*3)
    end
    if renderBranchF == 0 then
        love.graphics.draw(branch2,tilewidth*2, tileheight*11)
    end
end

function removeDebris()
    if spritePlayer.tile_x == 17 and spritePlayer.tile_y == 1 then
        renderStumpA = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 20 and spritePlayer.tile_y == 4 then
        renderStumpB = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    end

    if spritePlayer.tile_x == 4 and spritePlayer.tile_y == 1 then
        renderTreeStumpA = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 15 and spritePlayer.tile_y == 1 then
        renderTreeStumpB = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    end

    if spritePlayer.tile_x == 9 and spritePlayer.tile_y == 1 then
        renderTrashA = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 20 and spritePlayer.tile_y == 2 then
        renderTrashB = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 0 and spritePlayer.tile_y == 3 then
        renderTrashC = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 12 and spritePlayer.tile_y == 3 then
        renderTrashD = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    end

    if spritePlayer.tile_x == 5 and spritePlayer.tile_y == 3 then
        renderBranchA = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 9 and spritePlayer.tile_y == 4 then
        renderBranchB = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 14 and spritePlayer.tile_y == 2 then
        renderBranchC = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 2 and spritePlayer.tile_y == 5 then
        renderBranchD = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 3 and spritePlayer.tile_y == 2 then
        renderBranchE = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 17 and spritePlayer.tile_y == 3 then
        renderBranchF = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 0 and spritePlayer.tile_y == 1 then
        renderBranchG = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    elseif spritePlayer.tile_x == 10 and spritePlayer.tile_y == 1 then
        renderBranchH = 1
        love.audio.play(debrisSound)  -- Play debris sound only here
    end

    totalRemovedDebris = renderStumpA + renderStumpB + renderTreeStumpA + renderTreeStumpB +
                         renderBranchA + renderBranchB + renderBranchC + renderBranchD + renderBranchE + renderBranchF + renderBranchG + renderBranchH +
                         renderTrashA + renderTrashB + renderTrashC + renderTrashD

    if totalRemovedDebris == 16 then
       debrisSound:stop() 
        currentDialogue = zakiDialoguesStage1.debrisCleared
        updateCurrentDialogue(gamestate)
    end
end

function removeDebrisP2()

    if spritePlayer.tile_x==9 and spritePlayer.tile_y==12 then
        renderTrashA=1
    end

    if spritePlayer.tile_x==5 and spritePlayer.tile_y==9 then
        renderBranchA=1
    end

    if spritePlayer.tile_x==17 and spritePlayer.tile_y==12 then
        renderBranchB=1
    end

    if spritePlayer.tile_x==7 and spritePlayer.tile_y==3 then
        renderBranchC=1
    end

    if spritePlayer.tile_x==18 and spritePlayer.tile_y==7 then
        renderTrashB=1
    end

    if spritePlayer.tile_x==2 and spritePlayer.tile_y==2 then
        renderTrashC=1
        totalRemovedDebris=100
    end

    if spritePlayer.tile_x==17 and spritePlayer.tile_y==1 then
        renderBranchD=1
    end

    if spritePlayer.tile_x==11 and spritePlayer.tile_y==7 then
        renderBranchE=1
    end

    if spritePlayer.tile_x==2 and spritePlayer.tile_y==11 then
        renderBranchF=1
    end

    if spritePlayer.tile_x==15 and spritePlayer.tile_y==3 then
        renderTrashD=1
    end

    totalRemovedDebris = renderBranchA+renderBranchB+renderBranchC+renderBranchD+renderBranchE+renderTrashA+renderTrashB+renderTrashC+renderTrashD+renderBranchF
    
end

function drawXs()
    local scaleFactor = 1

    if redX1 then
        love.graphics.draw(redX, tilewidth * 1, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 1, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    end
    if redX2 then
        love.graphics.draw(redX, tilewidth * 6, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 6, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    end
    if redX3 then
        love.graphics.draw(redX, tilewidth * 9, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 9, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    end
    if redX4 then
        love.graphics.draw(redX, tilewidth * 14, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 14, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    end
    if redX5 then
        love.graphics.draw(redX, tilewidth * 18, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 18, soilOffsetY + tileheight * 2, 0, scaleFactor, scaleFactor)
    end

    if redX11 then
        love.graphics.draw(redX, tilewidth * 1, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 1, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    end
    if redX12 then
        love.graphics.draw(redX, tilewidth * 6, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 6, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    end
    if redX13 then
        love.graphics.draw(redX, tilewidth * 9, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 9, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    end
    if redX14 then
        love.graphics.draw(redX, tilewidth * 14, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 14, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    end
    if redX15 then
        love.graphics.draw(redX, tilewidth * 18, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    else
        love.graphics.draw(dirt, tilewidth * 18, soilOffsetY + tileheight * 4, 0, scaleFactor, scaleFactor)
    end
end

function drawXsP2()
    if redX1==true then
        love.graphics.draw(redX,tilewidth*2,tileheight*2)
    else
        love.graphics.draw(dirt,tilewidth*2,tileheight*2)
    end
    if redX2==true then
        love.graphics.draw(redX,tilewidth*6,tileheight*2)
    else
        love.graphics.draw(dirt,tilewidth*6,tileheight*2)
    end
    if redX3==true then
        love.graphics.draw(redX,tilewidth*10,tileheight*2)
    else
        love.graphics.draw(dirt,tilewidth*10,tileheight*2)
    end 
    if redX4==true then
        love.graphics.draw(redX,tilewidth*14,tileheight*2)
    else
        love.graphics.draw(dirt,tilewidth*14,tileheight*2)
    end
    if redX5==true then
        love.graphics.draw(redX,tilewidth*18,tileheight*2)
    else
        love.graphics.draw(dirt,tilewidth*18,tileheight*2)
    end
    
    if redX6==true then
        love.graphics.draw(redX,tilewidth*2,tileheight*6)
    else
        love.graphics.draw(dirt,tilewidth*2,tileheight*6)
    end
    if redX7==true then
        love.graphics.draw(redX,tilewidth*6,tileheight*6)
    else
        love.graphics.draw(dirt,tilewidth*6,tileheight*6)
    end
    if redX8==true then
        love.graphics.draw(redX,tilewidth*10,tileheight*6)
    else
        love.graphics.draw(dirt,tilewidth*10,tileheight*6)
    end
    if redX9==true then
        love.graphics.draw(redX,tilewidth*14,tileheight*6)
    else
        love.graphics.draw(dirt,tilewidth*14,tileheight*6)
    end
    if redX10==true then
        love.graphics.draw(redX,tilewidth*18,tileheight*6)
    else
        love.graphics.draw(dirt,tilewidth*18,tileheight*6)
    end

    if redX11==true then
        love.graphics.draw(redX,tilewidth*2,tileheight*10)
    else
        love.graphics.draw(dirt,tilewidth*2,tileheight*10)
    end
    if redX12==true then
        love.graphics.draw(redX,tilewidth*6,tileheight*10)
    else
        love.graphics.draw(dirt,tilewidth*6,tileheight*10)
    end
    if redX13==true then
        love.graphics.draw(redX,tilewidth*10,tileheight*10)
    else
        love.graphics.draw(dirt,tilewidth*10,tileheight*10)
    end
    if redX14==true then
        love.graphics.draw(redX,tilewidth*14,tileheight*10)
    else
        love.graphics.draw(dirt,tilewidth*14,tileheight*10)
    end
    if redX15==true then
        love.graphics.draw(redX,tilewidth*18,tileheight*10)
    else
        love.graphics.draw(dirt,tilewidth*18,tileheight*10)
    end

end

function digHoles()
    print("Digging holes...")
    local holeDug = false
    
    if spritePlayer.tile_x == 1 and spritePlayer.tile_y == 2 and redX1 then
        redX1 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 6 and spritePlayer.tile_y == 2 and redX2 then
        redX2 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 9 and spritePlayer.tile_y == 2 and redX3 then
        redX3 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 14 and spritePlayer.tile_y == 2 and redX4 then
        redX4 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 18 and spritePlayer.tile_y == 2 and redX5 then
        redX5 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end

    if spritePlayer.tile_x == 1 and spritePlayer.tile_y == 4 and redX11 then
        redX11 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 6 and spritePlayer.tile_y == 4 and redX12 then
        redX12 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 9 and spritePlayer.tile_y == 4 and redX13 then
        redX13 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 14 and spritePlayer.tile_y == 4 and redX14 then
        redX14 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    if spritePlayer.tile_x == 18 and spritePlayer.tile_y == 4 and redX15 then
        redX15 = false
        totalDugHoles = totalDugHoles + 1
        holeDug = true
    end
    
    if holeDug then
      debrisSound:stop() 
        love.audio.play(diggingSound)  -- Play digging sound only here
    end

    if totalDugHoles == 10 then
        allHolesDug = true
        gamestate = 4
        currentDialogue = zakiDialoguesSeedSelection.chooseSeed
        stopMenuRender2 = true
    end
end

function digHolesP2()
    if spritePlayer.tile_x==2 and spritePlayer.tile_y==2 and redX1==true then
        redX1=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==6 and spritePlayer.tile_y==2  and redX2==true then
        redX2=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==10 and spritePlayer.tile_y==2 and redX3==true then
        redX3=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==14 and spritePlayer.tile_y==2 and redX4==true then
        redX4=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==18 and spritePlayer.tile_y==2 and redX5==true then
        redX5=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==2 and spritePlayer.tile_y==6 and redX6==true then
        redX6=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==6 and spritePlayer.tile_y==6 and redX7==true then
        redX7=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==10 and spritePlayer.tile_y==6 and redX8==true then
        redX8=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==14 and spritePlayer.tile_y==6 and redX9==true then
        redX9=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==18 and spritePlayer.tile_y==6 and redX10==true then
        redX10=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==2 and spritePlayer.tile_y==10 and redX11==true then
        redX11=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==6 and spritePlayer.tile_y==10 and redX12==true then
        redX12=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==10 and spritePlayer.tile_y==10 and redX13==true then
        redX13=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==14 and spritePlayer.tile_y==10 and redX14==true then
        redX14=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
    if spritePlayer.tile_x==18 and spritePlayer.tile_y==10 and redX15==true then
        redX15=false
        totalDugHoles = totalDugHoles+1
        love.audio.play(diggingSound)
    end
end

function onRedX()
    local onX = (spritePlayer.tile_x == 1 or spritePlayer.tile_x == 6 or spritePlayer.tile_x == 9 or 
                 spritePlayer.tile_x == 14 or spritePlayer.tile_x == 18) and
                (spritePlayer.tile_y == 2 or spritePlayer.tile_y == 4)
    print("onRedX: " .. tostring(onX))
    return onX
end

function onRedXP2()
    if (spritePlayer.tile_x==2 or spritePlayer.tile_x==6 or spritePlayer.tile_x==10 or spritePlayer.tile_x==14 or spritePlayer.tile_x==18) and (spritePlayer.tile_y==2 or spritePlayer.tile_y==6 or spritePlayer.tile_y==10 )then
        
        return true
        
    else 
        movingBarX=0
        return false
    end 
    movingBarX=40
end

function updateCurrentDialogue(state)
    print("Updating dialogue for state: " .. state)
    if state == 1 then
        if forestState == 1 then
            currentDialogue = zakiDialoguesForest.forest1
        elseif forestState == 2 then
            currentDialogue = zakiDialoguesForest.forest2
        elseif forestState == 3 then
            currentDialogue = zakiDialoguesForest.forest3
        end
    elseif state == 3 then
        if totalRemovedDebris == 16 then
            currentDialogue = zakiDialoguesStage1.debrisCleared
            print("Dialogue updated to debris cleared")
        else
            currentDialogue = zakiDialoguesStage1.cleanDebris
            print("Dialogue updated to clean debris")
        end
    elseif state == 4 then
        currentDialogue = zakiDialoguesSeedSelection.chooseSeed
        print("Dialogue updated to seed selection")
    end
end

-- Helper function to determine which tree position the player is on
function isPlayerOnTreePosition(index)
    if index == 1 and spritePlayer.tile_x == 2 and spritePlayer.tile_y == 2 then
        return true
    elseif index == 2 and spritePlayer.tile_x == 6 and spritePlayer.tile_y == 2 then
        return true
    elseif index == 3 and spritePlayer.tile_x == 10 and spritePlayer.tile_y == 2 then
        return true
    elseif index == 4 and spritePlayer.tile_x == 14 and spritePlayer.tile_y == 2 then
        return true
    elseif index == 5 and spritePlayer.tile_x == 18 and spritePlayer.tile_y == 2 then
        return true
    elseif index == 6 and spritePlayer.tile_x == 2 and spritePlayer.tile_y == 6 then
        return true
    elseif index == 7 and spritePlayer.tile_x == 6 and spritePlayer.tile_y == 6 then
        return true
    elseif index == 8 and spritePlayer.tile_x == 10 and spritePlayer.tile_y == 6 then
        return true
    elseif index == 9 and spritePlayer.tile_x == 14 and spritePlayer.tile_y == 6 then
        return true
    elseif index == 10 and spritePlayer.tile_x == 18 and spritePlayer.tile_y == 6 then
        return true
    elseif index == 11 and spritePlayer.tile_x == 2 and spritePlayer.tile_y == 10 then
        return true
    elseif index == 12 and spritePlayer.tile_x == 6 and spritePlayer.tile_y == 10 then
        return true
    elseif index == 13 and spritePlayer.tile_x == 10 and spritePlayer.tile_y == 10 then
        return true
    elseif index == 14 and spritePlayer.tile_x == 14 and spritePlayer.tile_y == 10 then
        return true
    elseif index == 15 and spritePlayer.tile_x == 18 and spritePlayer.tile_y == 10 then
        return true
    end
    return false
end

