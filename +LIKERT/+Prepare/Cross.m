function [ cross ] = Cross
global S

dim   = round(S.PTB.wRect(4)*S.Parameters.LIKERT.FixationCross.ScreenRatio);
width = round(dim * S.Parameters.LIKERT.FixationCross.lineWidthRatio);
color = S.Parameters.LIKERT.FixationCross.Color;

cross = FixationCross(...
    dim   ,...                       % dimension in pixels
    width ,...                       % width     in pixels
    color ,...                       % color     [R G B] 0-255
    [S.PTB.CenterH S.PTB.CenterV] ); % center    in pixels

cross.LinkToWindowPtr( S.PTB.wPtr )

cross.AssertReady % just to check

end % function
