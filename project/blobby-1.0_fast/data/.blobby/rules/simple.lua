__AUTHOR__ = ""
__TITLE__  = "Simple rules"

npoint = 0

function IsWinning(lscore, rscore)
  return ( rscore+lscore >= SCORE_TO_WIN )
end

function OnBallHitsPlayer(player)
  if touches(player) > 3 then
    npoint = npoint+1
    if npoint%2 == 0 then
      mistake(player, LEFT_PLAYER, 1)
    else
      mistake(player, RIGHT_PLAYER, 1)
    end
  end
end

function OnBallHitsGround(player)
  npoint = npoint+1
  if npoint%2 == 0 then
    mistake(player, LEFT_PLAYER, 1)
  else
    mistake(player, RIGHT_PLAYER, 1)
  end
end
