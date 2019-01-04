W = {{{0.148426951478,-0.0896733054361,0.37491267778,-0.375412511799,0.0883960928014,0.250418071906},{-0.57433110075,0.209666989361,-0.201191859457,0.242489411163,0.0847519702479,0.247738947055},{-0.259653251539,-0.00243686845953,0.478715000376,0.49450771662,0.0399802215603,-0.522744964908},{0.445697519302,-0.0338491588011,-0.179242939599,0.389097173777,0.264016376735,-0.0197148054461},{-0.0517961691322,-0.0490162042787,-0.0145734048864,-0.21690657205,0.368075302247,-0.059405581798},{-0.106182336402,0.468497134866,-0.227462092047,-0.137184685397,-0.294109257422,-0.148578323861},{0.405655921008,0.269653834527,-0.019138367701,-0.0427593742198,0.072876816202,0.0449335252444},},
{{-0.0820750199396,0.381032488586,0.0415224124526,-0.306752901449,0.407476878973,-0.0671917424597,-0.303837442505},{-0.302069035753,0.189527598433,0.138745248275,-0.322894737282,-0.170473750691,0.120680583178,-0.312861530361},},
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
