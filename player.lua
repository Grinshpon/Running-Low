entity = require (".entity")

player = entity:new()

function player:start()
    self.x=0
    self.y=0
    self.velocity={x=0,y=0}
    self.frames[1] = love.graphics.newImage("Frames/Player/player_idle.png")
    self.frames[2] = love.graphics.newImage("Frames/Player/player_walk1.png")
    self.frames[3] = love.graphics.newImage("Frames/Player/player_walk2.png")
    self.frames[4] = love.graphics.newImage("Frames/Player/player_walk3.png")
    self.frames[5] = love.graphics.newImage("Frames/Player/player_walk4.png")
    self.frames.walk5 = love.graphics.newImage("Frames/Player/player_walk5.png")
    self.health = 200
    self.currentFrame = self.frames.idle
    self.currentTime = 0
end

function player:shoot(x,y)
    --shoot code
end

function player:melee(x,y)
    --melee attack
end

function player:update(dt)
    if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
	player:animate(dt,0.07)
	if self.currentFrame == 6 then
	    self.currentFrame = 2
	end
    else
	self.currentFrame = 1
    end
    if love.keyboard.isDown("d") then
	self.velocity.x = 1
    else
	self.velocity.x = 0
    end
end

function player:draw()
    local mW,mH,rH = love.graphics.getWidth()/2,love.graphics.getHeight()/2,love.graphics.getHeight()
    love.graphics.draw(self.frames[self.currentFrame],mW,mH,0,8*(rH/1920),8*(rH/1920))
    love.graphics.print(self.velocity.x,200,200)
end

return player
