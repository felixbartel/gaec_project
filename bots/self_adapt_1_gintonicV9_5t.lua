W = {{{-14.0410028941,3.83370992431,8.46179408583,9.19335634077,5.16204367681,-5.878035776},{1.61635790299,-4.9762563495,3.22604867564,-27.44578562,-5.43511552955,-1.58547692859},{-5.82360191646,-4.63936537087,11.6999424631,8.64234703209,2.31776482803,-1.28360155082},{9.80900241661,21.2459310311,-1.70594760678,3.83174569627,-5.6112241926,3.66850230796},{-7.84314407554,8.89125885772,1.40276873661,18.4595827748,4.90108490647,4.61557942965},{-0.132048044093,-0.860209215529,-46.661939186,4.47401392814,-1.4624083781,-1.34120988923},{-11.8788448436,13.3032772541,12.7601475472,-8.09162159702,9.38875973419,-6.33409421587},},
{{10.524983671,14.1368297684,16.0614858403,0.524136369393,-9.4764535811,-26.3947356334,11.9977351291},{2.56710486806,3.37877398427,-4.00610174292,9.13155942726,19.2295897752,8.50812369217,-0.0976074263247},},
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
