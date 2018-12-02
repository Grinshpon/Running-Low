entity = require (".entity")

player = entity:new()

function player:start()
    self.x=love.graphics.getWidth()/2
    self.y=love.graphics.getHeight()/2
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
    self.velocity.limit = 250 --250
    self.friction = 40 --40

    self.gun = {
	love.graphics.newImage("Frames/Player/gun.png"),
	love.graphics.newImage("Frames/Player/gunfire.png"),
	rotation = 0
    }
end

function player:shoot(x,y)
    --shoot code
end

function player:melee(x,y)
    --melee attack
end

function player:update(dt)
    local dvx,dvy,modifier = 0,0,250*(love.graphics.getHeight()/1920) --delta velocity(x) and delta velocity(y) modifier (300,)
    if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
	player:animate(dt,0.07)
	if self.currentFrame == 6 then
	    self.currentFrame = 2
	end
    else
	self.currentFrame = 1
    end
    if love.keyboard.isDown("d") then
	dvx = dvx+2
    else
	dvx = dvx+1
    end
    if love.keyboard.isDown("a") then
	dvx = dvx-2
    else
	dvx = dvx-1
    end
    if love.keyboard.isDown("w") then
	dvy = dvy-2
    else
	dvy = dvy-1
    end
    if love.keyboard.isDown("s") then
	dvy = dvy+2
    else
	dvy = dvy+1
    end
    player:move(dvx*modifier,dvy*modifier,dt)
end

function player:draw()
    local rH = love.graphics.getHeight()
    local modifier = rH/1920
    local eightMod = 8*modifier
    love.graphics.draw(self.frames[self.currentFrame],self.x,self.y,0,eightMod,eightMod)
    love.graphics.draw(self.gun[1],self.x+3*eightMod, self.y+eightMod+31*modifier, self.gun.rotation, eightMod,eightMod,3,1)
    love.graphics.print(self.velocity.x,200,1200)
end

return player
