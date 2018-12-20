W = {{{0.130135485653,0.346435659059,-0.0244362719788,0.179059333253,-0.211426610566,0.326389840494},{-0.0139943855236,-0.263968662179,0.0030438326196,0.110601501613,-0.177483211294,-0.404756540721},{-0.0466080451853,0.0774197705022,0.515448511066,0.0798785878454,0.089033305862,0.00839998980988},{0.0341295733538,-0.251897630483,0.11207532759,0.436083926123,0.309794825334,-0.394362857331},{0.305973793285,-0.525190668546,-0.383933265528,-0.382513661577,-0.242617328626,-0.0707614842194},{-0.0279481588459,0.0359870873268,0.00328088066876,0.270997817483,-0.0876092789023,0.485688367266},{0.0309106016124,0.501433052097,-0.341936971533,0.298521070993,0.40888744592,-0.488008437248},},
{{0.340595330594,0.0861033894966,0.261749671959,0.386579717196,0.432096555411,0.123671022991,0.183093302389},{0.473475501595,-0.362117000813,0.331315481575,-0.178507282576,0.425908857493,0.415855835697,0.495261066553},},
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
