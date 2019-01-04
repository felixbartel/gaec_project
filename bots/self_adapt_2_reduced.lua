W = {{{183.931911525,0.662626796572,4.54986898313,-10.8732938256,-53.0558261586,-56.5109503697},{11.0732758192,-98.7104067264,-68.296328473,-4.2534120282,18.8827058813,11.6309030738},{166.432223197,5.81700378757,36.6698453248,9.50023945021,-42.1277574593,3.26005254937},{-329.680590082,-129.858395202,708.60049981,287.136883128,4.992496369,-31.6283779715},{-144.851826985,-55.2620955488,-3.09767770553,52.9534067821,5.20690882248,-177.181653087},{43.4568937669,123.717677914,-11.1828775533,6.71400346848,-20.2183862584,27.9097025905},{-24.262029623,52.4420208276,4.18799217902,7.43250958735,-39.0136207461,-79.9843100643},},
{{-12.0782948867,1.87395646844,7.42986882421,246.418924913,-23.1429648167,-37.188034267,1.36588003381},{30.9871238872,3.61052217275,89.8395651888,117.473443773,29.1610932946,21.5307845117,20.8160477204},},
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
