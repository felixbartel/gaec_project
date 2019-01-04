W = {{{0.221962838188,-0.0472510231949,-0.0253451395462,0.400772958197,0.214073462298,0.300515418961},{-0.174790805511,-0.0385910111415,-0.311726845351,0.0718140156191,0.0768719081039,-0.335648367192},{-0.0857053802119,-0.203446787665,-0.402261654935,-0.0563391975648,0.00720537494238,-0.00233720882962},{0.397476063671,0.230259273091,-0.397863474809,-0.266771753106,-0.0666369116749,-0.264141573022},{0.276229802541,0.213583015026,-0.409363958909,0.263497346903,-0.195800326214,0.324155320364},{-0.264303905264,-0.106385407558,0.44572487928,-0.321894098312,-0.28993143993,0.257956413322},{-0.451982266139,0.130680659266,0.0815665253214,0.212800426937,-0.23947831592,0.332500821976},},
{{-0.236265062003,0.371262863837,0.183023262348,-0.487432053124,-0.188903412567,0.28026699069,0.183783088953},{0.233374032696,-0.403226253837,-0.188752724512,-0.158668014975,0.467977104634,0.357626099257,-0.197797884853},},
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
