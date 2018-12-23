W = {{{-0.340352827015,0.410185567528,0.409950731869,-0.315560393084,-0.0616976558892,0.228898259686},{0.445939195626,0.220967763083,0.320460558967,-0.318620007857,0.0286520043702,-0.162792332921},{-0.101233033087,-0.431858997083,-0.286709093354,0.301179704504,0.157539579982,0.192901789055},{-0.326606325658,-0.534369749023,-0.373703572327,-0.467684962298,0.453361005304,0.413599066452},{-0.265130239242,0.430137561504,0.125096762857,-0.125426230129,-0.0611088539468,-0.314642536806},{-0.29013490069,0.21830776944,0.30909649111,0.191273151148,0.450143251025,-0.236235012834},{-0.583362125454,0.504143565718,-0.43285108573,-0.129544926779,0.067049770782,0.418914657121},},
{{0.0898190932103,-0.499744659757,-0.418228888566,0.0961009808207,0.206017119608,0.410553833581,0.10496325227},{-0.160733735597,0.435236530552,0.428848525896,0.0923603238452,0.510907787657,0.446271339278,-0.159250059398},},
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
