local Dialove = require('Dialove')

function love.load()
  dialogManager = Dialove.init({
    font = love.graphics.newFont('CCRedAlert.ttf', 16)
  })
  dialogManager:push('Dialog content') -- stores a dialog into memory
  dialogManager:pop() -- requests the first pushed dialog to be shown on screen
  
  -- show() does both things, but don't do this:
  dialogManager:show('Dialog content')
  dialogManager:show('Dialog content')
  dialogManager:show('Dialog content') -- only this one will be shown

  -- use this approach instead:
  dialogManager:show('Dialog content')
  dialogManager:push('Dialog content')
  dialogManager:push('Dialog content')
end

function love.update(dt)
  dialogManager:update(dt)
end

function love.draw()
  dialogManager:draw()
end

function love.keypressed(k)
  if k == 'return' then
    dialogManager:pop()
  elseif k == 'c' then
    dialogManager:complete()
  elseif k == 'f' then
    dialogManager:faster()
  elseif k == 'down' then
    dialogManager:changeOption(1) -- next one
  elseif k == 'up' then
    dialogManager:changeOption(-1) -- previous one
  end
end

function love.keyreleased(k)
  if k == 'space' then
    dialogManager:slower()
  end
end