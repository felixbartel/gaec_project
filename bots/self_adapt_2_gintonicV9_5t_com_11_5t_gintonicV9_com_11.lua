W = {{{96.4719766137,17.0416624132,79.8930770095,-494.542318569,-1188.14233555,-21.992676186},{153.006357593,20.7986850603,173.409874588,-0.990053533479,-72.9891644475,180.893761928},{-55.9325177133,-454.430149602,5.66219685349,80.2977473498,-69.6144869297,212.717401104},{-102.650535346,12.674234664,89.1816108321,-3.49026078994,45.2040596336,-87.3705210581},{-254.032595906,-82.1307940933,354.634406803,-383.543608591,-52.4652690764,-76.8415749015},{94.6488935923,334.650849584,88.0905758676,45.3519054072,518.948182186,138.098202319},{-1359.1046905,66.7589173777,-84.0149145009,311.954994211,-9.30497528034,-25.1804776922},},
{{-40.6317558088,1316.40000609,-274.487772454,16.9265291621,19.3683118511,-261.365047577,-389.175797861},{375.573226051,307.630689156,331.981476672,244.336647475,259.239310348,-935.794382519,118.78987684},},
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
