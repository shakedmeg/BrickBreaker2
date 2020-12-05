Level1 = Level:extend();

-- level will store the blocks like a 2d array in a table, but with the indexes as strings
-- to simplify deletion and lookups of blocks when needed
function Level1:new(lives)
    Level1.super.new(self,
                      lives,
                      Rectangle(Level.mainCanvasSize.x * 0.15, Level.mainCanvasSize.y * 0.1, Level.mainCanvasSize.x * 0.7, Level.mainCanvasSize.y * 0.19),
                      Level.mainCanvasSize.x * 0.02,
                      Level.mainCanvasSize.y * 0.02)

    local y = self.blocksZone.y
    for i = 1,3 do
        local x = self.blocksZone.x
        local row = tostring(i)
        local block
        self.blocks[row] = {}
        for j = 1, 6 do
            block = Block(x, y, "/Images/Block" .. i .. ".png")
            self.blocks[row][tostring(j)] = block
            self.numOfBlocks = self.numOfBlocks + 1
            x = x + block.width + self.gapX
        end
        y = y + block.height + self.gapY
    end
    self.currentNumOfBlocks = self.numOfBlocks
    self.nextLevel = {}
    self.nextLevel.level = "Level2"
end

function Level1:update(dt)
    Level1.super.update(self, dt)
end

function Level1:draw()
    Level1.super.draw(self)
end

function Level1:switchLevel()
    gotoScene("Level2", self.lives)
end