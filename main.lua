Vector  = require "vector"
Player  = require "player"

function love.load()

  time = 0
  isLoading = true

  vector = Vector.new(0,0)
  player = Player.new(50, love.graphics.getHeight()/2, 20, vector)

end

function love.update(dt)

  time = time + dt  -- Calcul du temps passé depuis le démarage du programme
  fps = 1/dt        -- Calcul des FPS

  Player.update(dt) -- Mise à jour du joueur

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
  love.graphics.print(math.floor(time) .. "s",10,25)

  love.graphics.print("ORIENTATION JOUEUR : " .. math.floor(player.orientation*180/math.pi) .. "°",10,55)
  love.graphics.print("VITESSE JOUEUR : " .. player.vector.norme .. " px/s",10,70)

  -- CADRILLAGE
  love.graphics.setColor(1, 1, 1, 0.3)
  for grad=0, love.graphics.getWidth(), love.graphics.getWidth()/30 do
    love.graphics.line(grad, 0, grad, love.graphics.getHeight())
    love.graphics.line(0, grad, love.graphics.getWidth(), grad)
  end

  Player.draw()

end
