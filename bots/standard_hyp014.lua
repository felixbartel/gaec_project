W = {{{-0.020253508835,-0.0994748419374,-0.1434021123,0.0787347971696,-0.323644226817,-0.379928479702},{-0.204965000455,-0.020155571585,0.236191716532,-0.0046842630999,-0.355904970177,-0.15838255177},{-0.153770601313,0.452751394795,-0.0100064766061,0.162920047492,0.241706562024,-0.388581172848},{0.141344428541,0.332394169377,-0.0666237342519,0.446132285251,-0.135158749703,0.280769475089},{-0.295024221449,0.0502913400509,-0.148965041531,-0.323785641916,0.265593801729,-0.339950248503},{0.113237526781,-0.422887242751,-0.342540998702,-0.23340806767,0.422626227172,-0.00735408732937},{0.274681765368,-0.503544547283,-0.0940122923116,-0.033332364986,-0.455075006987,0.0215123717866},},
{{-0.371105051638,0.418988398395,-0.0994533435613,-0.017846816083,0.311601725424,-0.248722227665,0.0289697466216},{0.0899902358425,0.353416477038,-0.204499482461,-0.0558768355137,-0.213314814457,-0.2052765124,0.0474501293931},},
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
