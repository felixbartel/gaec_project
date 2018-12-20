W = {{{0.133976135,0.00375313674694,0.135165877725,-0.456006148225,0.259221125285,-0.399814865356},{-0.417701635051,-0.49963467546,0.0898094835025,-0.388258702751,-0.162553377484,-0.410934901201},{-0.366027721088,-0.385141560044,-0.276238787552,-0.0253292829211,0.439126036977,0.012492049712},{-0.0909526478415,-0.104537599612,0.316171149201,-0.437126771996,0.34990451722,-0.273671115821},{0.239217098746,-0.175245834795,-0.251612646192,0.424362189703,0.311234445142,-0.0726946083516},{-0.429402882001,0.407634373511,0.110388794541,-0.150584910781,0.151418887427,0.483717362153},{0.457941462007,0.445811213387,0.1041137044,0.487195151231,0.499501439111,0.308854782195},},
{{0.401884563117,-0.101505282441,0.282413711285,-0.321422887523,-0.50588541162,0.427181189989,-0.0662887229388},{0.0706402423059,-0.264742013197,-0.366339773633,-0.511092679319,-0.38308734324,0.0774033722192,0.211715645477},},
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
