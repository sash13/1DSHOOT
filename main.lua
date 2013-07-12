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
  actor.blink = 0
  
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
  max_enemies = 3
  
  time  = 0
  Hz    = 1
  dHz   = 0.08
  score = 0
  
  font = love.graphics.newFont(28)
  --addEnemy()
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
  -- tempolary array of enemies when it out of screan
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
      score = score + 1
    end
    if CheckCollision(v.x,v.y,2,3,actor.x,actor.y,actor.width,actor.height) then
      if actor.blink == 1 then
        table.insert(remEnemy, i)
        score = score - 1
      end
    end
  end
  
  for i,v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end
  
  time = time + dt
  if time > 2/Hz then
    time = 0
    Hz = Hz + dHz
    if Hz > 6 then
      Hz = 1
      max_enemies = max_enemies + 2
    end
  end
  
  if time > 1/Hz then
    actor.blink = 0
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
  if time < 1/Hz then
    actor.blink = 1
    love.graphics.rectangle("fill", actor.x, actor.y, actor.width, actor.height)
  end
  -- draw some score info
  if score > 0 then
    love.graphics.setColor(0,255,0,255)
  elseif score < 0 then
    love.graphics.setColor(255,0,0,255)
  else 
    love.graphics.setColor(0,0,0,255)
  end
  love.graphics.setFont(font)
  love.graphics.print(score, 50, 50)
  
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
  
  -- draw help info
  love.graphics.setColor(0,0,0,125)
  love.graphics.print('Press "Space" to speed up your player', 50, height/2+height/4)
  love.graphics.print('Press "Z" to create enemies', 50, height/2+height/4+28)
end

function speedUp()
  if actor.speedUp > 0 then return end
  actor.speedUp = actor.speedUpConstant
  
end

function addEnemy()
  if #enemies > max_enemies then return end
  local enemy = {}
  enemy.x = width
  enemy.y = actor.y
  table.insert(enemies, enemy)
  
end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
-- from [love2d tutorial, part 2](http://www.headchant.com/2010/12/31/love2d-%E2%80%93-tutorial-part-2-pew-pew/)
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end