W = {{{-0.413974069971,0.258542534156,0.366983757902,-0.300028453123,-0.318070652286,0.459932841285},{0.136199534058,0.205016589852,-0.317194957358,-0.409784993692,0.336547844594,0.455477959147},{0.0903310775349,0.196634222467,0.146639149624,-0.0501202626686,0.0869336559723,0.437745673339},{-0.23602489283,0.463160630447,0.0932536464374,-0.347143732202,-0.347154060239,-0.332833452883},{-0.507055843678,-0.189640300932,-0.201642928173,0.0753044524847,0.0189769936563,0.181350518062},{-0.409920911529,0.00314026753988,-0.0380660227363,0.178234872625,-0.225969111719,-0.166672031525},{-0.496883292675,0.181673883914,0.459517072514,0.423740809432,0.297326974339,0.206399776616},},
{{-0.0555725793304,0.367874985624,-0.149660952744,-0.284485028539,0.243173140938,0.0564420860528,-0.0160838148837},{-0.414765114983,-0.274487573202,-0.224781878221,0.470298960731,0.392588182722,-0.156002409817,0.114190329858},},
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
