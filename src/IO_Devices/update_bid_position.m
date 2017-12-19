%big function to update the bid each frame using an input device- either
%the keyboard (testmode) or the joystick in a determined direction
%three major parts- the top determines what the program should look for and
%the settings
%the second part updates the frame adjust based on if the joystick/keyboard
%is pointing up/down and also counts the frames without movement (to
%finalise the bid)
%the final part uses this to update the bidding vector and the current
%value of the monkey bid
function [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli)
%if using testmode look for keystrokes
if hardware.testmode
    [keyIsDown, secs, keyCode] = KbCheck;
else
    joystick_movement = peekdata(hardware.inputs.joystick, 4);
    if hardware.inputs.settings.direction == 'y'
        joystick_movement = mean(joystick_movement(:,2));
        joystick_bias = str2num(hardware.inputs.settings.joystick_y_bias);
    elseif hardware.inputs.settings.direction == 'x'
        joystick_movement = -mean(joystick_movement(:,1));
        joystick_bias = str2num(hardware.inputs.settings.joystick_x_bias);
    end
end

%set the default movement for the frame to zero
frame_adjust = 0;
output_frame_adjust = 0;
initial_bid_position = stimuli.bidspace.bidspace_info.position(4) - ...
    (stimuli.bidspace.bidspace_info.height * parameters.single_trial_values.starting_bid_value);

%update the bid position using arrow keys
if ~results.trial_values.task_checks.Status('no_bid_activity') && ~results.trial_values.task_checks.Status('stabilised_offer')
    %% KEYBOARD %%
    if hardware.testmode
        %if no key is pressed
        if keyIsDown == 0
            %start counting
            results.trial_values.stationary_frame_count = results.trial_values.stationary_frame_count + 1;
            %if count reaches max for a pause in movement time out the bidding
            if results.trial_values.stationary_frame_count == parameters.settings.max_pause * hardware.outputs.screen_info.hz
                %stop bidding and change bar colour
                results.trial_values.task_checks.Status('stabilised_offer') = true;
                stimuli.bidspace.bidspace_info.bidding_colour = [hardware.outputs.screen_info.white/2 0 0];
            end
            output_frame_adjust = frame_adjust;
        else
            %prevent overshoot
            if keyCode(hardware.inputs.keyboard.more_key) &&...
                    initial_bid_position + results.trial_results.y_adjust > stimuli.bidspace.bidspace_info.position(2) 
                %reset the count
                results.trial_values.stationary_frame_count = 0;
                %adjust bar adjustment
                frame_adjust = -hardware.inputs.settings.joystick_scalar;
                %if we overshoot bring the y adjust back to max it can be
                if initial_bid_position + results.trial_results.y_adjust + frame_adjust < stimuli.bidspace.bidspace_info.position(2)
                    frame_adjust = stimuli.bidspace.bidspace_info.position(2) - (initial_bid_position + results.trial_results.y_adjust);
                end
            elseif keyCode(hardware.inputs.keyboard.less_key) &&...
                    initial_bid_position + results.trial_results.y_adjust < stimuli.bidspace.bidspace_info.position(4)
                results.trial_values.stationary_frame_count = 0;
                frame_adjust = hardware.inputs.settings.joystick_scalar;
                if initial_bid_position + results.trial_results.y_adjust + frame_adjust > stimuli.bidspace.bidspace_info.position(4)
                    frame_adjust = stimuli.bidspace.bidspace_info.position(4) - (initial_bid_position + results.trial_results.y_adjust);
                end
            else
                %if some random key is pressed
                results.trial_values.stationary_frame_count = results.trial_values.stationary_frame_count + 1;
                if results.trial_values.stationary_frame_count == parameters.settings.max_pause * hardware.outputs.screen_info.hz
                    results.trial_values.task_checks.Status('stabilised_offer') = true;
                    stimuli.bidspace.bidspace_info.bidding_colour = [hardware.outputs.screen_info.white/2 0 0];
                end
            end
            output_frame_adjust = frame_adjust;
        end
    %% JOYSTICK %%
    else
        %look for joystick movement greater than the sensitivity threshold
        if abs(joystick_movement + joystick_bias) < hardware.inputs.settings.joystick_sensitivity
            %start counting
            results.trial_values.stationary_frame_count = results.trial_values.stationary_frame_count + 1;
            %if count reaches max for a pause in movement time out the bidding
            if results.trial_values.stationary_frame_count == parameters.settings.max_pause * hardware.outputs.screen_info.hz
                %stop bidding and change bar colour
                results.trial_values.task_checks.Status('stabilised_offer') = true;
                stimuli.bidspace.bidspace_info.bidding_colour = [hardware.outputs.screen_info.white/2 0 0];
            end
            output_frame_adjust = frame_adjust;
        else
            if joystick_movement + joystick_bias > hardware.inputs.settings.joystick_sensitivity
                %reset the count
                results.trial_values.stationary_frame_count = 0;
                %adjust bar adjustment
                frame_adjust = -hardware.inputs.settings.joystick_scalar;
                %if we overshoot bring the y adjust back to max it can be
                if initial_bid_position + results.trial_results.y_adjust + frame_adjust < stimuli.bidspace.bidspace_info.position(2)
                    frame_adjust = stimuli.bidspace.bidspace_info.position(2) - (initial_bid_position + results.trial_results.y_adjust);
                end
                output_frame_adjust = frame_adjust;
            else 
                results.trial_values.stationary_frame_count = 0;
                frame_adjust = hardware.inputs.settings.joystick_scalar;
                if initial_bid_position + results.trial_results.y_adjust + frame_adjust > stimuli.bidspace.bidspace_info.position(4)
                    frame_adjust = stimuli.bidspace.bidspace_info.position(4) - (initial_bid_position + results.trial_results.y_adjust);
                end
                output_frame_adjust = frame_adjust;
            end
        end
     end
else
    output_frame_adjust = NaN;
end

%update the y_adjust for the frame
results.trial_results.y_adjust = results.trial_results.y_adjust + frame_adjust;
%add this to the vector
results.trial_values.bidding_vector = [results.trial_values.bidding_vector, output_frame_adjust];

%test if every value of the bidding vector is zero past a timeout
if all(results.trial_values.bidding_vector == 0) && ...
        results.trial_values.stationary_frame_count == parameters.settings.bid_timeout * hardware.outputs.screen_info.hz
results.trial_values.task_checks.Status('no_bid_activity') = true;
end
    
%update the value of the bid
results.trial_results.monkey_bid = (stimuli.bidspace.bidspace_info.position(4) - (initial_bid_position + results.trial_results.y_adjust))...
    / stimuli.bidspace.bidspace_info.height;
