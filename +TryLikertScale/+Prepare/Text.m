function [ Text_Target , Text_Cursor ] = Text
global S

color = S.Parameters.LIKERT.Scale.ScaleColor;
content = '???';
size  = round(S.PTB.wRect(3)*S.Parameters.LIKERT.Scale.TextSize);
Xptb = S.PTB.CenterH;
Yptb_Target = S.PTB.wRect(4)*0.45;
Yptb_Cursor = S.PTB.wRect(4)*0.85;

Text_Target = Text( color, size, content, Xptb, Yptb_Target );
Text_Target.LinkToWindowPtr( S.PTB.wPtr )
Text_Target.AssertReady % just to check

Text_Cursor = Text( color, size, content, Xptb, Yptb_Cursor );
Text_Cursor.LinkToWindowPtr( S.PTB.wPtr )
Text_Cursor.AssertReady % just to check


end % function
