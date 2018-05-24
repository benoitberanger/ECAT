function [ EP, Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.Environement  = 'MRI';
    S.OperationMode = 'Acquisition';
end


%% Paradigme

switch S.OperationMode
    
    case 'Acquisition'
        Parameters.NrPics           = 216;
        Parameters.PicturesDuration = 2;
        Parameters.LikertDuration   = 2;
        Parameters.BlankPeriod      = 0.5;
        Parameters.PreparePeriod    = 0.5;
    case 'FastDebug'
        Parameters.NrPics           = 9;
        Parameters.PicturesDuration = 2;
        Parameters.LikertDuration   = 2;
    case 'RealisticDebug'
        Parameters.NrPics           = 3;
        Parameters.PicturesDuration = 0.5;
        Parameters.LikertDuration   = 2;
        Parameters.BlankPeriod      = 0.5;
        Parameters.PreparePeriod    = 0.5;
end

NrTrials = Parameters.NrPics;


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)' };
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for evt = 1 : NrTrials
    
    dur = Parameters.PicturesDuration + Parameters.LikertDuration + Parameters.BlankPeriod + Parameters.PreparePeriod;
    EP.AddPlanning({ 'pic' NextOnset(EP) dur });
    
end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargout < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot
    
end

end % function
