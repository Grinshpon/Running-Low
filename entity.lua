entity = {x= 0,y=0,velocity={x=0,y=0,limit = 1},friction=1,frames={},currentFrame = 0,currentTime = 0,health=100}

function entity:start()
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

function entity:update(dt)

end

function entity:draw()

end

function entity:animate(dt,timer)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= timer then
	self.currentTime = 0
	self.currentFrame = self.currentFrame + 1
    end
end

function entity:velocityMag() --velocity magnitude
    return math.sqrt(self.velocity.x*self.velocity.x + self.velocity.y+self.velocity.y)
end

function entity:move(dx,dy,dt) --tried to add some physics and acceleration for smooth movement, still need to work out the kinks
--[[    if dx ~= 0 or dy ~= 0 then
	if self:velocityMag() < self.velocity.limit then
	    self.velocity.x = self.velocity.x + dx*dt
	    self.velocity.y = self.velocity.y + dy*dt
	end
    end
    if dx == 0 then
	if self.velocity.x > 0 then
	    self.velocity.x = self.velocity.x - self.friction*dt
	elseif self.velocity.x < 0 then
	    self.velocity.x = self.velocity.y + self.friction*dt
	end
	if math.abs(self.velocity.x) < 0.05 then
	    self.velocity.x = 0
	end
    end
    if dy == 0 then
	if self.velocity.y > 0 then
	    self.velocity.y = self.velocity.y - self.friction*dt
	elseif self.velocity.y < 0 then
	    self.velocity.y = self.velocity.y + self.friction*dt
	end
	if math.abs(self.velocity.y) < 0.05 then
	    self.velocity.y = 0
	end
    end]]--
    self.velocity.x = dx
    self.velocity.y = dy
    self.x = self.x + self.velocity.x*dt
    self.y = self.y + self.velocity.y*dt
end

function entity:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return entity
