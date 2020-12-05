MovingState = BallState:extend()

function MovingState:new()
end

function MovingState:handleInput(ball)
end

-- moves the ball on the screen
function MovingState:update(dt, ball, level)
	ball.x = ball.x + ball.xDir * ball.speed * dt
	ball.y = ball.y + ball.yDir * ball.speed * dt
end
