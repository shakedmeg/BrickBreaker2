require 'Objects/Circle'

Ball = Circle:extend()

Ball.xDir = math.cos(math.rad(15))
Ball.yDir = math.sin(math.rad(15))

function Ball:new(margin)
	Ball.super.new(self, Level.mainCanvasSize.x*0.5, Level.mainCanvasSize.y*0.925, Level.mainCanvasSize.y*0.025)
	self.margin = margin
	self.speed = 400
	self.state = IdleState(self)
	self.xDir = Ball.xDir
	self.yDir = Ball.yDir
	self.image = Image("Images/Ball.png", self.x, self.y, self.r*2, self.r*2)
end


function Ball:update(dt, level)
	self.state:update(dt, self, level)
end

function Ball:draw()
	love.graphics.draw(self.image.image, self.x, self.y, 0 , self.image.sx, self.image.sy, self.image.ox, self.image.oy) 
end

-- return 8 points that will be used to test collisions, points are:
-- ball max x, ball center y 
-- ball min x, ball center y 
-- ball center x, ball max y 
-- ball center x, ball min y 
-- ball max x, ball min y
-- ball max x, ball max y 
-- ball min x, ball min y 
-- ball min x, ball max y 
function Ball:getCollisionPoints()
	local ballRight = self.x + self.r
	local ballLeft = self.x - self.r
	local ballButtom = self.y + self.r
	local ballTop = self.y - self.r
	return  {{["x"] = ballRight, ["y"] = self.y},
			 {["x"] = ballLeft, ["y"] = self.y},
			 {["x"] = self.x, ["y"] = ballButtom},
			 {["x"] = self.x, ["y"] = ballTop},
             {["x"] = ballRight, ["y"] = ballTop},
             {["x"] = ballRight, ["y"] = ballButtom},
             {["x"] = ballLeft, ["y"] = ballTop},
             {["x"] = ballLeft, ["y"] = ballButtom}}
end

function Ball:flipXDir()
	self.xDir = self.xDir * (-1)
end

function Ball:flipYDir()
	self.yDir = self.yDir * (-1)
end


function Ball:respawn()
	self.x = Level.mainCanvasSize.x * 0.5
	self.y = Level.mainCanvasSize.y * 0.925
	self.state = IdleState(self)
	self.xDir = Ball.xDir
	self.yDir = Ball.yDir
end