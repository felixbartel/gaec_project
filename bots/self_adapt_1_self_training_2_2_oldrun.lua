W = {{{-0.758606406812,-0.146396920716,-0.908378829888,-1.10725705117,0.865014739376,0.847699003301},{0.0846319089867,-1.38997391386,1.48298605237,-2.95538552838,-1.36757056126,-1.43693917007},{-1.50699929123,0.667854880773,3.57330437861,-0.182655284433,2.03193607784,0.0753642651806},{0.670822040631,-0.113719692912,-0.674910165325,0.346809986276,-0.117913056896,1.23340336532},{-1.62067451293,-0.435909826811,-2.64131447572,0.135098927092,-0.464487416239,-0.186391154566},{-0.14186171774,-0.181793537387,-3.26819344033,-0.812409906464,0.402308599982,-0.414628327312},{-0.0377350514392,0.188592352518,-1.10319376271,-1.43609775263,-1.35778035451,-0.540113598295},},
{{0.595986869703,1.87411825081,1.57745707187,-0.203187113311,-1.38111176262,-1.20794444194,-0.663111073396},{1.5513368704,0.787446014659,0.00818827559623,-1.64851741582,1.03689040672,1.82279178707,2.67785048879},},
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
