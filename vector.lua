-- Fonction qui calcule la composante x d'un vecteur v d'angle a
local function _getVx(speed, angle)
  return math.cos(angle) * speed
end

-- Fonction qui calcule la composante y d'un vecteur v d'angle a
local function _getVy(speed, angle)
  return math.sin(angle) * speed
end


Vector = {
  -- @param v la vitesse initiale, en px/secondes
  -- @param a l'angle de déplacement
  new = function(speed, angle)

    local vector = {}
    vector.norme = speed
    vector.normeX = _getVx(speed, angle)
    vector.normeY = _getVy(speed, angle)
    return vector
  end,

  -- Ajoute à un vecteur existant
  add = function(vector1, vector2)

    local newVector = {}
    newVector.normeX = vector1.normeX + vector2.normeX
    newVector.normeY = vector1.normeY + vector2.normeY

    newVector.norme = math.sqrt(math.pow(newVector.normeX, 2),math.pow(newVector.normeY, 2))

    return newVector

  end

}

return Vector
