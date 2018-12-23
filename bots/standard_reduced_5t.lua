W = {{{-0.0654535052602,-0.210485983335,0.20978563059,-0.274140890987,0.46981788094,0.332468527823},{0.203414553855,0.498326725298,0.066583891244,-0.240804577745,0.167048076275,0.148358908134},{0.288824244995,-0.440133766378,-0.394018718089,0.106199792792,-0.426820199069,-0.412485266612},{0.319035660352,-0.486220104523,0.225823537396,0.327593805611,0.405818016348,0.301363795747},{-0.291219471182,0.496992797105,-0.0482008807055,-0.111414373585,-0.425625920129,0.0507885820109},{-0.12378539451,0.483741883357,-0.0850718163029,-0.051245929525,-0.389506960883,-0.431687169846},{-0.444995009521,-0.233638925681,0.416131025995,-0.0608271075064,0.357065650063,0.34119690623},},
{{-0.543631147336,-0.137302166734,0.10856984643,-0.232637794541,0.320746234165,0.211336251549,-0.0397033666173},{-0.149304738404,0.445506918941,0.413856265096,0.0540956811064,0.461018160635,0.28505364941,0.0078334230705},},
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
