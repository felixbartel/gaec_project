W = {{{0.06758681409,0.336724602081,-0.0662759903051,0.254034382829,0.284612083233,0.247781322887},{-0.422490370552,-0.367332148091,0.081652492839,-0.484163608113,-0.371432792781,0.408233275401},{0.265955114341,-0.470819007015,0.452925357488,0.144016018543,-0.446669321294,-0.0493287587077},{0.352549508564,0.440258183443,-0.169610249419,0.185252682105,-0.330914471167,-0.203557171193},{-0.44367679591,0.0930893944047,0.273967825222,-0.311226391234,0.163336108108,-0.25975592427},{0.357994285048,-0.446816606887,-0.131985538016,0.308001774915,-0.316854966408,-0.423935205743},{-0.238329115441,0.246276034052,-0.132509405487,-0.209305543442,0.0764504656197,0.0574266571564},},
{{-0.252281777157,-0.1882634185,-0.414034379151,0.425014044077,0.18648645013,0.178437156541,-0.058451466485},{0.148584206075,0.239870807722,0.348847165922,0.371483736494,-0.377023464794,-0.264743184232,0.4531150045},},
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
