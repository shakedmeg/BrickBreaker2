CollisionManager = Object:extend()

function CollisionManager:new(level)
    self.level = level
end

-- Checks for the following collisions: BallToWall, ProjectileToWall, ProjectileToPaddle, BallToPaddle, BallToBlocks 
function CollisionManager:update(dt)
    if self.level.ball.state:is(MovingState) then
        self:handleBallToWall()
        self:handleProjectilesCollisions()
        if self.level.dead then return end

        if self.level.ball.y + self.level.ball.r >= self.level.paddle.rect.y and self.level.ball.yDir > 0 then
            self:handleBallToPaddle()
        end
        self:handleBallToBlocks()
    end
end

-- Checks if the ball has touched one of the walls, if so game will flip the ball's direction or die, depending on the wall.
function CollisionManager:handleBallToWall()
    if self.level.ball.x + self.level.ball.r >= gw or self.level.ball.x - self.level.ball.r <= 0 then
        self.level.ball:flipXDir()
    end

    if self.level.ball.y - self.level.ball.r <= 0 then
        self.level.ball:flipYDir()
    end

    if self.level.ball.y + self.level.ball.r >= Level.mainCanvasSize.y then
        self.level:die()
    end
end

-- handles the projectiles collision with the wall or the paddle. the game will only look for collision on the first
-- projectile in the table since it will be the closest to the buttom of the screen. furthermore the fire rate allows
-- only for one projectile at a time to get close enough to the paddle 
function CollisionManager:handleProjectilesCollisions()
    local projectile = self.level.shootingManager:getProjectile()
    if projectile ~= nil then
        if self:handleProjectileToWall(projectile) then
            projectile = self.level.shootingManager:getProjectile()
        end
    end
    if projectile ~= nil then self:handleProjectileToPaddle(projectile) end
end

-- destroys a projectile if it touched the buttom of the window
function CollisionManager:handleProjectileToWall(projectile)
    if projectile:getSecondY() >= Level.mainCanvasSize.y then
        table.remove(self.level.shootingManager.projectiles, 1)
        return true
    end
end

-- checks if a projectile touched one of the paddle's circles or it's rectangle, if so the game will die
function CollisionManager:handleProjectileToPaddle(projectile)
    if projectile:getSecondX() < self.level.paddle.c1.x then
        if self:circleRectCollision(projectile, self.level.paddle.c1) then
            self.level:die()
        end
    elseif projectile.x > self.level.paddle.c2.x then
        if self:circleRectCollision(projectile, self.level.paddle.c2) then
            self.level:die()
        end
    elseif (projectile.x > self.level.paddle.c1.x and projectile.x < self.level.paddle.c2.x) or
            (projectile:getSecondX() > self.level.paddle.c1.x and projectile:getSecondX() < self.level.paddle.c2.x) then
         if self.level.paddle.rect.y - projectile.y <= projectile.height then
                self.level:die()
         end
    end
end

-- checks if the ball touched one of the paddle's circles or it's rectangle, if so the game will die
function CollisionManager:handleBallToPaddle()
    if self.level.ball.x < self.level.paddle.c1.x then
        if distance(self.level.paddle.c1, self.level.ball) <= self.level.paddle.r + self.level.ball.r then
            self.level.ball:flipYDir()
            self.level.ball:flipXDir()
        end
    elseif self.level.ball.x > self.level.paddle.c2.x then
        if distance(self.level.paddle.c2, self.level.ball) <= self.level.paddle.r + self.level.ball.r then
            self.level.ball:flipYDir()
            self.level.ball:flipXDir()
        end
    elseif self.level.ball.x > self.level.paddle.c1.x and self.level.ball.x < self.level.paddle.c2.x then
        if self.level.paddle.rect.y - self.level.ball.y <= self.level.ball.r then
            self.level.ball:flipYDir()
        end
    end
end

-- checks for collisions between the ball and the blocks. first it checks if the ball is in the blocksZone, if so it will get the
-- balls collision points and generate from these points the corresponding keys for the blocks. With the keys it will check for collisions between the ball
-- and the blocks and will flip the ball if needed
function CollisionManager:handleBallToBlocks()
    if self:circleRectCollision(self.level.blocksZone, self.level.ball) then
        local ballPoints = self.level.ball:getCollisionPoints()
                    
        local keys = self:pointsToTableKeys(ballPoints)
                    
        local flipX, flipY = self:checkCollisions(ballPoints, keys)

        if flipY then self.level.ball:flipYDir() end
        if flipX then self.level.ball:flipXDir() end
    end
end


-- Returns true if a collision had occured between a rectangle and a circle, also returns whether axis should be flipped
function CollisionManager:circleRectCollision(rect, circle)
    test = {["x"] = circle.x, ["y"] = circle.y}
    local r = circle.r

    if circle.x < rect.x then
        test.x = rect.x
    elseif circle.x > rect.x + rect.width then
        test.x = rect.x + rect.width
    end

    if circle.y < rect.y then
        test.y = rect.y
    elseif circle.y > rect.y + rect.height then
        test.y = rect.y + rect.height
    end
    local dist = distance(circle, test)
    return dist <= r, test.x == circle.x, test.y == circle.y
end


-- Goes through each ball points and checks if it is in the block zone, if so it will check if the block is present in the table (using the keys).
-- If present i will look for a collision between the ball block.
-- Then it checks for a collision by a simple Circle to Rect collision detection.
-- If a collision had occured this function will return the axis that needs to be flipped and remove the block
function CollisionManager:checkCollisions(ballPoints, keys)
    local flipX, flipY
    for i = 1, #ballPoints do
        local point = ballPoints[i]
        if self:pointIsInBlockZone(point) then
            local key = keys[tostring(i)]
            if self.level.blocks[key.y] and self.level.blocks[key.y][key.x] then
                local block = self.level.blocks[key.y][key.x]
                local collision, checkFlipY, checkFlipX = self:circleRectCollision(block, self.level.ball)
                if collision then
                    self.level:removeBlock(key)
                    self.level:escalate()
                    flipX, flipY = self:checkFlips(flipX, filpY, checkFlipX, checkFlipY)
                    if flipX or flipY then break end
                end
            end
        end
    end
    return flipX, flipY
end

-- checks if a point is in the blocksZone
function CollisionManager:pointIsInBlockZone(point)
    return point.x >= self.level.blocksZone.x and point.x <= self.level.blocksZone:getSecondX() and
           point.y >= self.level.blocksZone.y and point.y <= self.level.blocksZone:getSecondY()
end

-- generates a key from a point by subtracting the empty space to the left and from the top,
-- and then dividing by the block's size and the gaps 
function CollisionManager:pointsToTableKeys(ballPoints)
    local keys = {}
    for i = 1, #ballPoints do
        local key = tostring(i)
        keys[key] = {}
        keys[key].x = tostring(math.floor((ballPoints[i].x - self.level.blocksZone.x) / (Block.width + self.level.gapX) + 1))
        keys[key].y = tostring(math.floor((ballPoints[i].y - self.level.blocksZone.y) / (Block.height + self.level.gapY) + 1))
    end
    return keys
end

-- accumelated the flip results. if both flips are false that means that the ball had came from the corner thus both
-- axis should be changed
function CollisionManager:checkFlips(flipX, flipY, checkFlipX, checkFlipY)
    if not (checkFlipX or checkFlipY) then
        flipX = true 
        flipY = true 
    else    
        flipX = flipX or checkFlipX
        flipY = flipY or checkFlipY
    end
    return flipX, flipY
end    

-- returns the distance between two objects
function distance(o1, o2)
    return math.sqrt((o1.x - o2.x)^2 + (o1.y - o2.y)^2) 
end
