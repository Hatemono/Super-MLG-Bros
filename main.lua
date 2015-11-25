debug = true
BulletSpeed = 1000
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
bulletImg = nil
enemyImg = nil
bullets = {}
enemies = {}
bulletsL = {}
walkTimer = 0.1
walk = true
wok = true
walk1 = 1
isLeft = false
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
PlayerAlive = true
score = 0
--PhysX--
FizykaLol = true   --Ustaw na true i umrzyj--
Objects = {player = { x = 200, y = 200, speed = 150, img = nil } , podloga = {}}
--PhysX--

function love.load(arg)
  --PhysX--
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)
  Objects.podloga.body = love.physics.newBody(world, love.graphics.getWidth()/4, love.graphics.getHeight()-16) 
  Objects.podloga.shape = love.physics.newRectangleShape(love.graphics.getWidth()/2, 16)
  Objects.podloga.fixture = love.physics.newFixture(Objects.podloga.body, Objects.podloga.shape)
  Objects.player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
  Objects.player.body:setFixedRotation(not FizykaLol)
  Objects.player.shape = love.physics.newRectangleShape(72,72)
  Objects.player.fixture = love.physics.newFixture(Objects.player.body, Objects.player.shape, 1)
  Objects.player.fixture:setRestitution(0.3)
  --PhysX--
	hit = love.audio.newSource("Audio/HITMARKER.mp3","static")
	wow = love.audio.newSource("/Audio/wow.mp3","static")
	bulletImg = love.graphics.newImage("/Gfx/bullet2.png")
  bulletImgL = love.graphics.newImage("/Gfx/bullet2L.png")
  enemyImg = love.graphics.newImage("/Gfx/Kriper.png")
  cross = love.graphics.newImage("/Gfx/Crosshair.png") --celownik jak cos
  love.mouse.setVisible(false) -- a to do wywalania kuhsoha
  run = love.graphics.newImage("/Gfx/Marian1.png")
  run2 = love.graphics.newImage("/Gfx/Marian2.png")
  run3 = love.graphics.newImage("/Gfx/Marian3.png")
  jump = love.graphics.newImage("/Gfx/jump.png")
  stop = love.graphics.newImage("/Gfx/marian_stop.png")
  runL = love.graphics.newImage("/Gfx/Marian1L.png")
  run2L = love.graphics.newImage("/Gfx/Marian2L.png")
  run3L = love.graphics.newImage("/Gfx/Marian3L.png")
  jumpL = love.graphics.newImage("/Gfx/jumpL.png")
  stopL = love.graphics.newImage("/Gfx/marian_stopL.png")
  snajpa = love.graphics.newImage("/Gfx/snajpa.png")
  snajpaL = love.graphics.newImage("/Gfx/snajpaL.png")
  Objects.podloga.img = love.graphics.newImage("/Gfx/brick.png")
  Objects.player.img = run
end

function love.update(dt)
  --PhysX--
  world:update(dt)
  --PhysX--
  if love.mouse.getX() < Objects.player.body:getX() then isLeft = true
  else isLeft = false end
  
	if love.keyboard.isDown("escape") then love.event.push("quit") end
  gundirection = findRotation(Objects.player.body:getX(), Objects.player.body:getY(),love.mouse.getX(),love.mouse.getY())
  if not love.keyboard.isDown("left", "right", "a", "d") then
    if isLeft then Objects.player.img = stopL
    else Objects.player.img = stop end
  end
	
  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight  ()) then
			table.remove(bullets, j)
			table.remove(enemies, i)
			score = score + 1
		end
	end

	if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), Objects.player.x, Objects.player.y, Objects.player.img:getWidth(), Objects.player.img:getHeight()) 
	and isAlive then
		table.remove(enemies, i)
		isAlive = false
	end
end
  
  
  if love.keyboard.isDown("left","a") then
		if Objects.player.x > 0 then
			Objects.player.body:applyForce(-300, 0)
      if(walk == true) then 
        walk = false
        walkTimer = 0.1
        if isLeft then
          if (walk1 == 1) then Objects.player.img = runL end
          if (walk1 == 2) then Objects.player.img = run2L end
          if (walk1 == 3) then Objects.player.img = run3L end
        else
          if (walk1 == 1) then Objects.player.img = run end
          if (walk1 == 2) then Objects.player.img = run2 end
          if (walk1 == 3) then Objects.player.img = run3 end
        end
      end
		end
	end
  
	if love.keyboard.isDown("right","d") then
		if Objects.player.x < (love.graphics.getWidth() - Objects.player.img:getWidth()) then
			Objects.player.body:applyForce(300, 0)
      if(walk == true) then 
        walk = false
        walkTimer = 0.1
        if isLeft then
          if (walk1 == 1) then Objects.player.img = runL end
          if (walk1 == 2) then Objects.player.img = run2L end
          if (walk1 == 3) then Objects.player.img = run3L end
        else
          if (walk1 == 1) then Objects.player.img = run end
          if (walk1 == 2) then Objects.player.img = run2 end
          if (walk1 == 3) then Objects.player.img = run3 end
        end
      end
		end	
	end
	
  if love.keyboard.isDown("down","s") then
		Objects.player.y = Objects.player.y + (Objects.player.speed * dt)
  end
	
  if love.keyboard.isDown("up","w") then
		Objects.player.body:applyLinearImpulse(0, -30)
    if isLeft then Objects.player.img = jumpL
    else Objects.player.img = jump end
	end
  
  if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
    newBullet = {}
    newBullet.img = bulletImg
    if isLeft then
      --PhysX--
      Iks = Objects.player.body:getX() - 20 + math.cos(gundirection)*100
      Igrek = Objects.player.body:getY() + math.sin(gundirection)*100
      newBullet.body = love.physics.newBody(world, Iks, Igrek, "dynamic") 
      newBullet.shape = love.physics.newRectangleShape(24,6)
      newBullet.body:setAngle(gundirection);
      newBullet.fixture = love.physics.newFixture(newBullet.body, newBullet.shape, 1)
      newBullet.fixture:setRestitution(0.9)
      newBullet.body:setLinearVelocity(math.cos(gundirection)*300, math.sin(gundirection)*300)
      --PhysX--
      table.insert(bulletsL, newBullet)
      if Objects.player.x < love.graphics.getWidth() - Objects.player.img:getWidth() then
        Objects.player.x = Objects.player.x+5 
      end
    else
      --PhysX--
      Iks = Objects.player.body:getX() + math.cos(gundirection)*100
      Igrek = Objects.player.body:getY() + math.sin(gundirection)*100
      newBullet.body = love.physics.newBody(world, Iks, Igrek, "dynamic") 
      newBullet.shape = love.physics.newRectangleShape(24,6)
      newBullet.body:setAngle(gundirection);
      newBullet.fixture = love.physics.newFixture(newBullet.body, newBullet.shape, 1)
      newBullet.fixture:setRestitution(0.9)
      newBullet.body:setLinearVelocity(math.cos(gundirection)*300, math.sin(gundirection)*300)
      --PhysX--
      table.insert(bullets, newBullet)
      if(Objects.player.x > 4) then Objects.player.x = Objects.player.x-5 end
    end
    canShoot = false
    canShootTimer = canShootTimerMax
	end
  
  walkTimer = walkTimer - (1 * dt)
  
  if walkTimer < 0 then
    walk = true
    if (walk1 < 3) then walk1 = walk1 + 1
    else walk1 = 1 end
  end
	
  canShootTimer = canShootTimer - (1 * dt)
	
	if canShootTimer < 0 then
    canShoot = true
	end
	
  for i, bullet in ipairs(bullets) do
    if bullet.body:getX() > love.graphics.getWidth() then
			table.remove(bullets, i)
		end
	end
  for i, bullet in ipairs(bulletsL) do
		if bullet.body:getX() < 0 - bulletImg:getWidth() then
			table.remove(bulletsL, i)
		end
	end
  
  createEnemyTimer = createEnemyTimer - (1 * dt)
    if createEnemyTimer < 0 then
      createEnemyTimer = createEnemyTimerMax
    randomNumber = math.random(10, love.graphics.getWidth() - 10)
    newEnemy = { y = randomNumber, x = 640, img = enemyImg }
    table.insert(enemies, newEnemy)
  end
  
  for i, enemy in ipairs(enemies) do
    enemy.x = enemy.x - (200 * dt)
    if enemy.x < 0 then 
      table.remove(enemies, i)
    end
  end
  
end

function love.draw(dt)
  local myszx, myszy = love.mouse.getPosition()
  love.graphics.polygon("fill", Objects.player.body:getWorldPoints(Objects.player.shape:getPoints()))
  love.graphics.polygon("fill", Objects.podloga.body:getWorldPoints(Objects.podloga.shape:getPoints()))
  love.graphics.draw(cross, myszx-60, myszy-45)
 	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),10,10)
  love.graphics.print("Wynik:"..tostring(score),50,50)
	love.graphics.draw(Objects.player.img, Objects.player.body:getX(), Objects.player.body:getY(),Objects.player.body:getAngle(),1,1,36,36)
  love.graphics.print(table.maxn(bulletsL)..'-'..table.maxn(bullets),10,80)
 	if isLeft then love.graphics.draw(snajpaL, Objects.player.body:getX(), Objects.player.body:getY()+20,gundirection+3.14,1,1,130,21)
  else love.graphics.draw(snajpa, Objects.player.body:getX(), Objects.player.body:getY()+20,gundirection,1,1,50,21) end
	for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.body:getX(), bullet.body:getY(),bullet.body:getAngle(),1,1,12,3)
	end
  
  for i, bullet in ipairs(bulletsL) do
    love.graphics.draw(bullet.img, bullet.body:getX(), bullet.body:getY(),bullet.body:getAngle(),1,1,12,3)
	end
  
  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y,0,0.3)
  end
  
  --for i=0, love.graphics.getWidth(), 16 do
  --  love.graphics.draw(Objects.podloga.img, i-8, love.graphics.getHeight()-16-8)
  --end
  
  love.graphics.print(tostring(walk1),60,10)
end

function love.keypressed(key)
	if key == "a" then hit:play() 
  else hit:play() end
	if key == "w" then wow:play() end
end

function findRotation(x1,y1,x2,y2) --do celowania ;p
   return math.atan2(y2 - y1, x2 - x1)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  --return x1 < x2+w2 and
  --       x2 < x1+w1 and
  --       y1 < y2+h2 and
  --      y2 < y1+h1
end