%small function to find the devices used to test that the monkey is
%fixating on the task before displaying it a rewarding fractal
%can be by testing the joystick is stationary, or that it saccades to a
%fixation cross
%the testing equivalent uses a 'mous esaccade' to the fixation cross
function hardware = find_fixation_devices(testmode, fixation_test)

%if not testing use joystick/eye tracker
if testmode.Value == 0
    if fixation_test == 'joystick'
        %find the joystick
        hardware.inputs.joystick = find_joystick(200, 'analog');
        hardware.devices.fixation = 'JOYSTICK';
        display('found joystick');
    elseif fixation_test == 'eye_tracker'
        %find the eye tracker
        hardware.devices.fixation = 'EYE_TRACKER';
        display('have not coded up eye tracker yet!');
    end
%otherwise use the mouse to hit a fixation spot
else
    %find the mouse
    [hardware.inputs.mouse.mouse_x, hardware.inputs.mouse.mouse_y, hardware.inputs.mouse.mouse_buttons] = GetMouse(task_window);
    hardware.devices.fixation = 'MOUSE';
end

%only if using the joystick for fixation testing
if testmode.Value == 0 && fixation_test == 'joystick'
    %set the joystick parameters
    hardware.inputs.settings.joystick_scalar = 25; %also defines keyboard sensitivity
    hardware.inputs.settings.joystick_sensitivity = 0.1;
    hardware.inputs.settings.joystick_x_bias = -0.1;
    hardware.inputs.settings.joystick_y_bias = -0.1;
end