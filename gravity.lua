Vector  = require "vector"

Gravity = {
  getValue = function(mass, distance)
    return 6.67 * math.pow(10, -11) * mass / math.pow(distance, 2)
  end,

  getGravity = function(astre, x, y)
    local distance = math.sqrt( math.pow(astre.y-y,2) + math.pow(astre.x-x,2) )
    if distance <= astre.infRad then
      local localX = x - astre.x
      local localY = astre.y - y
      local angle = math.atan2(localY, localX)

      if angle <0 then
        angle = math.pi*2 + angle
      end

      local gravityVector = Vector.new(-Gravity.getValue(astre.mass, distance),angle)

      return gravityVector
    else
      return Vector.new(0,0)
    end
  end
}

return Gravity
