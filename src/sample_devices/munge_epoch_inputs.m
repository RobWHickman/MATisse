function [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, epoch)

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
else
    hardware.joystick.movement.joy_movement = NaN;
end
end

%add in to the behaviour table
datarow = find(results.behaviour_table.frame == frame & strcmp(results.behaviour_table.epoch, epoch));
datacell = [parameters.trials.total_trials, {epoch}, frame,...
    hardware.joystick.movement.deflection_x, hardware.joystick.movement.deflection_y, hardware.touch.hold, hardware.missing.eye, hardware.missing.lick,...
    hardware.joystick.movement.joy_movement];

results.behaviour_table(datarow,:) = datacell;

%check touch inputs

epoch_subset = results.behaviour_table(find(strcmp(results.behaviour_table.epoch, epoch)),:);

if frame > 9
    touch_vals = epoch_subset.touch((frame - 9):frame,:);
    touch_percentage = sum(touch_vals)/length(touch_vals);
    if touch_percentage < hardware.touch.touch_perc
        parameters.task_checks.table.Status('touch_joystick') = 1;
    end
end