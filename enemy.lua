entityP = require (".entityP")
math.randomseed(os.time())

enemy = entityP:new()
function enemy:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.frames[1] = love.graphics.newImage("Frames/Enemy/bot_walk1.png")
    o.frames[2] = love.graphics.newImage("Frames/Enemy/bot_idle.png")
    o.frames[3] = love.graphics.newImage("Frames/Enemy/bot_walk2.png")
    o.frames[4] = love.graphics.newImage("Frames/Enemy/bot_idle.png")
    return o
end
function enemy:start(x,y)
    self.x = x or 700
    self.y = y or 700
    self.velocity={x=0,y=0}
    self.health = 50
    self.currentFrame = 2
    self.currentTime = 0
    self.velocity.limit = 250 --250
    self.dirCount = 0
    self.rotation = 0
end
function enemy:shoot()

end

function enemy:onDeath()

end

function enemy:playerAngle(x,y)
    --calculate angle between enemy and player
    return math.atan2((y-self.y),(x-self.x))
end

function enemy:changeDirection(x,y)
    newDir = math.random()*(2*math.pi)
    self.rotation = self:playerAngle(x,y) + newDir
end

function enemy:getSides(dir)
	xS = math.cos(dir)
	yS = math.sin(dir)
    return xS,yS
end

function enemy:update(dt,pX,pY)
    self.dirCount = self.dirCount + dt
    self:animate(dt,0.07)
	if self.currentFrame >= 4 then
	    self.currentFrame = 1
	end
    local modifier = 250*(love.graphics.getHeight()/1920)
    local vx,vy = self:getSides(self.rotation)
    self:move(vx*modifier,vy*modifier,dt)

    if self.dirCount > 5 then
        self:changeDirection(pX,pY)
        self.dirCount = 0
    end

end

function enemy:draw()
    local rH = love.graphics.getHeight()
    local modifier = rH/1920
    local eightMod = 8*modifier
    love.graphics.draw(self.frames[self.currentFrame],self.x,self.y,0,eightMod,eightMod,4,4)
end
--enemy instances will be stored in enemyTable, and these functions should be called from the table

enemyTable = {bots={},length=0}

function enemyTable:create(x,y)
    local newBot = enemy:new()
    newBot:start(x,y)
    table.insert(self.bots,newBot)
    self.length = self.length +1
end

function enemyTable:destroy(n)
    print("Bot destroyed")
    table.remove(self.bots,n)
    self.length = self.length -1
end

function enemyTable:start()
    self.bots = {}
    self.length = 0
end

function enemyTable:update(dt,pX,pY)
    for i,_ in ipairs(self.bots) do
        self.bots[i]:update(dt,pX,pY)
    end
end

function enemyTable:draw()
    for i,_ in ipairs(self.bots) do
        self.bots[i]:draw()
    end
end

return enemyTable
