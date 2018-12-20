W = {{{-0.277481182461,-0.0377094882241,0.0265593639139,0.00983510257473,0.0553042222884,0.430482877015},{0.428610414472,-0.0467881402787,0.402990789444,0.177207648735,0.159881511321,-0.31504076886},{-0.24144967403,-0.014110223412,0.519483073151,0.387779063609,-0.132814297329,-0.461157804099},{0.34901579035,0.0176915016557,-0.136342204688,0.4318564738,0.274789557361,-0.0427159691817},{-0.330337399349,-0.355807661977,-0.515359324637,-0.243938573237,-0.463329408803,0.112838934691},{-0.164451480434,-0.23131707627,0.410426916662,-0.246088490148,-0.195804003236,-0.0662236573757},{0.0322218493062,0.137262644191,0.0250915846167,-0.127040004857,-0.261775736784,-0.031420201035},},
{{0.301728310403,0.303774875775,-0.225158724233,0.348432697661,-0.464096015214,-0.115741355159,-0.349855183767},{-0.189773309451,0.121701708458,0.263177253306,-0.136928132963,-0.18023019256,0.502998807524,-0.326350070766},},
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
