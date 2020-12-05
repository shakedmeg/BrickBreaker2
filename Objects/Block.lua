require 'Objects/Rectangle'

Block = Rectangle:extend()
Block.width = Level.mainCanvasSize.x*0.1
Block.height = Level.mainCanvasSize.y*0.05


function Block:new(x, y, path)
	Block.super.new(self, x, y, Block.width, Block.height)
	self.image = Image(path, x, y, Block.width, Block.height)
end


function Block:draw()
	love.graphics.draw(self.image.image, self.x, self.y, 0 , self.image.sx, self.image.sy) 
end
