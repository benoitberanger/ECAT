function GenerateCursorRect( self )

self.cursorBaseRect = [0 0 self.lineThickness self.lineThickness*10];

self.cursorCurrentRect = self.cursorBaseRect;

self.cursor_pos_px = NaN;
self.cursor_pos_value = NaN;

end % function
