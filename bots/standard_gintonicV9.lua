W = {{{-0.0642450603419,0.195818128299,0.0238399381652,-0.59515502597,-0.138677685729,-0.18929313417},{-0.257510542081,-0.183679243362,0.0603898672837,0.542364717761,-0.675509894668,-0.307593262376},{0.366728788489,-0.066293992998,0.699158779822,0.165351678942,-0.112485600887,0.341913945785},{0.537281789782,-0.180232954366,0.084989619401,0.223064927173,0.0519351997357,-0.454661789718},{0.355038917961,0.424027570786,0.676440766706,0.756060416689,0.206739876013,0.476416692864},{0.22732840615,-0.422857622365,0.394714152457,0.26059153264,0.0434782975291,0.512997726291},{-0.363784020962,-0.096055803487,-0.334201998282,0.559509939811,-0.187204946944,0.0960069114364},},
{{0.395423621716,0.28733455325,-0.354824501437,0.281655588121,0.201590047,-0.391256495919,0.388971772979},{-0.0514379302378,0.703587288938,0.483955739085,0.0954249172198,0.632663181358,0.0963945929663,0.291917871163},},
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
