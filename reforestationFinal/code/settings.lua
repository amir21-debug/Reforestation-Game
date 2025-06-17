local settings = {
    -- Settings state
    masterVolume = 1.0,
    sliderX = 400,
    sliderWidth = 200,
    isDraggingSlider = false,
    
    -- UI elements
    backButton = {
        x = 300,
        y = 500,
        width = 200,
        height = 50
    },
    
 
    clouds = {},    
    
    -- Colors
    titleColor = {0.3, 0.5, 0.9},
    panelColor = {1, 1, 1, 0.7},
    borderColor = {0.6, 0.8, 1},
    sliderBgColor = {0.8, 0.9, 1},
    sliderFillColor = {0.5, 0.7, 1},
    sliderHandleColor = {1, 1, 1},
   backButtonColor = {0.3, 0.4, 0.8},  
    backButtonBorderColor = {0.1, 0.2, 0.6}, 
    buttonTextColor = {1, 1, 1}, 
    textColor = {0.2, 0.3, 0.7}
}

function settings.load(background)
    -- Store reference to background image
    settings.backgroundImg = background2
    
    
    settings.smallCloudImg = love.graphics.newImage("images/cloud.png")

    
   
    for i = 1, 6 do
        table.insert(settings.clouds, {
            x = math.random(50, 750),
            y = math.random(50, 550),
            scale = math.random(0.3, 0.6),
            speed = math.random(5, 15),
            direction = math.random() > 0.5 and 1 or -1
        })
    end
    
    
    settings.roundFont = love.graphics.newFont("fonts/CCRedAlert.ttf", 28)
    settings.smallFont = love.graphics.newFont("fonts/CCRedAlert.ttf", 20)
end

function settings.update(dt)
    -- Animate small clouds
    for _, cloud in ipairs(settings.clouds) do
        cloud.x = cloud.x + cloud.speed * dt * cloud.direction
        
        -- Bounce clouds off screen edges
        if cloud.x > 800 - settings.smallCloudImg:getWidth() * cloud.scale then
            cloud.direction = -1
        elseif cloud.x < 0 then
            cloud.direction = 1
        end
    end
end

function settings.draw()
    -- Draw the background image first
    love.graphics.setColor(1, 1, 1, 1)
    if settings.backgroundImg then
        love.graphics.draw(settings.backgroundImg, 0, 0, 0, 2.2, 2.2) 
    end
    
    
    -- Draw small floating clouds
    love.graphics.setColor(1, 1, 1, 0.8)
    for _, cloud in ipairs(settings.clouds) do
        love.graphics.draw(settings.smallCloudImg, cloud.x, cloud.y, 0, cloud.scale, cloud.scale)
    end
    
    -- Draw a semi-transparent panel for settings
    love.graphics.setColor(settings.panelColor)
    love.graphics.rectangle("fill", 200, 150, 400, 300, 25, 25)
    
    love.graphics.setColor(settings.borderColor)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", 200, 150, 400, 300, 25, 25) 
    
    
    love.graphics.setFont(settings.roundFont)
    love.graphics.setColor(settings.titleColor)
    love.graphics.print("Settings", 320, 170)
    
   
    love.graphics.setFont(settings.smallFont)
    love.graphics.setColor(settings.textColor)
    love.graphics.print(" Volume Contorl: ", 280, 230)
    
   
    love.graphics.setColor(settings.sliderBgColor)
    love.graphics.rectangle("fill", 300, 270, 200, 20, 10, 10) 
    
  
    love.graphics.setColor(settings.sliderFillColor)
    love.graphics.rectangle("fill", 300, 270, settings.sliderWidth * settings.masterVolume, 20, 10, 10)
    
   
    love.graphics.setColor(settings.sliderHandleColor)
    local handleX = 300 + (settings.sliderWidth * settings.masterVolume)
    
  
    love.graphics.circle("fill", handleX, 280, 15)
    love.graphics.circle("fill", handleX-8, 275, 10)
    love.graphics.circle("fill", handleX+8, 275, 10)
    
  
    love.graphics.setColor(settings.backButtonColor)
    love.graphics.rectangle("fill", settings.backButton.x, settings.backButton.y, 
                          settings.backButton.width, settings.backButton.height, 15, 15)
    

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Back to Sky", settings.backButton.x + 50, settings.backButton.y + 15)
end

function settings.mousepressed(x, y, button)
    if button == 1 then
        -- Check for slider interaction
        if y >= 260 and y <= 290 and x >= 290 and x <= 510 then
            settings.isDraggingSlider = true
            -- Update volume based on click position
            settings.masterVolume = math.max(0, math.min(1, (x - 300) / settings.sliderWidth))
        end
        
        -- Check for back button
        if x >= settings.backButton.x and x <= settings.backButton.x + settings.backButton.width
        and y >= settings.backButton.y and y <= settings.backButton.y + settings.backButton.height then
            return 0  -- Return to main menu
        end
    end
    return 2  -- Stay in settings
end

function settings.mousereleased(x, y, button)
    if button == 1 then
        settings.isDraggingSlider = false
    end
end

function settings.mousemoved(x, y)
    if settings.isDraggingSlider then
        -- Update volume based on drag position
        settings.masterVolume = math.max(0, math.min(1, (x - 300) / settings.sliderWidth))
    end
end

-- Get current volume
function settings.getVolume()
    return settings.masterVolume
end

return settings
