W = {{{0.490817889504,0.265320782375,-0.262925464718,0.203887897168,-0.035459988413,-0.269157102104},{-0.425648700069,-0.151026445142,-0.354231762228,0.366086724659,-0.10844247959,-0.00285360704471},{0.377289646151,0.227037094552,0.44979641073,-0.229267040781,-0.122370931708,0.14558830483},{-0.191780439195,-0.427468761209,-0.434464961022,0.139932713854,0.295133914835,0.00229502219325},{-0.25087857976,-0.467722735523,0.105013621962,-0.319318778515,0.421093345331,-0.392778996352},{0.233690443956,0.235980198352,0.162122312898,0.312293072038,0.455511030384,-0.298306257398},{0.370387627439,0.237923802112,-0.219266629177,0.00705337960688,-0.412186660004,-0.45770673907},},
{{-0.406094328897,-0.0831546997164,0.220195920998,0.314987350061,0.337015572574,-0.38030567168,0.184030645862},{-0.219427287989,-0.321734474872,0.373627359231,0.23429719293,0.0636195520595,-0.235068016492,0.134243717508},},
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
