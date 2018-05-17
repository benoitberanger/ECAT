function bip = Bip
global S

%% Parameters

fs  = S.Parameters.Audio.SamplingRate;
f0  = S.Parameters.STOPSIGNAL.Bip.Freq;
dur = S.Parameters.STOPSIGNAL.Bip.BipDuration;
iof = S.Parameters.STOPSIGNAL.Bip.InOutFadeRation;


%% Create objects

bip = Bip( fs , f0 , dur , iof );
bip. LinkToPAhandle( S.PTB.Playback_pahandle );
bip.AssertReadyForPlayback; % just to check


end % function
