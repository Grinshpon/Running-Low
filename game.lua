game = {}

player = require (".player")
bulletTable = require (".bullet")

function game.start()
    player:start()
    bulletTable:start()
    game.count = 0
    game.pShoot = false
    game.isPaused = false
end

function game.update(dt,paused)
    --print (tostring(dt))
    game.isPaused = paused
    player:update(dt)
    bulletTable:update(dt)
    if game.pShoot then
	game.count = game.count + dt
	if game.count >= 0.2 then
	    game.count = 0
	    game.pShoot = false
	end
    end
end

function game.mousePress(x,y,button)
    if not game.isPaused and not game.pShoot then
	game.pShoot = true
	if button == 1 then
	    --player:shoot(x,y)
	    bulletTable:create(player.x,player.y,player.gun.rotation,true)
	elseif button == 2 then
	    player:melee(x,y)
	end
    end
end

function game.draw()
    --code
    love.graphics.print("test",0,0)
    player:draw()
    bulletTable:draw()
end

return game
