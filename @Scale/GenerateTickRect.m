function GenerateTickRect( self )

x_start = self.scaleRect(1);
x_end   = self.scaleRect(3);

tick_x = linspace(x_start,x_end,length(self.values));

self.tickRect = zeros(4,length(self.values));

for t = 1 : length(self.values)
    
    self.tickRect(:,t) = CenterRectOnPoint( [0 0 self.lineThickness self.lineThickness*3] , tick_x(t) , self.center(2) )';
    
end % for each tick

end % function
