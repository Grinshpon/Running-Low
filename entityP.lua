entityP = {x= 0,y=0,velocity={x=0,y=0,limit = 1},friction=1,frames={},currentFrame = 0,currentTime = 0,health=100}
--If you're wondering why I copied an entire file and changed the name by one letter, it's because there's a bug that causes the player frames to be
-- overwritten by the enemy robot's frames, and I have no idea why that's happening, and since I'm nearing a deadline, I honestly don't feel like
-- delving in to fix it. So please welcome my gross workaround until I actually have the time to look into it, if I care at all when this is over.
function entityP:start()
    self.x = 0
    self.y = 0
    self.velocity = {x=0,y=0}
    self.frames = {}
    self.health = 100
    self.currentFrame = 0
    self.currentTime = 0
    self.velocity.limit = 1
    self.friction = 1
end

function entityP:update(dt)

end

function entityP:draw()

end

function entityP:animate(dt,timer)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= timer then
	self.currentTime = 0
	self.currentFrame = self.currentFrame + 1
    end
end

function entityP:velocityMag() --velocity magnitude
    return math.sqrt(self.velocity.x*self.velocity.x + self.velocity.y+self.velocity.y)
end

function entityP:move(dx,dy,dt) --tried to add some physics and acceleration for smooth movement, still need to work out the kinks
    local rH = love.graphics.getHeight()
    rHM = rH/1920
    local mod1,mod2,mod3 = 200*rHM,1720*rHM,1700*rHM --values different than original file
    if self.x < mod1 and dx < 0 then
        dx = -dx
    end
    if self.x > mod2 and dx > 0 then
        dx = -dx
    end
    if self.y < mod1 and dy < 0 or self.y > mod3 and dy > 0 then
        dy = -dy
    end
    self.velocity.x = dx
    self.velocity.y = dy
    self.x = self.x + self.velocity.x*dt
    self.y = self.y + self.velocity.y*dt
end

function entityP:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return entityP
