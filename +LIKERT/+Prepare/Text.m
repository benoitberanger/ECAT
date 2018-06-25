function [ Text_1 , Text_2 ] = Text
global S

color = S.Parameters.LIKERT.Scale.ScaleColor;
content = '';
Xptb = S.PTB.CenterH;
Yptb = S.PTB.wRect(4)*0.45;

Text_1 = Text( color, content, Xptb, Yptb );
Text_1.LinkToWindowPtr( S.PTB.wPtr )

Text_2 = Text_1.CopyObject;

Text_1.content = S.Parameters.LIKERT.Scale.Text_1;
Text_2.content = S.Parameters.LIKERT.Scale.Text_2;

Text_1.AssertReady % just to check
Text_2.AssertReady % just to check

end % function
