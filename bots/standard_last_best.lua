W = {{{0.00258502612373,-0.548520153939,0.36039561139,0.357230757789,-0.314716079616,-0.604295060212},{0.18968268582,-0.391862051362,0.550361257963,-0.0491525760258,0.369223509167,0.120153826101},{-0.0264013473887,-1.22632825198,-1.02545508845,0.0540064776044,0.762842719558,-0.831716605827},{-0.281958166453,-0.937279134089,1.30728834088,-0.624768650399,-0.716122832119,-0.209711888594},{0.215340884537,-0.634514858476,-2.6250410246,0.642822728194,-0.943860434944,0.077023758768},{0.0915733890749,-0.151845688801,0.693985993646,0.528294015123,0.636724370122,0.0593243893878},{-0.621111264767,0.43203292183,0.0197156002267,-0.527091479694,0.682316005054,-0.046187056055},},
{{0.311117175584,0.549926635695,-0.141202899257,0.586211648388,-1.38588746444,0.526355475342,-0.348407755488},{0.0787909682894,0.812083917956,0.79777088653,0.82646605636,0.470138360295,-0.61305283181,0.214079083338},},
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
