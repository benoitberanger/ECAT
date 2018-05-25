function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = STOPSIGNAL.Planning;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybinf logger
    
    [ ER, RR, KL, BR ] = Common.PrepareRecorders( EP );
    
    
    %% Prepare objects
    
    Circle = STOPSIGNAL.Prepare.Circle;
    Arrow  = STOPSIGNAL.Prepare.Arrow(Circle);
    Bip    = STOPSIGNAL.Prepare.Bip;
    
    
    %% Eyelink
    
    Common.StartRecordingEyelink
    
    
    %% Go
    
    % Initialize some variables
    EXIT = 0;
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        % Common.CommandWindowDisplay( EP, evt );
        
        switch EP.Data{evt,1}
            
            case 'StartTime' % --------------------------------------------
                
                Circle.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                Screen('Flip',S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
            case {'Go_Left','Go_Right','Stop_Left','Stop_Right'} % --------------------------------
                
                % Echo in the command window
                fprintf('#%3d/%.3d %4s %5s %3gms \n', ...
                    EP.Data{evt,4},size(EP.Data,1), EP.Data{evt,5}, EP.Data{evt,6}, EP.Data{evt,8} )
                
                button_press = 0;
                
                current_ssd = EP.Get('StopSignalDelay',evt);
                
                
                %% Circle
                
                Circle.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, StartTime + EP.Data{evt,2} - S.PTB.slack);
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime []});
                RR.AddEvent({['Circle__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                
                when = lastFlipOnset + Parameters.PreparePeriod - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% Circle + Arrow
                
                Circle.Draw
                Arrow.Draw(EP.Get('Left/Right',evt))
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, when);
                
                RR.AddEvent({['Arrow__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                
                %% SSD ?
                
                switch EP.Get('Go/Stop',evt)
                    
                    case 'Go'
                        
                        when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        secs = lastFlipOnset;
                        while secs < when
                            
                            % Fetch keys
                            [keyIsDown, secs, keyCode] = KbCheck;
                            if keyIsDown
                                
                                % ~~~ ESCAPE key ? ~~~
                                [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                                if EXIT
                                    break
                                end
                                
                                if ~button_press && any(keyCode([S.Parameters.Fingers.Left S.Parameters.Fingers.Right ]))
                                    side = S.Parameters.Fingers.Names{find(keyCode([S.Parameters.Fingers.Left S.Parameters.Fingers.Right]))}; %#ok<FNDSB>
                                    BR.AddEvent({EP.Data{evt,1} EP.Get('Go/Stop',evt) EP.Get('Left/Right',evt) current_ssd round((secs-lastFlipOnset)*1000) side })
                                    RR.AddEvent({['Click__' EP.Data{evt,1}] secs-StartTime [] []})
                                    button_press = 1;
                                    break
                                end
                                
                            end
                            
                        end % while
                        if EXIT
                            break
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                    case 'Stop'
                        
                        when = lastFlipOnset + current_ssd/1000 - S.PTB.anticipation;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        secs = lastFlipOnset;
                        while secs < when
                            
                            % Fetch keys
                            [keyIsDown, secs, keyCode] = KbCheck;
                            if keyIsDown
                                
                                % ~~~ ESCAPE key ? ~~~
                                [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                                if EXIT
                                    break
                                end
                                
                                if ~button_press && any(keyCode([S.Parameters.Fingers.Left S.Parameters.Fingers.Right ]))
                                    side = S.Parameters.Fingers.Names{find(keyCode([S.Parameters.Fingers.Left S.Parameters.Fingers.Right]))}; %#ok<FNDSB>
                                    BR.AddEvent({EP.Data{evt,1} EP.Get('Go/Stop',evt) EP.Get('Left/Right',evt) current_ssd round((secs-lastFlipOnset)*1000) side})
                                    RR.AddEvent({['Click__' EP.Data{evt,1}] secs-StartTime [] []})
                                    button_press = 1;
                                    break
                                end
                                
                            end
                            
                        end % while
                        if EXIT
                            break
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        ssd_onset = Bip.Playback( when);
                        RR.AddEvent({['SSD__' EP.Data{evt,1}] ssd_onset-StartTime [] []})
                        
                        when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        secs = lastFlipOnset;
                        while secs < when
                            
                            % Fetch keys
                            [keyIsDown, secs, keyCode] = KbCheck;
                            if keyIsDown
                                
                                % ~~~ ESCAPE key ? ~~~
                                [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                                if EXIT
                                    break
                                end
                                
                                if ~button_press && any(keyCode([S.Parameters.Fingers.Left S.Parameters.Fingers.Right ]))
                                    side = S.Parameters.Fingers.Names{find(keyCode([S.Parameters.Fingers.Left S.Parameters.Fingers.Right]))}; %#ok<FNDSB>
                                    BR.AddEvent({EP.Data{evt,1} EP.Get('Go/Stop',evt) EP.Get('Left/Right',evt) current_ssd round((secs-lastFlipOnset)*1000) side})
                                    RR.AddEvent({['Click__' EP.Data{evt,1}] secs-StartTime [] []})
                                    button_press = 1;
                                    break
                                end
                                
                            end
                            
                        end % while
                        if EXIT
                            break
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                end
                
                
                %% Hold
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr);
                RR.AddEvent({['Hold__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                if ~button_press
                    BR.AddEvent({EP.Data{evt,1} EP.Get('Go/Stop',evt) EP.Get('Left/Right',evt) current_ssd -1 ''})
                    if strcmp(EP.Get('Go/Stop',evt),'Stop')
                        STOPSIGNAL.AdjustSSD( EP, evt, 'up', Parameters.StepSize )
                    end
                else
                    if strcmp(EP.Get('Go/Stop',evt),'Stop')
                        STOPSIGNAL.AdjustSSD( EP, evt, 'down', Parameters.StepSize )
                    end
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyIsDown
                        
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                        
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    
    %% End of stimulation
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    TaskData.Parameters = Parameters;
    
    TaskData.BR = BR;
    assignin('base','BR', BR)
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
