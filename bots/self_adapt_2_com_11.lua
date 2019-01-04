W = {{{130.911630804,126.457032625,98.5618729539,95.9298070767,9.66917860088,6.36839598364},{69.7469319118,-112.731849035,5.54238140918,-3.80140993944,-23.1090403509,0.480944147778},{-58.318723817,-11.228410495,2.01256331409,77.2121782546,10.1591495808,107.224627002},{-3.40370829562,19.9844979267,-25.2839308392,-51.347362663,-4.57125619946,-35.6717877606},{12.759559227,-8.11082065739,50.4932559976,19.4633639115,-1.62401386446,-57.676667378},{-221.67731801,40.2006388825,-23.959269173,3.82788903161,2.33936533794,-13.0921308964},{117.978477353,-133.893706035,21.2937063168,-264.102514174,-29.195070741,-97.9459277971},},
{{10.5284623378,17.8716941409,-50.3150508636,66.6061416809,-6.17011903978,35.8799045729,27.9692773542},{72.2051351463,-22.7285915673,257.475859372,-26.2191043937,15.1109143184,54.8765555729,-6.57314525854},},
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
