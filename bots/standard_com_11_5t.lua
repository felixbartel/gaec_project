W = {{{-0.2511673398,-0.466730206307,-0.267186868537,0.364666050688,0.254643783594,0.134470026409},{-0.460990321896,0.298159845499,-0.445950915172,0.304489582025,-0.467171269489,0.175304688345},{-0.159486049717,0.447267630505,-0.0265483738118,0.139051645336,0.250272720281,-0.385292944427},{0.261827121334,-0.460511842808,0.299138157735,0.229341417935,0.442515783454,0.255079830182},{0.292814855357,0.252844494087,-0.38720057895,0.355719006514,-0.271519349883,0.315068160184},{0.222316422244,0.232707827979,0.184769835842,0.361291250343,0.463590252588,-0.302101247633},{-0.423779530005,0.251282635418,0.292161085368,-0.208998513022,0.359374996529,0.0583117053477},},
{{-0.0280237196179,-0.196295963501,-0.0547314388579,0.428044563683,-0.319404345557,0.140252101362,0.143856212753},{-0.143160817225,0.470651235616,0.413944638126,0.106905781955,0.435215142103,0.350084031086,-0.122165389468},},
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
