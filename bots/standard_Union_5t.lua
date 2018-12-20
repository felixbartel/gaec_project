W = {{{0.194583605701,-0.0772164992418,0.193611172597,0.0281335342206,0.0359124349156,-0.114270841279},{0.46263461849,0.301381562364,0.329631340521,-0.375628148576,0.0066275225899,-0.133099059598},{-0.104722973764,-0.425812325268,-0.259092016196,0.298762711252,0.178836779212,0.24214274681},{-0.33072276613,-0.46533522886,-0.400042035337,-0.403636934686,0.454812951082,0.402415572787},{-0.229847132645,0.498914986709,0.083754990368,-0.127444966176,-0.0334557085249,-0.244094977101},{-0.233959771067,0.293814108035,0.0308608380533,0.0373780029764,0.114694496566,-0.189589641287},{-0.451524611324,0.0646773203689,0.101622924176,0.229564782934,-0.232364106236,0.292167430092},},
{{0.104677711371,-0.475833325614,-0.397473890805,0.127828504472,0.169396630703,0.389312728385,0.128288031213},{-0.120848183471,0.449464645529,0.425027711034,0.0855393868482,0.456834304421,0.36962928692,-0.116362102006},},
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
