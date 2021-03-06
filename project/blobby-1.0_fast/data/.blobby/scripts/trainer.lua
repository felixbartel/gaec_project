function OnBounce()
end

function OnOpponentServe()
  moveto(130)
end

function OnServe(ballready)
  pos = ballx()-45+5*((getScore()+getOppScore())%7)
  moveto(pos)
  if pos-3 < posx() and posx() < pos+3 then
    if ballready then 
      jump()
    end
  end
end

function OnGame()
  if ballx() < 400-100 then -- ball near our site
    moveto(ballx()+5*bspeedx()-5*((getScore()+getOppScore())%5)-15)
    if ballx()-posx() < -10*bspeedx()+5 then
      jump()
    end
  else
    moveto(130)
  end
end
