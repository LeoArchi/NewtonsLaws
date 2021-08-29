Trajectory = {

predict = function(x, y, vector, nbPoints)

  local prediction = {}
  local virtualDt = 0.3

  local virtualX = x
  local virtualY = y

  for index=0, nbPoints, 1 do
    -- Tester la présence d'une accélération du à un potentiel champ gravitationnel, comme si dessus
    -- A la différence de si dessus, calculer systématiquement la gravité lorsque l'on se trouve dans la zone d'influance gravitationelle
    -- Si lorsque l'on applique la gravitation et que l'on dépasse la colition de la planète, alors recalculer les composantes de sorte que l'on reste à la surface de l'astre
    -- TODO (LA MEME CHOSE QUE LORS DU CALCUL REEL, D'OU L'INTERET D'UNE FONCTION)

    -- Calculer virtuellement le déplacement du joueur
    virtualX = virtualX + vector.normeX*virtualDt
    virtualY = virtualY - vector.normeY*virtualDt

    table.insert(prediction, {x = virtualX , y = virtualY})

  end

  return prediction
end

}

return Trajectory
