function love.draw()
    love.graphics.print('Hello World!', 300, 200)
    love.graphics.print("FPS:"..tostring(love.timer.getFPS()),10,10)
end

local anim8 = require 'anim8'

love.keyboard.setKeyRepeat(enable)
hit = love.audio.newSource("Audio/HITMARKER.mp3","static")
wow = love.audio.newSource("/Audio/wow.mp3","static")

function love.load()
	love.physics.setMeter(64) 
	world = love.physics.newWorld(0, 9.81*64, true)
	marian = love.physics.newBody(world,x,y,dynamic)
 
	jump = love.graphics.newImage("/Gfx/jump.png")
	stay = love.graphics.newImage("/Gfx/stay.png")
	run = love.graphics.newImage("/Gfx/run.png")
	x = 50
	y = 50
	speed = 300
end
function love.update(dt)
   if love.keyboard.isDown("right") then
      x = x + (speed * dt)
   end
   if love.keyboard.isDown("left") then
      x = x - (speed * dt)
   end
   if love.keyboard.isDown("down") then
      y = y + (speed * dt)
   end
   if love.keyboard.isDown("up") then
      y = y - (speed * dt)
   end
end
function love.keypressed(key)
	if key == "escape" then love.event.quit() end
	if key == "a" then hit:play() end
	if key == "up" then
		function love.draw()
			love.graphics.draw(jump, x, y)
		end
	end
	if key == "right" then
		function love.draw()
			love.graphics.draw(run, x, y)
		end
	end
	if key == "w" then wow:play() end
end
