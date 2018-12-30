W = {{{-2.94680453761,-1.50248974484,-0.0887750719838,2.36414561265,0.838734228876,3.790228155},{-0.770957464571,-1.23606087019,1.92526039833,-4.08373251801,-1.79615126089,-1.69600110316},{0.984101035943,0.177622309077,-0.621805065061,-2.48530700745,0.448308690674,-1.13674239418},{0.108974907067,0.651667673583,-2.79627022212,1.63341527412,0.206256985058,1.2250912507},{-0.427652255101,-0.784200288792,-2.07440655627,-0.191192206639,-2.02738374356,0.313591736928},{0.870947982239,2.01919859234,-6.21882879674,-1.53125250048,-2.46886512569,-0.264877618976},{0.561486308504,2.04435866289,6.07043671761,-0.175935703866,0.0289701150278,1.68118005173},},
{{0.271868049935,2.35812565124,0.666053819003,-1.06370098704,-0.760918684125,-3.89136930119,3.68066690306},{-1.93466696987,-2.36290259049,2.20067456602,1.2738247665,0.786331877318,2.23750353219,-1.64152006853},},
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
