require 'Objects/GameObject'

Circle = GameObject:extend()


function Circle:new(x, y, r)
	Circle.super.new(self, x, y)
	self.r = r
end

