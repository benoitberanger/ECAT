function GenerateCursorCoord( self )

% create a triangle
head   = [ self.cursor_pos_px, self.center(2) ]; % coordinates of head
width  = self.cursorsize;           % width of arrow head
points = [ head+[-width,+width]         % left corner
    head+[width,+width]         % right corner
    head+[0,0] ];      % vertex

self.cursorCoord = points;

end % function
