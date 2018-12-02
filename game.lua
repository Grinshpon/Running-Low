game = {}

player = require (".player")
bulletTable = require (".bullet")

function game.start()
    player:start()
    bulletTable:start()
end

function game.update(dt)
    --print (tostring(dt))
    player:update(dt)
    bulletTable:update(dt)
end

function game.mousePress(x,y,button)
    print("mousepressed")
    print(player.gun.rotation)
    if button == 1 then
	--player:shoot(x,y)
	bulletTable:create(player.x,player.y,player.gun.rotation,true)
    elseif button == 2 then
	player:melee(x,y)
    end
end

function game.draw()
    --code
    love.graphics.print("test",0,0)
    player:draw()
    bulletTable:draw()
end

return game
