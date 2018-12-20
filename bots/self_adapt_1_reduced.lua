W = {{{0.0883673604983,0.0346102713396,-0.130768596126,0.209210206555,-0.0484231812359,0.0335636804089},{0.440235317269,0.317857647446,-0.161921439129,0.15005839837,0.56595789234,0.215975638019},{-0.387291551243,-0.0612651305171,-0.420756637457,-0.185006348387,0.339656036998,-0.0424858025136},{-0.311132571415,-0.151829773295,-0.344685310408,-0.28433869412,-0.0327654291561,-0.0825033157182},{0.338401343652,0.254256885655,0.311205536775,-0.452515004409,-0.419910817439,-0.364142186415},{0.392341578823,-0.438385841505,-0.135406467621,-0.311094329664,-0.146522512111,0.141460987743},{-0.104130997675,-0.0587831526511,-0.374769376186,0.0545673022626,0.125882169541,0.258390063245},},
{{0.154330493402,0.345742171609,0.27302914811,0.263569765276,-0.322096014659,-0.467180008461,-0.309409057725},{-0.291245739211,-0.00400808198097,0.00587516260664,-0.382853013808,-0.103311566239,0.250502297116,-0.0781019643123},},
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
