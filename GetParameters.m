function [ Parameters ] = GetParameters
% GETPARAMETERS Prepare common parameters
global S

if isempty(S)
    S.Environement = 'MRI';
    S.Side         = 'Left';
    S.Task         = 'STOPSIGNAL';
end


%% Echo in command window

EchoStart(mfilename)


%% Paths

% Parameters.Path.wav = ['wav' filesep];


%% Set parameters

%%%%%%%%%%%
%  Audio  %
%%%%%%%%%%%

Parameters.Audio.SamplingRate            = 44100; % Hz

Parameters.Audio.Playback_Mode           = 1; % 1 = playback, 2 = record
Parameters.Audio.Playback_LowLatencyMode = 1; % {0,1,2,3,4}
Parameters.Audio.Playback_freq           = Parameters.Audio.SamplingRate ;
Parameters.Audio.Playback_Channels       = 2; % 1 = mono, 2 = stereo

% Parameters.Audio.Record_Mode             = 2; % 1 = playback, 2 = record
% Parameters.Audio.Record_LowLatencyMode   = 0; % {0,1,2,3,4}
% Parameters.Audio.Record_freq             = Parameters.Audio.SamplingRate;
% Parameters.Audio.Record_Channels         = 1; % 1 = mono, 2 = stereo


%%%%%%%%%%%%%%
%   Screen   %
%%%%%%%%%%%%%%
% Prisma scanner @ CENIR
Parameters.Video.ScreenWidthPx   = 1024;  % Number of horizontal pixel in MRI video system @ CENIR
Parameters.Video.ScreenHeightPx  = 768;   % Number of vertical pixel in MRI video system @ CENIR
Parameters.Video.ScreenFrequency = 60;    % Refresh rate (in Hertz)
Parameters.Video.SubjectDistance = 0.120; % m
Parameters.Video.ScreenWidthM    = 0.040; % m
Parameters.Video.ScreenHeightM   = 0.030; % m

Parameters.Video.ScreenBackgroundColor = [128 128 128]; % [R G B] ( from 0 to 255 )

%%%%%%%%%%%%
%   Text   %
%%%%%%%%%%%%
Parameters.Text.SizeRatio   = 0.03; % Size = ScreenWide *ratio
Parameters.Text.Font        = 'Arial';
Parameters.Text.Color       = [128 128 128]; % [R G B] ( from 0 to 255 )
Parameters.Text.ClickCorlor = [0   255 0  ]; % [R G B] ( from 0 to 255 )


%%%%%%%%%%%%%%
% STOPSIGNAL %
%%%%%%%%%%%%%%


% Parameters.STOPSIGNAL.Question.Content       = 'Est-ce vous ?';
% Parameters.STOPSIGNAL.Question.PositonXRatio = 0.5;  % Xpos = PositonXRatio * ScreenWidth
% Parameters.STOPSIGNAL.Question.PositonYRatio = 1/3;  % Ypos = PositonYRatio * ScreenHight

% Circle => @Circle
Parameters.STOPSIGNAL.Circle.DimensionRatio = 0.30;                                   % diameter  = DimensionRatio*ScreenHeight
Parameters.STOPSIGNAL.Circle.WidthRatio     = 0.01;                                   % thickness = WidthRatio    *diameter
Parameters.STOPSIGNAL.Circle.FrameColor     = [255 255 255];                          % [R G B] ( from 0 to 255 )
Parameters.STOPSIGNAL.Circle.DiskColor      = Parameters.Video.ScreenBackgroundColor; % [R G B] ( from 0 to 255 )
Parameters.STOPSIGNAL.Circle.ValueColor     = [0 0 0];                                % [R G B] ( from 0 to 255 ) useless for the big circle

% Arrow => @Arrow
% copy somes parameters from Circle

% Bip => @
Parameters.STOPSIGNAL.Bip.Freq            = 900;   % Hz
Parameters.STOPSIGNAL.Bip.BipDuration     = 0.500; % second
Parameters.STOPSIGNAL.Bip.InOutFadeRation = 0.05;  % ration : [0-1]


%%%%%%%%%%
% LIKERT %
%%%%%%%%%%

% Fixation cross
Parameters.LIKERT.FixationCross.ScreenRatio    = 0.10;          % ratio : dim   = ScreenWide *ratio_screen
Parameters.LIKERT.FixationCross.lineWidthRatio = 0.05;          % ratio : width = dim        *ratio_width
Parameters.LIKERT.FixationCross.Color          = [255 255 255]; % [R G B] ( from 0 to 255 )

% Likert scale
Parameters.LIKERT.Scale.ScreenRatio = 0.80;                              % ratio : dim = ScreenWide *ratio_screen
Parameters.LIKERT.Scale.Values      = {'0' '1' '2' '3' '4' '5' '6' '7'};
Parameters.LIKERT.Scale.ScaleColor  = [255 255 255];                     % [R G B] ( from 0 to 255 )
Parameters.LIKERT.Scale.CursorColor = [255 0   0  ];                     % [R G B] ( from 0 to 255 )
Parameters.LIKERT.Scale.Voffcet     = 0.40;                              % Ypos = (1-Voffcet)*ScreenHight
Parameters.LIKERT.Scale.Text_1      = 'J''aime';
Parameters.LIKERT.Scale.Text_2      = 'Je désire';

%%%%%%%%%%%%%%
%  Keybinds  %
%%%%%%%%%%%%%%

KbName('UnifyKeyNames');

Parameters.Keybinds.TTL_t_ASCII          = KbName('t'); % MRI trigger has to be the first defined key
% Parameters.Keybinds.emulTTL_s_ASCII      = KbName('s');
Parameters.Keybinds.Stop_Escape_ASCII    = KbName('ESCAPE');


switch S.Task
    
    case 'STOPSIGNAL'
        
        switch S.Environement
            
            case 'MRI'
                
                Parameters.Fingers.Left  = KbName('e'); % Index finger
                Parameters.Fingers.Right = KbName('b'); % Index finger

            case 'Practice'
                
                Parameters.Fingers.Left     = KbName('LeftArrow' );
                Parameters.Fingers.Right    = KbName('RightArrow');
                
        end
        
        Parameters.Fingers.Names = {'Left' 'Right'};
        
    case {'LIKERT' 'TryLikertScale' }
        
        switch S.Environement
            
            case 'MRI'
                
                switch S.Side
                    case 'Left'
                        Parameters.Fingers.Right    = KbName('e'); % Index finger
                        Parameters.Fingers.Validate = KbName('z'); % Middle finger
                        Parameters.Fingers.Left     = KbName('n'); % Ring finger
                    case 'Right'
                        Parameters.Fingers.Left     = KbName('b'); % Index finger
                        Parameters.Fingers.Validate = KbName('y'); % Middle finger
                        Parameters.Fingers.Right    = KbName('g'); % Ring finger
                end

            case 'Practice'
                
                Parameters.Fingers.Left     = KbName('LeftArrow' );
                Parameters.Fingers.Validate = KbName('DownArrow' );
                Parameters.Fingers.Right    = KbName('RightArrow');
                
        end
        
        Parameters.Fingers.Names = {'Left' 'Validate' 'Right'};

end


%% Echo in command window

EchoStop(mfilename)


end