W = {{{-0.239891121384,0.401460222328,0.212509321927,-0.156104047903,-0.46790162037,-0.311980082105},{0.412320275839,0.0609485852091,0.264785262868,-0.0679207543975,0.210094919453,-0.452279905546},{-0.237844875337,0.318760521472,-0.412642451267,-0.445260044316,-0.151355207386,0.187103715882},{0.213389176497,0.303872779054,-0.132244895336,0.292275178279,-0.164374379237,-0.0426141564377},{0.0339499223107,0.0498383568587,0.066062888962,0.272806153035,-0.45783365873,-0.25642003261},{0.386516710705,0.462357957443,0.0165370125254,0.463139531176,-0.0615308013267,0.322662898766},{0.301243850326,-0.295066182417,-0.198856533235,-0.47212827268,-0.295156674836,-0.375353940858},},
{{-0.0463041315477,0.25528534451,0.377352764715,-0.131569067795,0.134211141004,-0.247977284422,-0.322656927404},{0.150175604371,0.122386845136,-0.500228267853,0.42200274502,0.26241203387,0.421965706074,0.48966135699},},
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
