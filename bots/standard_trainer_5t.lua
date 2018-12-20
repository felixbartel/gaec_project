W = {{{0.364718857275,0.019170698162,-0.378441045859,-0.277823516278,-0.472732244041,-0.325713924985},{-0.333938007161,-0.423933147757,0.214633921788,0.0330709609289,0.122024529401,-0.491333585102},{0.282822642176,0.462230524708,0.48064212208,-0.340490678131,-0.494143852788,0.189168331227},{-0.255387189191,-0.513707431967,-0.279952461278,0.308154652058,-0.221999363768,0.0339767643872},{0.0549663879044,0.43669179018,0.406479012594,-0.0226280446998,0.0981154142674,0.214149944409},{-0.00606713478706,-0.479035052428,0.0153256322668,0.0394887630638,0.253569586995,0.362676233832},{-0.405472475174,-0.400982701819,0.392935179528,0.377992610357,-0.0994211232737,-0.431722952241},},
{{-0.395072076525,0.399121842961,-0.0857733081176,-0.0378569837909,0.3178245303,-0.256598970984,0.0333065986975},{0.375557223137,0.469127792342,0.14633434808,0.0868087937283,0.433789640961,-0.268942460001,0.368987397864},},
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
