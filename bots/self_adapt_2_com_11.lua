W = {{{0.297564121032,0.188857134816,-0.315246748021,0.0624724600042,-0.465954546504,0.0843234565403},{-0.421830520444,-0.396292737724,-0.25632997055,-0.0990169987018,-0.412983707018,-0.102302179423},{0.0640545890606,0.296765045335,-0.110958353134,0.109741261509,-0.161568906445,0.471085528983},{-0.0544940928811,-0.229530780312,0.250256466457,-0.307604699047,-0.469602541958,0.213750115975},{-0.393380087635,0.418877167158,-0.406843774893,-0.252616664357,0.26948450277,-0.25604552515},{0.144588526841,-0.273088478704,0.379178510746,0.141441616747,-0.175965970161,-0.29625481732},{0.313583311181,0.156055981543,0.339969732219,0.194319607014,-0.00330204172865,-0.498343701354},},
{{-0.0374249930513,-0.406812816368,-0.0560918093524,0.129498990113,0.00671487204278,0.444984179396,-0.163594380367},{-0.381616676792,-0.294435794964,-0.206473339232,0.471716850115,0.423884264807,-0.148501624178,0.171073630654},},
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
