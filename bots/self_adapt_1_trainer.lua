W = {{{0.0162467853856,0.265117128116,-0.122006222218,0.33032206818,0.336997504622,0.41782458034},{-0.375587999647,-0.233268606037,-0.41916745073,0.220357662077,-0.534436092162,-0.545420665698},{-0.269077877418,0.364580178131,0.134734126614,-0.235509163151,-0.159863413169,-0.345332367293},{-0.307392066703,-0.013440090888,-0.295483290517,0.486370437887,0.0833078974452,0.535520671704},{0.211757724062,0.0609460178125,0.12767441854,-0.112561740778,-0.28618538852,-0.189307915278},{-0.353453166676,0.310321143773,0.625087132973,-0.139364307792,0.283726870865,-0.44899788397},{-0.123628523492,-0.178081695788,0.702643741726,0.354931560038,0.0379579450576,0.314665547287},},
{{-0.123845801228,-0.309786831334,0.0202757359761,-0.301081751728,-0.389530836741,0.593478217454,0.513512878588},{0.237544154202,0.5675838111,0.632387234437,-0.0464332950785,-0.0779190026235,0.112804011185,0.216953701684},},
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
