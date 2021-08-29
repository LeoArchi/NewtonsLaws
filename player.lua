Trajectory  = require "trajectory"
Vector      = require "vector"
Gravity     = require "gravity"

Player = {

new = function(x, y, radius, vector)

  local player = {}

  player.x =  x           -- La position en x du joueur
  player.y =  y           -- La position en y du joueur
  player.radius = radius  -- Le rayon du joueur en px

  player.orientation = 0    -- L'orientation du joueur en radians
  player.oX = player.x + 20 -- La coordonée x du bout du curseur d'orientation
  player.oY = player.y      -- La coordonée y du bout du curseur d'orientation
  player.oV = 0.8           -- La vitesse angulaire de l'orientation lorsque le joueur la modifie

  player.vector = vector  -- Le vecteur vitesse du joueur
  player.acceleration = 1 -- L'accélération possible par le joueur lorsque les moteurs sont alumés, en px/s²

  player.trajectory = {}
  player.trajectory.tempsEcoule = 0
  player.trajectory.passee = {}
  player.trajectory.future = {}

  return player

end,

update = function(dt)
  -- Prédiction de la trajectoire du joueur
  player.trajectory.future = Trajectory.predict(player.x, player.y, player.vector, 50)

  player.trajectory.tempsEcoule = player.trajectory.tempsEcoule +dt

  -- Calculer l'orientation du joueur
  if love.keyboard.isDown("left") then
    -- On augmente l'angle du joueur de n radians par seconde
    if player.orientation + player.oV*dt >= math.pi*2 then
      player.orientation = player.orientation + player.oV*dt - math.pi*2
    else
      player.orientation = player.orientation + player.oV*dt
    end
  elseif love.keyboard.isDown("right") then
    -- On diminue l'angle du joueur de n radians par seconde
    if player.orientation + player.oV*dt <= 0 then
      player.orientation = player.orientation - player.oV*dt + math.pi*2
    else
      player.orientation = player.orientation - player.oV*dt
    end
  end

  player.oX = player.x + math.cos(player.orientation) * 20
  player.oY = player.y - math.sin(player.orientation) * 20

  -- Recalculer la vitesse du joueur lorque l'on accélère
  if love.keyboard.isDown("space") then
    -- On calcule le vecteur vitesse par rapport à l'accélération
    local vectorSpeed = Vector.new(player.acceleration,player.orientation)
    -- Le nouveau vecteur vitesse du joueur correspond à l'addition entre son ancien vecteur vitesse et le vecteur vitesse resultant de son accélération
    player.vector = Vector.add(player.vector, vectorSpeed)
  end

  -- Tester la présence d'une accélération du à un potentiel champ gravitationnel
  local gravityVector = Gravity.getGravity(soleil, player.x, player.y)
  if gravityVector.norme < 0 then

    -- Le nouveau vecteur vitesse du joueur correspond à l'addition entre son ancien vecteur vitesse et le vecteur vitesse resultant de son accélération
    player.vector = Vector.add(player.vector, gravityVector)

    -- TODO : Si lorsque l'on applique la gravitation et que l'on dépasse la colition de la planète, alors recalculer les composantes de sorte que l'on reste à la surface de l'astre
  end

  -- Calculer le déplacement du joueur
  player.x = player.x + player.vector.normeX*dt
  player.y = player.y - player.vector.normeY*dt

  -- Si il s'est écoulé plus de 0.3s depuis le dernier point sauvegardé, alors réinitialiser le temps et sauvegarder la position actuelle
  if player.trajectory.tempsEcoule > 0.1 then
    player.trajectory.tempsEcoule = 0
    table.insert(player.trajectory.passee, {x = player.x , y = player.y})
  end
end,

draw = function()
  -- TRAJECTOIRE PASEE DU JOUEUR
  love.graphics.setColor(0, 0, 1)
  for i, v in ipairs(player.trajectory.passee) do
    if i ~= 1 then
      local last = player.trajectory.passee[i-1]
      local current = player.trajectory.passee[i]
      love.graphics.line(last.x, last.y, current.x, current.y)
    end
  end

  -- TRAJECTOIRE PREDITE DU JOUEUR
  love.graphics.setColor(1, 1, 1)
  for i, v in ipairs(player.trajectory.future) do
    if i ~= 1 then
      local last = player.trajectory.future[i-1]
      local current = player.trajectory.future[i]
      --love.graphics.line(last.x, last.y, current.x, current.y)
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

}

return Player
