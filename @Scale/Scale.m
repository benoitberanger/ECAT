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
        
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function obj = Scale( width , values , scalecolor , cursorcolor , center )
            % obj = Scale( width=5 (pixels) ,  color=[128 128 128 255] from 0 to 255 , center = [ CenterX CenterY ] (pixels), values = cellstr )
            
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
                
                obj.width       = width;
                obj.scalecolor  = scalecolor;
                obj.cursorcolor = cursorcolor;
                obj.center      = center;
                obj.values      = values;
                
                % ================== Callback =============================
                
%                 obj.GenerateCoords
                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
