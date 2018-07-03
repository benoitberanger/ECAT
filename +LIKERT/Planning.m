function [ EP, Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.Environement  = 'MRI';
    S.OperationMode = 'Acquisition';
    S.SubjectID     = '001';
    S.DataPath      = fullfile( fileparts(pwd) , 'data' , S.SubjectID , filesep);
    S.PrePost       = 'Post';
end


%% Paradigme

switch S.OperationMode
    case 'Acquisition'
        Parameters.NrPics           = 216;
        
        Parameters.PreparePeriod    = 0.5; % second
        Parameters.BlankPeriod      = 0.5; % second
        Parameters.PictureDuration  = [4 6]; % [min max] for jitter, second
        Parameters.LikertDuration   = 5;   % second
        Parameters.HoldPeriod       = 0.5; % second
        Parameters.FixationCross    = 20;  % second
    case 'FastDebug'
        Parameters.NrPics           = 216;
        
        Parameters.PreparePeriod    = 0;
        Parameters.BlankPeriod      = 0;
        Parameters.PictureDuration  = [0 0];
        Parameters.LikertDuration   = 0;
        Parameters.HoldPeriod       = 0;
        Parameters.FixationCross    = 0;
        
%         Parameters.NrPics           = 6;
%         
%         Parameters.PreparePeriod    = 0.5;
%         Parameters.BlankPeriod      = 0.5;
%         Parameters.PictureDuration  = [0.5 1];
%         Parameters.LikertDuration   = 3;
%         Parameters.HoldPeriod       = 0.5;
%         Parameters.FixationCross    = 3;
        
    case 'RealisticDebug'
        Parameters.NrPics           = 12;
        
        Parameters.PreparePeriod    = 0.5;
        Parameters.BlankPeriod      = 0.5;
        Parameters.PictureDuration  = [4 6];
        Parameters.LikertDuration   = 5;
        Parameters.HoldPeriod       = 0.5;
        Parameters.FixationCross    = 3;
end

NrTrials = Parameters.NrPics;


%% Randomization of order for the pics

switch S.PrePost
    case 'Pre'
        l = load(fullfile(S.DataPath,'Pre_pictures.mat'));
    case 'Post'
        l = load(fullfile(S.DataPath,'Post_pictures.mat'));
end

NEU = l.(S.PrePost).NEU; % 1
ISO = l.(S.PrePost).ISO; % 2
ERO = l.(S.PrePost).ERO; % 3

order = [];

for i = 1 : length(NEU)
    order = [order Shuffle(1:3)];
end


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

c_NEU = 0;
c_ISO = 0;
c_ERO = 0;

for evt = 1 : NrTrials
    
    pic_dur = (Parameters.PictureDuration(2) - Parameters.PictureDuration(1))*rand + Parameters.PictureDuration(1);
    dur =  Parameters.BlankPeriod + Parameters.PreparePeriod + pic_dur;
    
    switch order(evt)
        case 1
            c_NEU = c_NEU + 1;
            target = NEU{c_NEU};
            % no likertscale here
        case 2
            c_ISO = c_ISO + 1;
            target = ISO{c_ISO};
            dur = dur + Parameters.LikertDuration*2/2 + 2*Parameters.HoldPeriod;
        case 3
            c_ERO = c_ERO + 1;
            target = ERO{c_ERO};
            dur = dur + Parameters.LikertDuration*2/2 + 2*Parameters.HoldPeriod;
    end
    
    EP.AddPlanning({ target NextOnset(EP) dur evt pic_dur});
    
end

EP.AddPlanning({ 'FixationCross' NextOnset(EP) Parameters.FixationCross [] []});

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
