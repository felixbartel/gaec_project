W = {{{-0.324918001617,0.128847445934,-0.406684946219,0.0435477085636,-0.215869426479,0.0881574173332},{-0.186577049202,-0.0130934030112,-0.0274938277293,0.322549501814,0.426753597668,0.399281815729},{0.0590376833157,-0.320550748535,0.442848633538,0.381314374103,0.023742080052,0.247727534821},{-0.415711300417,0.0243681403511,0.222833982961,-0.101517056908,0.212015738237,0.363808446715},{-0.455216026159,0.056080078464,0.178015376309,0.203320263858,0.12711046567,0.0754611768542},{-0.188567693358,-0.350430999252,0.00034513132325,-0.181323921338,-0.222758684514,0.132093584934},{0.139363244768,0.39774487399,0.331794977964,0.478826557046,-0.477786855456,0.179404517555},},
{{0.102119945965,-0.457630324128,-0.372117489946,0.164587341472,0.160240134535,0.39530474574,0.0990314788912},{0.182969998095,0.468597592236,0.104061159439,-0.0211482414262,0.369786187915,0.0868172910159,0.474848633654},},
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
