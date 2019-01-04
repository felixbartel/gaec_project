W = {{{0.350782061245,0.0930750379636,0.373114125463,0.140755920367,-0.0105389575799,-0.295958655715},{0.354671633107,0.205715189039,0.320532939655,-0.457696393374,0.0196727388374,0.337010347719},{0.441836021133,0.249664015523,0.443086067672,-0.229961965861,-0.617307511653,0.32456808979},{0.0285941337487,0.170877167259,0.395001497319,-0.293450789298,0.0128883225458,0.0398653281243},{0.154886606505,0.0965982375211,0.170316036722,0.55261300502,0.0149035764828,0.427946315543},{-0.214120045378,0.521319372642,-0.319037597383,-0.138712235365,0.250627699847,0.309333150433},{-0.00837479275893,-0.556885870831,-0.335073301309,0.0846681917249,-0.307927452994,0.31935620019},},
{{0.469899668426,0.139400726513,-0.117028923645,0.114447553472,0.317331523554,-0.182828805026,0.156848667443},{0.12063262277,0.546404255129,0.422695622616,0.00633977624818,0.422100108215,-0.0972964003114,0.127272846921},},
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
