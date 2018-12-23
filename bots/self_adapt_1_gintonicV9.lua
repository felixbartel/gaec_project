W = {{{32.998963129,2.06944868027,8.2103508985,2.74338167235,34.8779629199,26.20892868},{4.53637280379,57.7139204884,5.82512460423,-26.2031431339,39.0121172688,-4.33059771699},{21.230111655,43.8167296663,26.5867428491,-75.24624272,20.8672479876,-15.0566083645},{47.7244232054,66.8272522411,14.9810753555,-20.2810821419,27.4373505408,35.6408819722},{10.4531713131,7.58282806507,-15.1109214736,48.8365892388,33.5731669226,33.4640600203},{-19.0050782848,-59.940140202,-16.1250537256,0.785804245869,-4.8499164681,9.55848397053},{3.26417017302,-32.8232537507,-1.45469387055,-21.7094033854,-4.67711758099,-27.6881118468},},
{{8.50998594687,-20.5466002266,47.2635841493,13.7965950576,12.7743745815,23.4077721162,16.3346389712},{21.2402173026,0.7863345253,15.9871148522,27.5303858521,-0.324790191027,18.3256617585,-9.3004130473},},
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
