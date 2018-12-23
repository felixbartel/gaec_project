W = {{{0.494272746833,-0.0684488916061,0.00200213494061,-0.0714107598286,0.372951491247,-0.12419910321},{-0.165861437256,-0.0829824726691,0.22665823117,-0.00519161546723,-0.408102751703,-0.114143369105},{-0.0803877273619,0.122177475473,0.480897260296,-0.239706648409,-0.0899291186658,0.0505360967677},{-0.0477101138146,0.254605034523,0.384359794794,0.180501249126,0.317042378294,0.413815970705},{0.0432677321241,-0.349826978004,-0.214787530172,0.134461362898,0.366111781358,-0.0191892576779},{-0.350641848141,0.238109899874,0.324138256091,0.238256602396,0.454137302552,-0.239150303067},{-0.438366685083,0.0439323547195,-0.130985349985,-0.125794068825,-0.0679208462602,-0.143171150993},},
{{-0.40835155177,0.176655866086,-0.250390087826,0.254329295221,0.0600462484074,-0.0557461188121,0.34303021558},{-0.507162804652,-0.373358930106,-0.486744379038,-0.277310217405,0.137379957499,-0.11399130498,-0.478790961929},},
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
