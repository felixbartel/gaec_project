W = {{{0.311540475506,-0.320304610142,-0.348540395612,-0.399661171931,0.0678730054758,-0.53754953664},{-0.419425650611,0.387847239573,-0.518919166286,0.261839213521,-0.703760763456,0.161007014222},{0.353848075307,-0.142921164165,-0.688626667308,0.374696849002,-0.285402618531,-0.263965470196},{0.224304396422,-0.209071286902,0.148194684295,-0.290243541968,0.542512400163,0.0693508965251},{0.272120125888,0.260511282137,-0.643771520364,0.200131801592,-0.337015918149,0.467397157511},{0.294860511889,-0.370498937022,0.485848907507,0.0304057792175,-0.333968831235,0.389219509026},{-0.0657806440623,0.0638516574984,0.0903461139207,0.160669385772,0.189749120786,-0.491845314542},},
{{-0.0730828809446,-0.279049078297,-0.0378302904147,0.442924944719,-0.5049945474,0.227205178934,0.386582578721},{0.471676188013,0.38749694466,0.149683774416,0.0631309467013,0.396703293991,-0.329361293598,0.451164222623},},
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
