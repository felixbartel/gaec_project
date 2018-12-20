W = {{{-0.0173227702566,-0.346343267542,0.19744360629,0.247859834638,0.205129385536,0.406664182943},{-0.0742061133546,0.498450924327,-0.468558747459,0.318141315283,-0.503090424094,-0.285568518794},{0.00426653429774,0.0291362267782,0.358605788197,-0.107619369032,-0.210418629853,-0.0541161468603},{0.00540137475615,0.0592432372738,-0.0427458244267,0.52969144223,0.268556246002,-0.0232531203339},{-0.131772233653,0.0888054023402,0.362009442412,-0.449570264809,0.43115135593,-0.0812421623215},{-0.305967681917,-0.272623493161,0.482281491309,0.223205190001,0.370546890179,0.466863916566},{0.287750357289,-0.236756696293,0.362462122166,0.514124329453,-0.469600509982,0.184113591963},},
{{-0.0667303160529,0.371918014424,0.0525073462214,-0.291767775434,0.440489772161,-0.0917525889739,-0.315028705002},{0.0925281576921,-0.327922137189,-0.369783309146,-0.427110999863,-0.416681648108,0.107109125413,0.102935771563},},
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
