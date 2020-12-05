ShootingManager = Object:extend()

-- this class will manages the shots that are being fired from the blocks
function ShootingManager:new(level)
    self.level = level
    self.projectiles = {}
    self.alpha = 1
    self.alphaStep = 0.25
    self.fireRate = 3.75
    self.rateStep = 0.75
end

function ShootingManager:update(dt)
    for _, projectile in pairs(self.projectiles) do
        projectile:update(dt)
    end
end

-- This function is called after a block had been destroyed.
-- rate is the level.currentNumOfBlocks/level.numOfBlocks every time this goes below the alpha
-- a new shootingTimer will be created with a faster fire rate, alpha will decraese and the previous shootingTimer will be deleted.
-- In case there is no shootingTimer (after player dies) the shootingTimer will resume at the current fireRate.
function ShootingManager:startShooting(rate)
	if rate < self.alpha then
	 	self.alpha = self.alpha - self.alphaStep
		if self.shootingTimer then 
			timer:cancel(self.shootingTimer)
			self.shootingTimer = nil
		end
		self.shootingTimer = timer:every(self.fireRate, function() self:shoot() end)
		self.fireRate = self.fireRate - self.rateStep
	end
	if not self.shootingTimer then self.shootingTimer = timer:every(self.fireRate, function() self:shoot() end) end
end


-- randomly generates a blockNumber, gets a block from the field with it and fires a new projectile from that blocks.
function ShootingManager:shoot()
	local blockNumber = love.math.random(self.level.currentNumOfBlocks)
	local block = self.level:getBlockByNumber(blockNumber)
	local xShot = block.x + love.math.random(block.width) - 1
	local yShot = block.y + block.height
	table.insert(self.projectiles, Projectile(xShot, yShot))
end

-- returns the first projectile in the projectiles table
function ShootingManager:getProjectile()
	local projectile
	if #self.projectiles ~= 0 then
        projectile = self.projectiles[1]
    end
    return projectile
end