W = {{{-0.516394521941,-90.3202377696,-29.2502661307,-35.6855047277,21.4724161926,24.8296797581},{56.9172838089,-16.577182777,7.30752373533,-201.033989605,-12.6951579018,133.703240286},{11.7284496974,-10.0127634232,-15.803393618,-2.37931220669,1.1445739565,17.553952712},{2.56821472899,2.86633341502,-8.15033514392,-0.54167247447,-17.2217437084,-0.973519512707},{78.3314046552,-32.5402305935,-19.8089713257,-25.8975467812,9.01873942573,3.63965103877},{-33.0851223713,-78.3954435533,55.8534954804,0.185629813896,2.82906811699,-0.438726298499},{36.7565281344,2.54535068907,12.650035719,34.6067553458,-31.9176439872,-0.38259838463},},
{{122.679090103,25.2964725013,-0.455348069003,15.1704373853,-18.5594206933,6.57403890374,1.80523534463},{5.16730297254,-17.1334502184,-20.5091508478,-55.8351211027,-134.860841612,-17.4093892112,-11.8602396663},},
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
