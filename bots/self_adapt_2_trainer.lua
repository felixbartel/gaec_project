W = {{{-6.39144161187,-7.90296261813,0.977846573759,-9.92107874719,4.16036768537,-0.782750760006},{-0.480360550624,0.777512942073,10.0137233136,1.94716789179,0.702157659443,-14.5125477323},{-0.229485985817,-0.0602935653807,0.383521149484,-1.26560264222,0.508723323584,43.345192523},{2.2853278009,-6.75239483753,5.8838228343,-2.20542804323,1.27341245547,-0.489391688928},{2.23721233863,-4.3509768203,0.247467710701,1.79912596985,2.78806530983,0.015044330887},{-1.3945027148,-0.729051531216,1.50463922913,-12.2345830551,6.47783101328,0.784389665598},{-0.925228848318,1.12380155653,-25.4552027528,3.17503373091,-1.60965760253,0.227814115414},},
{{-2.71293015284,4.887762685,-2.63852027383,3.23629359927,0.682351211686,1.24232922949,-8.33337180324},{3.4805602601,-0.548294620226,-5.10817921492,-3.35330328533,-2.45097045002,1.73166818104,18.0945539019},},
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
