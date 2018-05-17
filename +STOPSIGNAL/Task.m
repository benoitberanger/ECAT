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
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
            case {'Go_Left','Go_Right','Stop_Left','Stop_Right'} % --------------------------------
                
                % Echo in the command window
                fprintf('#%3d cond=%4s side=%5s ssd=%3gms \n', ...
                    EP.Data{evt,4}, EP.Data{evt,5}, EP.Data{evt,6}, EP.Data{evt,8} )
                
                
                %% Circle
                
                Circle.Draw
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, StartTime + EP.Data{evt,2} - S.PTB.slack);
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime []});
                RR.AddEvent({['Circle__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                
                %% Circle + Arrow
                
                Circle.Draw
                Arrow.Draw(EP.Get('Left/Right',evt))
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, lastFlipOnset + Parameters.PreparePeriod - S.PTB.slack);
                
                RR.AddEvent({['Arrow__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                
                %% SSD ?
                
                switch EP.Get('Go/Stop',evt)
                    
                    case 'Go'
                        % pass
                    case 'Stop'
                        ssd_onset = Bip.Playback( lastFlipOnset + EP.Get('StopSignalDelay',evt)/1000 );
                        RR.AddEvent({['SSD__' EP.Data{evt,1}] ssd_onset-StartTime [] []})
                end
                
                
                %% Hold
                
                Screen('DrawingFinished',S.PTB.wPtr);
                lastFlipOnset = Screen('Flip',S.PTB.wPtr, lastFlipOnset + Parameters.HoldPeriod + EP.Get('jitter',evt) - S.PTB.IFI);
                RR.AddEvent({['Hold__' EP.Data{evt,1}] lastFlipOnset-StartTime [] []})
                
                
                %%
                
%                 %% ~~~ Step 0 : Jitter between trials ~~~
%                 
%                 step0Running  = 1;
%                 counter_step0 = 0;
%                 
%                 while step0Running
%                     
%                     counter_step0 = counter_step0 + 1;
%                     
%                     Circle.Draw
%                     Cross.Draw
%                     STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                     
%                     Screen('DrawingFinished',S.PTB.wPtr);
%                     lastFlipOnset = Screen('Flip',S.PTB.wPtr);
%                     SR.AddSample([lastFlipOnset-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                     
%                     % Record trial onset & step onset
%                     if counter_step0 == 1
%                         ER.AddEvent({EP.Data{evt,1}              lastFlipOnset-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                         RR.AddEvent({['Jitter__' EP.Data{evt,1}] lastFlipOnset-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                         step0onset = lastFlipOnset;
%                     end
%                     
%                     if lastFlipOnset >= step0onset + EP.Data{evt,8}
%                         step0Running = 0;
%                     end
%                     
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     % Fetch keys
%                     [keyIsDown, ~, keyCode] = KbCheck;
%                     if keyIsDown
%                         % ~~~ ESCAPE key ? ~~~
%                         [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
%                         if EXIT
%                             break
%                         end
%                     end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     
%                 end % while : step 0
%                 
%                 if EXIT
%                     break
%                 end
%                 
%                 
%                 %% ~~~ Step 1 : Draw target @ big ring ~~~
%                 
%                 Circle.Draw
%                 Cross.Draw
%                 
%                 Target.frameCurrentColor = Target.frameBaseColor;
%                 Target.Move( TargetBigCirclePosition, EP.Get('Target',evt) )
%                 Target.value = EP.Get('Probability',evt);
%                 Target.valueCurrentColor = GetColor(Target.value);
%                 Target.Draw
%                 
%                 PrevTarget.frameCurrentColor = Red;
%                 PrevTarget.Move( 0, 0 )
%                 PrevTarget.Draw
%                 
%                 STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                 
%                 Screen('DrawingFinished',S.PTB.wPtr);
%                 flipOnset_step_1 = Screen('Flip',S.PTB.wPtr);
%                 SR.AddSample([flipOnset_step_1-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                 RR.AddEvent({['Draw@Ring__' EP.Data{evt,1}] flipOnset_step_1-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                 
%                 
%                 %% ~~~ Step 2 : User moves cursor to target @ big ring  ~~~
%                 
%                 startCursorInTarget = [];
%                 step2Running        = 1;
%                 
%                 draw_PrevTraget      = 1;
%                 has_already_traveled = 0;
%                 
%                 frame_start = SR.SampleCount;
%                 
%                 counter_step1 = 0;
%                 
%                 while step2Running
%                     
%                     counter_step1 = counter_step1 + 1;
%                     
%                     Circle.Draw
%                     Cross.Draw
%                     Target.Draw
%                     if draw_PrevTraget
%                         PrevTarget.Draw
%                     end
%                     STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                     Cursor.Draw
%                     
%                     Screen('DrawingFinished',S.PTB.wPtr);
%                     lastFlipOnset = Screen('Flip',S.PTB.wPtr);
%                     SR.AddSample([lastFlipOnset-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                     
%                     % Record step onset
%                     if counter_step1 == 1
%                         RR.AddEvent({['Move@Ring__' EP.Data{evt,1}] lastFlipOnset-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                     end
%                     
%                     % Is cursor center in the previous target (@ center) ?
%                     if     STOPSIGNAL.IsOutside(Cursor,PrevTarget) &&  draw_PrevTraget % yes
%                     elseif STOPSIGNAL.IsOutside(Cursor,PrevTarget) && ~draw_PrevTraget % back inside
%                     elseif draw_PrevTraget % just outside
%                         PrevTarget.frameCurrentColor = PrevTarget.frameBaseColor;
%                         draw_PrevTraget = 0;
%                         ReactionTimeOUT = lastFlipOnset - flipOnset_step_1;
%                     else
%                     end
%                     
%                     % Is cursor center in target ?
%                     if STOPSIGNAL.IsInside(Cursor,Target) % yes
%                         
%                         Target.frameCurrentColor = Green;
%                         
%                         if isempty(startCursorInTarget) % Cursor has just reached the target
%                             
%                             startCursorInTarget = lastFlipOnset;
%                             
%                             if ~has_already_traveled
%                                 TravelTimeOUT = lastFlipOnset - flipOnset_step_1 - ReactionTimeOUT;
%                                 has_already_traveled = 1;
%                             end
%                             
%                         elseif lastFlipOnset >= startCursorInTarget + Parameters.TimeSpentOnTargetToValidate % Cursor remained in the target long enough
%                             step2Running = 0;
%                         end
%                         
%                     else % no, then reset
%                         startCursorInTarget = []; % reset
%                         Target.frameCurrentColor = Target.frameBaseColor;
%                     end
%                     
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     % Fetch keys
%                     [keyIsDown, ~, keyCode] = KbCheck;
%                     if keyIsDown
%                         % ~~~ ESCAPE key ? ~~~
%                         [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
%                         if EXIT
%                             break
%                         end
%                     end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     
%                 end % while : Setp 2
%                 
%                 Target.frameCurrentColor = Target.frameBaseColor;
%                 frame_stop = SR.SampleCount;
%                 
%                 if EXIT
%                     break
%                 else
%                     OutRecorder.AddSample([EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,8} EP.Data{evt,6} EP.Data{evt,9} EP.Data{evt,7} frame_start frame_stop round(ReactionTimeOUT*1000) round(TravelTimeOUT*1000)])
%                 end
%                 
%                 
%                 %% ~~~ Step 3 : Draw target @ center ~~~
%                 
%                 Circle.Draw
%                 Cross.Draw
%                 
%                 Target.frameCurrentColor = Target.frameBaseColor;
%                 Target.Move(0,0)
%                 Target.value = 0;
%                 Target.valueCurrentColor = Target.diskCurrentColor;
%                 Target.Draw
%                 
%                 PrevTarget.frameCurrentColor = Red;
%                 PrevTarget.Move( TargetBigCirclePosition, EP.Get('Target',evt)  )
%                 
%                 STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                 Cursor.Draw
%                 
%                 Screen('DrawingFinished',S.PTB.wPtr);
%                 flipOnset_step_3 = Screen('Flip',S.PTB.wPtr);
%                 SR.AddSample([flipOnset_step_3-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                 RR.AddEvent({['Draw@Center__' EP.Data{evt,1}] flipOnset_step_3-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                 
%                 
%                 %% ~~~ Step 4 : User moves cursor to target @ center ~~~
%                 
%                 startCursorInTarget = [];
%                 step4Running        = 1;
%                 
%                 draw_PrevTraget      = 1;
%                 has_already_traveled = 0;
%                 
%                 frame_start = SR.SampleCount;
%                 
%                 counter_step4 = 0;
%                 
%                 while step4Running
%                     
%                     counter_step4 = counter_step4 + 1;
%                     
%                     Circle.Draw
%                     Cross.Draw
%                     Target.Draw
%                     STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                     Cursor.Draw
%                     
%                     Screen('DrawingFinished',S.PTB.wPtr);
%                     lastFlipOnset = Screen('Flip',S.PTB.wPtr);
%                     SR.AddSample([lastFlipOnset-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                     
%                     % Record step onset
%                     if counter_step4 == 1
%                         RR.AddEvent({['Move@Center__' EP.Data{evt,1}] lastFlipOnset-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                     end
%                     
%                     % Is cursor center in the previous target (@ ring) ?
%                     if     STOPSIGNAL.IsOutside(Cursor,PrevTarget) &&  draw_PrevTraget % yes
%                     elseif STOPSIGNAL.IsOutside(Cursor,PrevTarget) && ~draw_PrevTraget % back inside
%                     elseif draw_PrevTraget % just outside
%                         PrevTarget.frameCurrentColor = PrevTarget.frameBaseColor;
%                         draw_PrevTraget = 0;
%                         ReactionTimeIN = lastFlipOnset - flipOnset_step_3;
%                     else
%                     end
%                     
%                     % Is cursor center in target ?
%                     if STOPSIGNAL.IsInside(Cursor,Target) % yes
%                         
%                         Target.frameCurrentColor = Green;
%                         
%                         if isempty(startCursorInTarget) % Cursor has just reached the target
%                             
%                             startCursorInTarget = lastFlipOnset;
%                             
%                             if ~has_already_traveled
%                                 TravelTimeIN = lastFlipOnset - flipOnset_step_3 - ReactionTimeIN;
%                                 has_already_traveled = 1;
%                             end
%                             
%                         elseif lastFlipOnset >= startCursorInTarget + Parameters.TimeSpentOnTargetToValidate % Cursor remained in the target long enough
%                             step4Running = 0;
%                         end
%                         
%                     else % no, then reset
%                         startCursorInTarget = []; % reset
%                         Target.frameCurrentColor = Target.frameBaseColor;
%                     end
%                     
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     % Fetch keys
%                     [keyIsDown, ~, keyCode] = KbCheck;
%                     if keyIsDown
%                         % ~~~ ESCAPE key ? ~~~
%                         [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
%                         if EXIT
%                             break
%                         end
%                     end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     
%                 end % while : Setp 4
%                 
%                 Target.frameCurrentColor = Target.frameBaseColor;
%                 frame_stop = SR.SampleCount;
%                 
%                 if EXIT
%                     break
%                 else
%                     InRecorder.AddSample([EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,8} EP.Data{evt,6} EP.Data{evt,9} EP.Data{evt,7} frame_start frame_stop round(ReactionTimeIN*1000) round(TravelTimeIN*1000)])
%                 end
%                 
%                 
%                 %% ~~~ Step 5 : Pause before dislpay of the reward ~~~
%                 
%                 step5Running  = 1;
%                 counter_step5 = 0;
%                 
%                 while step5Running
%                     
%                     counter_step5 = counter_step5 + 1;
%                     
%                     Circle.Draw
%                     Cross.Draw
%                     STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                     
%                     Screen('DrawingFinished',S.PTB.wPtr);
%                     lastFlipOnset = Screen('Flip',S.PTB.wPtr);
%                     SR.AddSample([lastFlipOnset-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                     
%                     % Record trial onset & step onset
%                     if counter_step5 == 1
%                         RR.AddEvent({['preReward__' EP.Data{evt,1}] lastFlipOnset-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                         step5onset = lastFlipOnset;
%                     end
%                     
%                     if lastFlipOnset >= step5onset +Parameters.RewardDisplayTime
%                         step5Running = 0;
%                     end
%                     
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     % Fetch keys
%                     [keyIsDown, ~, keyCode] = KbCheck;
%                     if keyIsDown
%                         % ~~~ ESCAPE key ? ~~~
%                         [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
%                         if EXIT
%                             break
%                         end
%                     end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     
%                 end % while : step 5
%                 
%                 
%                 %% ~~~ Step 6 : Show reward ~~~
%                 
%                 step6Running  = 1;
%                 counter_step6 = 0;
%                 
%                 while step6Running
%                     
%                     counter_step6 = counter_step6 + 1;
%                     
%                     Circle.Draw
%                     Reward.Draw(EP.Get('rewarded',evt) );
%                     STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%                     
%                     Screen('DrawingFinished',S.PTB.wPtr);
%                     lastFlipOnset = Screen('Flip',S.PTB.wPtr);
%                     SR.AddSample([lastFlipOnset-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
%                     
%                     % Record trial onset & step onset
%                     if counter_step6 == 1
%                         RR.AddEvent({['Reward__' EP.Data{evt,1}] lastFlipOnset-StartTime [] EP.Data{evt,4} EP.Data{evt,5} EP.Data{evt,6} EP.Data{evt,7} EP.Data{evt,8} EP.Data{evt,9} EP.Data{evt,10} })
%                         step6onset = lastFlipOnset;
%                     end
%                     
%                     if lastFlipOnset >= step6onset +Parameters.RewardDisplayTime
%                         step6Running = 0;
%                     end
%                     
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     % Fetch keys
%                     [keyIsDown, ~, keyCode] = KbCheck;
%                     if keyIsDown
%                         % ~~~ ESCAPE key ? ~~~
%                         [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
%                         if EXIT
%                             break
%                         end
%                     end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     
%                 end % while : step 6
%                 
%                 if EXIT
%                     break
%                 end
%                 
%                 
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
%     % "The end"
%     Circle.Draw
%     Cross.Draw
%     STOPSIGNAL.UpdateCursor(Cursor, EP.Get('Deviation',evt))
%     Screen('DrawingFinished',S.PTB.wPtr);
%     lastFlipOnset = Screen('Flip',S.PTB.wPtr);
%     SR.AddSample([lastFlipOnset-StartTime Cursor.X Cursor.Y Cursor.R Cursor.Theta])
    
    
    %% End of stimulation
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    TaskData.Parameters = Parameters;

    TaskData.BR = BR;
    assignin('base','BR', BR)
        
    
catch err
    
    Common.Catch( err );
    
end

end % function
