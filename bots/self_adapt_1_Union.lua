W = {{{-0.0107459923511,0.190549772521,-0.16263533349,0.166906321474,-0.0976831613292,-0.0431553062971},{-0.110175721967,-0.250376105237,0.351337432461,-0.403636728923,0.356011341148,0.43742803313},{-0.506439562146,-0.500802334036,0.202641324348,0.00275994383846,0.0331226040484,-0.306748975699},{-0.326250732975,-0.0711317119037,-0.259401476398,0.41578072576,0.160709938559,0.44548032725},{0.0227447015533,0.398115710313,0.160642922187,0.156688189242,0.325260780205,0.322437518946},{0.468771553371,-0.49995025771,-0.152474551548,-0.00249832758655,0.403386576738,0.327438947161},{0.328582966951,0.358286546538,0.348297401583,-0.188188412103,-0.317996407878,-0.050722905882},},
{{0.218443130516,0.375869267275,0.276840992707,0.256358425373,-0.283775715029,-0.492079724539,-0.323461968625},{-0.361348860354,-0.367293759354,0.499534510056,-0.181486314074,-0.435679017618,-0.058377948177,0.237607858748},},
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
