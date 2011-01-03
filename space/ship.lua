-- Ship
Ship = {}

function Ship:new( x, y )
	local object = {
		image = gfx.newImage("images/ship.png"),
		x_pos = x,
		y_pos = y,
		angle = 0,
		x_vel = 0,
		y_vel = 0,
		radius = 14,
		turn_vel = 1.5,
		thrust = false,
		fuel_per_second = 50,
		speed_cap = true,
		max_vel = 500,
		turning_left = false,
		turning_right = false,
		fuel = 60,
		force_per_fuel = 1
	}
	
	setmetatable(object, { __index = Ship })
	return object
end

function Ship:update_vel( dt )
	if self.thrust and self.fuel > 0 then
		local x_vel = self.x_vel
		local y_vel = self.y_vel
		local thrust = dt * self.fuel_per_second * self.force_per_fuel
		
		self.x_vel = x_vel + (thrust * math.sin(self.angle))
		self.y_vel = y_vel - (thrust * math.cos(self.angle))
		
		if self.speed_cap and self:past_max( ) then
			self.x_vel = x_vel
			self.y_vel = y_vel
		else
			self.fuel = self.fuel - dt
		end
	end
end

function Ship:update_angle( dt )
	if self.turning_right then
		self.angle = self.angle + (dt * self.turn_vel)
	elseif player.turning_left then
		self.angle = self.angle - (dt * self.turn_vel)
	end
end

function Ship:update_pos( dt, width, height )
	self.x_pos = self.x_pos + (dt * self.x_vel)
	self.y_pos = self.y_pos + (dt * self.y_vel)
	
	-- Wrap ship at window edges
	if self.x_pos <= 0 then
		self.x_pos = self.x_pos + width
	elseif self.x_pos >= width then
		self.x_pos = self.x_pos - width
	end
	
	if self.y_pos <= 0 then
		self.y_pos = self.y_pos + height
	elseif self.y_pos >= height then
		self.y_pos = self.y_pos - height
	end
end

function Ship:past_max( )
	local total_velocity = math.sqrt(self.x_vel^2 + self.y_vel^2)
	return total_velocity > self.max_vel
end

function Ship:refuel( f )
	self.fuel = self.fuel + f.fuel
end

function Ship:render( )
	gfx.setColor(255, 255, 255)
	gfx.draw(self.image, self.x_pos, self.y_pos, self.angle, 0.5, 0.5, 32, 32)
end
