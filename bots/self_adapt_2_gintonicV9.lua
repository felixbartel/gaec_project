W = {{{-1954.91795433,1865.0038534,-347.457320327,812.727377235,-257.30920971,266.257144474},{474.227488719,-690.913778677,4114.91976868,-235.051820359,2180.01055186,-2311.70417404},{-735.095954645,-205.664446007,-1620.81947434,2432.74494817,-9.1736492923,190.040181157},{713.255773551,5288.85537271,3188.10161907,23.6534669601,554.169578971,1555.43375427},{1904.77765524,529.77253391,-470.406609452,14135.9151508,-699.9609067,-49.8599937282},{-387.039739988,-4206.42123881,6380.40270712,-198.048973423,-830.740577694,-2313.6466831},{310.842905263,917.087331161,1829.61922738,2346.31096555,-1183.28670728,-2906.98312363},},
{{-467.389567485,4353.4517464,-116.376750495,3362.7535105,8152.38532217,-756.711613998,17.3446824652},{-4421.33680673,-723.570263673,3124.49034141,15951.2992127,-2647.85619424,861.314998051,-779.291289258},},
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
