function hardware = get_task_devices(hardware)

%get the screen and its info
%takes the screen number set in the GUI
hardare.outputs.screen_info = get_screen_information(hardware.outputs.screen_info.screen_number);

%get the input devices
hardware = find_bidding_devices(hardware);
hardware = find_fixation_devices(hardware);