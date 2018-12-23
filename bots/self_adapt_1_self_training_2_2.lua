W = {{{-0.336036195709,0.633848123724,1.21764048742,-0.0265662103763,0.284361540588,0.00133470462705},{0.555687106224,0.0414059913448,-0.0722500773063,-0.00912049553091,-0.424509914277,-0.26232662848},{-0.679933008276,-0.322923398028,0.245067145926,0.0554486685369,-0.118116108571,-0.160561693812},{-0.181728355814,0.617213991501,-1.24688305147,-0.240147310869,0.315961222411,0.666137340868},{0.426698014773,-0.0790015351889,-0.401513593263,-0.064462840552,0.252614343818,0.0222463926774},{-0.184717889601,-0.206321111615,-1.04546479162,0.269156906004,-0.604928242026,-0.060118462406},{-0.726211087337,-0.11605674897,-1.01301415104,0.625412088575,-0.336979207548,-0.512833737773},},
{{1.21860826378,-0.137871845395,0.504699757691,-0.564416098461,0.28716765337,-0.946239718677,-0.472308557501},{-0.342576180353,0.28008732806,0.739033536613,-0.840990080499,0.642308201761,0.716393063195,0.65942688414},},
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
