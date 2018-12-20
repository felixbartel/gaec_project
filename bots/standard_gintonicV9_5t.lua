W = {{{-0.165761814487,-0.236510945104,0.266688278236,-0.339166875569,0.0400124350939,-0.475530782149},{0.339031058747,-0.195530634494,-0.023472156254,0.101250859982,-0.509441761354,0.477811795892},{-0.193325375428,-0.140064930155,0.464472597508,0.256799683331,-0.472133292844,0.144460004823},{0.0836026128229,-0.418845383625,-0.222849277295,0.49241704516,0.479228379763,0.199435807135},{-0.0046689458185,0.0563392591735,0.135764297447,0.190949677867,-0.356375008091,-0.0246217172179},{-0.228961969657,0.499681776383,-0.182414228864,-0.0417565596079,0.216300340933,0.298139289572},{-0.35804051644,0.0309304181672,-0.102990977162,-0.137922661271,-0.0503130272766,-0.231985443721},},
{{-0.409766031544,-0.191245626524,0.381184464984,0.0477089155708,0.412613086666,-0.171691912325,0.137569992312},{0.393372497921,0.457778270787,0.146166752952,0.0493653206269,0.43826399019,-0.263138219172,0.382094919004},},
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
