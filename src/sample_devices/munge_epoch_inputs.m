%a function that takes the sampled behaviour of a frame and adds it to a
%pre-initialised table for behaviour
%this table is then sample for that behaviour later
%the table is also saved at the end of each trial
function [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, epoch)

%no functionality of testmode yet
if ~parameters.break.testmode
    
%munge joystick inputs
%set the appropriate sensitivty to use for the epoch
%generally these will be the same, but not necessarily
if strcmp(epoch, 'bidding')
    sensitivity = hardware.joystick.sensitivity.movement;
else
    sensitivity = hardware.joystick.sensitivity.centered;
    
    %if the sample joystick deflection is greater than the centering
    %sensitivty, monkey has broken the JCW condition
    if((abs(hardware.joystick.movement.deflection_x) > sensitivity || abs(hardware.joystick.movement.deflection_y) > sensitivity) && ~strcmp(epoch, 'bidding'))
        parameters.task_checks.table.Status('joystick_centered') = 1;
    end
end

%munge the joystick data into the movement for the frame in the bidding
%epoch
if strcmp(epoch, 'bidding')
    %find the correct direction and thus joystick channel to sample
    if strcmp(hardware.joystick.direction, 'x')
        if(abs(hardware.joystick.movement.deflection_x) > sensitivity)
            %if no scaling or testmode impetus is equal to speed (1 or -1)
            if parameters.break.testmode || ~hardware.joystick.movement.scaling
                impetus = hardware.joystick.movement.deflection_x / abs(hardware.joystick.movement.deflection_x);
            %else take into account the amount of deflection
            else
                impetus = hardware.joystick.movement.deflection_x;
            end
        %if no significant deflection set impetus to zero
        else
            impetus = 0;
        end
    %do the same for the y axis if e.g. auctions
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
    
    %the joystick 'movement' is equal to the impetus times the speed of
    %each movement
    hardware.joystick.movement.joy_movement = hardware.joystick.movement.speed * impetus;
else
    %if not in the bidding phase the movement is NaN obviously
    hardware.joystick.movement.joy_movement = NaN;
end
end

%forma new row of data and slot this into the behaviour table
datarow = find(results.behaviour_table.frame == frame & strcmp(results.behaviour_table.epoch, epoch));
datacell = [parameters.trials.total_trials, {epoch}, frame,...
    hardware.joystick.movement.deflection_x, hardware.joystick.movement.deflection_y, hardware.touch.hold, hardware.missing.eye, hardware.missing.lick,...
    hardware.joystick.movement.joy_movement, NaN];

results.behaviour_table(datarow,:) = datacell;

%check touch inputs
epoch_subset = results.behaviour_table(find(strcmp(results.behaviour_table.epoch, epoch)),:);

%sample the last x frames
if frame >= hardware.touch.touch_samples
    touch_vals = epoch_subset.touch((frame - (hardware.touch.touch_samples - 1)):frame,:);
    if strcmp(hardware.touch.touch_req, 'any')
        if all(touch_vals == 0)
            parameters.task_checks.table.Status('touch_joystick') = 1;
        end
    else
        touch_percentage = sum(touch_vals)/length(touch_vals);
        %if touch percentage lower than the threshold, monkey has failed the
        %touch requirement for the trial
        if touch_percentage < hardware.touch.touch_perc
            parameters.task_checks.table.Status('touch_joystick') = 1;
        end
    end
end