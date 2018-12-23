W = {{{-2.14504804018,1.57005331242,-2.20190919745,-3.85508110997,0.992999005414,2.85138039053},{2.34505885481,0.56315915255,2.46759833559,-6.24594567129,-2.38680252437,-2.0096148338},{0.0669107082119,-2.51619471926,-0.534182811644,-1.24515862108,-2.99071582502,-2.81296490524},{-2.96729662242,-1.15963017145,-0.63105042116,-0.558989861606,-2.10362090523,2.35329768163},{-0.407800495044,-0.213492239549,-4.6115714937,-1.26308213811,-3.67920811328,-0.945324924436},{-3.25614750636,-2.35974022546,4.30510123777,1.73044504519,-0.0303049829487,-0.469663944172},{-0.692454456567,-1.19526250668,0.110101142281,-1.11680499595,1.80446946829,-2.61503474539},},
{{1.21683910128,-1.58696726717,0.882832272983,1.3064415064,-1.38667042101,0.950323588085,0.560889023915},{-0.697802551896,0.359535222182,2.69528610324,-3.39874631583,1.04387389287,-1.45696651537,2.86304237532},},
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
