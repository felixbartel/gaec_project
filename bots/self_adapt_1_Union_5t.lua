W = {{{0.288335874764,-0.308683325296,-0.0540231967326,0.151633806653,0.223000813603,0.476107976753},{0.381179754012,-0.0184506508637,-0.232247868668,-0.367579690921,0.254204505289,0.134342218024},{0.123599728192,-0.245563178436,-0.104846274682,-0.0633277930326,0.147013868634,-0.338391076158},{0.478372744713,0.378630806683,0.410666010617,-0.371087600284,0.181949544135,-0.280802267348},{0.0384711613397,-0.356392705799,-0.0570334322076,-0.233045788059,-0.170502774622,-0.00863524574481},{-0.314142450561,-0.248327138684,0.0557757427807,-0.141651762745,0.15519824509,-0.368218866453},{0.241826678643,-0.128584849511,0.0160214612776,-0.542938673519,-0.183695117923,0.223232750119},},
{{0.328404151734,-0.247490974046,0.23190985915,-0.215488578084,-0.472252947097,0.500107768031,-0.0974887639172},{0.135073936373,0.402998607187,0.33009688053,0.54639107368,0.489069595579,0.0189210341109,-0.204166388818},},
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
