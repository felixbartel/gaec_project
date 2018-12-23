W = {{{0.325519005192,-1.04964472041,0.180241241748,-1.34296301481,-0.916084625001,1.73465574182},{0.620019530931,-0.818299067957,-1.5649513861,0.481102655776,-0.220757084486,2.43903356532},{0.947011560349,0.629750986873,0.897704506616,-1.19881277572,0.866571291379,-0.727068667964},{0.862187922621,-0.921923336209,0.0687141290794,-0.859297846597,0.931259018159,-0.0720102690448},{-0.761912852185,-0.737502774755,-1.60066761404,0.764719559202,0.47840310325,-0.687243460495},{-2.77512996126,-0.13229931702,1.95807862346,1.5692898545,0.387692320657,1.38167518807},{0.0478673545446,-0.17677136231,2.13996623019,-0.385279298278,0.356553265021,-0.212765773048},},
{{-0.309305427412,-1.54527589826,0.0154198654862,-0.351974507338,-0.956859540113,1.89597340647,1.14954595123},{0.218333412361,-0.369853548477,0.807619734962,0.803550611649,-0.430971543766,-0.318573550871,1.40354022761},},
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
