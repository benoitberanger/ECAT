function [ EP, Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.Environement  = 'MRI';
    S.OperationMode = 'Acquisition';
    S.PTB.IFI       = 1/60;
end


%% Paradigme

Parameters.PreparePeriod = 0.5; % second
Parameters.HoldPeriod    = 1.0; % second
Parameters.JitterMin     = 0.5; % second
Parameters.JitterMax     = 4.0; % second
Parameters.JitterMean    = 1.0; % second

Parameters.StartStaircases = [100 150 200 250]; % millisecond

Parameters.StepSize        = 50; % millisecond

switch S.OperationMode
    
    case 'Acquisition'
        Parameters.NrGo   = 96;
        Parameters.NrStop = 32;
    case 'FastDebug'
        Parameters.NrGo   = 3;
        Parameters.NrStop = 1;
    case 'RealisticDebug'
        Parameters.NrGo   = 24;
        Parameters.NrStop = 8;
end

assert( mod(Parameters.NrGo, Parameters.NrStop) == 0 )

NrTrials = Parameters.NrGo + Parameters.NrStop;

SequenceGoStop = Common.ShuffleN( [ zeros(1,Parameters.NrGo/Parameters.NrStop) 1 ], NrTrials/(Parameters.NrGo/Parameters.NrStop +1) );
SequenceLR     = Common.ShuffleN( [0 1]                                           , NrTrials/2 );

Paradigm = cell(NrTrials,5);

Staircase_idx = 1:length(Parameters.StartStaircases);
SequenceStaircaise =  Common.ShuffleN( Staircase_idx , NrTrials/length(Staircase_idx) );

counter_staircase = 0;

for e = 1 : NrTrials
    
    switch SequenceGoStop(e)
        case 0
            Paradigm{e,1} = 'Go';
            Paradigm{e,5} = 0;
        case 1
            Paradigm{e,1} = 'Stop';
            counter_staircase = counter_staircase + 1;
            Paradigm{e,5} = SequenceStaircaise(counter_staircase);
            if counter_staircase <= length(Staircase_idx)
                Paradigm{e,4} = Parameters.StartStaircases(SequenceStaircaise(counter_staircase));
            end
    end
    
    switch SequenceLR(e)
        case 0
            Paradigm{e,2} = 'Left';
        case 1
            Paradigm{e,2} = 'Right';
    end
    
end


%% Generate Jitter according to a density function

MIN = Parameters.JitterMin;
MAX = Parameters.JitterMax;
MEAN = Parameters.JitterMean;
N = 1e6;

rand_uni =  MIN + (MAX-MIN)*rand(N/2,1); % uniform probability density function
rand_norm = MEAN + 0.2.*randn(N,1); % normal probability density function
rand_task = [rand_uni ; rand_norm]; % concatenate the two
rand_task( rand_task<MIN ) = []; % cut when values outside the bounds
rand_task( rand_task>MAX ) = []; % cut when values outside the bounds
rand_task = Shuffle(rand_task); rand_task = Shuffle(rand_task); % double shuffle (only one needed)

jitter_float = rand_task(1:NrTrials); % take only NrTrials jitter values
jitter_int_frame = round(jitter_float/S.PTB.IFI)*S.PTB.IFI; % round toward the inter-frame-interval
Paradigm(:,3) = num2cell( jitter_int_frame );


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'Trial#', 'Go/Stop', 'Left/Right', 'jitter (s)', 'StopSignalDelay (ms)', 'Staircase idx'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for evt = 1 : NrTrials
    
    dur = Parameters.PreparePeriod + Parameters.HoldPeriod + Paradigm{evt,3};
    EP.AddPlanning({ [Paradigm{evt,1} '_' Paradigm{evt,2}] NextOnset(EP) dur evt Paradigm{evt,1} Paradigm{evt,2} Paradigm{evt,3} Paradigm{evt,4} Paradigm{evt,5}});
    
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
