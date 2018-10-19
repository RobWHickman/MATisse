function [results, hardware] = update_bid_position2(hardware, results, parameters, stimuli)

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

%get the coordinates for the bidding space for tasks
if strcmp(parameters.task.type, 'BDM')
    %get the positions of the bidspace
    limits = hardware.screen.dimensions.height - [stimuli.bidspace.position(2), stimuli.bidspace.position(4)];
    %e.g. for BDM doesn't use the whole screen- this is the amount to add
    %to make sure current position is correct within bidding space
    box_in = limits(2);
    
elseif strcmp(parameters.task.type, 'BC')
    limits = [0, hardware.screen.dimensions.width];
    box_in = 0;
else
    %pavlovian
end

current_position = (results.single_trial.starting_bid + total_movement) *...
    abs(limits(1)-limits(2)) +...
    box_in;

%get the movement of this frame (+ve or -ve)
implied_movement = results.behaviour_table.movement(move_row);

%do the munging
if implied_movement == 0
    hardware.joystick.movement.stationary_count = hardware.joystick.movement.stationary_count + 1;
    screen_movement = 0;
    if hardware.joystick.movement.stationary_count == parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate
        parameters.task_checks.Status('stabilised_offer') = true;
    end
elseif implied_movement > 0
    hardware.joystick.movement.stationary_count = 0;
    screen_movement = (implied_movement / hardware.joystick.bias.manual_bias);
    
    disp(implied_movement);
    disp(screen_movement);
    disp(current_position);
    disp(limits);
    
    if (current_position + screen_movement) > limits(1)
        screen_movement = limits(1) - current_position;
        hardware.joystick.movement.limited_bidding = 1;
    end
elseif implied_movement < 0
    hardware.joystick.movement.stationary_count = 0;
    screen_movement = (implied_movement * hardware.joystick.bias.manual_bias);

    if (current_position + screen_movement) > limits(2)
        screen_movement = limits(2) - current_position;
        hardware.joystick.movement.limited_bidding = 1;
    end
end

stimuli_movement = screen_movement / (limits(1) - limits(2));

%replace with move row??
nan_rows = find(isnan(results.behaviour_table.stimuli_movement(bidding,:)));
first_nan = bidding(nan_rows(1));

results.behaviour_table.stimuli_movement(first_nan) = stimuli_movement;
    
