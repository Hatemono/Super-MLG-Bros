debug = true
BulletSpeed = 1000
player = { x = 200, y = 200, speed = 150, img = nil }
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
bulletImg = nil
bullets = {}
bulletsL = {}
walkTimer = 0.1
walk = true
wok = true
walk1 = 1
isLeft = false

function love.load(arg)
	hit = love.audio.newSource("Audio/HITMARKER.mp3","static")
	wow = love.audio.newSource("/Audio/wow.mp3","static")
	--player.img = love.graphics.newImage("/Gfx/mlgario.png")
	bulletImg = love.graphics.newImage("/Gfx/bullet2.png")
  bulletImgL = love.graphics.newImage("/Gfx/bullet2L.png")
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
  player.img = run
end

function love.update(dt)
	if love.keyboard.isDown("escape") then love.event.push("quit") end
  gundirection = findRotation(player.x-13, player.y+20,love.mouse.getX(),love.mouse.getY())
  if not love.keyboard.isDown("left", "right", "a", "d") then
    if isLeft then player.img = stopL
    else player.img = stop end
  end
	
  if love.keyboard.isDown("left","a") then
		if player.x > 0 then
			player.x = player.x - (player.speed*dt)
      if(walk == true) then 
        walk = false
        walkTimer = 0.1
        if (walk1 == 1) then player.img = runL end
        if (walk1 == 2) then player.img = run2L end
        if (walk1 == 3) then player.img = run3L end
        end
		end
    isLeft = true
	end
  
	if love.keyboard.isDown("right","d") then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
      if(walk == true) then 
        walk = false
        walkTimer = 0.1
        if (walk1 == 1) then player.img = run end
        if (walk1 == 2) then player.img = run2 end
        if (walk1 == 3) then player.img = run3 end
      end
		end	
    isLeft = false
	end
	
  if love.keyboard.isDown("down","s") then
		player.y = player.y + (player.speed * dt)
  end
	
  if love.keyboard.isDown("up","w") then
		player.y = player.y - (player.speed * dt)
    if isLeft then player.img = jumpL
    else player.img = jump end
	end
  
  if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
    if isLeft then
      newBullet = { x = player.x - 98, y = player.y+35, img = bulletImgL }
      table.insert(bulletsL, newBullet)
      if player.x < love.graphics.getWidth() - player.img:getWidth() then
        player.x = player.x+5 
      end
    else  
      newBullet = { x = player.x + 150, y = player.y+35, img = bulletImg }
      table.insert(bullets, newBullet)
      if(player.x > 4) then player.x = player.x-5 end
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
    bullet.x = bullet.x + (BulletSpeed * dt)
		if bullet.x > love.graphics.getWidth() then
			table.remove(bullets, i)
		end
	end
  for i, bullet in ipairs(bulletsL) do
    bullet.x = bullet.x - (BulletSpeed * dt)
		if bullet.x < 0 - bulletImg:getWidth() then
			table.remove(bulletsL, i)
		end
	end
  
end

function love.draw(dt)
  local myszx, myszy = love.mouse.getPosition()
  love.graphics.draw(cross, myszx-60, myszy-60)
 	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),10,10)
	love.graphics.draw(player.img, player.x, player.y)
  love.graphics.print(table.maxn(bulletsL)..'-'..table.maxn(bullets),10,80)
 	if isLeft then love.graphics.draw(snajpaL, player.x-90, player.y+20)
  else love.graphics.draw(snajpa, player.x-13, player.y+20,gundirection) end
 
	for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y,gundirection)
	end
  
  for i, bullet in ipairs(bulletsL) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
  
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
