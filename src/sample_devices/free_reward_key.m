function [hardware, trial_free_reward] = free_reward_key(hardware, parameters, trial_free_reward)

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
        tap_open_time = calculate_open_time(tap, hardware.solenoid.release.free_amount);
        
        %get the right tap bit to open
        if tap == 1 %water
            tap_to_open = 18;
        elseif tap == 2 %ulysses reward tap
            tap_to_open = 17;
        elseif tap == 3 %vicer juice reward tap
            tap_to_open = 19;
        else
            disp('no other tap found!');
        end

        if(tap_open_time > 0)
            getty_send_bits(parameters.getty.bits, tap_to_open, 1)
            getty_send_bits(parameters.getty.bits, 16, 1)
            
            %wait with the tap open
            WaitSecs(tap_open_time);

            %outputSingleScan(hardware.solenoid.device, tap_closed);
            getty_send_bits(parameters.getty.bits, tap_to_open, 0)
            getty_send_bits(parameters.getty.bits, 16, 0)
        end
    end
    
    %update the free reward the monkey has got this trial
    trial_free_reward = trial_free_reward + hardware.solenoid.release.free_amount;
end