require 'Objects/Rectangle'

Projectile = Rectangle:extend()


function Projectile:new(x, y)
	Projectile.super.new(self, x, y, Level.mainCanvasSize.x * 0.01, Level.mainCanvasSize.y * 0.04)
	self.speed = 200
	self.image = Image("Images/Projectile.png", x, y, self.width, self.height)
end

function Projectile:update(dt)
	self.y = self.y + self.speed * dt 
end

function Projectile:draw()
	love.graphics.draw(self.image.image, self.x, self.y, 0 , self.image.sx, self.image.sy) 
end