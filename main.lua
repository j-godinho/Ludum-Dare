-- Verifica se dois retangulos colidem
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
    x2 < x1 + w1 and
    y1 < y2 + h2 and
    y2 < y1 + h1
end

-- Funcao que inicializa as variaveis do jogo
function startGame()
	player = {x=300, y=300, score=0, speed=400, bulletSpeed=400}
	gravitySpeed = 200
	enemies = {}
	enemySpeed=100
	currentState = "verticalGame"
	enemySize=20
	borders={}
	ratio=1


end

function love.load()
  startGame()

  playerImage = love.graphics.newImage("6.png")
  backgroundImage = love.graphics.newImage("background.jpg")

  coolFont = love.graphics.newFont("ProggySquareTT.ttf", 40)
  love.graphics.setFont(coolFont)

end

function love.update(dt)
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

		local newBorderTop = {x=800, y=0, width=5, height=50*math.random()}
		table.insert(borders, newBorderTop)

		for i=1, #borders do
			borders[i].x=borders[i].x-enemySpeed*dt
		end



	elseif(currentState=="gameover")then
		if love.keyboard.isDown("k") then
			startGame()
		end

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


		for i=1, #borders do
			love.graphics.rectangle("fill", borders[i].x-borders[i].width/2, borders[i].y-borders[i].height/2, borders[i].width, borders[i].height)
		end

		love.graphics.print(player.score, 20,20)

	elseif currentState == "gameover" then
		love.graphics.print("GameOver, press K to start again", 100, 100)
		love.graphics.print("Score: " .. player.score, 20,200)
	end


end
