entity = {x= 0,y=0,velocity={x=0,y=0},frames={},currentFrame = 0,currentTime = 0,health=100}

function entity:start()
    self.x = 0
    self.y = 0
    self.velocity = {x=0,y=0}
    self.frames = {}
    self.health = 100
    self.currentFrame = 0
    self.currentTime = 0
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

function entity:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return entity
