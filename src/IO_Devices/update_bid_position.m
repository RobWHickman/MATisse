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
    %the multiplier to make moving the joystick harder/easier in a specific
    %direction
    joystick_added_bias = hardware.inputs.settings.added_bias;
    if hardware.inputs.settings.direction == 'y'
        joystick_movement = mean(joystick_movement(:,2));
        joystick_bias = str2num(hardware.inputs.settings.joystick_y_bias);
    elseif hardware.inputs.settings.direction == 'x'
        joystick_movement = mean(joystick_movement(:,1));
        joystick_bias = str2num(hardware.inputs.settings.joystick_x_bias);
    end
end

%take how far the joystick is moved forward into account (or dont)
if hardware.inputs.settings.joystick_velocity
    joystick_impetus_r = ((joystick_movement + joystick_bias)) * 2.5/ 0.6; %0.6 is pretty much the max you can move it in any direction
    joystick_impetus_l = ((joystick_movement + joystick_bias)) * 2.5/ 0.6; %0.6 is pretty much the max you can move it in any direction
else
    joystick_impetus_l = 1;
    joystick_impetus_r = -1;
end

%set the limits for the bidding
%also set the bid multiplier (this is 1 for y axis (BDM) and -1 for the x
%axis (BC) because of how PTB sets up the screen coords
if strcmp(parameters.task, 'BDM')
    limits = [stimuli.bidspace.bidspace_info.position(2), stimuli.bidspace.bidspace_info.position(4)];
    initial_bid_position = stimuli.bidspace.bidspace_info.position(4) - ...
    (stimuli.bidspace.bidspace_info.height * parameters.single_trial_values.starting_bid_value);
    axis_multiplier = 1;
elseif strcmp(parameters.task, 'BC')
    limits = [0, hardware.outputs.screen_info.width];
    initial_bid_position = hardware.outputs.screen_info.width/2;
    axis_multiplier = -1;
end

%set the default movement for the frame to zero
frame_adjust = 0;
output_frame_adjust = 0;

%update the bid position using arrow keys
if (~results.trial_values.task_checks.Status('no_bid_activity') | ~results.trial_values.task_checks.Requirement('no_bid_activity')) &&...
        (~results.trial_values.task_checks.Status('stabilised_offer') | ~results.trial_values.task_checks.Requirement('stabilised_offer'))
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
                    initial_bid_position + results.trial_results.adjust > limits(1)
                %reset the count
                results.trial_values.stationary_frame_count = 0;
                %adjust bar adjustment
                frame_adjust = -hardware.inputs.settings.joystick_scalar;
                %if we overshoot bring the y adjust back to max it can be
                if initial_bid_position + results.trial_results.adjust + frame_adjust < limits(1)
                    frame_adjust = limits(1) - (initial_bid_position + results.trial_results.adjust);
                end
            elseif keyCode(hardware.inputs.keyboard.less_key) &&...
                    initial_bid_position + results.trial_results.adjust < limits(2)
                results.trial_values.stationary_frame_count = 0;
                frame_adjust = hardware.inputs.settings.joystick_scalar;
                if initial_bid_position + results.trial_results.adjust + frame_adjust > limits(2)
                    frame_adjust = limits(2) - (initial_bid_position + results.trial_results.adjust);
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
            if (joystick_movement + joystick_bias) > 0
                %TOWARDS THE LEFT
                %reset the count
                results.trial_values.stationary_frame_count = 0;
                %adjust bar adjustment
                frame_adjust = -(hardware.inputs.settings.joystick_scalar * joystick_impetus_l * axis_multiplier) / joystick_added_bias; %THIS LINE
                %if we overshoot bring the y adjust back to max it can be
                if initial_bid_position + results.trial_results.adjust + frame_adjust < limits(1)
                    frame_adjust = limits(1) - (initial_bid_position + results.trial_results.adjust);
                end
                output_frame_adjust = frame_adjust;
            else %TOWARDS THE RIGHT
                results.trial_values.stationary_frame_count = 0;
                frame_adjust = (hardware.inputs.settings.joystick_scalar * -joystick_impetus_r * axis_multiplier) * joystick_added_bias; %scalar = speed %THIS LINE
                if initial_bid_position + results.trial_results.adjust + frame_adjust > limits(2)
                    frame_adjust = limits(2) - (initial_bid_position + results.trial_results.adjust);
                end
                output_frame_adjust = frame_adjust;
            end
        end
     end
else
    output_frame_adjust = NaN;
end

%add this to the vector
results.trial_values.bidding_vector = [results.trial_values.bidding_vector, output_frame_adjust];

%test if every value of the bidding vector is zero past a timeout
if all(results.trial_values.bidding_vector == 0) && ...
        results.trial_values.stationary_frame_count == parameters.settings.bid_timeout * hardware.outputs.screen_info.hz
results.trial_values.task_checks.Status('no_bid_activity') = true;
end

%update the adjust for the frame
results.trial_results.adjust = results.trial_results.adjust + frame_adjust;
