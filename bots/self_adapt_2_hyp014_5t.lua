W = {{{0.343971472982,-0.188413497566,-0.298716616673,-0.260114513514,0.370750376624,-0.441007195709},{0.0216845537375,-0.14716167938,-0.383782743173,-0.248278904981,-0.0126295719271,-0.0664845903552},{-0.405075337974,-0.370114524141,0.448854933324,-0.0732827281949,0.319846022478,0.0244543592095},{-0.42056161652,-0.167079674256,-0.0596436462569,-0.132267243703,-0.0936212669255,-0.0386018161525},{-0.175323816762,0.0867560280654,-0.196693986912,-0.297597241136,-0.359593544893,0.0658227949192},{0.405902971045,-0.112480767708,0.114450151268,0.0746261442734,0.242724527401,0.314280674398},{-0.328140684633,-0.18302046774,0.442143878849,0.42325768812,-0.0750850174418,0.20099407705},},
{{0.157246074207,-0.494972701605,0.385619521385,0.246863111105,-0.149033635507,-0.416049839905,0.343317159889},{-0.273454256112,0.222768095899,-0.450899835746,0.476779359288,-0.337234220539,0.385787765698,0.166014739864},},
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
