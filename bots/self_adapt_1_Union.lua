W = {{{-0.380019879519,1.06141179106,-0.308693913021,0.332749179445,0.638712037982,-1.2738090735},{0.180626144276,-0.286587186556,0.429526167172,-0.413482721115,0.0150743302423,0.200679612451},{-0.258886401085,0.0191269108257,0.330067664616,-0.0630349315793,0.245985998038,0.140898665404},{0.282245155837,-0.0293196529094,-0.714295104367,-0.0688641269472,0.0428992646034,-0.538802507138},{-0.0101967861546,-0.0524508388728,-0.714654416822,-0.0543926987666,-0.557762914883,0.281329613073},{-0.823788172241,0.278617931593,-0.663876799356,-0.835909356939,0.513951781549,0.590786103937},{0.0877861444289,-0.896279158731,0.205463611508,-0.291904809095,0.102723360593,-0.439885795842},},
{{0.132847063295,-0.262614398017,0.845727938346,0.662938248515,-1.21299498905,0.39863089883,-0.51077851364},{1.04575289957,0.0922693865312,-0.0617475294224,0.510730103586,0.695193485167,-0.711432773543,-0.164371488036},},
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
