-- Fuel
Fuel = {}

function Fuel:new( x, y )
	local object = {
		image = gfx.newImage("images/love-ball.png"),
		x_pos = x,
		y_pos = y,
		radius = 14,
		fuel = 30,
		fuel_quality = 1
	}
	
	setmetatable(object, { __index = Fuel } )
	return object
end

function Fuel:place( x, y )
	self.x_pos = x
	self.y_pos = y
end

function Fuel:render( )
	gfx.setColor(255, 255, 255)
	gfx.draw(self.image, self.x_pos, self.y_pos, 0, 0.5, 0.5, 32, 32)
end
