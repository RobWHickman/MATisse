function [parameters, hardware] = munge_epoch_inputs(parameters, hardware, frame, epoch)
hardware = sample_inputs(parameters, hardware, 100);

epoch_number = find(strcmp(parameters.timings.Description, epoch));
hardware.joystick.trial.deflection = vertcat(hardware.joystick.trial.deflection, [hardware.joystick.movement.deflection_y, hardware.joystick.movement.deflection_x, frame, epoch_number]);

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

