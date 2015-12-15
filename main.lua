-- Verifica se dois retangulos colidem
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
    x2 < x1 + w1 and
    y1 < y2 + h2 and
    y2 < y1 + h1
end

-- Funcao que inicializa as variaveis do jogo
function startGame()
	player = {x=300, y=300, score=0, speed=400, bulletSpeed=400, lifes = 1, immune=false}
	gravitySpeed = 200
	enemies = {}
	enemySpeed=100
	currentState = "entrance"
	enemySize=20
	bordersTop={}
	bordersDown={}
	ratio=1
	items = {}
	itemsSpeed=100
	itemSize = 15
	timeCount = 0
	verticalCount = 0
	verticalBoolean = true
	horizontalCount = 0
	horizontalBoolean = false
	looseCount = 0
	backgroundSound = love.audio.newSource("Careless.mp3")
  backgroundSound: setLooping(true)
	scaleX=1
	scaleY=1
  maxScale =3
	looseTime =0
	gravitySound = love.audio.newSource("gravity.wav")
	decrSpeedItems={}
	incrSpeedItems={}
  limitSpeedMax = 2000
  limitSpeedMin = 250



end

function love.load()

  	startGame()

  	playerImage = love.graphics.newImage("6.png")
  	backgroundImage = love.graphics.newImage("background2.jpg")
	  incrementSizeImage = love.graphics.newImage("incrSize.png")
  	coolFont = love.graphics.newFont("ProggySquareTT.ttf", 40)
  	love.graphics.setFont(coolFont)

  	incrementSpeedImage = love.graphics.newImage("incrSpeed.png")
  	decrSpeedImage = love.graphics.newImage("decrSpeed.png")
  	incrSpeedImage = love.graphics.newImage("incrSpeed.png")


end

function getNewBackground()
	number = love.math.random(1, 7)
	backgroundImage = love.graphics.newImage("background"..number..".jpg")
end

function incrementSize()
	scaleX=scaleX+0.05
	scaleY=scaleY+0.05

end

function incrementSpeed()
  if player.speed < limitSpeedMax then
	   player.speed = player.speed + 50
  end
end
function decreaseSpeed()
  if player.speed > limitSpeedMin then
	   player.speed = player.speed - 50
  end
end
function changeGravityTimer(type)
  number = love.math.random(1, 2)
  if type == 1 then
    if number == 1 then
      return 350
    else
      return 500
    end

  else
    if number == 2 then
      return 60
    else
      return 85
    end
  end

end
function love.update(dt)

	if currentState == "entrance" then
		if (love.keyboard.isDown("a") or love.keyboard.isDown("d")) then
				backgroundSound:play()
				currentState = "verticalGame"
		elseif  (love.keyboard.isDown("w") or love.keyboard.isDown("s")) then
				backgroundSound:play()
				currentState = "verticalGame"

		end
	else
		timeCount = timeCount + 1
		if verticalBoolean then
			verticalCount = verticalCount + 1
		end
		if horizontalBoolean then
			horizontalCount = horizontalCount + 1
		end

		enemySize = enemySize + 10
		if timeCount == 10 then
			getNewBackground()
			--getNewEnemyColor()
			timeCount = 0
		end
		if verticalCount == 400 then
			gravitySound:play()
			verticalBoolean = false
			horizontalBoolean = true
			currentState = "horizontalGame"
			verticalCount = 0
		end

		if horizontalCount == 70 then
			horizontalBoolean = false
			verticalBoolean=true
			currentState = "verticalGame"
			horizontalCount = 0
		end

		if currentState == "verticalGame" then
			--Detectar Input
			player.score = player.score + 1
			if player.y>love.graphics.getHeight()/2 and player.y + playerImage:getWidth()/2 + 5<love.graphics.getHeight()then
				player.y=player.y+gravitySpeed*dt
			end

			if player.y <=love.graphics.getHeight()/2 and player.y -(playerImage:getWidth() - 10)>0 then
					player.y=player.y-gravitySpeed*dt
			end
			if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) and player.y>0 then
        if player.y - (playerImage:getWidth() -10)> 0 then
          player.y=player.y-player.speed*dt
        end
      end


			if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) and player.y<love.graphics.getHeight() then
        if player.y  + playerImage:getWidth() < love.graphics.getHeight() then
          player.y=player.y+player.speed*dt
        end
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
      if(player.x < 0 or player.x>love.graphics.getWidth()) then
        if player.lifes > 1 then
          player.lifes = player.lifes - 1
          player.x = love.graphics.getWidth()/2
          player.y= love.graphics.getHeight()/2
          currentState = "looseLife"

        elseif player.lifes == 1 then
          currentState="gameover"
        end
      end

		elseif(currentState=="gameover")then
			if love.keyboard.isDown("k") then
				startGame()
			end
		end


			if math.random() < 0.04 then
				local newEnemy = {x=800 , y= math.random()*800, width=love.math.random(20,60), height=love.math.random(15,50)}
				table.insert(enemies, newEnemy)
			end

			if math.random() < 0.005 then
				local newItem = {x=800, y=math.random()*800, width=15, height=15}
				table.insert(items, newItem)
			end

			if math.random() < 0.005 then
				local decrSpeed = {x=800, y=math.random()*800, width=20, height=20}
				table.insert(decrSpeedItems, decrSpeed)
			end

			if math.random() < 0.01 then
				local incrSpeed = {x=800, y=math.random()*800, width=20, height=20}
				table.insert(incrSpeedItems, incrSpeed)
			end

			for i=#enemies,1,-1 do
				if player.immune==false then
					if checkCollision(enemies[i].x, enemies[i].y, enemies[i].width, enemies[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
						--gameover
						if player.lifes > 1 then
							player.lifes = player.lifes - 1
							player.x = love.graphics.getWidth()/2
							player.y= love.graphics.getHeight()/2
							currentState = "looseLife"

						elseif player.lifes == 1 then
							currentState="gameover"
						end
					end
				end
			end

			for i=#items, 1, -1 do
				if checkCollision(items[i].x, items[i].y, items[i].width, items[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
						pickupSound = love.audio.newSource("pickup.mp3")
						pickupSound:play()
						table.remove(items, i)
						incrementSize()
				end
			end

			for i=1, #items do
				items[i].x = items[i].x - itemsSpeed*dt
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

			for i=#decrSpeedItems, 1, -1 do
				if checkCollision(decrSpeedItems[i].x, decrSpeedItems[i].y, decrSpeedItems[i].width, decrSpeedItems[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
						pickupSound = love.audio.newSource("pickup.mp3")
						pickupSound:play()
						table.remove(decrSpeedItems, i)
						decreaseSpeed()
				end
			end

			for i=1, #decrSpeedItems do
				decrSpeedItems[i].x=decrSpeedItems[i].x-enemySpeed*dt
			end

			for i=#incrSpeedItems, 1, -1 do
				if checkCollision(incrSpeedItems[i].x, incrSpeedItems[i].y, incrSpeedItems[i].width, incrSpeedItems[i].height, player.x, player.y, playerImage:getWidth(), playerImage:getHeight()) then
						pickupSound = love.audio.newSource("pickup.mp3")
						pickupSound:play()
						table.remove(incrSpeedItems, i)
						incrementSpeed()
				end
			end

			for i=1, #incrSpeedItems do
				incrSpeedItems[i].x=incrSpeedItems[i].x-enemySpeed*dt
			end



			if player.x<=0 then
				if player.lifes > 1 then
					player.lifes = player.lifes - 1
					player.x = love.graphics.getWidth()/2
					player.y= love.graphics.getHeight()/2
					currentState = "looseLife"

				elseif player.lifes == 1 then
					currentState="gameover"
				end
			end


		if currentState=="looseLife" then
			--looseTime = looseTime + 1

			player.immune = true
			looseCount = looseCount + 1
			if looseCount == 30 then
				looseCount=0
				currentState = "verticalGame"
        player.imune = false
			end

      --if looseTime == 20 then
				--player.imune=false
				--looseTime=0
			--end
		end

	end

  clean()
end


function love.draw()
	if currentState == "horizontalGame" or currentState == "verticalGame" then

		love.graphics.draw(backgroundImage, 0, 0)
		love.graphics.draw(playerImage, player.x, player.y,
							math.atan2(love.mouse.getY()-player.y,
							love.mouse.getX()-player.x),scaleX,scaleY, playerImage:getWidth()/2,
							playerImage:getHeight()/2)

		for i=1, #enemies do
			love.graphics.setColor(math.random()*255, math.random()*255, math.random()*255)
			love.graphics.rectangle("fill", enemies[i].x-enemies[i].width/2, enemies[i].y-enemies[i].height/2, enemies[i].width, enemies[i].height)
		end

		love.graphics.setColor(255,255,255)
		for i=1, #items do
			love.graphics.draw(incrementSizeImage,items[i].x-items[i].width/2, items[i].y-items[i].height/2,0,1,1, items[i].width/2, items[i].height)

			--love.graphics.draw(incrementSizeImage, items[i].x-items[i].width/2, items[i].y-items[i].height/2, items[i].width/2, items[i].height)
		end
		for i=1, #bordersTop do
			love.graphics.rectangle("fill", bordersTop[i].x-bordersTop[i].width/2, bordersTop[i].y-bordersTop[i].height/2, bordersTop[i].width, bordersTop[i].height)
		end

		for i=1, #bordersDown do
			love.graphics.rectangle("fill", bordersDown[i].x-bordersDown[i].width/2, bordersDown[i].y-bordersDown[i].height/2, bordersDown[i].width, bordersDown[i].height)
		end

		for i=1, #decrSpeedItems do
			love.graphics.draw(decrSpeedImage,decrSpeedItems[i].x-decrSpeedItems[i].width/2, decrSpeedItems[i].y-decrSpeedItems[i].height/2,0,1,1, decrSpeedItems[i].width/2, decrSpeedItems[i].height)
		end

		for i=1, #incrSpeedItems do
			love.graphics.draw(incrSpeedImage,incrSpeedItems[i].x-incrSpeedItems[i].width/2, incrSpeedItems[i].y-incrSpeedItems[i].height/2,0,1,1, incrSpeedItems[i].width/2, incrSpeedItems[i].height)
		end

		love.graphics.print("Score: "..player.score, 20,20)
		love.graphics.print("Best Score: 99999", 450, 20)


	elseif currentState == "gameover" then
		backgroundSound:stop()
		love.graphics.print("GameOver, press K to start again", 110, 250)
		love.graphics.print("Score: " ..player.score, 350,300)

	elseif currentState == "entrance" then
		love.graphics.print("LD34Winner", 250,50,0,2,2)
		love.graphics.print("Use W/S or A/D to advance on our",150,200 )
		love.graphics.print("Gravity Field, but be aware!",150,300 )
		love.graphics.print("Sometimes the Force changes", 150,400)
		love.graphics.print("May the force be with you!", 150,500)

  elseif currentState == "looseLife" then
    love.graphics.print("Imune", 300, 300)
	end


end


function clean()
	for i=#enemies,1,-1  do
		if enemies[i].x==-30 then
			table.remove(enemies, i)
		end
	end
	for i=#bordersTop,1,-1 do
		if bordersTop[i].x==-30 then
			table.remove(bordersTop, i)
		end
	end
	for i=#bordersDown,1,-1  do
		if bordersDown[i].x==-30 then
			table.remove(bordersDown, i)
		end
	end

end
