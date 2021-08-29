Gravity = require "gravity"

Astre = {
  new = function(name, radius, mass, x, y)
    local astre = {}
    astre.name = name
    astre.radius = radius
    astre.mass = mass
    astre.x = x
    astre.y = y
    astre.infRad = 0 -- Rayon d'influance gravitationnelle

    return astre
  end,

  initGravity = function(astre)

    repeat
      astre.infRad = astre.infRad + 10
      local gravity = Gravity.getValue(astre.mass, astre.infRad)
    until gravity < 1

  end,

  update = function()
  end,

  draw = function(astre)

    -- Dessin du cercle d'influance
    love.graphics.setColor(1, 0, 0, 0.2)
    love.graphics.circle("fill", astre.x, astre.y, astre.infRad, 64)

    -- Dessin du soleil
    love.graphics.setColor(1, 0.7, 0)
    love.graphics.circle("fill", astre.x, astre.y, astre.radius, 32)

  end
}

return Astre
