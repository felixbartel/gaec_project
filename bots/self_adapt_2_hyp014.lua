W = {{{0.154934937204,0.365641161394,0.0270128272919,0.177631499014,-0.198455401053,0.352778171213},{-0.256252215073,0.285607326402,-0.262569528312,0.295350849876,0.131153854092,-0.279313341235},{0.333515151563,-0.248101143967,-0.469183209409,-0.440406375653,-0.348992536717,-0.525128946176},{-0.272171678427,0.32952827699,-0.0156352185277,-0.135881524826,-0.146166040402,0.133666113053},{0.300063162933,0.176848503983,-0.197999764102,-0.0138593234686,-0.186173966111,-0.325070149971},{-0.482450551984,0.321356677209,0.215600310989,-0.261988344879,-0.240248036329,-0.296147652885},{0.00534346500787,-0.370940433963,0.405279003065,0.346607747001,0.0625357591298,0.367000798148},},
{{-0.115095647656,-0.0086300930506,0.0388104809512,-0.288727494669,-0.130523292002,0.362315944288,0.164061396098},{0.475213373242,-0.401488954985,0.339756504113,-0.201902146277,0.362079047865,0.413066624648,0.384502437906},},
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
