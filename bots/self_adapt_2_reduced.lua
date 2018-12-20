W = {{{-0.236412062914,0.254208816805,-0.468509534468,-0.174403057361,0.301185402112,0.320784056597},{-0.499836993818,0.45931987266,0.00367638542179,0.00276635474297,0.167002811615,0.275504476077},{0.0365349401574,0.282504228103,-0.127202076926,0.060705886597,-0.158618997695,0.44072316389},{0.234079200451,0.0157981507996,0.144742776668,-0.280786626817,0.455494234916,-0.0194742131098},{-0.410475580091,-0.206890413065,0.406083877663,-0.483547171682,-0.143286493203,-0.299842420233},{0.123199100222,0.361565706251,0.035198627148,0.407328149228,0.206963614476,0.437421206017},{0.3736482258,0.251462853476,0.443630533972,-0.458664813202,-0.402869390297,-0.492356761614},},
{{-0.255759334738,0.072425484861,-0.0902885823039,-0.366084534839,0.26141016503,-0.357466555796,0.486774034139},{-0.450613897139,-0.323032541686,-0.468684847934,-0.271736782545,0.165580801629,-0.13735472008,-0.48884624094},},
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
