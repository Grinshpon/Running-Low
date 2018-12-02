--[[bullet = {
    x=0,
    y=0,
    velocity = {x=0,y=0}
    direction=0,
    friendly=false,-- true means won't harm player (as in it came from the player)
    frames={
	love.graphics.newImage("Frames/Proj/bullet.png"),
	love.graphics.newImage("Frames/Proj/bullet2.png")
    },
    currentFrame = 1
}--]]

local entity = require (".entity")
bullet = entity:new()

function bullet:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.frames = {
	love.graphics.newImage("Frames/Proj/bullet.png"),
	love.graphics.newImage("Frames/Proj/bullet2.png")
    }
    return o
end

function bullet:start (x,y,dir,friendly)
    self.x=x
    self.y=y
    self.direction = dir
    self.friendly = friendly
    self.getSides = function(dir)
	local vel=1000
	xS = vel*math.cos(dir)
	yS = vel*math.sin(dir)
	return xS,yS
    end
    self.currentFrame = 1
    self.currentTime = 0
    self.velocity={x=0,y=0}
end

bulletTable = {}

function bulletTable:start()
    self = {}
end

function bulletTable:create(x,y,dir,friendly)
    print(self[1])
    local newBullet = bullet:new()
    newBullet:start(x,y,dir,friendly)
    table.insert(self,newBullet)
    print(self[1])
end

function bulletTable:destroy(n)
    print("destroyed")
    table.remove(self,n)
end

function bulletTable:update(dt)
    if self[1] ~= 1 then
	for i,_ in ipairs(self) do
	    print("Direction:"..self[i].direction)
	    if math.abs(self[i].x) > love.graphics.getHeight() or math.abs(self[i].y) > love.graphics.getHeight() then
		self:destroy(i)
	    end
	end
	for i,_ in ipairs(self) do
	    local direc = self[i].direction
	    local dx,dy = self[i].getSides(direc)
	    self[i]:move(dx,dy,dt)
	    self[i]:animate(dt,0.07)
	    if self[i].currentFrame >= 3 then
		self[i].currentFrame = 1
	    end
	end
    end
end

function bulletTable:draw()
    local modifier = 6*(love.graphics.getHeight()/1920)
    if self[1] ~= 1 then
	for i,v in  ipairs(self) do
	    print(self[i].currentFrame)
	    love.graphics.draw(self[i].frames[self[i].currentFrame],self[i].x,self[i].y,self[i].direction,modifier,modifier,4,4)
	end
    end
end

return bulletTable
