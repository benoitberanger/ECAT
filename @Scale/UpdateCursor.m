function UpdateCursor( self, dpx )

if self.cursor_pos_px + dpx < self.scaleRect(1)
    self.cursor_pos_px = self.scaleRect(1);
elseif self.cursor_pos_px + dpx > self.scaleRect(3)
    self.cursor_pos_px = self.scaleRect(3);
else
    self.cursor_pos_px = self.cursor_pos_px + dpx;
end

self.cursor_pos_value = self.px2value(self.cursor_pos_px);

self.cursorCurrentRect = CenterRectOnPoint( self.cursorBaseRect, self.cursor_pos_px, self.center(2) );

end % function
