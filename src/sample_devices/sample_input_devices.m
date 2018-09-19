function hardware = sample_input_devices(parameters, hardware)

if ~parameters.break.testmode
    %legacy for analog sampling
    if strcmp(hardware.ni_inputs, 'analog')
        joystick_sample = peekdata(hardware.ni_devices, measure_frames);
        touch_val = getvalue(hardware.touch);
        hardware.touch.hold = touch_val(2);
    
    %sample digitial joystick
    elseif strcmp(hardware.ni_inputs, 'digital')
        joystick_sample = inputSingleScan(hardware.joystick.joystick);
        touch_sample = inputSingleScan(hardware.joystick.touch);
        hardware.touch.hold = touch_sample(1);
    end
    
    %store the joystick movement data
    hardware.joystick.movement.deflection_x = joystick_sample(1);
    hardware.joystick.movement.deflection_y = joystick_sample(2);

    %no eye tracker for testmode
    hardware.eyetracker.movement = NaN;
    %no lick for testmode
    hardware.solenoid.lick = NaN;
    
else
    [keyIsDown, secs, keyCode] = KbCheck;
    
    if strcmp(hardware.joystick.direction, 'y')
        if keyCode(hardware.joystick.keyboard.more_key)
            hardware.joystick.movement.deflection_y = 1;
        elseif keyCode(hardware.joystick.keyboard.less_key)
             hardware.joystick.movement.deflection_y = -1;
        else
            hardware.joystick.movement.deflection_y = 0;
        end
        hardware.joystick.movement.deflection_x = 0;
    else
        if keyCode(hardware.joystick.keyboard.more_key)
            hardware.joystick.movement.deflection_x = 1;
        elseif keyCode(hardware.joystick.keyboard.less_key)
             hardware.joystick.movement.deflection_x = -1;
        else
            hardware.joystick.movement.deflection_x = 0;
        end
        hardware.joystick.movement.deflection_y = 0;
    end

    %no eye tracker for testmode
    hardware.eyetracker.movement = NaN;
    %no touch for testmode
    hardware.touch.hold = NaN;
    %no lick for testmode
    hardware.solenoid.lick = NaN;
end
