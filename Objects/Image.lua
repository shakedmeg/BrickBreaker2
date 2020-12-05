Image = GameObject:extend();

function Image:new(path, x, y, w, h)
    Image.super.new(self, x , y)
    self.image = love.graphics.newImage(path)
    local imageW, imageH = self.image:getDimensions()
    self.sx = w / imageW
    self.sy = h / imageH
    self.ox = imageW/2
    self.oy = imageH/2
end