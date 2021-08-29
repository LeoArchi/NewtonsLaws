Vector  = require "vector"
Player  = require "player"
Astre   = require "astre"

function love.load()

  time = 0
  isLoading = true

  love.mouse.setVisible(false)

  default = love.graphics.newFont(12)
  forty = love.graphics.newFont(40)

  vector = Vector.new(0,0)
  player = Player.new(50, 200, 20, vector)

  soleil = Astre.new("Soleil", 75, 3000000000000000, love.graphics.getWidth()/2, love.graphics.getHeight()/2)

end

function love.update(dt)

  time = time + dt  -- Calcul du temps passé depuis le démarage du programme
  fps = 1/dt        -- Calcul des FPS

  if isLoading then
    Astre.initGravity(soleil)
    isLoading = false
  else
    Player.update(dt) -- Mise à jour du joueur
  end

end

function love.keypressed(key, scancode, isrepeat)
  if key == "r" then
    love.load()
  end
end

function love.draw()

  if isLoading then
    love.graphics.setFont(forty)
    love.graphics.print("LOADING ...", love.graphics.getWidth()/2 -90,love.graphics.getHeight()/2-20)
  else
    -- VARIABLE DE DEBUG
    love.graphics.setFont(default)
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

    Astre.draw(soleil)

    Player.draw()

    -- Dessin du curseur de la souris
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(love.mouse.getX()-5, love.mouse.getY(), love.mouse.getX()+5, love.mouse.getY())
    love.graphics.line(love.mouse.getX(), love.mouse.getY()-5, love.mouse.getX(), love.mouse.getY()+5)
  end

end
