function [ circle ] = Circle
global S

diameter   = S.Parameters.STOPSIGNAL.Circle.DimensionRatio*S.PTB.wRect(4);
thickness  = S.Parameters.STOPSIGNAL.Circle.WidthRatio*diameter;
frameColor = S.Parameters.STOPSIGNAL.Circle.FrameColor;
diskColor  = S.Parameters.STOPSIGNAL.Circle.DiskColor;
valueColor = S.Parameters.STOPSIGNAL.Circle.ValueColor;
Xorigin    = S.PTB.CenterH;
Yorigin    = S.PTB.CenterV;
screenX    = S.PTB.wRect(3);
screenY    = S.PTB.wRect(4);

circle = Circle(...
    diameter   ,...     % diameter  in pixels
    thickness  ,...     % thickness in pixels
    frameColor ,...     % frame color [R G B] 0-255
    diskColor  ,...     % disk  color [R G B] 0-255
    valueColor ,...     % disk  color [R G B] 0-255
    Xorigin    ,...     % X origin  in pixels
    Yorigin    ,...     % Y origin  in pixels
    screenX    ,...     % H pixels of the screen
    screenY    );       % V pixels of the screen

circle.filled = 0; % only draw the frame, dont fill the disk inside

circle.LinkToWindowPtr( S.PTB.wPtr )

circle.AssertReady % just to check

end % function
