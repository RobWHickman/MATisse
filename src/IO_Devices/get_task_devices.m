%function to set which devices are to be used for each section of the task
%indicates what hardware should be used for each subtask and sets some
%variables for those hardware
function hardware = get_task_devices(parameters, hardware, task_window)

%get the screen and its info
%takes the screen number set in the GUI
hardware = get_screen_information(hardware);

%get the input devices
hardware = find_bidding_devices(parameters, hardware);
hardware = find_fixation_devices(hardware, task_window);

%get the output devices
hardware = find_payout_devices(parameters, hardware);
hardware = find_error_devices(hardware);