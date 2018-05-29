function GenerateTickRect( self )

x_start = self.scaleRect(1);
x_end   = self.scaleRect(3);

tick_x = linspace(x_start,x_end,length(self.values));

self.tickRect = zeros(4,length(self.values));

baseRect = [0 0 self.lineThickness self.lineThickness*3];

for t = 1 : length(self.values)
    
    self.tickRect(:,t) = CenterRectOnPoint( baseRect , tick_x(t) , self.center(2) )';
    
end % for each tick


%% Prepare value2px & px2value

% --- px2value

x_start = self.scaleRect(1);
x_end   = self.scaleRect(3);

y_start = str2double(self.values{1  });
y_end   = str2double(self.values{end});

self.p2v = polyfit([x_start x_end], [y_start y_end], 1);


% --- value2px

y_start = self.scaleRect(1);
y_end   = self.scaleRect(3);

x_start = str2double(self.values{1  });
x_end   = str2double(self.values{end});

self.v2p = polyfit([x_start x_end], [y_start y_end], 1);


end % function
