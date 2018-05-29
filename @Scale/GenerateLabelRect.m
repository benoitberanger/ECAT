function GenerateLabelRect( self )

allBounds = zeros(length(self.values),4);

for t = 1 : length(self.values)
    
    allBounds(t,:) = Screen('TextBounds',self.wPtr,self.values{t});
    
end % for each tick

baseRect = ceil(max(allBounds));
[xoffset, yoffset] = RectCenter(baseRect);

self.labelY = floor(self.tickRect(2,1)) - yoffset*3 -1 ;

x_start = self.scaleRect(1);
x_end   = self.scaleRect(3);

x_tick = linspace(x_start,x_end,length(self.values));

self.labelX = x_tick - xoffset -1 ;

end % function
