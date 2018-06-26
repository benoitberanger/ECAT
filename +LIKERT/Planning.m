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
        Parameters.PreparePeriod    = 0.5;
        Parameters.BlankPeriod      = 0.5;
        Parameters.PictureDuration  = [4 6];
        Parameters.LikertDuration   = 5;
        Parameters.FixationCross    = 20;
    case 'FastDebug'
        Parameters.NrPics           = 6;
        Parameters.PreparePeriod    = 0.5;
        Parameters.BlankPeriod      = 0.5;
        Parameters.PictureDuration  = [0.5 1];
        Parameters.LikertDuration   = 3;
        Parameters.FixationCross    = 3;
    case 'RealisticDebug'
        Parameters.NrPics           = 12;
        Parameters.PreparePeriod    = 0.5;
        Parameters.BlankPeriod      = 0.5;
        Parameters.PictureDuration  = [4 6];
        Parameters.LikertDuration   = 5;
        Parameters.FixationCross    = 20;
end

NrTrials = Parameters.NrPics;


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'Trial#', 'Picture duration(s)'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

EP.AddPlanning({ 'FixationCross' NextOnset(EP) Parameters.FixationCross [] []});

for evt = 1 : NrTrials
    
    if mod(evt,NrTrials/3) == 0
        EP.AddPlanning({ 'FixationCross' NextOnset(EP) Parameters.FixationCross [] []});
    end
    
    pic_dur = (Parameters.PictureDuration(2) - Parameters.PictureDuration(1))*rand + Parameters.PictureDuration(1);
    dur =  Parameters.BlankPeriod + Parameters.PreparePeriod + pic_dur + Parameters.LikertDuration*2;
    EP.AddPlanning({ 'pic' NextOnset(EP) dur evt pic_dur});
    
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
