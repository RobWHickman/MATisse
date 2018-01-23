%function to find device used to fixate to a cross at the start of each
%trial
%can be either based on an eye tracker or a mouse when debugging downstairs
function hardware = find_fixation_devices(parameters, hardware, task_window)

%if not testing use joystick/eye tracker
if parameters.modification.testmode == 0
    %find the eye tracker
    hardware.fixation.device = 'eye_tracker';
    display('have not coded up eye tracker yet!');
%otherwise use the mouse to hit a fixation spot
else
    %find the mouse
    [hardware.fixation.mouse_x, hardware.fixation.mouse_y, hardware.fixation.mouse_buttons] = GetMouse(task_window);
    hardware.fixation.device = 'mouse';
end
