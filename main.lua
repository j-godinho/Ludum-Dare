-- Verifica se dois retangulos colidem
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
    x2 < x1 + w1 and
    y1 < y2 + h2 and
    y2 < y1 + h1
end

-- Funcao que inicializa as variaveis do jogo
function startGame()
	player = {x=300, y=400, score=0, speed=200, bulletSpeed=400}
	enemies = {}
	enemySpeed=100
	enemySize=20
	borders={}
	ratio=1
	currentState = "game"
end

function love.load()
  startGame()

  playerImage = love.graphics.newImage("nave.png")
  backgroundImage = love.graphics.newImage("background.jpg")

  coolFont = love.graphics.newFont("ProggySquareTT.ttf", 40)
  love.graphics.setFont(coolFont)

end

function love.update(dt)
	if currentState == "game" then
		--Detectar Input
		if love.keyboard.isDown("w") and player.y>0 then
			player.y=player.y-player.speed*dt
		end
		if love.keyboard.isDown("a") and player.x>0 then
			player.x=player.x-player.speed*dt
		end
		if love.keyboard.isDown("s") and player.y<love.graphics.getHeight() then
			player.y=player.y+player.speed*dt
		end
		if love.keyboard.isDown("d") and player.x<love.graphics.getWidth() then
			player.x=player.x+player.speed*dt
		end


		if math.random() < 0.05 then
			local newEnemy = {x=800, y=math.random()*800, width=enemySize*ratio, height=enemySize*ratio}
			table.insert(enemies, newEnemy)
		end


		for i=#enemies,1,-1 do
			if checkCollision(enemies[i].x, enemies[i].y, enemies[i].width, enemies[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
				--gameover
				currentState="gameover"

			end
		end

		for i=1, #enemies do
			enemies[i].x=enemies[i].x-enemySpeed*dt
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
	if currentState == "game" then
		love.graphics.draw(backgroundImage, 0, 0)
		love.graphics.draw(playerImage, player.x, player.y,
							math.atan2(love.mouse.getY()-player.y,
							love.mouse.getX()-player.x),1,1, playerImage:getWidth()/2, playerImage:getHeight()/2)

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
