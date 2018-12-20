W = {{{0.202130808582,0.316954253893,0.230151756274,-0.394068938313,-0.219725143372,0.107233780526},{-0.0817637243486,0.00818694232991,-0.227174796251,-0.00883083100094,-0.381450680573,0.486395622824},{-0.157124761874,0.462652822932,-0.0137665268691,0.153187315607,0.22584321806,-0.381333188317},{-0.153685887814,-0.0967849626265,-0.242551029216,-0.338855202882,-0.0884820422564,-0.173517709125},{0.332392294808,0.0320130975899,-0.335679060078,-0.154859965392,0.0346325689214,-0.411172172297},{-0.0486083372799,0.30499998531,0.178755908578,-0.327254447628,-0.112334304312,0.213235869214},{-0.499837327005,0.459510352414,0.311691446741,0.16442628739,0.311417621363,0.332497235315},},
{{-0.0335079967056,-0.235379142556,-0.0526772065671,0.443012403725,-0.348345458951,0.125488052375,0.133934852481},{-0.321235995392,0.00772212660756,0.427126420694,-0.347057151093,0.259426945279,-0.262323482551,0.0995795234029},},
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
