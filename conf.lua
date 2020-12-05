gw = 1080
gh = 680
sx = 1
sy = 1

function love.conf(t)
	t.window.title = "Brick Breaker"
	t.window.width = gw 
    t.window.height = gh 
    t.modules.physics = false
end