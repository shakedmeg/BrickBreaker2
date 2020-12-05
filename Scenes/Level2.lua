Level2 = Level:extend();

function Level2:new(lives)
    Level2.super.new(self,
                      lives,
                      Rectangle(Level.mainCanvasSize.x*0.15, Level.mainCanvasSize.y*0.1, Level.mainCanvasSize.x*0.70, Level.mainCanvasSize.y * 0.26),
                      Level.mainCanvasSize.x*0.02,
                      Level.mainCanvasSize.y*0.02)

    local y = self.blocksZone.y
    for i = 1,4 do
        local x = self.blocksZone.x
        local row = tostring(i)
        local block
        self.blocks[row] = {}
        for j = 1, 6 do
            block = Block(x, y, "/Images/Block" .. j+3 .. ".png")
            self.blocks[row][tostring(j)] = block
            self.numOfBlocks = self.numOfBlocks + 1
            x = x + block.width + self.gapX
        end
        y = y + block.height + self.gapY
    end
    self.currentNumOfBlocks = self.numOfBlocks

end

function Level2:update(dt)
    Level1.super.update(self, dt)
end

function Level2:draw()
    Level1.super.draw(self)
end

function Level2:switchLevel()
    gotoScene("MainPanel", "You Won!\nPlay Again?\n( Or Hire Me ;) )", 3)
end