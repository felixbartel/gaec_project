W = {{{0.161229788408,0.117239702547,0.237608965285,-0.0466135779305,0.355942400431,0.0653623555483},{-0.461376183163,0.261853636483,-0.423367986082,0.327409406935,-0.483536061816,0.173049182004},{-0.266935910681,-0.260324900666,0.261668645547,0.00299126432923,0.267179200547,-0.249326773319},{-0.0924699416585,0.264533414082,0.465772779275,-0.346506776141,-0.276444730067,0.352397899861},{0.235352120076,-0.132338322283,-0.421042757315,0.11108286274,0.140872719703,-0.428975527964},{0.0633128566368,-0.385314262681,-0.390379858145,0.520402786452,-0.16469612591,-0.400193642818},{-0.318628231311,0.0394062099507,-0.10241244434,-0.154398207,-0.0440130442572,-0.224737955377},},
{{0.400933097956,-0.0878735820176,0.306238358984,-0.203957391636,-0.40256637241,-0.153147752755,0.176890845565},{0.171072688131,0.370801256065,0.398336262797,0.0985937149136,0.486798552052,0.0649190398938,0.107872307709},},
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
