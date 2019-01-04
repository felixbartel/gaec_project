W = {{{0.239571179619,1.02238011239,-0.202362012119,-0.508052818605,1.0349494785,-0.809614296675},{-0.276471597312,-0.949474944276,-0.947017709512,0.0601999961042,-0.441918806532,-0.427787067738},{-0.124155512762,-0.176549187093,-0.234514243471,-0.71087365069,0.0526609978116,-0.71159066812},{0.365923759778,0.044235661264,0.237286121684,-0.591242613893,-0.554109099575,-0.219623529427},{-0.220380355373,-0.403962882138,0.205603102674,-0.112851603934,-0.447942165713,-0.185167354522},{-0.97466510107,-0.183180283066,0.154547031751,0.444544399966,0.268846557639,-0.956258787959},{0.210654628969,-0.186994213547,-0.0471015281726,-0.539783768549,0.163058501886,-0.73684344095},},
{{-0.163465108607,-0.420009018535,0.0444915341996,0.313431243976,-0.193001020612,0.616743464213,-0.282468225411},{-0.0415338988373,0.5276529123,0.103141940299,0.552317644104,-0.0483616561439,0.141744636308,0.944405512878},},
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
