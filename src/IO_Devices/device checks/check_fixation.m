%function to check if the monkey is fixating on the cross
%returns a boolean that is true if they fixated and false if they did not
function [parameters, results] = check_fixation(parameters, stimuli, results, hardware, task_window)

if hardware.testmode == 0
    if strcmp(hardware.inputs.settings.fixation_test, 'joystick')
        results = check_joystick_stationary(parameters, hardware, results);
        results.trial_values.task_checks.Status('fixation') = 1;
        
    elseif strcmp(hardware.inputs.settings.fixation_test, 'eye_tracker')
        display('eye tracker not yet set up');
    end
else
    %is there a way to constantly check mouse position?
    [hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y, parameters.inputs.mouse_buttons] = GetMouse(task_window);
    fixation = IsInRect(hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y, stimuli.fixation_cross.fixation_box);
    if fixation == 1
        results.trial_values.task_checks.Status('fixation') = true;
    end
    %grow the vector of fixation coordinates
    results.trial_values.fixation_vector = [results.trial_values.fixation_vector, {{hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y}}];
end