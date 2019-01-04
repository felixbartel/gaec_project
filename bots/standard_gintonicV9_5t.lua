W = {{{0.079957835303,0.260520680891,0.274451736228,0.095058684545,-0.343295746135,0.29388158169},{0.2167271292,0.323513898246,-0.530056413929,0.525979989862,-0.410071949484,0.0515677549477},{0.642647685337,0.462542936999,0.782013249148,-0.289440075177,-0.524260031174,0.486737766782},{0.377637609777,0.53868885744,0.397400242701,-0.164388871871,-0.228493580575,0.000227253402287},{0.512673594579,0.511747130401,0.569832489829,0.52075883393,0.291302573051,0.676011429392},{0.287368693818,0.206108862717,-0.080643351047,0.2860487057,-0.24124382423,-0.131080129129},{0.218660501002,-0.239382019747,-0.122015931794,0.315217799933,-0.774129638067,0.263630238612},},
{{-0.35824393174,0.280245711218,0.525395111994,-0.334756428582,0.425946063989,-0.0350483659429,-0.18911898694},{0.119230568322,-0.0373179313988,0.670961284767,0.274201859578,0.414570745485,0.0606132470173,0.171687236604},},
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
