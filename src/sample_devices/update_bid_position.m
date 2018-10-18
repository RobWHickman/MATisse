function [results, hardware] = update_bid_position(hardware, results, parameters, stimuli)

%find the rows that correspond to bidding in the behaviour table
bidding = find(strcmp(results.behaviour_table.epoch, 'bidding'));
%get the total movement thus far
%and the row that is currently active
if all(isnan(results.behaviour_table.stimuli_movement))
    total_movement = 0;
    move_row = bidding(1);
else
    total_movement = nansum(results.behaviour_table.stimuli_movement(bidding,:));
    move_rows = find(~isnan(results.behaviour_table.stimuli_movement));
    move_row = move_rows(end) + 1;
end

%find the limits of the bidding for each task
%find initial position for this frame in real pixels
if strcmp(parameters.task.type, 'BDM')
    limits = hardware.screen.dimensions.height - [stimuli.bidspace.position(2), stimuli.bidspace.position(4)];
    current_bid_position = stimuli.bidspace.position(4) - ...
        (stimuli.bidspace.dimensions.height * (results.single_trial.starting_bid + total_movement));
    
elseif strcmp(parameters.task.type, 'BC')
    limits = [hardware.screen.dimensions.width, 0];
    current_bid_position = (results.single_trial.starting_bid + total_movement) * hardware.screen.dimensions.width;
else
    %pavlovian
end

%get the movement of this frame (+ve or -ve)
implied_movement = results.behaviour_table.movement(move_row);

%if no movement then indicator is stationary for this frame
if implied_movement == 0
    hardware.joystick.movement.stationary_count = hardware.joystick.movement.stationary_count + 1;
    stimuli_movement = 0;
    if hardware.joystick.movement.stationary_count == parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate
        parameters.task_checks.Status('stabilised_offer') = true;
    end
elseif implied_movement > 0
    hardware.joystick.movement.stationary_count = 0;
    stimuli_movement = implied_movement / hardware.joystick.bias.manual_bias;
    if (current_bid_position + stimuli_movement) > limits(1)
        stimuli_movement = limits(1) - current_bid_position;
        hardware.joystick.movement.limited_bidding = 1;
    end
elseif implied_movement < 0
    hardware.joystick.movement.stationary_count = 0;
    stimuli_movement = implied_movement * hardware.joystick.bias.manual_bias;
    if (current_bid_position + stimuli_movement) < limits(2)
        stimuli_movement = limits(2) - current_bid_position;
        hardware.joystick.movement.limited_bidding = 1;
    end
end

%convert back to percentage of bidding space
stimuli_movement = stimuli_movement / (limits(1) - limits(2));

nan_rows = find(isnan(results.behaviour_table.stimuli_movement(bidding,:)));
first_nan = bidding(nan_rows(1));

results.behaviour_table.stimuli_movement(first_nan) = stimuli_movement;