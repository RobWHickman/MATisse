%function to set which devices are to be used for each section of the task
%indicates what hardware should be used for each subtask and sets some
%variables for those hardware
function hardware = get_task_devices(parameters, hardware, task_window)

fprintf('Finding task devices');

%get the screen and its info
%takes the screen number set in the GUI
hardware = get_screen_information(hardware);

%get the input devices
hardware = find_external_inputs(parameters, hardware);

%get the output devices
if ~parameters.break.testmode
    hardware = find_solenoid(hardware);
end
hardware = find_error_devices(hardware);