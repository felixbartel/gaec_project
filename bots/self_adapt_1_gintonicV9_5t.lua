W = {{{-0.151488136756,-0.103164608439,0.600943983116,-0.374565303866,0.383707002485,0.436035695161},{0.0889669166932,0.434134227164,-0.501217181664,-0.282890814048,0.050380677833,0.307591410011},{-0.345546054512,-0.198071192515,-0.424336761014,-0.167453201494,0.456880084532,0.444842263876},{0.495774878824,-0.302803693405,0.150915675769,0.511183096866,-0.343448914838,-0.00700091075345},{0.313881480142,0.380186382774,0.464356732017,0.476416484393,-0.517449769868,0.194692298828},{-0.148728358625,0.409288241444,-0.270013994001,-0.0405360837465,-0.38928791908,-0.128413712618},{-0.269366442726,-0.269669668109,0.405812618477,-0.0467174326556,0.398442669991,0.109353584554},},
{{0.126120559794,0.472747974943,-0.340493161851,0.519773713322,-0.221912285562,-0.317653622394,0.346167585959},{0.122781182417,0.481765634016,0.301780703242,0.537291943485,0.553716301266,0.00111290698107,-0.231438556493},},
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
