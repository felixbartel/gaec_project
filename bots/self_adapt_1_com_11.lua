W = {{{-4.4528331546,3.11622031466,-2.44912899592,-1.6007650609,-9.04918705042,6.6839231304},{4.21457704918,9.43782554649,-1.01334211735,-0.136013682307,-9.26270681679,9.64772209929},{-4.12866397567,-4.25602262765,5.89677278487,-10.0203892346,-0.526633257423,6.82549225622},{-9.2014763574,0.309844290831,9.66818354454,-7.20539584333,4.89707981845,0.462108684308},{6.80659531987,0.479777555915,-2.69542941505,-2.8868588473,12.0326932479,-4.25088924315},{-4.02965735585,-2.8674853685,-0.944192375785,-3.14388103692,-9.3477775021,-4.53619760282},{-7.29106871426,-3.36935940423,2.40349908451,6.11418967105,-7.582408019,6.88519600375},},
{{4.53524910634,10.5020648649,10.8251224222,-0.00583087685359,-2.70980899977,2.52508507972,1.75676975164},{1.52042394033,-1.65257921742,0.933646962025,-2.09753340439,-9.52782132912,4.44129270368,1.37466897994},},
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
