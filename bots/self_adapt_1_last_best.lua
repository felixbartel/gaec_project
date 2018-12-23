W = {{{0.00957249315586,-0.361198929847,0.206933784544,0.252945211355,0.20874029323,0.404921060183},{-0.32750561326,-0.475712165779,-0.393906855158,-0.398295087183,0.463963424725,0.38116124488},{0.112754353329,0.0785991026775,0.134882883737,0.432856139232,0.453015738384,-0.271537525428},{-0.123603169771,0.0658742304891,-0.167001931526,0.456175252846,-0.460918419854,0.218028163525},{0.319559611729,-0.140593251897,-0.203809904684,-0.285989397739,-0.0648029677364,-0.338897166769},{-0.544110091016,-0.415963412966,0.263355088202,0.149588909467,0.241167264738,-0.0459609379506},{0.184610819435,0.112814574157,0.0376605053199,-0.0413240415571,0.194266573502,0.292028403088},},
{{-0.119889476513,-0.380880295244,0.112470940199,-0.177473976929,-0.490257497088,0.488374606554,0.462272545342},{0.231265411462,0.339615145474,-0.347541240486,-0.187654809241,-0.489746596229,0.123996595236,0.387776647159},},
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
