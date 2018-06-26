function [ EP, Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.Environement  = 'MRI';
    S.OperationMode = 'Acquisition';
    S.Parameters = GetParameters;
end


%% Paradigme

Values = S.Parameters.LIKERT.Scale.Values;
Values = str2double(Values([1 end]));

switch S.OperationMode
    case 'Acquisition'
        
        Parameters.NrTrials         = 20;
        
        Parameters.PreparePeriod    = 0.5; % second
        Parameters.BlankPeriod      = 0.5; % second
        Parameters.LikertDuration   = 5;   % second
        Parameters.ShowResult       = 1;   % second
        
    case 'FastDebug'
        
        Parameters.NrTrials         = 3;
        
        Parameters.PreparePeriod    = 0.5; % second
        Parameters.BlankPeriod      = 0.5; % second
        Parameters.LikertDuration   = 5;   % second
        Parameters.ShowResult       = 0.5;   % second
        
    case 'RealisticDebug'
        
        Parameters.NrTrials         = 5;
        
        Parameters.PreparePeriod    = 0.5; % second
        Parameters.BlankPeriod      = 0.5; % second
        Parameters.LikertDuration   = 5;   % second
        Parameters.ShowResult       = 1;   % second
        
end

vect = linspace(Values(1), Values(2), Parameters.NrTrials+2);
vect = Shuffle(vect(2:end-1));
vect = round((vect*10))/10; % round at the 1/10;

Parameters.Values = vect;


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'Trial#'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for evt = 1 : Parameters.NrTrials
    
    dur = Parameters.PreparePeriod + Parameters.BlankPeriod + Parameters.LikertDuration + Parameters.ShowResult;
    
    EP.AddPlanning({ num2str(Parameters.Values(evt)) NextOnset(EP) dur evt});
    
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
