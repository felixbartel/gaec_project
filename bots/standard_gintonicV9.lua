W = {{{-0.0395780979227,-0.105243714435,-0.152449210663,0.0949019324745,-0.342232004756,-0.360536667383},{0.330294031758,-0.211538270747,-0.0183017386473,0.061187013899,-0.47779531971,0.470917863496},{0.235481479462,0.367525182316,-0.376065849059,0.180786876198,-0.099980503976,-0.206527496211},{0.320076510973,0.434710141097,0.51443458854,-0.241053634361,-0.293725385331,-0.0118867012258},{-0.120134530558,-0.411940640981,0.0126219080325,-0.379303803527,-0.211018679707,0.10890427588},{-0.0243559463184,-0.479035052428,0.00541234295446,0.0285041452853,0.238723988608,0.372175066779},{-0.377142531537,-0.239277006069,-0.200474556244,-0.238916625455,0.419578015415,0.390859218346},},
{{0.328366334643,-0.0562850566206,-0.494711923961,0.289561322341,0.0588235179479,0.190866153859,0.23315335954},{0.391081663708,0.453044773318,0.13668562772,0.0540301176976,0.420792206235,-0.263138219172,0.386534039665},},
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
