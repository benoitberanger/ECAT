% Get the bounding box.
textSize=48;
string='Good morning.';
yPositionIsBaseline=1; % 0 or 1
[w,r]=Screen('OpenWindow',1,255);
woff=Screen('OpenOffscreenWindow',w,[],[0 0 2*textSize*length(string) 2*textSize]);
Screen(woff,'TextFont','Arial');
Screen(woff,'TextSize',textSize);
t=GetSecs;
bounds=TextBounds(woff,string,yPositionIsBaseline)
fprintf('TextBounds took %.3f ms.\n',(GetSecs-t)*1000);
Screen('Close',woff);

% Show that it's correct by using the bounding box to frame the text.
% x0=100;
% y0=100;

x0=r(3)/2;
y0=r(4)/2;

%%

Screen(w,'TextFont','Arial');
Screen(w,'TextSize',textSize);
Screen('DrawText',w,string,x0,y0,0,255,yPositionIsBaseline);
Screen('FrameRect',w,0,InsetRect(OffsetRect(bounds,x0,y0),-1,-1));

%%

xt = r(3)/2;
yt = r(4)/2;

[width,height] = RectSize(bounds);

X0 = round(x0 - width/2);
Y0 = round(y0 + height/2);

Screen('DrawText',w,string,X0,Y0,128,255,yPositionIsBaseline);
Screen('FrameRect',w,0,InsetRect(OffsetRect(bounds,X0,Y0),-1,-1));

Screen('FrameRect',w,128,CenterRectOnPoint(bounds,xt,yt))

%%

% Get bounding rect of text:

str = '333333333';

[ textrect, orect ] = Screen('TextBounds', w, str);
% Get offset between rect center and top-left corner:
[xoffset, yoffset] = RectCenter(textrect);

cx = xt;
cy = yt;

% Calculate (xp, yp) to use to position text at (cx, cy):
xp = cx - xoffset; yp = cy - yoffset;

% Draw:
Screen('DrawText', w, str, xp, yp);

Screen('FrameRect',w,0,OffsetRect(textrect,xp,yp))

Screen('DrawLine', w, [255 0 0] , xp, yp , xp, yp);

%%

Screen('DrawLine', w ,[255 0 0], xt, 0, xt, yt*2);
Screen('DrawLine', w ,[255 0 0], 0, yt, xt*2, yt);

Screen('Flip',w);
% Speak('Click to quit');
% GetClicks;
% Screen('Close',w);





