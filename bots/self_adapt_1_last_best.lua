W = {{{0.0749919961024,-0.0184571707839,-0.0534928749312,-0.257547121901,0.333679238469,-0.215034637739},{-0.50270110295,0.4618668156,0.446689183538,-0.325205000885,-0.0719336819069,-0.394994778696},{0.395692026456,-0.173175148108,0.295681621863,-0.235567952673,-0.475173986927,-0.171091405379},{-0.451682455955,0.330679744136,-0.110388607436,0.0126681167811,0.27655035598,-0.0277325938415},{-0.42194871048,-0.398702839627,0.210101503706,0.139114231624,-0.12426844364,-0.178062001029},{-0.4968738876,0.14548525431,0.304426554246,-0.00315450663243,0.262244467753,0.0725001553653},{-0.429086907239,0.148268410057,-0.355264287702,-0.203300716982,0.349238916198,0.103303408669},},
{{-0.44879637702,0.42523697392,-0.262562947102,0.44797642276,-0.523031032055,0.307682743702,0.0315516482626},{-0.136973248252,0.235744734462,0.31369010158,-0.140734969667,-0.180658866676,0.447499764771,-0.325696401875},},
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
