ntouches = 0
oldtouches = 0

function OnBounce()
end

function OnOpponentServe()
  ntouches = 0
  oldtouches = 0
  moveto(130)
end

function OnServe(ballready)
  ntouches = 0
  oldtouches = 0
  pos = ballx()-45+5*(getScore()%7)
  moveto(pos)
  if pos-3 < posx() and posx() < pos+3 then
    if ballready then 
      jump()
    end
  end
end

function OnGame()
  if ntouches < 1 then
    if touches() ~= 0 and touches() ~= oldtouches then
      ntouches = ntouches+1
      oldtouches = touches()
    end
    if touches() == 0 then
      oldtouches = 0
    end

    if ballx() < 400 then -- ball on our site
      moveto(ballx()+5*bspeedx()-5*((getScore()+getOppScore())%4)-15)
      if ballx()-posx() < -10*bspeedx()+5 then
        jump()
      end
    else
      moveto(130)
    end
    else
      moveto(400)
  end
end
