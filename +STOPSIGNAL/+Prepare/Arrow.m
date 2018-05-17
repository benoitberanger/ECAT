function [ arrow ] = Arrow ( circle )
global S

circle_center   = [circle.Xptb circle.Yptb];
circle_diameter = circle.diameter;
color           = circle.frameBaseColor;
thickness       = circle.thickness;

arrow = Arrow(...
    circle_center,...    % [x y] in pixels
    circle_diameter,...    % in pixels
    color,...            % [R G B a] from 0 to 255
    thickness);          % line thickness, in pixels

arrow.LinkToWindowPtr( S.PTB.wPtr )

arrow.AssertReady % just to check

end % function
