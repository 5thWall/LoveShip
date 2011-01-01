gfx = love.graphics

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

-- Love callbacks
function love.load( )
	local width = gfx.getWidth()
	local height = gfx.getHeight()
	
	player = Ship:new(width/2, height/2)
	
	fuel = Fuel:new(math.random(width), math.random(height))
	
	stars = StarField:new(200, 50, width, height)
end

function love.update( dt )
	local w = gfx.getWidth()
	local h = gfx.getHeight()
	
	player:update_angle(dt)
	player:update_vel(dt)
	player:update_pos(dt, w, h)
	
	if collides(player, fuel) then
		player:refuel(fuel)
		fuel:place(math.random(w), math.random(h))
	end
	
	stars:move_stars(player.x_vel, player.y_vel, w, h)
end

function collides( ob1, ob2 )
	local x1, y1, r1 = ob1.x_pos, ob1.y_pos, ob1.radius
	local x2, y2, r2 = ob2.x_pos, ob2.y_pos, ob2.radius
	
	return (x1 - x2)^2 + (y1 - y2)^2 <= (r1 + r2)^2
end

function love.draw( )
	stars:render()
	player:render()
	fuel:render()
end

function love.keypressed( key, unicode )
	if key == "up" then
		player.thrust = true
	end
	
	if key == "right" then
		player.turning_right = true
	end
	
	if key == "left" then
		player.turning_left = true
	end
	
	if key == "escape" then
		end_game()
	end
end

function love.keyreleased( key, unicode )
	if key == "up" then 
		player.thrust = false
	end
	
	if key == "right" then
		player.turning_right = false
	end
	
	if key == "left" then
		player.turning_left = false
	end
end

function end_game( )
	love.event.push("q")
end