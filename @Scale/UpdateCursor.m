function UpdateCursor( self, dpx )

self.cursor_pos_px    = self.cursor_pos_px + dpx;
self.cursor_pos_value = self.px2value(self.cursor_pos_px);

self.cursorCurrentRect = CenterRectOnPoint( self.cursorBaseRect, self.cursor_pos_px, self.center(2) );

end % function
