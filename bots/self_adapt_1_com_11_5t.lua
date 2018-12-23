W = {{{0.046079374977,0.386473958822,0.246451841602,0.273386893318,0.150721562697,0.360682372441},{0.213292503812,0.409144276319,-0.428840971423,-0.149469394591,0.198532283473,-0.595458655889},{0.210228318786,0.290043946766,-0.259232745714,0.319462201071,-0.0879112275031,0.0248991473488},{-0.143627683034,0.341015567604,-0.405152418238,0.140895032914,-0.0729782793165,-0.504855428832},{-0.391352339779,0.242543982464,-0.390223456262,0.0644946028707,-0.223739788543,-0.17477081077},{0.179834786814,-0.285630124227,0.545928362618,0.225494764341,0.317677334075,0.649918151712},{0.461539601335,-0.270644924302,0.0846266358789,-0.544708719204,0.629832958339,0.434717354502},},
{{-0.022992897226,0.321580717522,-0.213195971446,0.101574180824,0.316958057126,-0.408347170792,-0.024918451724},{0.0605733579991,0.505987193715,0.181456002722,0.301467060157,0.539273725197,0.102212590262,-0.149460641629},},
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
