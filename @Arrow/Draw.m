function Draw( self, side )

switch side
    
    case 'Left'
        
        fromH = self.circle_center(1) - self.circle_diameter/4 ;
        fromV = self.circle_center(2)                          ;
        toH   = self.circle_center(1) + self.circle_diameter/4 ;
        toV   = self.circle_center(2) + self.circle_diameter/4 ;
        Screen('DrawLine', self.wPtr , self.color, fromH, fromV, toH, toV , self.thickness);
        
        fromH = self.circle_center(1) - self.circle_diameter/4 ;
        fromV = self.circle_center(2)                          ;
        toH   = self.circle_center(1) + self.circle_diameter/4 ;
        toV   = self.circle_center(2) - self.circle_diameter/4 ;
        Screen('DrawLine', self.wPtr , self.color, fromH, fromV, toH, toV , self.thickness);
        
    case 'Right'
        
        fromH = self.circle_center(1) - self.circle_diameter/4 ;
        fromV = self.circle_center(2) + self.circle_diameter/4 ;
        toH   = self.circle_center(1) + self.circle_diameter/4 ;
        toV   = self.circle_center(2)                          ;
        Screen('DrawLine', self.wPtr , self.color, fromH, fromV, toH, toV , self.thickness);
        
        fromH = self.circle_center(1) - self.circle_diameter/4 ;
        fromV = self.circle_center(2) - self.circle_diameter/4 ;
        toH   = self.circle_center(1) + self.circle_diameter/4 ;
        toV   = self.circle_center(2)                          ;
        Screen('DrawLine', self.wPtr , self.color, fromH, fromV, toH, toV , self.thickness);
        
    otherwise
        
        error('side')
        
end

end % function
