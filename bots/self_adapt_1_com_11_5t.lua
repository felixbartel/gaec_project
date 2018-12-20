W = {{{-0.134068197132,-0.374650930401,0.156972947333,0.244279574526,0.191088049361,0.418668665364},{-0.492021528222,-0.226275598281,0.288698119814,0.304017566889,-0.318019595492,-0.505346333348},{0.11864750992,0.0250009190131,0.52078088537,-0.0292461941973,-0.65165426955,-0.502892383362},{0.312240384672,0.443056153545,0.0134352159362,-0.300927075771,0.245491082623,-0.302654919439},{0.305328653078,-0.116445785402,-0.214544177442,-0.395488318083,-0.223764312714,-0.256578872107},{0.109680612409,-0.384877147836,-0.104050322253,-0.171655593403,0.412690948442,-0.347373781627},{-0.089301462271,0.355091861024,0.18443686784,0.527763252088,-0.325011402516,0.3736482258},},
{{-0.0424466936475,0.360973830351,0.0364919981471,-0.249990557354,0.388549924241,-0.0945293357539,-0.328335908676},{0.143316832812,0.433261225367,0.269008998781,0.554953062268,0.567338637915,-0.112244115219,-0.106470531865},},
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
