W = {{{-0.138400264221,0.077861974772,-0.239649154784,0.00467519837796,-0.155597617144,0.242576438238},{0.428194452645,0.0365346524197,0.270226621377,-0.0123189498949,0.213959520603,-0.431531328561},{0.254913720091,0.442411840695,-0.453214395231,-0.0201639128564,-0.132230300259,0.17385840307},{0.402754101583,-0.439965075349,0.222443160054,0.356769111602,-0.00361821878383,0.319186102978},{0.00220352371015,0.451838089652,-0.347220241722,-0.0790559628943,-0.188774609552,-0.0689766653495},{-0.258703588541,0.290067464271,0.0604804551834,0.064629889325,0.164654364316,-0.208646293798},{-0.456708769085,0.0272390111077,-0.0243306640418,0.140950372864,0.359417964957,-0.461392280448},},
{{0.0235098365665,0.446929087158,-0.268937503729,-0.408143360382,-0.192625888544,0.171103301989,0.229940937519},{0.163008635921,0.461767003037,0.0729532520054,0.00567522815946,0.396484179082,0.146039098743,0.486340094636},},
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
