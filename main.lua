require "vector"

function love.load()

  va = 0.8 -- vitesse angulaire de la variation de l'orientation

  tempsPasse = 0

  player = {}
  player.x =  love.graphics.getWidth()/2 -- La position en x du joueur
  player.y =  love.graphics.getHeight()/2 -- La position en y du joueur
  player.o = 0 -- L'orientation du joueur en radians
  player.oX = player.x + 20
  player.oy = player.y
  player.radius = 20
  player.vector = Vector:new(0,0) -- Le vecteur vitesse du joueur, exprimé par l'orientation de son mouvement en radians et sa vitesse en px par seconde
  player.acceleration = 1 -- L'accélération possible par le joueur lorsque les moteurs sont allumés, en px par seconde par seconde

  player.trajectory = {}
  player.trajectory.tempsEcoule = 0
  player.trajectory.points = {}
end

function love.update(dt)

  -- Calcul du temps passé
  tempsPasse = tempsPasse + dt

  -- Calcul des FPS
  fps = 1/dt

  -- Calcul du temps écoulé pour la sauvegarde de la trajectoire du joueur
  player.trajectory.tempsEcoule = player.trajectory.tempsEcoule + dt

  -- Calculer l'orientation du joueur
  if love.keyboard.isDown("left") then
    -- On augmente l'angle du joueur de n radians par seconde
    if player.o + va*dt >= math.pi*2 then
      player.o = player.o + va*dt - math.pi*2
    else
      player.o = player.o + va*dt
    end
  elseif love.keyboard.isDown("right") then
    -- On diminue l'angle du joueur de n radians par seconde
    if player.o + va*dt <= 0 then
      player.o = player.o - va*dt + math.pi*2
    else
      player.o = player.o - va*dt
    end
  end

  player.oX = player.x + math.cos(player.o) * 20
  player.oY = player.y - math.sin(player.o) * 20

  -- Recalculer la vitesse du joueur lorque l'on accélère
  if love.keyboard.isDown("space") then
    -- On calcule le vecteur vitesse par rapport à l'accélération
    local vectorSpeed = Vector:new(player.acceleration,player.o)

    -- Le nouveau vecteur vitesse du joueur correspond à l'addition entre son ancien vecteur vitesse et le vecteur vitesse resultant de son accélération
    player.vector = Vector:add(player.vector, vectorSpeed)
  end

  -- Tester la présence d'une accélération du à un potentiel champ gravitationnel
  -- TODO

  -- Calculer le déplacement du joueur
  player.x = player.x + player.vector.normeX*dt
  player.y = player.y - player.vector.normeY*dt

  -- Si il s'est écoulé plus de 1s depuis le dernier point sauvegardé, alors réinitialiser le temps et sauvegarder la position actuelle
  if player.trajectory.tempsEcoule > 0.3 then
    player.trajectory.tempsEcoule = 0
    table.insert(player.trajectory.points, {playerX = player.x , playerY = player.y})
  end

end

function love.keypressed(key, scancode, isrepeat)
  if key == "r" then
    love.load()
  end
end

function love.draw()

  -- VARIABLE DE DEBUG
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(math.floor(fps) .. " FPS",10,10)
  love.graphics.print(math.floor(tempsPasse) .. "s",10,25)

  love.graphics.print("ORIENTATION JOUEUR : " .. math.floor(player.o*180/math.pi) .. "°",10,55)
  love.graphics.print("VITESSE JOUEUR : " .. player.vector.norme .. " px/s",10,70)

  -- CADRILLAGE
  love.graphics.setColor(1, 1, 1, 0.3)
  for grad=0, love.graphics.getWidth(), love.graphics.getWidth()/30 do
    love.graphics.line(grad, 0, grad, love.graphics.getHeight())
    love.graphics.line(0, grad, love.graphics.getWidth(), grad)
  end

  -- TRAJECTOIRE DU JOUEUR
  love.graphics.setColor(0, 0, 1)
  for i, v in ipairs(player.trajectory.points) do
    if i ~= 1 then
      local last = player.trajectory.points[i-1]
      local current = player.trajectory.points[i]
      love.graphics.line(last.playerX, last.playerY, current.playerX, current.playerY)
    end
  end

  -- PROGRADE
  love.graphics.setColor(1, 0.8, 0)
  love.graphics.line(player.x, player.y, player.x+player.vector.normeX, player.y-player.vector.normeY)

  -- RETROGRADE
  love.graphics.setColor(0, 1, 0.5)
  love.graphics.line(player.x, player.y, player.x-player.vector.normeX, player.y+player.vector.normeY)

  -- LE JOUEUR
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", player.x, player.y, player.radius, 32)

  -- ORIENTATION DU JOUEUR
  love.graphics.setColor(0, 0, 0)
  love.graphics.line(player.x, player.y, player.oX, player.oY)

end
