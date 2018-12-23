W = {{{0.0988333462357,0.131619593774,0.254205861062,0.392942964296,0.157040103592,-0.53426595023},{-0.24870393568,0.335896812556,-0.329690561076,0.368784966069,-0.000772928824124,0.117983436905},{0.0852254049837,0.396731717868,-0.180626076592,-0.360972520214,0.415633353335,0.0105650394385},{0.244284023509,-0.530556875205,-0.0255145674003,0.168707699576,-0.555976069955,-0.126500861614},{-0.229198643257,0.487958349756,0.150965234799,0.41945560794,0.108617191588,0.157394537479},{-0.323028103951,-0.435691529901,-0.016673041419,0.386305407925,-0.138871584762,0.451171767872},{0.369647546571,-0.06014533185,0.252024557271,0.133680292405,-0.037598957152,-0.398046758932},},
{{-0.169404079697,-0.413461116854,0.169252009297,0.331526603028,-0.338633333001,-0.403827143461,0.138192788176},{0.23519776329,0.329480404663,0.0632179936315,-0.0175805323338,0.307059006703,0.1159794615,0.496602980217},},
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
