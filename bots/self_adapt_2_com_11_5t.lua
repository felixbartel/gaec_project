W = {{{-444.851069516,-1384.5709859,-769.195596034,-723.906653923,140.59784871,27.3060958665},{-212.457108866,-21030.829887,-30.9596279507,-407.215486005,284.25253674,-574.832351154},{-494.742947144,174.680928092,-455.154037322,-65.7044810703,79.3074479254,-1059.33133681},{310.532959451,-136.713485333,-2151.45091217,-152.84595962,-60.7710023199,-5.49107192533},{118.798787848,81.8334060595,-797.910004584,-67.9161155532,-125.104619954,53.6104673579},{-135.583766607,701.530091171,1484.75426906,375.700481961,-146.345072505,-171.405816345},{143.049028995,-269.379801791,632.953640592,-53.6430423929,14.2537311288,-177.651622947},},
{{310.471136152,-51.0950366139,419.911185376,-1999.99172378,31.7970546868,49.5347645957,-210.502131594},{12.5658166697,64.2558948145,1948.01015474,118.35081695,-112.187254792,-163.161627577,-146.884372339},},
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
