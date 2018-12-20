W = {{{-0.0204352229008,-0.388426300856,-0.291728516372,0.450492037888,-0.175240690448,0.401749906817},{0.00103713073279,0.00750181587158,-0.216977991951,-0.45853052831,-0.435476269038,-0.441048321466},{-0.277498497789,0.410558284227,0.261539115427,-0.325042572573,-0.0228172902693,-0.474605814724},{-0.173522256969,0.365107721553,0.396226200802,-0.158170220155,0.332429120987,0.0492836020406},{0.479457305197,0.317226622749,0.335245741776,0.445895914703,0.182434462683,0.395896707611},{-0.448389065157,-0.141182644746,0.309005951356,-0.0767371385323,0.0784188522101,0.226815042762},{-0.499731085859,-0.332396328146,0.189451659625,0.352416368717,0.0527340787657,0.476052991116},},
{{-0.318754472094,0.482589489696,0.348111084793,0.19324149641,-0.135890426539,-0.412207830539,-0.205316189781},{-0.0922187960526,-0.381877401803,-0.0868100686056,-0.391882476415,-0.211935808851,-0.051267504234,-0.309658065217},},
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
