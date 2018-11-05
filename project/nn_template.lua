
function OnBounce()
end

function OnOpponentServe()
  moveto(130) -- Wenn der Gegner spielt, in Ausgangsposition gehen
end

function OnServe(ballready)
  moveto(ballx() - 20) -- Etwas links vom Ball hinstellen
  if posx() < ballx() - 17 and posx() > ballx() - 23 then
       -- Dieser zugegeben etwas komplizierte Ausdruck bewirkt, dass
       -- man sich erstmal unterhalb des Balles befinden muss. Leider muss
       -- das so aufwendig gemacht werden, weil moveto() niemals eine Stelle
       -- ganz exakt erreicht.
    if ballready then 
      jump() -- Natürlich nur springen wenn der Ball schon bereitsteht
    end
  end
end

function OnGame()
  input = {posx(), posy(), launched(), ballx()-posx(), bally()-posy(), bspeedx(), bspeedy()}
  output = feed_forward(input)
  decide_what_to_do(output)
end


function feed_forward(x)
  for i = 1,#W do
    x = activate(x,W[i],b[i])
  end
  return x
end


function activate(x,Wi,b) -- using the sigmoid function 1/(1+exp(-x))
  local y = {}
  for i = 1,#Wi do
    y[i] = 0
    for j = 1,#Wi[1] do
      y[i] = y[i]+Wi[i][j]*x[j]
    end
    y[i] = 1/(1+math.exp(-(y[i]+b[i])))
  end
  return y
end


function decide_what_to_do(output)
  if output[1] > output[2] then
    if output[1] > 0.5 then
      left()
    end
  else
    if output[2] > 0.5 then
      right()
    end
  end
  if output[3] > 0.75 then
    jump()
  end
end
