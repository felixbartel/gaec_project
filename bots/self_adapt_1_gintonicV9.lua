W = {{{0.112798173861,0.0782551595359,-0.131003419342,0.171200104971,-0.0543183806074,-0.0608514681584},{0.116273712744,-0.495384429381,0.471314895044,0.239432059843,-0.161595322002,-0.337736398098},{-0.39398612017,-0.21115974706,0.254719879651,0.30352673166,-0.0136190873542,0.434780710044},{-0.37282316773,0.48115439429,-0.344895578813,-0.0397706205439,-0.402844555163,-0.332267004454},{-0.127027371393,0.113342161646,-0.353796235603,-0.210983655493,-0.326885306308,0.392912938988},{0.113433059471,0.00367046499571,0.463925026964,-0.233007741011,0.196776567337,-0.388999142973},{-0.231995202599,-0.225775957872,-0.192776654151,-0.196206307018,-0.2217018795,-0.0511044030762},},
{{0.363568196718,0.475709927733,-0.147196599817,-0.426104507543,-0.302331809009,0.167643553679,-0.170571999016},{-0.429614168813,0.412129219468,0.0381565733843,0.395396815573,-0.12075948343,-0.504338466405,0.40300899564},},
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
