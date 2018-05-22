function [ EP, Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.Environement  = 'MRI';
    S.OperationMode = 'Acquisition';
    S.PTB.IFI       = 1/60;
end


%% Paradigme

clc

Parameters.PreparePeriod = 0.5; % second
Parameters.HoldPeriod    = 1.0; % second
Parameters.JitterMin     = 0.5; % second
Parameters.JitterMax     = 4.0; % second
Parameters.JitterMean    = 1.0; % second

Parameters.StartSSD = 50; % millisecond

switch S.OperationMode
    
    case 'Acquisition'
        Parameters.NrGo   = 96;
        Parameters.NrStop = 32;
        chunck = 4;
    case 'FastDebug'
        Parameters.NrGo   = 3;
        Parameters.NrStop = 1;
        chunck = [];
    case 'RealisticDebug'
        Parameters.NrGo   = 24;
        Parameters.NrStop = 8;
        chunck = 4;
end

NrTrials = Parameters.NrGo + Parameters.NrStop;

SequenceGoStop = Common.Randomize01( Parameters.NrGo, Parameters.NrStop, chunck);
SequenceLR = Common.Randomize01( NrTrials/2, NrTrials/2, chunck);

Paradigm = cell(NrTrials,4);

for e = 1 : NrTrials
    
    switch SequenceGoStop(e)
        case 0
            Paradigm{e,1} = 'Go';
        case 1
            Paradigm{e,1} = 'Stop';
    end
    
    switch SequenceLR(e)
        case 0
            Paradigm{e,2} = 'Left';
        case 1
            Paradigm{e,2} = 'Right';
    end
    
end

Paradigm(:,4) = {Parameters.StartSSD};


jitter_vect_float = Parameters.JitterMin + (Parameters.JitterMax - Parameters.JitterMin) * rand(NrTrials,1);
jitter_vect_int = round(jitter_vect_float/S.PTB.IFI)*S.PTB.IFI;
Paradigm(:,3) = num2cell( jitter_vect_int );


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'Trial#', 'Go/Stop', 'Left/Right', 'jitter (s)', 'StopSignalDelay (ms)'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------


for evt = 1 : NrTrials
    
    dur = Parameters.PreparePeriod + Parameters.HoldPeriod + Paradigm{evt,3};
    EP.AddPlanning({ [Paradigm{evt,1} '_' Paradigm{evt,2}] NextOnset(EP) dur evt Paradigm{evt,1} Paradigm{evt,2} Paradigm{evt,3} Paradigm{evt,4}});
    
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
