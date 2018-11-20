function OnBounce()
end

function OnOpponentServe()
  moveto(130) -- Wenn der Gegner spielt, in Ausgangsposition gehen
end

function OnServe(ballready)
  moveto(ballx()-20-getScore()%5) -- Etwas links vom Ball hinstellen
  if posx() < ballx() - 17 and posx() > ballx() - 27 then
    if ballready then 
      jump()
    end
  end
end

function OnGame()
  if ballx() < 400 then -- ball on our site
    moveto(ballx() + 10*bspeedx() - 15 - getScore()%7)
    if ballx() < posx()+5-5*bspeedx() or bspeedx() < 1 or bspeedx() > -1 then
      jump()
    end
  end
end
