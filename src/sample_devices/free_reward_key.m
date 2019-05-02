function [hardware, open_float] = free_reward_key(hardware, parameters, open_float)
%set open float free reward to zero if first pass
if ~isfield(open_float, 'trial_free_reward')
    open_float.trial_free_reward = 0;
end

%check if the free reward button has been pressed
[keyIsDown, keyTime, keyCode] = KbCheck;
%get the time of the press run
reward_press_time = GetSecs();

if keyIsDown
    %only works at most once every 1 seconds
    if reward_press_time - hardware.solenoid.release.last_free_reward < 1
        %in reality this spams the console because key presses last longer
        %than one refresh
        %disp('too soon since last key press');
    else
        %output message
        disp(strcat('releasing ', num2str(hardware.solenoid.release.free_amount), 'ml of ', hardware.solenoid.release.free_liquid, ' for free'));
        %update to the new time
        hardware.solenoid.release.last_free_reward = reward_press_time;
        
        if strcmp(hardware.solenoid.release.free_liquid, 'juice')
            tap = hardware.solenoid.release.reward_tap;
        elseif strcmp(hardware.solenoid.release.free_liquid, 'water')
            tap = hardware.solenoid.release.budget_tap;
        end
        
        %calculate the open time of the tap
        open_float.tap_open_time = calculate_open_time(tap, hardware.solenoid.release.free_amount);
        
        %get the right tap bit to open
        if tap == 1 %water
            open_float.tap_to_open = 18;
        elseif tap == 2 %ulysses reward tap
            open_float.tap_to_open = 17;
        elseif tap == 3 %vicer juice reward tap
            open_float.tap_to_open = 19;
        else
            disp('no other tap found!');
        end

        if(open_float.tap_open_time > 0)
            disp('RELEASING FREE REWARD');
            getty_send_bits(parameters.getty.bits, [open_float.tap_to_open, 16], 1, hardware.solenoid.sample);
            open_float.open_tap = 1;
            
        end
        %update the free reward the monkey has got this trial
        open_float.trial_free_reward = open_float.trial_free_reward + hardware.solenoid.release.free_amount;
        %save the released amount into results
        disp(strcat('now paid', num2str(open_float.trial_free_reward), 'ml for free this trial'));
    end
end

%close the tap
if isfield(open_float, 'tap_open_time') && open_float.open_tap
    if GetSecs > hardware.solenoid.release.last_free_reward + open_float.tap_open_time
        disp('CLOSING FREE REWARD');
        open_float.open_tap = 0;
        getty_send_bits(parameters.getty.bits, [open_float.tap_to_open, 16], 0);
    end
end
