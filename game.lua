game = {}

function game.update(dt)
    print (tostring(dt))
end

function game.draw()
    --code
    love.graphics.print("test",0,0)
end

return game
