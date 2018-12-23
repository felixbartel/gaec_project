W = {{{-0.558871943675,0.323219759616,0.507198188386,-0.284143229637,0.34224018074,0.46551525985},{-0.951646122505,-0.259278080561,0.326068840442,0.105690789814,0.45565175225,-0.0232282907059},{0.210140400046,-0.280723024299,0.0468389862241,0.0427856257832,-0.36576532624,-0.0315760999979},{0.36748996702,0.308103255425,-0.0821059378169,0.0456166003026,0.178281314084,-0.0818109922109},{-0.148259089977,-0.0907293351628,-0.064112895306,-0.32815659121,-0.308068012136,-0.24854262785},{0.126609283408,-0.251377291932,-0.583823673014,0.463990857474,-0.22798967308,0.128006589971},{-0.324779617342,0.297040610792,0.216459649296,-0.390999933313,-0.237584722164,-0.135951566137},},
{{-0.0171057173252,0.44216248581,0.154878221606,-0.590176550507,0.388906504915,0.183822031146,-0.370055630993},{0.276029922111,-0.151801647279,-0.430370375593,0.0825754379999,-0.136785765357,0.263825196493,-0.235195412543},},
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
