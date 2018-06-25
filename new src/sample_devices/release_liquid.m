%function to release liquid from a solenoid tap for a given number of
%seconds
%there are 4 solenoid taps, of which 3 are in use at the moment
function release_liquid(parameters, modifiers, hardware, results, payout)

%payout the budget tap (tap 1)
if strcmp(payout, 'budget')
    %calculate the budget liquid to release
    results.output.budget_liquid = results.output.budget * modifiers.budget.magnitude;
    %calculate the tap open time via the calibration
    tap_open_time = (results.trial_results.budget_liquid) / simple_divider1;
    tap = hardware.solenoid.release.budget_tap;

%payout the reward tap (depends on the monkey)
elseif strcmp(payout, 'reward')
    if results.trial_results.reward > 0
        results.output.reward_liquid = modifiers.fractals.magnitude_vector(results.trial_results.reward); %increments of 0.15ml of juice
    else
        results.output.reward_liquid = 0;
    end
    tap_open_time = (results.output.reward_liquid) / simple_divider2;
    tap = hardware.solenoid.release.reward_tap;
    end

%pays out a manually assigned tap via the GUI    
elseif strcmp(payout, 'test_tap')
    tap_open_time = hardware.solenoid.calibration.open_time;
    tap = hardware.solenoid.calibration.test_tap;
    disp('opening test solenoid');

%pays out a manually assigned tap via the GUI but 100x for calibration  
elseif strcmp(payout, 'calibrate')
    WaitSecs(5); %for calibration
    tap_open_time = hardware.solenoid.calibration.open_time;
    tap = hardware.solenoid.calibration.test_tap;
    disp('opening test solenoid');

%pays out a some free juice/water    
elseif strcmp(payout, 'test_tap')
    tap_open_time = hardware.solenoid.calibration.open_time;
    tap = hardware.solenoid.calibration.test_tap;
    disp('opening test solenoid');

end

%chose which solenoid port to open (change to 1)
%there is a fourth solenoid but it isnt hooked up
if tap == 1 %water
    tap_open = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 2 %ulysses water reward tap
    tap_open = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 3 %vicer juice reward tap
    tap_open = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
else
    disp('no other tap found!');
end

%open the tap
putvalue(hardware.outputs.reward_output, tap_open)

%wait with the tap open
WaitSecs(tap_open_time);

%close the tap
reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
putvalue(hardware.outputs.reward_output, reset)

%if calibrating, do this x more times
if strcmp(payout, 'calibrate')
    for calibration_loop = 1:hardware.solenoid.calibration.spurt_repeats
       %open the tap
        putvalue(hardware.outputs.reward_output, tap_open)

        %wait with the tap open
        WaitSecs(tap_open_time);

        %close the tap
        reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        putvalue(hardware.outputs.reward_output, reset)

        %wait a little each loop
        WaitSecs(0.05); 
        %not really necessary but good to check its looping properly
    end
end
