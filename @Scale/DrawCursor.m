function DrawCursor( self )

Screen('FillPoly' , self.wPtr, self.cursorcolor, self.cursorCoord);
Screen('FramePoly', self.wPtr,        [ 0 0 0 ], self.cursorCoord);

end % function
