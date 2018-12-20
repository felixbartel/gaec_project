W = {{{0.30514589267,-0.29777241505,0.0961085045397,-0.474569088428,0.03636729104,0.191481954557},{-0.464856009788,0.220769822293,-0.16310442795,0.250344754292,0.0114930091343,0.292378049671},{-0.275092064014,0.457807932382,0.0550022245817,-0.106886410584,0.00396529729224,-0.22677476158},{0.366508251428,0.0734740355269,-0.121114204491,0.447760060538,0.246420026089,-0.0498305873653},{-0.386674582693,0.163184504836,0.112963491899,-0.0900498185853,0.358408669441,-0.256089405441},{0.483024596263,0.310307188104,0.0165466968252,0.155126951248,-0.391856381864,0.0314272291572},{0.34667745557,0.272651585643,-0.0438488944041,0.0211137914975,0.0803076238521,-0.0228297921607},},
{{-0.0776076515861,0.369241699032,0.0686417377024,-0.226827552213,0.410231220594,-0.112990484265,-0.323050937594},{-0.298867364023,-0.0182846055471,-0.125662702532,-0.0772932149983,-0.182167254381,0.242052377901,-0.298452509177},},
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
