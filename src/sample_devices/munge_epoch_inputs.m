function [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, epoch)

%add in to the behaviour table
disp(epoch);
disp(results.behaviour_table.epoch);
strcmp(results.behvaiour_table.epoch, epoch)
disp(results.behaviour.frame == frame);

datacell = [parameters.trials.total_trials, {epoch}]

if ~parameters.break.testmode
%munge joystick inputs
if strcmp(epoch, 'bidding')
    sensitivity = hardware.joystick.sensitivity.movement;
else
    sensitivity = hardware.joystick.sensitivity.centered;
end

if((abs(hardware.joystick.movement.deflection_x) > sensitivity || abs(hardware.joystick.movement.deflection_y) > sensitivity) && ~strcmp(epoch, 'bidding'))
    parameters.task_checks.Status('hold_joystick') = 1;
end

if strcmp(epoch, 'bidding')
    if strcmp(hardware.joystick.direction, 'x')
        if(abs(hardware.joystick.movement.deflection_x) > sensitivity)
            if parameters.break.testmode || ~hardware.joystick.movement.scaling
                impetus = hardware.joystick.movement.deflection_x / abs(hardware.joystick.movement.deflection_x);
            else
                impetus = hardware.joystick.movement.deflection_x;
            end
        else
            impetus = 0;
        end
    elseif strcmp(hardware.joystick.direction, 'y')
        if(abs(hardware.joystick.movement.deflection_y) > sensitivity)
            if parameters.break.testmode || ~hardware.joystick.movement.scaling
                impetus = hardware.joystick.movement.deflection_y / abs(hardware.joystick.movement.deflection_y);
            else
                impetus = hardware.joystick.movement.deflection_y;
            end
        else
            impetus = 0;
        end
    end

    hardware.joystick.movement.joy_movement = hardware.joystick.movement.speed * impetus;
end

%munge touch inputs


end

