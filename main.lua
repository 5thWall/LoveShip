require("space/ship.lua")
require("space/fuel.lua")
require("space/starfield.lua")

gfx = love.graphics

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