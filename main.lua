-- Verifica se dois retangulos colidem
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
    x2 < x1 + w1 and
    y1 < y2 + h2 and
    y2 < y1 + h1
end

-- Funcao que inicializa as variaveis do jogo
function startGame()
	player = {x=300, y=300, score=0, speed=400, bulletSpeed=400, lifes = 3}
	gravitySpeed = 200
	enemies = {}
	enemySpeed=100
	currentState = "verticalGame"
	enemySize=20
	bordersTop={}
	bordersDown={}
	ratio=1
	items = {}
	itemsSpeed=100
	itemSize = 15
	timeCount = 0
end

function love.load()

  startGame()

  playerImage = love.graphics.newImage("6.png")
  backgroundImage = love.graphics.newImage("background2.png")

  coolFont = love.graphics.newFont("ProggySquareTT.ttf", 40)
  love.graphics.setFont(coolFont)

end

function love.update(dt)
	timeCount = timeCount + 1
	player.score = player.score + 1
	enemySize = enemySize + 10
	if timeCount == 50 then
		backgroundImage = love.graphics.newImage("background.jpg")
	elseif timeCount == 100 then
		backgroundImage = love.graphics.newImage("background2.png")
		timeCount = 0
	end

	if currentState == "verticalGame" then
		--Detectar Input

		if player.y>love.graphics.getHeight()/2 and player.y<love.graphics.getHeight()then
			player.y=player.y+gravitySpeed*dt
		end

		if player.y<=love.graphics.getHeight()/2 and player.y>0 then
				player.y=player.y-gravitySpeed*dt
		end
		if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and player.y>0 then
			player.y=player.y-player.speed*dt
		end


		if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and player.y<love.graphics.getHeight() then
			player.y=player.y+player.speed*dt
		end

		if love.keyboard.isDown("c")then
			currentState = "horizontalGame"
		end
	elseif (currentState =="horizontalGame")then
		if player.x>love.graphics.getWidth()/2 and player.x<love.graphics.getWidth()then
			player.x=player.x+gravitySpeed*dt
		end

		if player.x<=love.graphics.getWidth()/2 and player.y>0 then
				player.x=player.x-gravitySpeed*dt
		end

		if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) and player.x>0 then
			player.x=player.x-player.speed*dt
		end
		if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) and player.x<love.graphics.getWidth() then
			player.x=player.x+player.speed*dt
		end

		if love.keyboard.isDown("c")then
			currentState = "verticalGame"
		end

	elseif(currentState=="gameover")then
		if love.keyboard.isDown("k") then
			startGame()
		end
	end

	if currentState == "verticalGame" then

		if math.random() < 0.05 then
			local newEnemy = {x=800 , y= math.random()*800, width=20, height=20}
			table.insert(enemies, newEnemy)
		end


		for i=#enemies,1,-1 do
			if checkCollision(enemies[i].x, enemies[i].y, enemies[i].width, enemies[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
				--gameover
				if player.lifes > 1 then
					player.lifes = player.lifes - 1
					player.x = love.graphics.getWidth()/2
					player.y= love.graphics.getHeight()/2

				elseif player.lifes == 1 then
					currentState="gameover"
				end
			end
		end


		for i=1, #enemies do
			enemies[i].x=enemies[i].x-enemySpeed*dt
		end

		local newBorderTop = {x=800, y=0, width=3, height=10}
		table.insert(bordersTop, newBorderTop)

		
		local newBorderDown = {x=800, y=600, width=3, height=10}
		table.insert(bordersDown, newBorderDown)


		for i=1, #bordersTop do
			bordersTop[i].x=bordersTop[i].x-enemySpeed*dt
		end

		for i=1, #bordersDown do
			bordersDown[i].x=bordersDown[i].x-enemySpeed*dt
		end

		for i=#bordersDown,1,-1 do
			if checkCollision(bordersDown[i].x, bordersDown[i].y, bordersDown[i].width, bordersDown[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
				--gameover
				if player.lifes > 1 then
					player.lifes = player.lifes - 1
				end
			end
		end

		for i=#bordersTop,1,-1 do
			if checkCollision(bordersTop[i].x, bordersTop[i].y, bordersTop[i].width, bordersTop[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
				--gameover
				if player.lifes > 1 then
					player.lifes = player.lifes - 1
				end
			end
		end

		clean()



	elseif currentState=="horizontalGame" then

	elseif currentState=="gameover" then

	end

end


function love.draw()
	if currentState == "horizontalGame" or currentState == "verticalGame" then
		love.graphics.draw(backgroundImage, 0, 0)
		love.graphics.draw(playerImage, player.x, player.y,
							math.atan2(love.mouse.getY()-player.y,
							love.mouse.getX()-player.x),1,1, playerImage:getWidth()/2,
							playerImage:getHeight()/2)

		for i=1, #enemies do
			love.graphics.rectangle("fill", enemies[i].x-enemies[i].width/2, enemies[i].y-enemies[i].height/2, enemies[i].width, enemies[i].height)
		end

		for i=1, #bordersTop do
			love.graphics.rectangle("fill", bordersTop[i].x-bordersTop[i].width/2, bordersTop[i].y-bordersTop[i].height/2, bordersTop[i].width, bordersTop[i].height)
		end

		for i=1, #bordersDown do
			love.graphics.rectangle("fill", bordersDown[i].x-bordersDown[i].width/2, bordersDown[i].y-bordersDown[i].height/2, bordersDown[i].width, bordersDown[i].height)
		end

		love.graphics.print("Score: "..player.score, 20,20)
		love.graphics.print("Jóias: "..player.lifes, 250, 20)


		love.graphics.print("enemies: "..#enemies, 50,50)

	elseif currentState == "gameover" then
		love.graphics.print("GameOver, press K to start again", 100, 100)
		love.graphics.print("Score: " .. player.score, 20,200)
	end


end


function clean()
	for i=1, #enemies do
		if enemies[i].x==-20 then
			table.remove(enemies, enemies[i])
		end			
	end
	for i=1, #bordersTop do
		if bordersTop[i].x==-20 then
			table.remove(bordersTop, bordersTop[i])
		end			
	end
	for i=1, #bordersDown do
		if bordersDown[i].x==-20 then
			table.remove(bordersDown, bordersDown[i])
		end			
	end

end

