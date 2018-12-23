W = {{{-0.658897774271,0.326695356014,0.577716153707,-0.547234962875,-0.00864347542596,0.260261819443},{0.238747141393,0.589645457695,-0.135235372781,0.157672546904,0.155355589929,0.245981402665},{-0.472151629276,0.202138487057,0.200592637849,0.637061270198,0.0141340109564,-0.394619391667},{0.303350359372,0.506103364312,0.188439596641,-0.0316611228923,0.899725510127,0.179932862836},{0.0177083263153,-0.130739037284,0.235263146078,-0.160522834572,-0.586447178721,-0.162457712488},{0.420526919244,0.251904681665,0.0774686813892,0.355270385636,-0.462319944114,-0.418335608976},{-0.0595405146025,0.318652522745,0.24662063449,0.104611857299,-0.445359873675,-0.556452608442},},
{{0.327107068342,0.316403859066,0.258687370667,0.399261111408,-0.337220533533,-0.401909217975,-0.378874942293},{0.509229169876,-0.587330181884,-0.549625874935,-0.0662731954904,-0.109379302218,0.334034836131,0.190503769275},},
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
