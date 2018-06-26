function sample_solenoid(hardware, payout)

%if solenoid not set, find it
if ~strcmp(hardware.solenoid.device.tag, 'SolenoidOutput')
    disp('finding solenoid');
    hardware = find_solenoid(hardware);
end

%pays out a manually assigned tap via the GUI    
if strcmp(payout, 'test_tap')
    tap_open_time = hardware.solenoid.calibration.open_time;
    tap = hardware.solenoid.calibration.test_tap;
    disp('opening test solenoid');
    release_liquid(hardware, tap, tap_open_time)

%pays out a manually assigned tap via the GUI but 100x for calibration  
elseif strcmp(payout, 'calibrate')
    WaitSecs(5); %for calibration
    tap_open_time = hardware.solenoid.calibration.open_time;
    tap = hardware.solenoid.calibration.test_tap;
    disp('opening test solenoid');
    for open = 1:hardware.solenoid.calibration.spurt_repeats
        release_liquid(hardware, tap, tap_open_time)
        WaitSecs(0.1);
    end

%pays out a some free juice/water    
elseif strcmp(payout, 'test_tap')
    tap_open_time = hardware.solenoid.calibration.open_time;
    tap = hardware.solenoid.calibration.test_tap;
    disp('opening test solenoid');

end
