SpaceObject = {
	pos = {
		x = 0,
		y = 0,
		angle = 0
	},
	vel = {
		x = 0,
		y = 0
	},
	radius = 0
}

function SpaceObject:new( x_pos, y_pos, i )
	local object = {}
	
	setmetatable(object, { __index = SpaceObject })
	return object
end

function SpaceObject:collides( ob1, ob2 )
	ob2 = ob2 or self
	
	local x1, y1, r1 = ob1.pos.x, ob1.pos.y, ob1.radius
	local x2, y2, r2 = ob2.pos.x, ob2.pos.y, ob2.radius
	
	return (x1 - x2)^2 + (y1 - y2)^2 <= (r1 + r2)^2
end

function SpaceObject:update( dt )
	-- nothing 
end

function SpaceObject:render( )
	gfx.setColor(255, 255, 255)
	local x = self.pos.x % gfx.getWidtth()
	local y = self.pos.y % gfx.getHeight()
	gfx.draw(self.gfx.image, x, y, self.pos.angle, self.gfx.scale, self.gfx.ox, self.gfx.oy)
end

--TODO: add a set offset method, test, etc