function [results, hardware] = update_bid_position(hardware, results, parameters, stimuli)

total_movement = sum(results.behaviour_table.movement(find(strcmp(results.behaviour_table.epoch, 'bidding')),:));

if strcmp(parameters.task.type, 'BDM')
    limits = [stimuli.bidspace.position(4), stimuli.bidspace.position(2)];
    initial_bid_position = stimuli.bidspace.position(4) - ...
        (stimuli.bidspace.dimensions.height * (results.single_trial.starting_bid + total_movement));
    axis_multiplier = -1;
    
elseif strcmp(parameters.task.type, 'BC')
    limits = [0, hardware.screen.dimensions.width];
    initial_bid_position = (results.single_trial.starting_bid + total_movement) * hardware.screen.dimensions.width;
    axis_multiplier = 1;
end

implied_movement = hardware.joystick.movement.joy_movement;

if implied_movement == 0
    hardware.joystick.movement.stationary_count = hardware.joystick.movement.stationary_count + 1;
    stimuli_movement = 0;
    if hardware.joystick.movement.stationary_count == parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate
        parameters.task_checks.Status('stabilised_offer') = true;
    end
elseif implied_movement > 0
    hardware.joystick.movement.stationary_count = 0;
    stimuli_movement = axis_multiplier * implied_movement / hardware.joystick.bias.manual_bias;
    if axis_multiplier * (initial_bid_position + stimuli_movement) > axis_multiplier * limits(2)
        stimuli_movement = limits(2) - initial_bid_position;
        hardware.joystick.movement.limited_bidding = 1;
    end
elseif implied_movement < 0
    hardware.joystick.movement.stationary_count = 0;
    stimuli_movement = axis_multiplier * implied_movement * hardware.joystick.bias.manual_bias;
    if axis_multiplier * (initial_bid_position + stimuli_movement) < axis_multiplier * limits(1)
        stimuli_movement = limits(1) - initial_bid_position;
        hardware.joystick.movement.limited_bidding = 1;
    end
end

%stimuli_movement = stimuli_movement / (limits(2) - limits(1));
row = find(isnan(results.behaviour_table.stimuli_movement(find(strcmp(results.behaviour_table.epoch, 'bidding')),:)), 1);
disp('row');
disp(row);

