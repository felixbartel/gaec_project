W = {{{0.520241484764,0.15314402984,-0.178996549094,-0.148842018289,0.161012835935,0.2337431244},{0.0212485504306,0.02799144014,-0.141598642655,-0.579184454318,-0.426444663426,-0.398411059537},{-0.449504221045,-0.320630163814,0.526808898252,-0.167864178382,0.373090282534,0.0341227674397},{0.143250726039,-0.359921611833,0.17476561947,-0.345053118091,0.433537028832,-0.276062209218},{0.330767876222,0.0555058636777,-0.289454929526,-0.180414990054,0.0860194208766,-0.401990935724},{-0.552490228363,0.00104899434789,0.156992699535,-0.292344934586,0.44312154282,-0.389716523812},{-0.466947086127,0.462094549863,-0.445156741218,-0.111869032072,0.0334176775823,0.390804176158},},
{{-0.370295050744,0.330183232102,0.418992573811,-0.264882677782,-0.446900034576,0.291841276577,0.173503449455},{0.290183975186,0.0794682846921,0.274607050315,-0.00774521482711,-0.321405379234,-0.296352951249,0.527169771947},},
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
