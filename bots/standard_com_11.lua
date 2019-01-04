W = {{{0.297133528286,0.265698168879,0.336811675234,0.120928787323,0.633212953502,0.0208836573284},{-0.47625798361,0.361710676279,0.117663949336,-0.0655364969096,-0.541039595052,-0.436289233561},{0.349266375186,0.249168988441,-0.3518709393,-0.103157723062,-0.222189045572,0.40852819222},{0.604325340426,-0.0875236982766,0.0974573058172,0.316835515399,-0.39533043629,-0.135308714677},{0.215685836789,0.179537767045,-0.237537754839,-0.400640585371,-0.242016703154,0.238323189575},{0.245425907714,0.389245338247,-0.143479908916,-0.146704344775,-0.23143689793,0.202881545337},{-0.0604131068142,0.00112559460782,0.0372617808698,0.0660183827283,-0.478428812796,0.391767275999},},
{{-0.488716303029,0.0167046979656,-0.19258840916,0.522213782769,-0.00980721884151,-0.0994734201713,0.460087980982},{-0.140918024188,0.643283606703,0.49175760938,-0.055117568968,0.252098597864,0.334391557692,-0.0137294789851},},
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
