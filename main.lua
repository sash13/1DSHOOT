function love.load(arg) 
  width = love.graphics.getWidth( )
  height = love.graphics.getHeight( )
  
  actor = {}
  actor.width = 50
  actor.height = 50
  actor.seek = 60
  actor.x = width - (width-actor.seek)
  actor.y = height/2-actor.height/2
  actor.speed = 100
  actor.speedUpConstant = 150
  actor.speedUp = 0
  
  speedUpBox = {}
  speedUpBox.x = width - 100 - 100*0.3
  speedUpBox.y = 50*0.3
  speedUpBox.height = 20
  speedUpBox.width = 0
  
  edges = {}
  
  edge = {}
  edge.x = 0
  edge.y = 0
  edge.width = width
  edge.height = actor.y
  table.insert(edges, edge)
  
  edge = {}
  edge.x = 0
  edge.y = height/2+actor.height/2
  edge.width = width
  edge.height = actor.y
  table.insert(edges, edge)
  
  enemies = {}
  
  addEnemy()
end

function love.keyreleased(key)
    if (key == " ") then
      speedUp()
    end
    if (key == "z") then
      addEnemy()
    end
    
end

function love.update(dt)
  -- tempolary array of enemies when it out of scean
  local remEnemy = {}
  
  local shiftDiff = (actor.speed + actor.speedUp)*dt
  -- update actor position
  --actor.x = actor.x + (actor.speed + actor.speedUp)*dt
  if actor.speedUp > 0 then
    actor.speedUp = actor.speedUp - dt*50
  end
  
  -- calculate fill of bonus box ex: 50/150*100%=33.33% 
  speedUpBox.width = actor.speedUp/actor.speedUpConstant*100
  if actor.speedUp < 0 then actor.speedUp = 0 end
  
  for i,v in ipairs(enemies) do
    --v.x = v.x - 100*dt
    v.x = v.x - shiftDiff
    local dif = -actor.width
    if v.x < dif then
      table.insert(remEnemy, i)
    end
  end
  
  for i,v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end
  
end

function love.draw()
  -- draw a background
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("fill", 0, 0, width, height)
  
  -- draw a red edges
  love.graphics.setColor(255,255,255,255)
  for i,v in ipairs(edges) do
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
  
  -- draw our actor
  love.graphics.setColor(255,255,0,125)
  love.graphics.rectangle("fill", actor.x, actor.y, actor.width, actor.height)
  
  -- draw some debug info
  --love.graphics.setColor(0,0,0,255)
  --love.graphics.print(actor.x, 100, 100)
  
  --draw speedUp box
  love.graphics.setColor(0,0,0,125)
  love.graphics.rectangle("fill", speedUpBox.x, speedUpBox.y, speedUpBox.width, speedUpBox.height)
  
  --draw enemies
  for i,v in ipairs(enemies) do
    love.graphics.setColor(255,0,0,255)
    -- don'n render enemy when it out of game screan
    if v.x < width then
      love.graphics.rectangle("fill", v.x, v.y, actor.width, actor.height)
    end
  end
  
end

function speedUp()
  if actor.speedUp > 0 then return end
  actor.speedUp = actor.speedUpConstant
  
end

function addEnemy()
  local enemy = {}
  enemy.x = width
  enemy.y = actor.y
  table.insert(enemies, enemy)
  
end