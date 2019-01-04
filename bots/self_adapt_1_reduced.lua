W = {{{-6.70626600393e+14,9.57886847573e+13,-1.7719398454e+14,-9.53591563866e+13,1.49565942073e+14,-7.80480937667e+13},{2.02720027955e+14,-1.8881776712e+14,2.18915921588e+13,2.22754953406e+14,-1.52793993511e+14,3.2884397054e+14},{-8.23995271683e+13,-3.30099162484e+14,-5.8732394122e+14,7.83984890187e+13,-3.92844408113e+14,1.60227287504e+14},{-6.33372587895e+14,3.70862468685e+14,-1.26654376249e+13,2.24638714939e+14,2.63136746508e+14,7.5965866074e+14},{5.47647524121e+13,9.3981986453e+13,3.20735154996e+14,-8.80197029975e+13,1.77310621603e+14,-3.69853264965e+14},{5.68036732586e+13,1.06528033251e+14,6.17635736174e+13,2.86653628909e+14,-2.00332776542e+14,-1.78838449927e+14},{3.32298819024e+14,-3.11571144409e+14,3.09302757616e+13,5.22448251181e+13,3.31145775595e+13,-6.75166060294e+14},},
{{-1.13500619807e+14,4.99340203562e+14,-7.31835903467e+14,2.09429359289e+14,1.6990089444e+14,-4.55491800626e+14,1.02097735491e+14},{7.40893642444e+14,2.51497631065e+14,3.00326664712e+14,-1.38429526525e+14,1.43233745626e+14,2.13929318463e+13,2.98201297331e+14},},
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
