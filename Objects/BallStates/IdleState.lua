IdleState = BallState:extend()

function IdleState:new(ball)
	self.ball = ball
end

-- if the mouse had been clicked the state will be transitioned to moving state thus launching the ball
function IdleState:handleInput()
	if input:pressed('click') then
		self.ball.state = MovingState()
	end
end


-- moves the ball according to the paddle
function IdleState:update(dt)
	local x = love.mouse.getX()
	if x > self.ball.x then 
		self.ball.x = math.min(x, self.ball.x + (dt * self.ball.speed), gw - self.ball.margin)
	elseif x < self.ball.x then
	    self.ball.x = math.max(x, self.ball.x - (dt * self.ball.speed), self.ball.margin)
	end
end
