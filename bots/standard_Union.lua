W = {{{-0.0826695159221,-0.120693609031,0.516085742116,-0.504125247249,-0.312282331513,0.287668027213},{0.47467624144,0.265176031214,0.322716602766,-0.361401462951,0.0351422200037,-0.132917144685},{0.232632426103,-0.0312608162757,-0.334250748181,0.0900979952423,0.12967549513,0.181971105031},{-0.336017722413,-0.482811187301,-0.402778012189,-0.40946010232,0.451905274629,0.393951263471},{-0.276302692623,0.472178097214,0.0702987797914,-0.160419076239,-0.0357928853899,-0.227790051322},{-0.232853575897,0.272063888764,0.042749537583,0.0265639417555,0.138067783481,-0.174155497812},{-0.381274130444,-0.249372709769,0.380454160159,0.440286872867,0.432323611008,-0.197118422994},},
{{0.119759999687,-0.458854398652,-0.398787299789,0.0906031740128,0.177252518624,0.382866284765,0.0914188458674},{-0.140939817554,0.452007157196,0.412820168468,0.0726509864381,0.433367704937,0.380013779927,-0.11096936487},},
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
