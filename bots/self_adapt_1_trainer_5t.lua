W = {{{0.0714948980938,0.320943738093,-0.0180484199732,-0.113979909366,0.255968570982,-0.174963867619},{-0.148065346971,0.350314687937,0.0319110656011,0.441603300057,0.0335254800099,0.451465554402},{-0.407336832583,-0.504050860311,-0.176725163396,-0.0546060120789,0.127278950144,0.494120318662},{-0.21390047881,0.370105498256,0.236618382449,-0.445635396903,0.175242526968,-0.41060631723},{0.322288643885,0.418202701069,-0.318747578749,-0.267524275036,0.582429817433,0.0813994656098},{-0.0889268854821,-0.217406486968,0.346528685463,-0.305762704459,-0.182997617461,-0.121619312111},{0.0597450855592,0.103988384163,0.0503837818832,-0.0965447012789,-0.216270423842,0.0961213122055},},
{{0.159461130559,0.36332171925,0.262235004754,0.288783539694,-0.35810179087,-0.426052701008,-0.316227158513},{-0.221295039142,0.323450640669,0.0112498868946,-0.124292779511,0.237299526196,-0.238736432961,-0.266752063217},},
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
