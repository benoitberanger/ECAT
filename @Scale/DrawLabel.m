function DrawLabel( self )

Screen('TextSize' , self.wPtr, self.values_sz);

for t = 1 : length(self.values)
    
    Screen('DrawText',self.wPtr,self.values{t},self.labelX(t),self.labelY,self.scalecolor);
    
end % for each tick

end % function
