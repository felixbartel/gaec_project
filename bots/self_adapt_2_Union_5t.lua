W = {{{-0.325889412567,-0.0169264478051,0.344223007874,-0.451987067341,-0.276550805791,0.229855591181},{0.087895101365,0.172953067234,-0.0386101745275,0.0110222399749,-0.263640267193,-0.218923325491},{-0.16321022493,-0.218800277511,0.321659014134,-0.477285476567,0.350462300511,-0.211732650635},{0.280292497614,-0.279743201249,-0.106186279287,0.37948402057,-0.426933518684,-0.284130882429},{0.22395823758,-0.0908086228128,-0.452155556361,-0.249973868181,-0.505585268994,0.153197762284},{-0.0942297366707,0.0219416445824,-0.215047990715,0.27920459335,-0.0814754876023,0.412367915695},{0.307126041455,0.0948878246872,0.129617840892,0.0749938208161,-0.00737987798608,-0.465199509556},},
{{-0.342006323761,-0.427942103486,0.0924824532847,0.455033951083,-0.224342081862,-0.492869833482,0.311721345103},{0.175830532216,0.432541638211,0.0771893294719,-0.017623810382,0.378318594547,0.11619779489,0.452937899533},},
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
