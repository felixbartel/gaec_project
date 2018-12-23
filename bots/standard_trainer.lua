W = {{{0.119561064264,-0.0239231724664,0.330894067071,0.260981900699,0.242387698346,0.0467178064667},{-0.193111780645,-0.0162849658024,-0.333660866992,0.0856978983762,0.0755024966557,-0.389962908808},{-0.306966849291,0.38695886804,-0.243153575167,0.175357339333,0.0894034026829,0.0923139571801},{0.040834937071,0.370573428313,-0.332378866245,0.0724395254611,-0.485897213104,-0.389124092067},{0.390306503924,-0.24117793659,-0.571629157757,0.382354034712,0.445357267409,-0.0773673731159},{-0.552369031731,-0.133745150245,0.106071520944,-0.309617235827,0.336428390122,-0.311876911282},{-0.460765655544,0.246278241593,-0.136702999788,0.159524750147,-0.0110704116778,0.349254848867},},
{{-0.342061559242,0.29857786219,0.441713664954,-0.324394446374,-0.485075648521,0.384434228423,0.130058539526},{-0.185263736532,0.486092789206,0.35570694139,0.163931824217,0.391552611837,0.35886587346,-0.171005810662},},
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
