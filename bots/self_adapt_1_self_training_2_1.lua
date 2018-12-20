W = {{{-0.112337277608,-0.425812325268,-0.265980285535,0.298762711252,0.181177547675,0.194690186564},{-0.495489232605,0.210073933356,-0.164448782781,0.259244517533,0.0336474114192,0.28431993109},{0.140176353106,-0.333336541184,0.142697211499,-0.41225704568,0.395730915752,-0.241301548093},{0.421078548674,-0.00184657811312,-0.159799210787,0.419777826699,0.239003722809,-0.0496879616452},{-0.00233056430559,-0.248061663358,-0.0470041776838,-0.477716045311,0.0033425405046,0.085314150064},{-0.492104446692,0.368885158977,-0.367384989506,-0.120831581774,-0.00552624040577,-0.0289668140395},{0.354248616034,0.274179390927,-0.0550933372435,-0.0172726654079,0.0741142631463,-0.00761136852617},},
{{-0.0686573003995,0.355986609729,0.0208584907834,-0.246788200011,0.401013601227,-0.0675720302223,-0.318980814561},{-0.216840235456,0.261289158304,0.332267603659,-0.173470658091,-0.151082264697,0.446497447086,-0.337587642469},},
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
