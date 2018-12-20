W = {{{0.457185125671,0.0448585257795,0.247693349508,0.440860440622,-0.255837165678,-0.228377477926},{-0.378685894405,-0.254139300433,0.460994860612,-0.308478521791,0.297596201166,-0.369910765855},{-0.2535127486,0.133769733496,-0.120096868552,-0.283224556114,0.303486870229,-0.358171964657},{-0.457406187376,-0.107806545061,0.218419033107,0.346504446444,0.0556662870416,0.123606092584},{0.308090380242,-0.0760629204736,-0.209760499843,-0.287216650059,-0.0860901593826,-0.334662670142},{0.283006671423,-0.0773810716562,0.135396689962,0.238514037147,0.316486134021,0.26669053076},{0.15739946278,-0.0941264544775,-0.0639054188296,0.231856401688,-0.0576553832363,0.402707766629},},
{{0.143988937975,0.375988043524,0.30928019455,0.294955958758,-0.275414158756,-0.501129192395,-0.264005450288},{-0.243133445485,0.22263617506,-0.189340827219,-0.194887151299,-0.108194204278,0.00722542041932,-0.258887740578},},
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
