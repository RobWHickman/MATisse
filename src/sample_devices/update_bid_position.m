function [results, hardware] = update_bid_position(hardware, results, parameters, stimuli)

if strcmp(parameters.task.type, 'BDM')
    limits = [stimuli.fractals.position(2), stimuli.fractals.position(4)];
    initial_bid_position = stimuli.bidspace.position(4) - ...
        (stimuli.bidspace.dimensions.height * results.single_trial.starting_bid) + results.movement.total_movement;
    axis_multiplier = -1;
elseif strcmp(parameters.task.type, 'BC')
    limits = [0, hardware.screen.dimensions.width];
    initial_bid_position = (results.single_trial.starting_bid + results.movement.total_movement) * hardware.screen.dimensions.width;
    axis_multiplier = 1;
end

implied_movement = hardware.joystick.movement.joy_movement;

if implied_movement == 0
    results.movement.stationary_count = results.movement.stationary_count + 1;
    hardware.joystick.movement.stimuli_movement = 0;
    if results.movement.stationary_count == parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate
        parameters.task_checks.Status('stabilised_offer') = true;
    end
elseif implied_movement * axis_multiplier > 0
    results.movement.stationary_count = 0;
    hardware.joystick.movement.stimuli_movement = implied_movement / hardware.joystick.bias.manual_bias;
    if initial_bid_position + hardware.joystick.movement.stimuli_movement > limits(2)
        disp('limiting bidding');
        hardware.joystick.movement.stimuli_movement = limits(2) - initial_bid_position;
    end
elseif implied_movement * axis_multiplier < 0
    results.movement.stationary_count = 0;
    hardware.joystick.movement.stimuli_movement = implied_movement * hardware.joystick.bias.manual_bias;
    if initial_bid_position + hardware.joystick.movement.stimuli_movement < limits(1)
        disp('limiting bidding');
        hardware.joystick.movement.stimuli_movement = limits(1) - initial_bid_position;
    end
end

hardware.joystick.movement.stimuli_movement = hardware.joystick.movement.stimuli_movement / (limits(2) - limits(1));