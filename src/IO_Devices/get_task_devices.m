function hardware = get_task_devices(hardware, task_window)

%get the screen and its info
%takes the screen number set in the GUI
hardware = get_screen_information(hardware);

%get the input devices
hardware = find_bidding_devices(hardware);
hardware = find_fixation_devices(hardware, task_window);

%get the output devices
hardware = find_payout_devices(hardware);
hardware = find_error_devices(hardware);