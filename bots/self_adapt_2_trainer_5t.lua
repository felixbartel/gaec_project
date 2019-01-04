W = {{{4.78072456382,0.647529402575,-3.71937860901,-28.5486906153,-0.25211538775,-1.56793957971},{15.7920058089,-9.83613541669,7.27214110597,-2.60750636203,6.46534757154,49.9536159978},{15.8703107316,2.5164928707,-3.0242885906,-9.18826668261,-2.6232160949,-14.6722147611},{2.00027576873,-1.46029561718,6.63633749835,-11.2307824828,1.33775007334,-0.431586033359},{-1.81041812925,-2.99344374231,49.7889049081,-4.95932846357,3.47024410762,-2.50633785882},{-0.90858655909,-1.7153969824,-7.03812925367,-0.781884493712,4.02457757429,-3.26322672691},{1.55463109688,0.306464250568,-1.97948211465,-14.8178131745,0.972537948322,10.8811027304},},
{{2.0427974622,-8.06955271236,-3.2245084024,-1.69982156543,8.36598254802,-1.37506607555,-1.75909431933},{-9.80858513147,-5.16091645162,5.7255540575,-13.8458375564,-6.47983783015,0.177562928179,-2.7444610471},},
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
