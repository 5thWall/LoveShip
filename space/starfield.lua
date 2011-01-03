-- Starfield
StarField = {}

function StarField:new( density, depth, width, height )
	local object = { 
		stars = {}, 
		move_scale = 100 
	}
	
	for i=1, density do
		local x = math.random(width)
		local y = math.random(height)
		local s = math.random(depth, 3 * depth) / depth
		object.stars[i] = { x_pos = x, y_pos = y, size = s }
	end
	
	setmetatable(object, { __index = StarField })
	return object
end

function StarField:move_stars( x_vel, y_vel, width, height )
	for i,v in ipairs(self.stars) do
		v.x_pos = v.x_pos - ((x_vel * v.size) / self.move_scale)
		v.y_pos = v.y_pos - ((y_vel * v.size) / self.move_scale)
		
		-- Wrap stars at window edges
		if v.x_pos <= 0 then
			v.x_pos = v.x_pos + width
		elseif v.x_pos >= width then
			v.x_pos = v.x_pos - width
		end

		if v.y_pos <= 0 then
			v.y_pos = v.y_pos + height
		elseif v.y_pos >= height then
			v.y_pos = v.y_pos - height
		end
	end
end

function StarField:render( )
	gfx.setColor(255, 255, 255)
	
	for i,v in ipairs(self.stars) do
		gfx.circle("fill", v.x_pos, v.y_pos, v.size)
	end
end
