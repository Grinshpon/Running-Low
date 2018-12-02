entity = require (".entity")

player = entity:new()

player.frames = {
    idle=nil,
    walk1=nil,
    walk2=nil,
    walk3=nil,
    walk4=nil,
    walk5=nil,
}

function player:start()
    self.x=0
    self.y=0
    self.velocity={x=0,y=0}
    self.frames.idle = love.graphics.newImage("Frames/Player/player_idle.png")
    self.frames.walk1 = love.graphics.newImage("Frames/Player/player_walk1.png")
    self.frames.walk2 = love.graphics.newImage("Frames/Player/player_walk2.png")
    self.frames.walk3 = love.graphics.newImage("Frames/Player/player_walk3.png")
    self.frames.walk4 = love.graphics.newImage("Frames/Player/player_walk4.png")
    self.frames.walk5 = love.graphics.newImage("Frames/Player/player_walk5.png")
    self.health = 200
end

function player:update(dt)
    --code goes here
end

function player:draw()
    --code
end

return player
