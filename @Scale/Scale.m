classdef Scale < baseObject
    %SCALE Class to prepare and LIKERT scale in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        width       = zeros(0,1)   % width of each arms, in pixels
        scalecolor  = zeros(0,4) % [R G B a] from 0 to 255
        cursorcolor = zeros(0,4) % [R G B a] from 0 to 255
        center      = zeros(0,2) % [ CenterX CenterY ] of the cross, in pixels
        values      = cell(0)    % cellstr
        
        % Internal variables
        
        scaleRect  = zeros(0,4) % [x1 y1 x2 y2]
        tickRect   = zeros(4,0) % [x1 y1 x2 y2 ; x1 y1 x2 y2 ; .... ; x1 y1 x2 y2]'
        cursorRect = zeros(0,4) % [x1 y1 x2 y2]
        labelX     = zeros(0,1);
        labelY     = zeros(0,1);

        lineThickness = 3; % pixels
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = Scale( width , values , scalecolor , cursorcolor , center )
            % self = Scale( width=5 (pixels) ,  color=[128 128 128 255] from 0 to 255 , center = [ CenterX CenterY ] (pixels), values = cellstr )
            
            % ================ Check input argument =======================
            
            % Arguments ?
            if nargin > 0
                
                % --- width ----
                assert( isscalar(width) && isnumeric(width) && width>0 , ...
                    'width = width of the scale, in pixels' )
                
                % --- scalecolor ----
                assert( isvector(scalecolor) && isnumeric(scalecolor) && all( uint8(scalecolor)==scalecolor ) , ...
                    'color = [R G B a] from 0 to 255' )
                
                % --- cursorcolor ----
                assert( isvector(cursorcolor) && isnumeric(cursorcolor) && all( uint8(cursorcolor)==cursorcolor ) , ...
                    'color = [R G B a] from 0 to 255' )
                
                % --- center ----
                assert( isvector(center) && isnumeric(center) , ...
                    'center = [ CenterX CenterY ] of the cross, in pixels' )
                
                % --- values ----
                assert( iscellstr(values) , ...
                    'values = {''smt'' ''other'' } (cellstr)' )
                
                self.width       = width;
                self.scalecolor  = scalecolor;
                self.cursorcolor = cursorcolor;
                self.center      = center;
                self.values      = values;
                
                % ================== Callback =============================
                
                self.GenerateScaleRect  % real position
                self.GenerateTickRect   % real position
                self.GenerateCursorRect % main rect, but not at the right position
                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
