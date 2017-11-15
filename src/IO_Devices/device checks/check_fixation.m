%function to check if the monkey is fixating on the cross
%returns a boolean that is true if they fixated and false if they did not
function [parameters, results] = check_fixation(parameters, stimuli, results)

if hardware.inputs.settings.testmode == 0
    if hardware.inputs.settings.fixation_test == 'joystick'
        [parameters.task_checks.Status('hold_joystick'), results] = check_joystick_stationary(parameters, hardware, results);
    elseif hardware.inputs.settings.fixation_test == 'eye_tracker'
        display('eye tracker not yet set up');
    end
else
   fixation = IsInRect(hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y, stimuli.fixation_cross.fixation_box); 
   %grow the vector of fixation coordinates
   results.trial_values.fixation_vector = [results.trial_values.fixation_vector, {{hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y}}];
end

%check if the fixation test has passed
%is inside = 1
%default is false for all checks
if fixation == 1
    parameters.task_checks.Status('fixation') = true;
else
    parameters.task_checks.Status('fixation') = false;    
end

