W = {{{0.472423557781,0.127730908075,0.334812714082,-0.0507400732362,-0.0361464566683,-0.122682464897},{-0.350909078267,-0.43183988208,-0.0425199304686,-0.451738851511,0.33681865703,0.0163064744693},{-0.182066533659,-0.218885812677,0.474956635284,0.391576680626,-0.217599578708,0.339187106418},{0.345562386532,-0.24812183186,0.359035017643,-0.30202830655,-0.482595959962,0.296677775612},{0.291622663662,-0.189799686023,0.348713236324,-0.165223447984,0.326978539675,0.209833301696},{0.115721938418,-0.0776716013203,0.0916138681354,0.0366616269884,0.165994509503,0.475523559889},{-0.124743027043,0.455319174378,0.353083165239,0.46870088616,-0.113589045587,-0.183668415437},},
{{0.159461130559,0.386337050572,0.300123163932,0.286417752714,-0.286786057108,-0.466380211603,-0.296252620845},{-0.437689133882,-0.357895139382,-0.188879184871,-0.459835296484,-0.128393280914,0.0709958902928,0.281562614239},},
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
