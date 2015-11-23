debug = true
player = { x = 200, y = 200, speed = 150, img = nil }
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
bulletImg = nil
bullets = {}
walkTimer = 0.1
walk = true
wok = true
walk1 = 1


function love.load(arg)
	hit = love.audio.newSource("Audio/HITMARKER.mp3","static")
	wow = love.audio.newSource("/Audio/wow.mp3","static")
	--player.img = love.graphics.newImage("/Gfx/mlgario.png")
	bulletImg = love.graphics.newImage("/Gfx/bullet2.png")
  run = love.graphics.newImage("/Gfx/Marian1.png")
  run2 = love.graphics.newImage("/Gfx/Marian2.png")
  run3 = love.graphics.newImage("/Gfx/Marian3.png")
  jump = love.graphics.newImage("/Gfx/jump.png")
  snajpa = love.graphics.newImage("/Gfx/snajpa.png")
  player.img = run
end

function love.update(dt)
	if love.keyboard.isDown("escape") then love.event.push("quit") end
	if love.keyboard.isDown("left","a") then
		if player.x > 0 then
			player.x = player.x - (player.speed*dt)
      if(walk == true) then 
        walk = false
        walkTimer = 0.1
          if (wok == true) then
            player.img = run2
            wok = false
          else wok = true end
          if (walk1 == 1) then player.img = run end
          if (walk1 == 2) then player.img = run2 end
          if (walk1 == 3) then player.img = run3 end
        end
		end
	end
	if love.keyboard.isDown("right","d") then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
         if(walk == true) then 
          walk = false
          walkTimer = 0.1
          if (wok == true) then
            wok = false
          else wok = true end
          if (walk1 == 1) then player.img = run end
          if (walk1 == 2) then player.img = run2 end
          if (walk1 == 3) then player.img = run3 end
        end
		end	
	end
	if love.keyboard.isDown("down","s") then
		player.y = player.y + (player.speed * dt)
   	end
	if love.keyboard.isDown("up","w") then
		player.y = player.y - (player.speed * dt)
    player.img = jump
	end
		if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') and canShoot then
		newBullet = { x = player.x + 150, y = player.y+35, img = bulletImg }
		table.insert(bullets, newBullet)
    if(player.x > 4) then player.x = player.x-5 end
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
	bullet.x = bullet.x + (500 * dt)
		if bullet.x < 0 then
			table.remove(bullets, i)
		end
	end
end

function love.draw(dt)
 	love.graphics.print("FPS:"..tostring(love.timer.getFPS()),10,10)
	love.graphics.draw(player.img, player.x, player.y)
 	love.graphics.draw(snajpa, player.x-13, player.y+20)
 
	for i, bullet in ipairs(bullets) do
  		love.graphics.draw(bullet.img, bullet.x, bullet.y)
	end
  love.graphics.print(tostring(walk1),60,10)
end

function love.keypressed(key)
	if key == "a" then hit:play() 
  else hit:play() end
	if key == "w" then wow:play() end
end
