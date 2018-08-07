%function to release liquid from a solenoid tap for a given number of
%seconds
%there are 4 solenoid taps, of which 3 are in use at the moment
function results = release_liquid(parameters, hardware, results, payout)
%calibration results
%follows equation y = mx + c
%y = amount of water, x is the length of the tap opening
%m = 1; %m is the gradient of the calibration curve
%c = 0; %c is the addec onstant of the calibration curve
simple_divider1 = 5.586; %want to calibrate this more carefully, but it should give accurate amounts of water
simple_divider2 = 5.843; %want to calibrate this more carefully, but it should give accurate amounts of water

%payout the budget tap (tap 1)
if strcmp(payout, 'budget')
    results.trial_results.budget_liquid = results.trial_results.remaining_budget * 1.2; %max budget is 1.2ml
    tap = 1;
    tap_open_time = calculate_open_time(results.trial_results.budget_liquid, tap);
    %tap_open_time = (results.trial_results.budget_liquid) / simple_divider1; %1.2ml = 0.25s
    display('budget');
    display(tap_open_time);

%payout the reward tap (depends on the monkey)
elseif strcmp(payout, 'reward')
    %MARIUS
%     if results.trial_results.reward > 0
%         results.trial_results.reward_liquid = ((results.trial_results.reward * 2) - 1) * 0.15;
%         if results.trial_results.reward == 1
%             results.trial_results.reward_liquid = 0.3;
%         end
%         %increments of 0.15ml of juice
%         %DELETE THESE LINES
% %         if results.trial_results.reward == 1
% %             results.trial_results.reward_liquid = 0.45;
% %         elseif results.trial_results.reward == 2
% %             results.trial_results.reward_liquid = 0.75;
% %         end
%         %DELETE HERE
    %ROB
%     if results.trial_results.reward > 0
%         results.trial_results.reward_liquid = ((results.trial_results.reward) * 0.2) + 0.05;
%         %if results.trial_results.reward == 1
%         %    results.trial_results.reward_liquid = 0.3;
%         %end

        
    if results.trial_results.reward > 0
        %results.trial_results.reward_liquid = 0.25 + (results.trial_results.reward - 1)*0.125; %ROB; MARIUS- 0.25, 0.375, 0.5
        %results.trial_results.reward_liquid = 0.2 + (results.trial_results.reward - 1)*0.1; %ROB- 0.2, 0.3, 0.4, 0.5, 0.6
        %results.trial_results.reward_liquid = 0.2 + (results.trial_results.reward - 1)*0.25; %ROB- 0.2, 0.45, 0.7
        %results.trial_results.reward_liquid = 0.2 + (results.trial_results.reward - 1)*0.4; %MARIUS- 0.2, 0.35, 0.5, 0.65, 0.8
        %results.trial_results.reward_liquid = 0.1 + (results.trial_results.reward - 1)*0.1; %ROB- 0.1, 0.2, 0.3
        
        %%%START UNCOMMENT
         results.trial_results.reward_liquid = 0.2 + (results.trial_results.reward - 1)*0.15; %ROB- 0.2, 0.35, 0.5...
%         %super dirty and quick prob stimuli
% %         if(results.trial_results.reward_liquid == 0.2)
% %             if round(rand)
% %                 results.trial_results.reward_liquid = 1;
% %                 disp('PAYOUT FULL ON PROB');
% %             else
% %                 results.trial_results.reward_liquid = 0;
% %                 disp('NO PAYOUT ON PROB');
% %             end
% %         end
        
        %%%END UNCOMMENT
        
        
%         results.trial_results.reward_liquid = 0.15 + (results.trial_results.reward - 1)*0.25;
%         if results.trial_results.reward == 5
%             results.trial_results.reward_liquid = 1.65;
%         else
%             results.trial_results.reward_liquid = 0.15 + (results.trial_results.reward - 1)*0.25;
%         end
          %results.trial_results.reward_liquid = 0.3 + (results.trial_results.reward - 1)*0.4;
    else
        results.trial_results.reward_liquid = 0;
        
    end
    tap_open_time = (results.trial_results.reward_liquid) / simple_divider2;
    if strcmp(parameters.save_info.primate, 'Ulysses')
        tap = 3;
    elseif strcmp(parameters.save_info.primate, 'Vicer')
        tap = 3;
    end
    if ~isfield(results.trial_results, 'reward_liquid')
        results.trial_results.reward_liquid = 0;
    end
    tap_open_time = calculate_open_time(results.trial_results.reward_liquid, tap);

%pays out a manually assigned tap via the GUI    
elseif strcmp(payout, 'test_tap')
    tap_open_time = hardware.outputs.settings.test_open_time;
    tap = hardware.outputs.settings.test_tap;
    display('opening test solenoid- n.b. results have been cleared');

%pays out a manually assigned tap via the GUI but 100x for calibration  
elseif strcmp(payout, 'calibrate')
    WaitSecs(5); %for calibration
    tap_open_time = hardware.outputs.settings.test_open_time;
    tap = hardware.outputs.settings.test_tap;
    display('opening test solenoid- n.b. results have been cleared');
end

if tap_open_time > 0
%chose which solenoid port to open (change to 1)
%there is a fourth solenoid but it isnt hooked up
if tap == 1 %water
    tap_open = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 2 %ulysses water reward tap
    tap_open = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 3 %vicer juice reward tap
    tap_open = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
else
    display('no other tap found!');
end

%open the tap
putvalue(hardware.outputs.reward_output, tap_open)

%wait with the tap open
WaitSecs(tap_open_time);

%close the tap
reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
putvalue(hardware.outputs.reward_output, reset)
end
%if calibrating, do this 99 more times
if strcmp(payout, 'calibrate')
for calibration_loop = 1:49
   %open the tap
    putvalue(hardware.outputs.reward_output, tap_open)

    %wait with the tap open
    WaitSecs(tap_open_time);

    %close the tap
    reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    putvalue(hardware.outputs.reward_output, reset)
    
    %wait a little each loop
    WaitSecs(0.05); %not really necessary but good to check its looping
    %properly
end
end
