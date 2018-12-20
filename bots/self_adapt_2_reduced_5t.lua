W = {{{-0.0958481706943,0.288371749817,-0.0758246738595,-0.0184055161922,-0.0448675040645,-0.268471671561},{-0.218631573741,-0.0557880504999,0.379686790735,0.295445793598,-0.000965951502554,-0.160390320996},{0.34271203107,-0.427477512723,-0.218653138232,-0.208077058915,-0.236816119858,0.17787915731},{0.435502455972,0.252873539774,-0.470126639518,0.138570217239,-0.23518943596,-0.261565902806},{0.245190799436,0.296025740136,0.493297347734,-0.0962124822231,-0.430863243933,0.150297905419},{0.413604089048,0.123552704957,0.179909745852,-0.387162499086,-0.141838715366,-0.312676705985},{0.487253569367,-0.109496177847,0.477163248068,-0.340411921012,-0.251999857272,0.0276665694273},},
{{-0.199783391942,-0.344577749763,0.215355533417,-0.328267539855,0.259784270779,0.152123785696,0.0814206578669},{0.158258035698,0.475010141201,0.0571914700668,0.0199536829795,0.379079717778,0.105423954232,0.499244479899},},
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
