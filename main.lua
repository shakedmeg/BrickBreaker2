Object = require 'Lib/Oop'
Timer = require 'Lib/Timer'
Input = require 'Lib/Input'


-- Adjust screen size and load all games files also loads the first scene
function love.load(...)
	local width, height = love.graphics.getDimensions()
	resize(width/gw, height/gh)


	local scene_files = {}
    recursiveEnumerate('Scenes', scene_files)
    requireFiles(scene_files)

    local object_files = {}
    recursiveEnumerate('Objects', object_files)
    requireFiles(object_files)

    local object_files = {}
    recursiveEnumerate('Managers', object_files)
    requireFiles(object_files)
    
    input = Input()
    input:bind('mouse1', 'click')

    timer = Timer()
    current_scene = nil

	gotoScene('MainPanel')
end


function love.update(dt)
    timer:update(dt)
    if current_scene then current_scene:update(dt) end
end

function love.draw()
    if current_scene then current_scene:draw() end
end


function gotoScene(scene_type, ...)
    current_scene = _G[scene_type](...)
end

-- recursivly iterates over all sub folders in a given path and loads all the files
function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local t = love.filesystem.getInfo(file)
        if t.type == "file" then
            table.insert(file_list, file)
        elseif t.type == "directory" then
            recursiveEnumerate(file, file_list)
        end
    end
end

-- loads a file
function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

function resize(sw, sh)
    love.window.setMode(sw*gw, sh*gh) 
    sx, sy = sw, sh
end


-- Overriding the default way run is implemeted.
-- Now after getting the dt between two frames, the method will add it to an accumulator. While this accumulator is larger than
-- the fixed_dt the method will continue to call updates (stimulating physics steps) and decrease the accumulator by the fixed_dt.
-- The remanider of the accumulator will be held for the next iteration. This is based on this article https://gafferongames.com/post/fix_your_timestep/
function love.run()
    if love.math then love.math.setRandomSeed(os.time()) end
    if love.load then love.load(arg) end
    if love.timer then love.timer.step() end

    local dt = 0
    local fixed_dt = 1/60
    local accumulator = 0

    while true do
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == 'quit' then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        accumulator = accumulator + dt
        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.0001) end
    end
end