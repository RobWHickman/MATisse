function [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli)
if hardware.inputs.settings.testmode
    [keyIsDown, secs, keyCode] = KbCheck;
else
    joystick_movement = peekdata(hardware.inputs.joystick, 4);
    if hardware.inputs.settings.direction == 'y'
        joystick_movement = -mean(joystick_movement(:,2));
        joystick_bias = hardware.inputs.settings.joystick_y_bias;
    elseif hardware.inputs.settings.direction == 'x'
        joystick_movement = -mean(joystick_movement(:,1));
        joystick_bias = hardware.inputs.settings.joystick_x_bias;
    end
end

%set the default movement for the frame to zero
frame_adjust = 0;
output_frame_adjust = 0;
initial_bid_position = stimuli.bidspace.bidspace_info.position(4) - (stimuli.bidspace.bidspace_info.height * parameters.single_trial_values.computer_bid_value);

%update the bid position using arrow keys
if false(results.trial_values.task_checks.Status('bid_activity') & results.trial_values.task_checks.Status('targeted_offer'))
    if hardware.inputs.settings.testmode
        %if no key is pressed
        if keyIsDown == 0
            %start counting
            results.trial_values.stationary_frame_count = results.trial_values.stationary_frame_count + 1;
            %if count reaches max for a pause in movement time out the bidding
            if results.trial_values.stationary_frame_count == parameters.settings.bid_timeout * hardware.outsputs.screen_info.hz
                %stop bidding and change bar colour
                results.trial_values.task_checks.Status('targeted_offer') = true;
                stimuli.bidspace.bidspace_info.bidding_colour = [0 0 parameters.screen.white];
            end
            output_frame_adjust = frame_adjust;
        else
            %prevent overshoot
            if keyCode(hardware.inputs.keyboard.more_key) &&...
                    initial_bid_position + results.trial_values.y_adjust > stimuli.bidspace.bidspace_info.position(2) 
                %reset the count
                results.trial_values.stationary_frame_count = 0;
                %adjust bar adjustment
                frame_adjust = -hardware.inputs.settings.joystick_scalar;
                %if we overshoot bring the y adjust back to max it can be
                if initial_bid_position + results.trial_values.y_adjust + frame_adjust < stimuli.bidspace.bidspace_info.position(2)
                    frame_adjust = stimuli.bidspace.bidspace_info.position(2) - (initial_bid_position + results.trial_values.y_adjust);
                end
            elseif keyCode(hardware.inputs.keyboard.less_key) &&...
                    initial_bid_position + results.trial_values.y_adjust < stimuli.bidspace.bidspace_info.position(4) 
                results.trial_values.stationary_frame_count = 0;
                frame_adjust = hardware.inputs.settings.joystick_scalar;
                if initial_bid_position + results.trial_values.y_adjust + frame_adjust > stimuli.bidspace.bidspace_info.position(4)
                    frame_adjust = stimuli.bidspace.bidspace_info.position(4) - (initial_bid_position + results.trial_values.y_adjust);
                end
            else
                %if some random key is pressed
                results.trial_values.stationary_frame_count = results.trial_values.stationary_frame_count + 1;
                if results.trial_values.stationary_frame_count == parameters.settings.bid_timeout * hardware.outsputs.screen_info.hz
                    results.trial_values.task_checks.Status('targeted_offer') = true;
                    stimuli.bidspace.bidspace_info.bidding_colour = [0 0 parameters.screen.white];
                end
            end
            output_frame_adjust = frame_adjust;
        end
    else
        %look for joystick movement greater than the snesitivity threshold
        display(joystick_movement);
        if abs(joystick_movement + joystick_bias) < parameters.inputs.joystick_sensitivity
            %start counting
            bidspace_info.frame_count = bidspace_info.frame_count + 1;
            %if count reaches max for a pause in movement time out the bidding
            if bidspace_info.frame_count == bidspace_info.max_pause
                %stop bidding and change bar colour
                trial_values.bidding_phase = false;
                %bidspace_info.bidding_colour = [parameters.screen.white 0 0];
            end
            output_frame_adjust = frame_adjust;
        else
            %obviously have to limit this etc.
            if joystick_movement + joystick_bias > parameters.inputs.joystick_sensitivity
                %reset the count
                bidspace_info.frame_count = 0;
                %adjust bar adjustment
                frame_adjust = -parameters.inputs.joystick_scalar;
                %if we overshoot bring the y adjust back to max it can be
                if bidspace_info.monkey_bid_position + bidspace_info.y_adjust + frame_adjust < bidspace_info.position(2)
                    frame_adjust = bidspace_info.position(2) - (bidspace_info.monkey_bid_position + bidspace_info.y_adjust);
                end
            else 
                bidspace_info.frame_count = 0;
                frame_adjust = parameters.inputs.joystick_scalar;
                if bidspace_info.monkey_bid_position + bidspace_info.y_adjust + frame_adjust > bidspace_info.position(4)
                    frame_adjust = bidspace_info.position(4) - (bidspace_info.monkey_bid_position + bidspace_info.y_adjust);
                end
            end
        end
     end
else
    output_frame_adjust = NaN;
end

%update the y_adjust for the frame
results.trial_values.y_adjust = results.trial_values.y_adjust + frame_adjust;
%add this to the vector
results.trial_values.bidding_vector = [results.trial_values.bidding_vector, output_frame_adjust];

%update the value of the bid
results.trial_values.current_bid = ((initial_bid_position + results.trial_values.y_adjust) - stimuli.bidspace.bidspace_info.position(2))...
    / stimuli.bidspace.bidspace_info.height;
