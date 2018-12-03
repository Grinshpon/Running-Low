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
    self.frames.walk5 = love.graphics.newImage("Frames/Player/player_walk5.png")--this frame is never called, but it actually looks better like that, so the bug is now intentional
    self.health = 100
    self.currentFrame = self.frames.idle
    self.currentTime = 0
    self.velocity.limit = 250 --250
    self.friction = 40 --40

    self.gun = {
	love.graphics.newImage("Frames/Player/gun.png"),
	love.graphics.newImage("Frames/Player/gunfire.png"),
	rotation = 0,
	direction = 1 -- -1= left, 1=right
    }
    --[[self.bullet = {
	love.graphics.newImage("Frames/Proj/bullet.png"),
	love.graphics.newImage("Frames/Proj/bullet2.png"),
	rotation = 0,
	x = 0,
	y = 0,
	spawn = function(dir)
	    self.rotation = dir
    }--]]
end

function player:shoot()
    self.health = self.health-1
end

function player:melee(x,y)
    --melee attack
end

function player:gunAngle()
    mX,mY = love.mouse.getPosition()
    return math.atan2((mY-self.y),(mX-self.x))
end

function player:update(dt)
    local dvx,dvy,modifier = 0,0,275*(love.graphics.getHeight()/1920) --delta velocity(x) and delta velocity(y) modifier (300,)
    if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
	self:animate(dt,0.07)
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
    self:move(dvx*modifier,dvy*modifier,dt,true)
    self.gun.rotation = self:gunAngle()
    if self.gun.rotation > 1.56 or self.gun.rotation < -1.56 then
	self.gun.direction = -1
    else
	self.gun.direction = 1
    end
end

function player:draw()
    local rH = love.graphics.getHeight()
    local modifier = rH/1920
    local eightMod = 8*modifier
    local dir = self.gun.direction
    love.graphics.draw(self.frames[self.currentFrame],self.x,self.y,0,dir*eightMod,eightMod,3,5)
    love.graphics.draw(self.gun[1],self.x, self.y, self.gun.rotation, eightMod,dir*eightMod,2,1) --x+3*eightMod, y+eightMod+31*modifier
end

return player
