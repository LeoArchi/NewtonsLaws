Gravity = require "gravity"
Vector = require "vector"

Trajectory = {

predict = function(x, y, vector, nbPoints)

  local prediction = {}
  local virtualDt = 0.3

  local virtualX = x
  local virtualY = y

  for index=0, nbPoints, 1 do

    -- Tester la présence d'une accélération du à un potentiel champ gravitationnel
    local gravityVector = Gravity.getGravity(soleil, virtualX, virtualY)
    if gravityVector.norme < 0 then

      -- Le nouveau vecteur vitesse du joueur correspond à l'addition entre son ancien vecteur vitesse et le vecteur vitesse resultant de son accélération
      vector = Vector.add(vector, gravityVector)

      -- TODO : Si lorsque l'on applique la gravitation et que l'on dépasse la colition de la planète, alors recalculer les composantes de sorte que l'on reste à la surface de l'astre
    end

    -- Calculer virtuellement le déplacement du joueur
    virtualX = virtualX + vector.normeX*virtualDt
    virtualY = virtualY - vector.normeY*virtualDt

    table.insert(prediction, {x = virtualX , y = virtualY})

  end

  return prediction
end

}

return Trajectory
