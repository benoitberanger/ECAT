classdef Arrow < baseObject
    %ARROW Class to prepare and draw a arrow= left/Right queues in PTB
    % This object depends on the the @Circle : center + circle_diameter
    
    %% Properties
    
    properties
        
        % Parameters for the creation
        
        circle_center   = zeros(0,2) % [x y] in pixels
        circle_diameter = zeros(0)   % in pixels
        color           = zeros(0,4) % [R G B a] from 0 to 255
        thickness       = zeros(0)   % line thickness, in pixels
        
        % Internal variables
        
        
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = Arrow( circle_center, circle_diameter, color, thickness )
            %
            
            % ================ Check input argument =======================
            
            % Arguments ?
            if nargin > 0
                
                % --- circle_center ----
                assert( isvector(circle_center) && isnumeric(circle_center) && all(circle_center>0)  , ...
                    'circle_center = [x y], in pixels' )
                
                % --- circle_diameter ----
                assert( isscalar(circle_diameter) && isnumeric(circle_diameter) && circle_diameter>0 , ...
                    'circle_diameter = circle_diameter of the circle, in pixels' )
                
                % --- color ----
                assert( isvector(color) && isnumeric(color) && all( uint8(color)==color ) , ...
                    'color = [R G B a] from 0 to 255' )
                
                % --- thickness ----
                assert( isscalar(thickness) && isnumeric(thickness) && thickness>0 , ...
                    'thickness = thickness of the lines, in pixels' )
                
                % ================== Callback =============================
                
                self.circle_center   = circle_center;
                self.circle_diameter = circle_diameter;
                self.color           = color;
                self.thickness       = thickness;
                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
