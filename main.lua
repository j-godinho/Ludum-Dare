function love.load()
	love.physics.setMeter(64)
	world = love.physics.newWorld(0,9.8*64, true)
	
	objects = {}
	
	objects.ground = {}
	objects.ground.body = love.physics.newBody(world, 800/2, 600)
	objects.ground.shape = love.physics.newRectangleShape(800,25)
	objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape,1)

	
	objects.ceiling = {}
	objects.ceiling.body = love.physics.newBody(world, 800/2, 0)
	objects.ceiling.shape = love.physics.newRectangleShape(800,25)
	objects.ceiling.fixture = love.physics.newFixture(objects.ceiling.body, objects.ceiling.shape,1)

	
	objects.left = {}
	objects.left.body = love.physics.newBody(world, 0, 600/2)
	objects.left.shape = love.physics.newRectangleShape(25,800)
	objects.left.fixture = love.physics.newFixture(objects.left.body, objects.left.shape,1)

	
	objects.right = {}
	objects.right.body = love.physics.newBody(world, 800,600/2)
	objects.right.shape = love.physics.newRectangleShape(25,800)
	objects.right.fixture = love.physics.newFixture(objects.right.body, objects.right.shape,1)

	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 800/2, 600/2, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(20)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape,1)
	objects.ball.fixture:setRestitution(0.9)

	objects.square = {}
	objects.square.body = love.physics.newBody(world, 400,400, "dynamic")
	objects.square.shape = love.physics.newRectangleShape(25,25)
	objects.square.fixture = love.physics.newFixture(objects.square.body, objects.square.shape,1)

	

	
end

function love.update(dt)
	world:update(dt)
	
	
	if love.keyboard.isDown("w") then
		objects.ball.body:applyForce(0, -400)
	elseif love.keyboard.isDown("s") then 
		objects.ball.body:applyForce(0,400)
	elseif love.keyboard.isDown("a") then
		objects.ball.body:applyForce(-400,0)
	elseif love.keyboard.isDown("d") then
		objects.ball.body:applyForce(400,0)
	elseif love.keyboard.isDown("w") and love.keyboard.isDown("d") then
		objects.ball.body:applyForce(400,400)
	elseif love.keyboard.isDown("w") and love.keyboard.isDown("a") then
		objects.ball.body:applyForce(-400,400)
	
	elseif love.keyboard.isDown("s") and love.keyboard.isDown("d") then
		objects.ball.body:applyForce(400,-400)
	elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
		objects.ball.body:applyForce(-400,-400)
	end
end

function love.draw()

	
	love.graphics.setColor(125,30,72)
	love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
	love.graphics.polygon("fill", objects.ceiling.body:getWorldPoints(objects.ceiling.shape:getPoints()))
	love.graphics.polygon("fill", objects.left.body:getWorldPoints(objects.left.shape:getPoints()))
	love.graphics.polygon("fill", objects.right.body:getWorldPoints(objects.right.shape:getPoints()))
	
	love.graphics.setColor(255,255,255)
	love.graphics.polygon("fill", objects.square.body:getWorldPoints(objects.square.shape:getPoints()))

	love.graphics.setColor(72,125,30)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	
end
