W = {{{-0.28431200287632463,0.1638676234761326,0.3898670749053138,-0.36942114814980936,-0.09544121776618508,-0.3520874378803224,0.04696270562973796},{-0.28600591025258293,-0.2826578451574664,0.09865692551803562,0.42231965828184187,0.18800706760322472,-0.10492065095568992,-0.03618170961487088},{0.3039130604357827,-0.10055692454047027,0.22293952012147544,0.4516772832292285,-0.25906583717052056,0.23544683032876035,0.07628692213861465},{0.19408638977808268,-0.35482765411934825,0.1367255668640056,0.3077274661203887,-0.23918711750617105,0.3663771765419003,0.35177582640487515},{-0.22647533729552405,0.19055901937532949,0.2759209070125439,-0.2246961298888971,-0.4018445174839751,0.4030115221659919,0.3535358831771298},{-0.2503568225270325,0.3041960014595867,0.03306685735843127,-0.4536613832766683,0.13254835508565244,-0.18880842890780136,-0.3654250562185988},{0.3403376896668744,-0.19307777182733343,0.09035645891532817,0.026133647158957496,0.07706418653276534,-0.230523374403153,0.08313521832135318},{-0.10289384599604345,0.09940434732242706,0.027231168670606598,0.19766646810152289,-0.14275603230223144,0.35288283755338445,-0.3423342490046817},{0.3196091626147619,-0.12582537449913506,0.03175507853063242,0.17528166397828124,0.2359525439661645,-0.2440300662417585,0.012762769032027887}},
{{0.029391000960165115,-0.4387971092400269,0.15285607061237588,-0.1946414814734948,0.40883530656990197,0.34026434930419436,-0.4627330765761941,0.029174372009634006,-0.33868997324581807},{-0.30126617827953706,0.002865265067222622,-0.1777858804413356,-0.11557085009557033,-0.40870478592738635,0.17749864391479153,-0.43141173950087763,-0.05691893649034141,-0.1836847276388549},{0.1978146956759017,0.03364248292692598,0.047649213388542,0.21347343553271703,0.2591610014497747,0.2448950314331515,0.4264187699365807,-0.2537429129564681,-0.02392210701746013}}}
b = {{-0.006870620965410246,-0.48814187442768975,-0.07534568361327576,-0.042758347714754175,0.13188066088429562,0.1787458742103285,-0.011499059206123374,0.4632402554206334,-0.06868398134816134},{0.1315342395560437,-0.01728436760619745,0.30382039511705694}}

function OnBounce()
end

function OnOpponentServe()
  moveto(130) -- Wenn der Gegner spielt, in Ausgangsposition gehen
end

function OnServe(ballready)
  moveto(ballx() - 20) -- Etwas links vom Ball hinstellen
  if posx() < ballx() - 17 and posx() > ballx() - 23 then
       -- Dieser zugegeben etwas komplizierte Ausdruck bewirkt, dass
       -- man sich erstmal unterhalb des Balles befinden muss. Leider muss
       -- das so aufwendig gemacht werden, weil moveto() niemals eine Stelle
       -- ganz exakt erreicht.
    if ballready then 
      jump() -- Natürlich nur springen wenn der Ball schon bereitsteht
    end
  end
end

function OnGame()
  input = {posx(), posy(), launched(), ballx()-posx(), bally()-posy(), bspeedx(), bspeedy()}
  output = feed_forward(input)
  decide_what_to_do(output)
end


function feed_forward(x)
  for i = 1,#W do
    x = activate(x,W[i],b[i])
  end
  return x
end


function activate(x,Wi,b) -- using the sigmoid function 1/(1+exp(-x))
  local y = {}
  for i = 1,#Wi do
    y[i] = 0
    for j = 1,#Wi[1] do
      y[i] = y[i]+Wi[i][j]*x[j]
    end
    y[i] = 1/(1+math.exp(-(y[i]+b[i])))
  end
  return y
end


function decide_what_to_do(output)
  if output[1] > output[2] then
    if output[1] > 0.5 then
      left()
    end
  else
    if output[2] > 0.5 then
      right()
    end
  end
  if output[3] > 0.75 then
    jump()
  end
end
