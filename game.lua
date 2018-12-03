game = {}

player = require (".player")
bulletTable = require (".bullet")
enemyTable = require (".enemy")

function game.start()
    player:start()
    bulletTable:start()
    enemyTable:start()
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
    game.wall = love.graphics.newImage("Images/border.png")
end

function game.update(dt,paused)
    --print (tostring(dt))
    game.isPaused = paused
    player:update(dt)
    bulletTable:update(dt)
    enemyTable:update(dt,player.x,player.y)
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

    for i,_ in ipairs(enemyTable.bots) do
        if enemyTable.bots[i].shoot then
            local botX,botY,plX,plY = enemyTable.bots[i].x,enemyTable.bots[i].y,player.x,player.y
            local botDir = enemyTable.bots[i]:playerAngle(plX,plY)
            print(botX..", "..botY)
            print(botDir)
            bulletTable:create(botX,botY,botDir,false)
        end
    end
end

function game.mousePress(x,y,button)
    if not game.isPaused and not game.pShoot then
	game.pShoot = true
	if button == 1 then
	    player:shoot()
	    bulletTable:create(player.x,player.y,player.gun.rotation,true)
        enemyTable:create(1200,1200) --DEBUGGING
	elseif button == 2 then
	    player:melee(x,y)
        enemyTable:destroy(1) --DEBUGGING
	end
    end
end

function game.draw()
    local height = love.graphics.getHeight()
    local modifier=4*(height/1920)
    love.graphics.draw(game.wall,0,0,0,7.5*modifier,7.5*modifier)
    player:draw()
    bulletTable:draw()
    enemyTable:draw()
    love.graphics.draw(game.epBar,5,5,0,modifier,modifier)
    love.graphics.print(player.health,5,5+16*modifier)
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
