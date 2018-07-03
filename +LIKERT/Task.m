function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = LIKERT.Planning;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybind logger
    
    [ ER, RR, KL, BR ] = Common.PrepareRecorders( EP, Parameters );
    
    
    %% Prepare objects
    
    Cross = LIKERT.Prepare.Cross;
    Scale = LIKERT.Prepare.Scale;
    [ Text_1 , Text_2 ] =  LIKERT.Prepare.Text;
    [ Image , List ]= LIKERT.Prepare.Image;
    Parameters.List = List;
    
    
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
                
            case 'FixationCross'
                
                fprintf( 'Cross : %ds \n' , Parameters.FixationCross )
                
                Cross.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr);
                
                ER.AddEvent({EP.Data{evt,1} TIME-StartTime []});
                RR.AddEvent({['FixationCross__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                when = TIME + Parameters.FixationCross - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
                    % Fetch keys
                    [keyIsDown, TIME, keyCode] = KbCheck;
                    
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
                
                
            otherwise % --------------------------------
                
                % Echo in the command window
                fprintf('#%3d/%.3d %16s ', ...
                    EP.Data{evt,4}, Parameters.NrPics , EP.Data{evt,1} )
                
                
                %% Preparation cross
                
                Cross.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr);
                ER.AddEvent({EP.Data{evt,1} TIME-StartTime []});
                RR.AddEvent({['PreparationCross__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                when = TIME + Parameters.PreparePeriod - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
                    % Fetch keys
                    [keyIsDown, TIME, keyCode] = KbCheck;
                    
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
                TIME = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['BlankScreen__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                when = TIME + Parameters.BlankPeriod - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
                    % Fetch keys
                    [keyIsDown, TIME, keyCode] = KbCheck;
                    
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
                
                % Screen('FillRect', S.PTB.wPtr, rand(1,3)*255, CenterRectOnPoint([0 0 500 500],S.PTB.CenterH,S.PTB.CenterV));
                Image.(EP.Data{evt,1}).Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['Picture__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                if size(Image.(EP.Data{evt,1}).X,1) > 768
                    0
                end
                
                when = TIME + EP.Get( 'Picture', evt ) - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
                    % Fetch keys
                    [keyIsDown, TIME, keyCode] = KbCheck;
                    
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
                
                
                %% Likert 1 : J'aime
                
                % Pick a random value around the half of the scale
                Scale.cursor_pos_value = (4-3)*rand + 3 ; % values must be in [3 - 4]
                if abs( Scale.cursor_pos_value - 3.5 ) < 0.1
                    Scale.cursor_pos_value = Scale.cursor_pos_value + sign(rand-0.5)*0.2;
                end
                Scale.cursor_pos_px    = Scale.value2px( Scale.cursor_pos_value );
                Scale.UpdateCursor(0);
                
                Scale.Draw
                Text_1.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['Likert__1__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                button_press = 0;
                dpx = 0;
                % -S.PTB.slack*3 : 1 frame in advance, to keep a reliable timing on the Hold period if no validation
                when = TIME + Parameters.LikertDuration -S.PTB.IFI -S.PTB.slack ;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
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
                            BR.AddEvent({EP.Data{evt,1} round((TIME-TIME)*1000) Scale.cursor_pos_value})
                            RR.AddEvent({['Click__' EP.Data{evt,1}] TIME-StartTime [] []})
                            button_press = 1;
                            fprintf(' %4.dms %1.1f ', BR.Data{BR.EventCount,2} , BR.Data{BR.EventCount,3} )
                            break
                        end
                        
                        Scale.UpdateCursor( dpx )
                        
                    else
                        
                        dpx = 0;
                        
                    end
                    
                    Scale.Draw
                    Text_1.Draw
                    
                    Screen('DrawingFinished',S.PTB.wPtr);
                    TIME = Screen('Flip',S.PTB.wPtr);
                    
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% Hold__1
                
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr);
                RR.AddEvent({['Hold__1__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                if ~button_press
                    BR.AddEvent({EP.Data{evt,1} -1 Scale.cursor_pos_value})
                    fprintf(' %4.dms %1.1f ', BR.Data{BR.EventCount,2} , BR.Data{BR.EventCount,3} )
                end
                
                when = TIME + Parameters.HoldPeriod -S.PTB.IFI -S.PTB.slack ;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
                    % Fetch keys
                    [keyIsDown, TIME, keyCode] = KbCheck;
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
                
                
                %% Likert 2 : Je désire
                
                % Pick a random value around the half of the scale
                Scale.cursor_pos_value = (4-3)*rand + 3 ; % values must be in [3 - 4]
                if abs( Scale.cursor_pos_value - 3.5 ) < 0.1
                    Scale.cursor_pos_value = Scale.cursor_pos_value + sign(rand-0.5)*0.2;
                end
                Scale.cursor_pos_px = Scale.value2px( Scale.cursor_pos_value );
                Scale.UpdateCursor(0);
                
                Scale.Draw
                Text_2.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr, when);
                RR.AddEvent({['Likert__2__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                button_press = 0;
                dpx = 0;
                % -S.PTB.slack*3 : 1 frame in advance, to keep a reliable timing on the Hold period if no validation
                when = TIME + Parameters.LikertDuration -S.PTB.IFI -S.PTB.slack ;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
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
                            BR.AddEvent({EP.Data{evt,1} round((TIME-TIME)*1000) Scale.cursor_pos_value})
                            RR.AddEvent({['Click__' EP.Data{evt,1}] TIME-StartTime [] []})
                            button_press = 1;
                            fprintf(' %4.dms %1.1f ', BR.Data{BR.EventCount,2} , BR.Data{BR.EventCount,3} )
                            break
                        end
                        
                        Scale.UpdateCursor( dpx )
                        
                    else
                        
                        dpx = 0;
                        
                    end
                    
                    Scale.Draw
                    Text_2.Draw
                    
                    Screen('DrawingFinished',S.PTB.wPtr);
                    TIME = Screen('Flip',S.PTB.wPtr);
                    
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                %% Hold__2
                
                Screen('DrawingFinished',S.PTB.wPtr);
                TIME = Screen('Flip',S.PTB.wPtr);
                RR.AddEvent({['Hold__2__' EP.Data{evt,1}] TIME-StartTime [] []})
                
                if ~button_press
                    BR.AddEvent({EP.Data{evt,1} -1 Scale.cursor_pos_value})
                    fprintf(' %4.dms %1.1f ', BR.Data{BR.EventCount,2} , BR.Data{BR.EventCount,3} )
                end
                
                when = TIME + Parameters.HoldPeriod -S.PTB.IFI -S.PTB.slack ;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while TIME < when
                    
                    % Fetch keys
                    [keyIsDown, TIME, keyCode] = KbCheck;
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
    
    
    %% End of stimulation
    
    for img = 1 : size(Parameters.List,1)
         Screen('Close', Image.(Parameters.List{img,1}).texPtr );
    end
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    TaskData.Parameters = Parameters;
    
    TaskData.BR = BR;
    assignin('base','BR', BR)
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
