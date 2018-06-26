function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = TryLikertScale.Planning;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybind logger
    
    [ ER, RR, KL, BR ] = Common.PrepareRecorders( EP, Parameters );
    
    
    %% Prepare objects
    
    Cross = LIKERT.Prepare.Cross;
    Scale = LIKERT.Prepare.Scale;
    [ Text_Target , Text_Cursor ] =  TryLikertScale.Prepare.Text;
    
    
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
                
                
            otherwise % --------------------------------
                
                % Echo in the command window
                fprintf('#%3d/%.3d %s ', ...
                    EP.Data{evt,4}, size(EP.Data,1) , EP.Data{evt,1} )
                
                
                %% Preparation cross
                
                Cross.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr);
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime []});
                RR.AddEvent({['PreparationCross__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
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
                
                
                %% Likert : Target value
                
                % Pick a random value around the half of the scale
                Scale.cursor_pos_value = (4-3)*rand + 3 ; % values must be in [3 - 4]
                if abs( Scale.cursor_pos_value - 3.5 ) < 0.1
                    Scale.cursor_pos_value = Scale.cursor_pos_value + sign(rand-0.5)*0.2;
                end
                Scale.cursor_pos_px = Scale.value2px( Scale.cursor_pos_value );
                Scale.UpdateCursor(0);
                
                Scale.Draw
                Text_Target.content = num2str(EP.Data{evt,1});
                Text_Target.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['Likert__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                button_press = 0;
                dpx = 0;
                % -S.PTB.slack*3 : 1 frame in advance, to keep a reliable timing on the Hold period if no validation
                when = lastFlipOnset + Parameters.LikertDuration -S.PTB.IFI -S.PTB.slack ;
                secs = lastFlipOnset;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                        
                        if keyCode( S.Parameters.Fingers.Validate )
                            BR.AddEvent({EP.Data{evt,1} round((secs-lastFlipOnset)*1000) Scale.cursor_pos_value})
                            RR.AddEvent({['Click__' EP.Data{evt,1}] secs-StartTime [] []})
                            button_press = 1;
                            fprintf(' %4.dms %1.1f ', BR.Data{BR.EventCount,2} , BR.Data{BR.EventCount,3} )
                            break
                        end
                        
                        Scale.UpdateCursor( dpx )
                        
                    else
                        
                        dpx = 0;
                        
                    end
                    
                    Scale.Draw
                    Text_Target.Draw
                    
                    Screen('DrawingFinished',S.PTB.wPtr);
                    secs = Screen('Flip',S.PTB.wPtr);
                    
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% Show result
                
                Scale.Draw
                Text_Target.Draw
                Text_Cursor.content = num2str( round(10*Scale.cursor_pos_value)/10 );
                Text_Cursor.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr);
                RR.AddEvent({['ShowResult__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                if ~button_press
                    BR.AddEvent({EP.Data{evt,1} -1 Scale.cursor_pos_value})
                    fprintf(' %4.dms %1.1f ', BR.Data{BR.EventCount,2} , BR.Data{BR.EventCount,3} )
                end
                
                when = lastFlipOnset + Parameters.ShowResult - S.PTB.slack;
                secs = lastFlipOnset;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                
                
                fprintf('\n')
                
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    Cross.Draw
    
    Screen('DrawingFinished',S.PTB.wPtr);
    Screen('Flip',S.PTB.wPtr);
    
    
    %% End of stimulation
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    TaskData.Parameters = Parameters;
    
    TaskData.BR = BR;
    assignin('base','BR', BR)
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
