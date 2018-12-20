W = {{{0.00918467598851,0.104212127734,0.171637872135,0.2520860984,-0.367218761113,0.193563788205},{-0.0417258744531,0.228332155508,0.0152318009961,0.0646778429956,0.405185674728,0.302863209371},{-0.243608401132,-0.122304519201,-0.395073690023,0.215724211268,-0.0508017976055,-0.0349260851445},{-0.152808765688,0.361338539154,-0.479638289864,-0.102364536534,0.303329736389,-0.34685241057},{0.0417568891573,0.273491224404,-0.0221526739997,0.213918425692,-0.449248243691,0.089516381013},{0.166183564356,0.35157966697,0.0336281042689,0.232672177994,-0.207181082294,-0.0227482687144},{0.000902254698665,0.278870069647,0.0698881459948,-0.123604860744,-0.291776834457,0.0102842433081},},
{{0.498264340674,-0.353947633192,0.270176202049,-0.483189927381,0.42439270617,-0.478378447373,0.0732256134178},{0.255233617198,0.126242710743,0.398215476437,-0.367196140782,0.496941031294,0.276418205102,0.398683578727},},
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
