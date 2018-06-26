%function to check if the monkey is fixating on the cross
%returns a boolean that is true if they fixated and false if they did not
function [parameters, results] = check_fixation(parameters, stimuli, results, hardware, task_window)

%if not in testmode either check that the joystick is stationary orthat the
%monkey is fixated on a cross
if ~parameters.break.testmode
    if strcmp(hardware.inputs.settings.fixation_test, 'joystick')
        [parameters, results] = check_joystick_stationary(parameters, hardware, results);
    elseif strcmp(hardware.inputs.settings.fixation_test, 'eye_tracker')
        warning('!have not coded up eye tracker yet!');
    end
else
    %is there a way to constantly check mouse position?
    [hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y, parameters.inputs.mouse_buttons] = GetMouse(task_window);
    fixation = IsInRect(hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y, stimuli.fixation_cross.fixation_box);
    if fixation == 1
        parameters.task_checks.Status('fixation') = true;
    end
    %grow the vector of fixation coordinates
    results.movement.fixation_vector = [results.movement.fixation_vector, {{hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y}}];
end