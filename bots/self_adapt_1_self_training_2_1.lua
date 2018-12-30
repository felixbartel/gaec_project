W = {{{-4.29835603301,-3.75997219583,8.92546304433,5.95945890432,7.5496116042,10.2044347324},{-2.3233576582,-4.91904380332,-5.57689222572,2.90028056515,-1.65078362221,7.49344684215},{7.29496441397,2.1650279158,-19.1996390064,-5.16745598271,-4.22751002671,-1.45095510601},{6.99886700935,2.98243577828,1.46612973014,-5.28007614543,6.10389529012,2.76620794548},{-0.863101831246,-1.70782703186,21.2709766325,-5.84398319226,0.619166893802,-2.02821417371},{-8.11352153953,-13.5683753033,3.61260755935,4.30131185493,-1.51249257965,6.55293224015},{-0.340153175342,3.78841572803,-11.0943877881,-2.82736063488,2.73074926723,0.255050674899},},
{{4.28498062721,-5.53987881995,-3.77196292503,4.07750326402,9.36506430194,7.73980179866,-1.8283181766},{-9.77930862145,-2.59307716936,5.40179674791,0.0670137047634,-6.78785429793,-11.748122174,11.679445563},},
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
