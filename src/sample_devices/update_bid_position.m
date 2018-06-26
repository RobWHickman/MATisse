function [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli)
%if using testmode look for keystrokes
if hardware.testmode
    [keyIsDown, secs, keyCode] = KbCheck;
else
    joystick = check_joystick(hardware);
end

%set the limits for the bidding
%also set the bid multiplier (this is 1 for y axis (BDM) and -1 for the x
%axis (BC) because of how PTB sets up the screen coords
if strcmp(parameters.task, 'BDM')
    bidding_limits = [stimuli.bidspace.position(2), stimuli.bidspace.position(4)];
    initial_bid_position = stimuli.bidspaceposition(4) - ...
    (stimuli.bidspace.dimensions.height * results.single_trial.starting_bid_value);
elseif strcmp(parameters.task, 'BC')
    bidding_limits = [0, hardware.outputs.screen_info.width];
    initial_bid_position = hardware.screen.dimensions.width/2;
end
%move all this above into a separate functionto be run on the first frame

%set the default movement for the frame to zero
frame_adjust = 0;

%update the bid position using arrow keys
if (~parameters.task_checks.Status('no_bid_activity') || ~parameters.task_checks.Requirement('no_bid_activity')) &&...
        (~parameters.task_checks.Status('stabilised_offer') || ~parameters.task_checks.Requirement('stabilised_offer'))
    if parameters.modification.testmode
        if keyIsDown == 0
            results = stationary_frame(parameters, hardware, results); %CODE THIS UP
        elseif keyCode(hardware.inputs.keyboard.more_key) &&...
                initial_bid_position + results.movement.adjust > limits(1)
            %reset the count
            results.movement.stationary_frame_count = 0;
            %work out how 
            frame_adjust = adjust_position(hardware, results, bidding_limits, 'more'); %CODE THIS UP
        elseif keyCode(hardware.inputs.keyboard.less_key) &&...
                initial_bid_position + results.trial_results.adjust < limits(2)
            results.movement.stationary_frame_count = 0;
            frame_adjust = adjust_position(hardware, results, bidding_limits, 'less');
        end
    else
        if abs(joystick.movement + joystick.offset) < hardware.joystick.sensitivity.movement
            results = stationary_frame(parameters, hardware, results);
        else
            if joystick.movement + joystick.offset < 0
                results.movement.stationary_frame_count = 0;
                frame_adjust = adjust_position(hardware, results, bidding_limits, 'less', joystick);
            elseif joystick.movement + joystick.offset > 0
                results.movement.stationary_frame_count = 0;
                frame_adjust = adjust_position(hardware, results, bidding_limits, 'more', joystick);
            end
        end
    end
    output_frame_adjust = frame_adjust;
else
    output_frame_adjust = NaN;
end

%add this to the vector
results.movement.bidding_vector = [results.movement.bidding_vector, output_frame_adjust];

%test if every value of the bidding vector is zero past a timeout
if all(results.movement.bidding_vector == 0) &&...
        results.movement.stationary_frame_count == parameters.settings.bid_timeout * hardware.screen.refresh_rate &&...
        parameters.task_checks.Requirement('no_bid_activity')
results.trial_values.task_checks.Status('no_bid_activity') = true;
end

%update the adjust for the frame
results.movement.adjust = results.movement.adjust + output_frame_adjust;
