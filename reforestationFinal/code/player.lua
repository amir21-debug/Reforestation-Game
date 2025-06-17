Player = Object:extend()

function Player:new()
   self.image = love.graphics.newImage("images/boy.png") 
   self.x = 120 -- Initial x position
   self.y = love.graphics.getHeight() - 100 -- Initial y position (on the "floor")
   self.speed = 100
   self.width = self.image:getWidth()
   self.height = self.image:getHeight()
end
    
function Player:update(dt)
    -- Update character position based on keyboard input
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt -- Move right
    elseif love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt -- Move left
    elseif love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt -- Move down
    elseif love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt -- Move up
    end

     local window_width = love.graphics.getWidth()
    local scaled_width = self.width * 0.4 -- Account for the scaling factor
    
      local window_Height= love.graphics.getHeight()
      local scaled_height = self.height * 0.4

    if self.x < 0 then
        self.x = 0
    elseif self.x + scaled_width > window_width then
        self.x = window_width - scaled_width
    end
    if self.y  < 0 then
      self.y = 0
     elseif self.y + scaled_height >window_Height then
        self.y = window_Height- scaled_height
end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, 1.2, 1.2) -- Adjust scaling here
end