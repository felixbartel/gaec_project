W = {{{-0.311899732455,0.373616067897,0.449680066781,-0.291577279785,-0.0398977638509,0.218478764157},{0.412299446732,0.50564276402,-0.0565566449127,0.461378563148,-0.0309717302479,-0.0541164412524},{-0.103177570706,-0.327885013673,-0.207291790544,0.424606152163,-0.343148923553,0.297095662751},{0.284418900828,0.124149460133,-0.0144778035404,-0.215353448183,-0.202800810821,0.0101745351803},{-0.206378710205,0.263250175238,-0.25754521153,-0.429773782955,-0.131453477325,-0.209815964675},{-0.267781962705,-0.139862593851,0.407426320129,-0.335128291719,-0.399389744244,0.258620032559},{-0.0180486323463,0.142273128583,-0.176085666368,0.462085624497,-0.0253560611939,-0.0457108361314},},
{{-0.0245580670402,-0.224115483492,-0.0362128770151,0.453100406009,-0.318618777573,0.105876694526,0.125160808846},{-0.105181722914,0.489126320333,0.417726518138,0.0783737220687,0.435716695533,0.354618765313,-0.123586080679},},
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
