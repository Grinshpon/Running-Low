game = {}

player = require (".player")

function game.start()
    player:start()
end

function game.update(dt)
    print (tostring(dt))
    player:update(dt)
end

function game.draw()
    --code
    love.graphics.print("test",0,0)
    player:draw()
end

return game
