function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = LIKERT.Planning;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybinf logger
    
    [ ER, RR, KL, BR ] = Common.PrepareRecorders( EP );
    
    
    %% Prepare objects
    
    Cross = LIKERT.Prepare.Cross;
    Scale = LIKERT.Prepare.Scale;
    
    
    %% Eyelink
    
    Common.StartRecordingEyelink
    
    
    %% Go
    
    % Initialize some variables
    EXIT = 0;
    dpx_lim = Scale.width/20;
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        % Common.CommandWindowDisplay( EP, evt );
        
        switch EP.Data{evt,1}
            
            case 'StartTime' % --------------------------------------------
                
                Cross.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                Screen('Flip',S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
            case {'pic'} % --------------------------------
                
                % Echo in the command window
                fprintf('#%3d/%.3d \n', ...
                    EP.Data{evt,4},size(EP.Data,1) )
                
                
                %% Fixation cross
                
                Cross.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, StartTime + EP.Data{evt,2} - S.PTB.slack);
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime []});
                RR.AddEvent({['FixationCross__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
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
                
                
                %% Blank screen
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['BlankScreen__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                when = lastFlipOnset + Parameters.BlankPeriod - S.PTB.slack;
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
                
                
                %% Picture
                
                Screen('FillRect', S.PTB.wPtr, rand(1,3)*255, CenterRectOnPoint([0 0 500 500],S.PTB.CenterH,S.PTB.CenterV));
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['Picture__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                when = lastFlipOnset + Parameters.PictureDuration - S.PTB.slack;
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
                
                
                %% Likert
                
                Scale.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['Likert__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                Scale.cursor_pos_value = rand + ( str2double(Scale.values{1}) + str2double(Scale.values{end}) ) / 2;
                Scale.cursor_pos_px    = Scale.value2px( Scale.cursor_pos_value );
                Scale.UpdateCursor(0);
                
                
                dpx = 0;
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    % Fetch keys
                    [keyIsDown, ~, keyCode] = KbCheck;
                    
                    if keyIsDown
                        
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                        
                        if keyCode( S.Parameters.Fingers.Left )
                            dpx = dpx - 1;
                            dpx = max( dpx , -dpx_lim );
                        end
                        
                        if keyCode( S.Parameters.Fingers.Right )
                            dpx = dpx + 1;
                            dpx = min( dpx , +dpx_lim );
                        end
                        
                        Scale.UpdateCursor( dpx )
                        
                    else
                        
                        dpx = 0;
                        
                    end
                    
                    Scale.Draw
                    
                    Screen('DrawingFinished',S.PTB.wPtr);
                    secs = Screen('Flip',S.PTB.wPtr);
                    
                    
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
