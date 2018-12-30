W = {{{-4.29874172344,-2.94546621718,-1.6935384889,0.806449089534,-2.47882039448,-0.721393872894},{1.54564873905,-1.93733277868,-1.32421408597,-3.02375487394,-0.372542460591,-3.63016512597},{-2.92224581962,-0.652811384174,2.17996258596,1.99168326972,4.85058442823,1.13624986853},{1.72584851193,-2.29521368856,-8.40052659772,1.93603393539,-2.59573547242,-1.2405037368},{1.86699971905,0.872151184455,1.75585610616,-0.142863573662,5.05178762947,-6.04862977856},{-2.32421551747,1.87318105926,-0.87386666359,-2.4701850438,-3.1552487669,-4.38566116983},{-2.65182854054,-1.01837294734,-7.64211851496,2.36546539785,-0.400815378448,-0.11379709052},},
{{-1.15212138982,1.28085933629,2.29017091193,-7.27971698889,4.85376855391,0.074851186569,-1.51282956782},{-0.772464102557,3.2914899116,0.639464076683,-0.594893977534,-0.900662207067,4.52967823233,0.293840253731},},
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
