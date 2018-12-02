entity = {x= 0,y=0,velocity={x=0,y=0},frames={},health=100}

function entity:start()
    self.x = 0
    self.y = 0
    self.velocity = {x=0,y=0}
    self.frames = {}
    self.health = 100
end

function entity:update(dt)

end

function entity:draw()

end

function entity:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return entity
