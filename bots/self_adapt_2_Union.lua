W = {{{-0.378347860863,0.110325099705,0.449015559629,-0.165169735336,-0.202569495304,-0.383314554066},{0.218242626599,-0.441587087616,0.0619815993906,-0.0480304743011,0.0593939072344,0.215536857064},{-0.0238161164697,0.102313006351,-0.139737377939,-0.236578588142,-7.67155878068e-06,-0.59584701246},{0.260009833046,0.00881319117228,0.0780619704925,-0.273709105088,0.470213678094,-0.0549198531392},{-0.516899802475,-0.225481278487,0.407138500849,-0.522466398574,-0.123958953328,-0.307934343774},{0.424056569712,-0.492181841353,0.427430113502,-0.342879726354,-0.111330355929,0.350781944837},{-0.513697784444,0.0101694231018,-0.337936388419,0.474339149998,0.193679732873,-0.0337378991522},},
{{-0.102058037858,0.10121006898,-0.142094514779,-0.292201415232,0.415504314788,-0.00648984796506,0.0834221619184},{-0.37079009175,-0.208523611406,0.329604197443,0.37929130863,0.141754863743,-0.420656166623,0.473120666412},},
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
