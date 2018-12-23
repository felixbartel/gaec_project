W = {{{-45.018739346,-4.17159902196,6.85013125997,-50.96164061,-2.23055398068,1.63701534954},{-0.521446211824,3.05034880633,-99.6301066745,24.6406680803,-5.39656259262,6.05582994126},{30.0365421322,0.837914294273,-1.51712737171,0.0140533398468,8.18260882118,19.4659222374},{14.09187662,0.745287206109,43.6460601916,-26.1719242141,-0.981312203302,-0.393472498671},{50.0716898361,5.42076246694,12.7909079639,2.28457596383,14.6549215026,9.36034603049},{5.81341953172,-8.29916402308,46.4535635532,-8.19837589153,1.61607833162,3.3102110159},{-21.6849329837,22.8076464931,-18.7259074541,-2.08148513403,-0.624479861002,-59.0302496713},},
{{5.49148088467,-14.9462836297,-33.7733428996,-0.540290103337,-1.389714546,10.63802284,11.1112162916},{2.21791980989,6.34784367068,-13.7517143013,-1.80717129561,-0.779350387638,-17.0889377392,2.07083290026},},
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
