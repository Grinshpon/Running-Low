game = {}

player = require (".player")
bulletTable = require (".bullet")
enemyTable = require (".enemy")

function game.start()
    player:start()
    bulletTable:start()
    enemyTable:start()
    game.count = 0
    game.kCount = {}
    game.spawnCount = 0
    game.timeTillSpawn = -1
    game.pShoot = false
    game.isPaused = true
    game.epBar = love.graphics.newImage("Images/bar.png")
    game.EP = {
	love.graphics.newImage("Images/ep.png"),
	love.graphics.newImage("Images/epmed.png"),
	love.graphics.newImage("Images/eplow.png")
    }
    game.over = false
    game.wall = love.graphics.newImage("Images/border.png")
    game.ouch = love.audio.newSource("Sounds/robot.wav","static")
end

function game.update(dt,paused)
    --print (tostring(dt))
    rHModif = rHModif or love.graphics.getHeight()/1920
    game.isPaused = paused
    player:update(dt)
    bulletTable:update(dt)
    enemyTable:update(dt,player.x,player.y)
    for i,_ in ipairs(bulletTable) do --collision detection
        local bX,bY,pX,pY = bulletTable[i].x,bulletTable[i].y,player.x,player.y
        if math.abs(bX) > love.graphics.getHeight() or math.abs(bY) > love.graphics.getHeight() then
            bulletTable:destroy(i)
        elseif not bulletTable[i].friendly and math.abs(bX - pX) < 20*rHModif and math.abs(bY - pY) < 25*rHModif then
            player.health = player.health - 5
            bulletTable:destroy(i)
            if playSound then
                game.ouch:play()
            end
        elseif bulletTable[i].friendly then
            local hit = false
            for i,_ in ipairs(enemyTable.bots) do
                if not hit then
                    if math.abs(bX - enemyTable.bots[i].x) < 50*rHModif and math.abs(bY - enemyTable.bots[i].y) < 50*rHModif then
                        enemyTable.bots[i].health = enemyTable.bots[i].health -10
                        bulletTable:destroy(i)
                        hit = true
                        print("bot health: "..enemyTable.bots[i].health)
                        if playSound then
                            game.ouch:play()
                        end
                    end
                end
            end
        end
    end
    for i,_ in ipairs(enemyTable.bots) do
        if enemyTable.bots[i].health <= 0 then
            enemyTable:kill(i) --replace with :kill(i) when death animation is ready
            game.kCount[i] = game.kCount[i] or 0
            game.kCount[i] = game.kCount[i] + dt
            if game.kCount[i] > 1 then
                enemyTable:destroy(i)
                game.kCount[i] = 0
            end
        end
    end

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
        if not enemyTable.bots[i].killed and enemyTable.bots[i].shoot then
            local botX,botY,plX,plY = enemyTable.bots[i].x,enemyTable.bots[i].y,player.x,player.y
            local botDir = enemyTable.bots[i]:playerAngle(plX,plY)
            print(botX..", "..botY)
            print(botDir)
            bulletTable:create(botX,botY,botDir,false)
        end
    end

    if game.timeTillSpawn == -1 then --spawn controller
        game.timeTillSpawn = 3
        enemyTable:create(1200*rHModif,1200*rHModif)
    end
    game.spawnCount = game.spawnCount + dt
    if game.spawnCount >= game.timeTillSpawn then
        game.spawnCount = 0
        game.timeTillSpawn = game.timeTillSpawn - 0.05
        if game.timeTillSpawn < 1.4 then
            game.timeTillSpawn = 2.4
        end
        local spX,spY = 500,500
        if player.x > love.graphics.getHeight()*rHModif/2 then
            spX = 400*rHModif
        else
            spX = 1600*rHModif
        end
        if player.y > love.graphics.getHeight()*rHModif/2 then
            spY = 400*rHModif
        else
            spY = 1600*rHModif
        end
        enemyTable:create(spX,spY)
    end

end --game.update()

function game.mousePress(x,y,button)
    if not game.isPaused and not game.pShoot then
	game.pShoot = true
	if button == 1 then
	    player:shoot()
	    bulletTable:create(player.x,player.y,player.gun.rotation,true)
        --enemyTable:create(1200,1200) --DEBUGGING
	elseif button == 2 then
	    player:melee(x,y)
        --enemyTable:create(1200,1200) --DEBUGGING
        --enemyTable:destroy(1) --DEBUGGING
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
