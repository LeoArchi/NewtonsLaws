-- Fonction qui calcule la composante x d'un vecteur v d'angle a
local function _getVx(v, a)
  return math.cos(a) * v
end

-- Fonction qui calcule la composante y d'un vecteur v d'angle a
local function _getVy(v, a)
  return math.sin(a) * v
end


Vector = {}

-- @param v la vitesse initiale, en px/secondes
-- @param a l'angle de déplacement
function Vector:new(v, a)
  local vector = {}
  vector.norme = v
  vector.normeX = _getVx(v, a)
  vector.normeY = _getVy(v, a)
  return vector
end

-- Ajoute à un vecteur existant
function Vector:add(vector1, vector2)

  local newVector = {}
  newVector.normeX = vector1.normeX + vector2.normeX
  newVector.normeY = vector1.normeY + vector2.normeY

  newVector.norme = math.sqrt(math.pow(newVector.normeX, 2),math.pow(newVector.normeY, 2))

  return newVector

end
