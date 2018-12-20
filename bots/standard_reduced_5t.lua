W = {{{0.119641959042,-0.268870220128,0.386388549499,0.199704214045,0.356683045869,-0.0500849500814},{0.180633705371,0.363332473735,-0.162278105161,0.0894428002681,-0.181859967002,-0.302382764577},{-0.0488336417134,-0.32377087502,-0.39036311427,-0.0104200114513,0.384166275644,-0.268569724383},{0.279795566546,0.0753705047602,0.111497821705,0.203823611104,0.32651945261,-0.446574519263},{0.0670402472773,0.297844619111,0.409684337475,-0.49981508097,0.307550098686,-0.458369039473},{-0.247460400523,0.275243247183,0.0424503796204,0.0383739456509,0.160478962979,-0.181350526716},{-0.34698182817,0.0480623063075,-0.100157845573,-0.13915496848,-0.0493470586054,-0.225958296916},},
{{-0.383549090217,0.414377245008,-0.0936332903164,-0.0364923098386,0.319677631429,-0.280817222173,0.0444531007049},{0.0583846592497,-0.0961668277883,-0.0436018040351,0.455623027948,0.426981990481,0.389685720427,0.072957688358},},
}
function OnBounce()
end

function OnOpponentServe()
  moveto(130)
end

function OnServe(ballready)
  moveto(ballx() - 20)
  if posx() < ballx() - 17 and posx() > ballx() - 23 then
    if ballready then 
      jump()
    end
  end
end

function OnGame()
  input = {2*posx()/CONST_FIELD_WIDTH, posy()/400, (ballx()-posx())/CONST_FIELD_WIDTH, 2*(bally()-posy())/CONST_FIELD_WIDTH, bspeedx()/10, bspeedy()/10}
  output = feed_forward(input)
  decide_what_to_do(output)
end


function feed_forward(x)
  for i = 1,#W do
    x = activate(x,W[i])
  end
  return x
end


function activate(x,Wi) -- using the sigmoid function 1/(1+exp(-x))
  local y = {}
  x[#x+1] = 1
  for i = 1,#Wi do
    y[i] = 0
    for j = 1,#Wi[1] do
      y[i] = y[i]+Wi[i][j]*x[j]
    end
    y[i] = 1/(1+math.exp(-y[i]))
  end
  return y
end


function decide_what_to_do(output)
  if output[1] < 0.49 then
    left()
  end
  if output[1] > 0.51 then
    right()
  end
  if output[2] > 0.7 then
    jump()
  end
end
