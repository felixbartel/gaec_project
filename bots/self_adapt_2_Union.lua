W = {{{-0.0529432912773,0.476905006314,-0.377566625408,-0.225773638214,-0.40788329056,-0.387467800893},{-0.0452114693111,0.0626245147547,0.465584731849,0.0858330631228,-0.0838067945382,0.0669539658775},{-0.165704815764,-0.0452937898544,0.443764701564,-0.108913261054,0.200696924727,0.321400801851},{-0.373481486387,-0.145628838239,-0.106823725049,-0.132929667008,-0.0983509039898,-0.0250377880051},{-0.0425278395174,-0.0184945879806,-0.410014350368,0.189651275756,0.47679190793,-0.114978673999},{-0.12866969337,0.48595093228,0.339480893723,0.480507384184,-0.109709571986,-0.186537878158},{0.350460792224,0.0358411912663,0.0809339394681,0.043608932617,-0.0204296075189,-0.437343479349},},
{{-0.42159876342,-0.122778963782,-0.168020581093,-0.425476011251,0.349285498998,0.190003832015,-0.217815159871},{0.155255750332,0.463997275263,0.0508641187884,0.017651874421,0.413282326783,0.105407496506,0.481319984304},},
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
