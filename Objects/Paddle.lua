require 'Objects/Circle'
require 'Objects/Rectangle'

Paddle = GameObject:extend()

-- the paddle is consturcted from two circles and a rectangle the only moves horizontally on the screen
function Paddle:new()
	Paddle.super.new(self, Level.mainCanvasSize.x * 0.5, Level.mainCanvasSize.y * 0.975)
	local w = Level.mainCanvasSize.x*0.1
	local h = Level.mainCanvasSize.y*0.05
	self.rect = Rectangle(self.x - w/2, self.y - h/2, w, h)

	self.r = self.rect.height/2
	self.c1 = Circle(self.rect.x, self.rect.y + self.rect.height/2, self.r)
	self.c2 = Circle(self.rect.x + self.rect.width, self.rect.y + self.rect.height/2, self.r)
	self.speed = 400
	self.image = Image("Images/Paddle.png", self.x, self.y, w + self.r*2, h)

end

-- moves the paddle within the screen's limitations
function Paddle:update(dt)
	local x = love.mouse.getX()
	if x > self.x then 
		self.x = math.min(x, self.x + (dt * self.speed), gw - self.rect.width/2 - self.r)
	elseif x < self.x then
	    self.x = math.max(x, self.x - (dt * self.speed), self.rect.width/2 + self.r)
	end
	self.rect.x = self.x - self.rect.width/2
	self.c1.x = self.rect.x
	self.c2.x = self.rect.x + self.rect.width
end

function Paddle:draw()
	love.graphics.draw(self.image.image, self.x, self.y, 0 , self.image.sx, self.image.sy, self.image.ox, self.image.oy) 
end

function Paddle:respawn()
	self.x = Level.mainCanvasSize.x * 0.5
	self.y = Level.mainCanvasSize.y * 0.975
	self.rect.x = self.x - self.rect.width/2
	self.rect.y = self.y - self.rect.height/2

	self.c1.x = self.rect.x
	self.c1.y = self.rect.y + self.rect.height/2
	self.c2.x = self.rect.x + self.rect.width
	self.c2.y = self.rect.y + self.rect.height/2
end