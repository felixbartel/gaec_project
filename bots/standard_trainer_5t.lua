W = {{{0.437635260526,0.246399035032,-0.172076559759,-0.177587989792,0.187227496322,0.0816522575436},{-0.106723777512,0.416231534692,0.213810427033,-0.155167646036,0.345444036003,-0.442276225365},{-0.233640387862,0.105163034177,0.393651599918,-0.133534019682,-0.141227880901,-0.160220664525},{0.234410108299,0.1686658585,-0.0879393052287,0.474860073188,-0.226023801486,0.278874498893},{-0.10579764873,0.335348682026,-0.430331195639,0.326427092178,-0.12146933264,-0.105301402338},{-0.430717189231,0.201775347809,0.414188007435,0.211629403744,0.484130661034,-0.317082675804},{-0.361889919046,0.00290712571439,-0.101693043283,-0.201007586097,-0.0322919730926,-0.214670320929},},
{{-0.410045831443,0.340272276651,0.403932230225,-0.239109789237,-0.392986648832,0.282015842498,0.0830922440486},{0.162316055193,0.442568908518,0.398868403322,-0.0583457474338,0.517437530018,0.108401826823,0.128212410023},},
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
