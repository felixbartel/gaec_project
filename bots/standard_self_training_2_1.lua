W = {{{-0.502787559048,0.0474898315204,-0.417788425592,-0.277149108901,0.227600837172,0.446507447165},{0.186324963461,0.105274998248,-0.0799018000418,0.620582178356,0.136708707933,0.0838998865764},{0.586547288553,-0.209031837611,0.339152957784,0.539249484949,0.158021623272,0.388143729912},{-0.377294071954,-0.189745790158,-0.527732702465,-0.314503493185,0.386878682737,-0.144789337849},{-0.264131813566,-0.103671918016,0.603046163138,-0.875912889877,-0.382693129817,-0.258343207548},{-0.426514141883,0.0751949110879,-0.325638246676,-0.989284680426,0.36729136804,-0.440623541339},{0.0554543589154,0.0952615260431,0.319622419232,-0.46960119954,-0.743089589007,-0.596763625641},},
{{0.42406621975,-0.398312539536,-0.574443700034,-0.151167941065,0.306804940101,0.528796883799,0.0421684982914},{-0.209784117546,-0.196214216878,-0.480618946701,0.691841552008,0.301327276624,-0.322106846496,0.101249737231},},
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
