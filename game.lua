game = {}

player = require (".player")
bulletTable = require (".bullet")

function game.start()
    player:start()
    bulletTable:start()
    game.count = 0
    game.pShoot = false
    game.isPaused = false
    game.epBar = love.graphics.newImage("Images/bar.png")
    game.EP = {
	love.graphics.newImage("Images/ep.png"),
	love.graphics.newImage("Images/epmed.png"),
	love.graphics.newImage("Images/eplow.png")
    }
    game.over = false
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
    if player.health <= 0 then
	game.over = true
	for i,_ in ipairs(bulletTable) do
	    bulletTable:destroy(i)
	end
    end
end

function game.mousePress(x,y,button)
    if not game.isPaused and not game.pShoot then
	game.pShoot = true
	if button == 1 then
	    player:shoot()
	    bulletTable:create(player.x,player.y,player.gun.rotation,true)
	elseif button == 2 then
	    player:melee(x,y)
	end
    end
end

function game.draw()
    local modifier=4*(love.graphics.getHeight()/1920)
    love.graphics.draw(game.epBar,5,5,0,modifier,modifier)
    love.graphics.print(player.health,5,5+16*modifier)
    player:draw()
    bulletTable:draw()
    for i=1,player.health,1 do
	if player.health < 33 then
	    love.graphics.draw(game.EP[3],5+(2*i-1)*modifier,5+modifier,0,modifier,modifier)
	elseif player.health < 66 then
	    love.graphics.draw(game.EP[2],5+(2*i-1)*modifier,5+modifier,0,modifier,modifier)
	else
	    love.graphics.draw(game.EP[1],5+(2*i-1)*modifier,5+modifier,0,modifier,modifier)
	end
    end
end

return game
