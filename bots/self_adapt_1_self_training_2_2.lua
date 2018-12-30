W = {{{0.527991426945,0.030051739788,-1.01687617151,-0.122596339177,-0.114477345144,0.459972048312},{-0.290679322831,-0.174962654021,1.4268285507,-0.37999749072,0.74502840647,-0.0253367277165},{-0.323417338049,0.267141044108,-1.02371180162,-0.0186119221129,-0.079937350908,-0.193543378872},{0.193759258387,0.209600975916,-2.12692063696,-0.251803376513,-0.0267036772503,-0.289997216895},{-0.164733624981,-0.373429749623,-0.603473081333,-0.288140097273,0.092917066079,-0.336628624628},{-1.18483319893,-0.691957411782,-0.195193556339,-0.53024923747,-0.414779782115,0.283591364425},{-0.0784710351956,0.177320992645,0.800648383881,-0.721627467514,-0.730225554583,0.164009269887},},
{{-0.71442489295,1.20666981538,-0.113031737711,-0.463208682263,-0.118352514376,-0.607064735587,0.686357127824},{0.628530484112,-0.271546589709,0.627609091016,0.599947373997,0.357568427049,-0.0610030664236,0.111847995614},},
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
