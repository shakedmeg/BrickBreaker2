require 'Scenes/Scene'

Level = Scene:extend();

Level.mainCanvasSize = {["x"] = gw, ["y"] = gh*0.9}
Level.lifeCanvasSize = {["x"] = gw, ["y"] = gh*0.1}


function Level:new(lives, blocksZone, gapX, gapY)
    self.blocks = {}
    self.paddle = Paddle()
    self.ball = Ball(self.paddle.rect.width/2 + self.paddle.r)
    self.main_canvas = love.graphics.newCanvas(Level.mainCanvasSize.w, Level.mainCanvasSize.y)
    self.hearts_canvas = love.graphics.newCanvas(Level.lifeCanvasSize.x, Level.lifeCanvasSize.y)
    self.blocksZone = blocksZone
    self.gapX = gapX
    self.gapY = gapY
    self.collisionManager = CollisionManager(self)
    self.shootingManager = ShootingManager(self)
    self.numOfBlocks = 0
    self.currentNumOfBlocks = 0
    self.dead = false
    self:initHearts(lives)
end

-- init heart images to the player
function Level:initHearts(lives)
    self.lives = lives
    self.heartImages = {}
    local x = 0
    local heartWidth = Level.lifeCanvasSize.x*0.08
    local heartHeight = Level.lifeCanvasSize.y*0.95
    for i = 1, lives do
        self.heartImages[#self.heartImages + 1] = Image("Images/Heart.png", x, 0, heartWidth, heartHeight)
        x = x + heartWidth + self.gapX
    end
end


function Level:update(dt)
    if self.dead then return end
    self.ball.state:handleInput()

    self.paddle:update(dt)
    self.ball:update(dt, self)
    self.shootingManager:update(dt)
    self.collisionManager:update(dt, self.ball, self.paddle)
end


function Level:draw()
    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.rectangle("fill", 0, 0, Level.lifeCanvasSize.x, Level.lifeCanvasSize.y)
    love.graphics.setColor(1,1,1,1)
    self:drawHeartsCanvas(self.hearts_canvas)
    self:drawMainCanvas(self.main_canvas)
end


function Level:beginDraw(canvas)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
end


function Level:endDraw(canvas, x, y)
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(canvas, x, y, 0)
    love.graphics.setBlendMode('alpha')
end


function Level:drawMainCanvas(canvas)
    self:beginDraw(canvas)
    
    if not self.dead then
        self.ball:draw()
        self.paddle:draw()
    end

    for _, v in pairs(self.blocks) do
        for _, block in pairs(v) do
            block:draw()
        end
    end


    for _, projectile in pairs(self.shootingManager.projectiles) do
        projectile:draw()
    end
    love.graphics.setBackgroundColor(0, 0, 0, 1)
    self:endDraw(canvas, 0, Level.lifeCanvasSize.y)
end


function Level:drawHeartsCanvas(canvas)
    self:beginDraw(canvas)
    for i = 1, #self.heartImages do
        local heart = self.heartImages[i]
        love.graphics.draw(heart.image, heart.x, heart.y, 0, heart.sx, heart.sy)
    end
    love.graphics.setBackgroundColor(0.7, 0.7, 0.7, 1)
    self:endDraw(canvas, 0, 0)
end


-- turn dead to true, decrement lives, and deletes projectiles from screen. if no lives are left it will activate a game over scene (TODO)
-- else it respwans the ball and the paddle
function Level:die()
    self.dead = true
    self.heartImages[self.lives] = nil
    self.lives = self.lives -1
    self.shootingManager.projectiles = {}
    timer:cancel(self.shootingManager.shootingTimer)
    if self.lives == 0 then
        gotoScene("MainPanel", "You Lost\n Play Again?", 2)
    else
        timer:after(1, function() self:respawn() end)
    end
end


function Level:respawn()
    self.ball:respawn()
    self.paddle:respawn()
    self.dead = false
end


-- iterates the blocks table and finds a block by a blockNumber
function Level:getBlockByNumber(blockNumber)
    local counter = 0
    local k, v = next(self.blocks)
    local innerK, innerV
    while counter < blockNumber do
        counter = counter + 1
        innerK, innerV = next(v, innerK)
        if innerK == nil then
            k, v = next(self.blocks, k)
            innerK, innerV = next(v)
        end
    end
    return innerV
end


-- removes a block by a key
function Level:removeBlock(key)
    self.blocks[key.y][key.x] = nil
    if next(self.blocks[key.y]) == nil then
        self.blocks[key.y] = nil
    end
    self.currentNumOfBlocks = self.currentNumOfBlocks - 1
end


-- escalates the fire rate or moves to the next level if no blocks are left
function Level:escalate()
    if self.currentNumOfBlocks > 0 then
        self.shootingManager:startShooting(self.currentNumOfBlocks / self.numOfBlocks)
    else 
        self.shootingManager.projectiles = {}
        timer:cancel(self.shootingManager.shootingTimer)
        self:switchLevel()
    end
end


function Level:switchLevel()
end