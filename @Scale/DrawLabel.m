function DrawLabel( self )

for t = 1 : length(self.values)
    
    Screen('DrawText',self.wPtr,self.values{t},self.labelX(t),self.labelY,self.scalecolor);
    
end % for each tick

end % function
