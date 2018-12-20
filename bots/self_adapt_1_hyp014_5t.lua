W = {{{0.473142543427,-0.228277838786,-0.0594494307247,0.188516426705,0.295588697322,-0.170975275637},{-0.494970111884,0.223797876974,-0.161573499812,0.248978269865,0.0268343458966,0.284590336349},{0.236875052587,0.173116623394,0.0538173704328,0.361872550876,-0.255519512532,0.172756906999},{0.409847796342,-0.00203494783438,-0.164303966041,0.443425034797,0.240221321504,-0.047805826849},{-0.370942351085,0.164364607948,0.0687370110596,-0.0705345880533,0.304595458214,-0.26187372528},{0.0136828203857,-0.374231525081,0.188762538048,0.430508888763,0.314377364465,0.395567738708},{-0.0613385776011,0.406582574891,0.346596573465,0.093792011145,0.154189459298,-0.22396058312},},
{{-0.0608394609879,0.36295533689,0.0384112616927,-0.255104649914,0.40796828559,-0.0756926806525,-0.331388080007},{0.156568800622,0.202303069162,0.199616209273,0.177596977349,0.158776310618,0.253568704989,-0.143672050993},},
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
