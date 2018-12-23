W = {{{0.0264008163771,0.0395365663669,0.430872948647,0.811548070425,-0.05625099182,0.450596741556},{0.190348741193,0.299462233976,-0.200010263563,0.335732926702,0.747230595888,-0.458634091629},{-1.77640719001,0.632502222855,-0.276429702852,-0.0173701568411,-0.402664771019,-0.345167169784},{0.314059069891,0.0319137585183,-0.198150357618,0.0625497849595,-0.0849118015506,0.128426095545},{-0.66857713834,0.398869793044,-0.205088857629,-0.166933850988,0.260942833008,-0.591822744814},{-0.249819174542,-0.146723967622,0.964040850998,0.453508166579,0.031179235863,-0.195187645328},{-0.305723422087,-0.580226032272,-0.197798930114,-0.490528235941,0.615471493066,-0.26978860296},},
{{0.228230787936,-0.234242563611,0.300716583721,-0.519783041678,-0.173422673039,0.118484990534,0.411226600975},{0.354738143031,0.19950470637,-0.923293594182,2.87907638104,-1.34852904827,-1.03563622701,0.00207795095204},},
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
