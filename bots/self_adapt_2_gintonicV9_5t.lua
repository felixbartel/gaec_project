W = {{{-1907.08851233,-2595.13850666,-1021.86662473,33370.9010011,880.288601715,-7909.44028263},{-4443.58854714,869.066146154,1836.44660869,6989.09180067,6661.25565394,-45.1746625914},{-2691.46691468,-2217.3136136,1437.4828261,342.674020249,-1461.96460194,-564.041494744},{573.348108408,-839.487290057,18492.2324602,192.009250974,490.285130763,287.171971692},{-12094.2378296,508.287636314,-3182.02561499,-13979.5459626,-1983.29570536,4220.79940039},{-1993.54103329,-1861.82524358,176.564199056,-17377.6637284,-761.013960412,1686.53566029},{11475.283006,-1451.6924552,1371.34429096,14163.2427409,880.420424528,2154.81222579},},
{{-7374.88727693,-4002.9367057,-15913.2919002,16201.5317663,-3653.82039681,-1667.6070917,3786.50498853},{-2974.53388793,478.187615386,-2420.39048976,13534.9793592,-1549.67560927,206.125115072,-34.4095921566},},
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
