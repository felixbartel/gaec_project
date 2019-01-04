W = {{{0.205764590138,-0.159139625134,0.231582299148,0.0748587746722,0.0815847997345,-0.12037527589},{0.365976798738,0.509555843349,-0.00245128632974,0.425061392374,-0.0491780655594,-0.0618110553166},{-0.337338744472,0.517178684536,0.423413203803,-0.0123022729042,0.060089111479,-0.434813084481},{0.435029582053,-0.299557086211,0.0518893627307,0.382573338202,-0.339467240872,0.0371994847213},{-0.235369157029,0.472782520251,0.0476671327842,-0.125641057322,0.0167414280779,-0.225347381296},{-0.233405825939,0.205296415426,-0.11134912915,0.538513549275,-0.452871602946,-0.501797652845},{0.357120968433,0.288876718981,0.474233190064,-0.494268386282,-0.422969908991,-0.569579126627},},
{{0.202930599276,0.39783993002,-0.370109085581,-0.296887359329,0.13595447244,-0.374509364443,-0.244428630363},{-0.0451699758601,0.450252390549,0.394076977042,0.0841554934321,0.399024387722,0.336830220056,-0.119877645042},},
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
