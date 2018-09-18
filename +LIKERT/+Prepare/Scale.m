function [ scale ] = Scale()
global S

width = round(S.PTB.wRect(3)*S.Parameters.LIKERT.Scale.ScreenRatio);
values = S.Parameters.LIKERT.Scale.Values;
scalecolor = S.Parameters.LIKERT.Scale.ScaleColor;
cursorcolor = S.Parameters.LIKERT.Scale.CursorColor;
x = S.PTB.CenterH;
y = S.PTB.wRect(4)*(1-S.Parameters.LIKERT.Scale.Voffcet);
values_sz = round(S.PTB.wRect(3)*S.Parameters.LIKERT.Scale.ValuesSize);

scale = Scale(...
    width ,...                       % width     in pixels
    values, ...                      % cellstr
    scalecolor ,...                  % color     [R G B] 0-255
    cursorcolor ,...                 % color     [R G B] 0-255
    [x y] ,...                       % center    in pixels
    values_sz);

scale.LinkToWindowPtr( S.PTB.wPtr )

scale.GenerateLabelRect

scale.AssertReady % just to check

end % function
