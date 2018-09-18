classdef Scale < baseObject
    %SCALE Class to prepare and LIKERT scale in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        width       = zeros(0,1)  % width of the triangle, in pixels
        scalecolor  = zeros(0,4) % [R G B a] from 0 to 255
        cursorcolor = zeros(0,4) % [R G B a] from 0 to 255
        center      = zeros(0,2) % [ CenterX CenterY ] of the cross, in pixels
        values      = cell(0)    % cellstr
        values_sz   = zeros(0,1) % tick text size
        cursorsize  = zeros(0,1)
        
        % Internal variables
        
        scaleRect  = zeros(0,4) % [x1 y1 x2 y2]
        tickRect   = zeros(4,0) % [x1 y1 x2 y2 ; x1 y1 x2 y2 ; .... ; x1 y1 x2 y2]'
        
        labelX     = zeros(0,1)
        labelY     = zeros(0,1)
        
        lineThickness = 3; % pixels
        
        cursor_pos_px     = zeros(0,1)
        cursor_pos_value  = zeros(0,1)
        cursorCoord       = zeros(0,3) % [x1 y1 ; x2 y2 ; x3 y3]
        
        p2v = zeros(0,1) % polynome to polyval : pixel -> value
        v2p = zeros(0,1) % polynome to polyval : value -> pixel
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = Scale( width , values , scalecolor , cursorcolor , center, values_sz, cursorsize )
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
                self.values_sz   = values_sz;
                self.cursorsize  = cursorsize;
                
                % ================== Callback =============================
                
                self.cursor_pos_px = NaN;
                self.cursor_pos_value = NaN;
                
                self.GenerateScaleRect   % real position
                self.GenerateTickRect    % real position
                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
