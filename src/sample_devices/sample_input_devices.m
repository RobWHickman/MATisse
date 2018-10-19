function hardware = sample_input_devices(parameters, hardware)

if ~parameters.break.testmode
    %legacy for analog sampling
    if strcmp(hardware.ni_inputs, 'analog')
        joystick_sample = peekdata(hardware.joystick.joystick, measure_frames);
        touch_val = getvalue(hardware.touch.touch);
        hardware.touch.hold = touch_val(2);
    
    %sample digitial joystick
    elseif strcmp(hardware.ni_inputs, 'digital')
        joystick_sample = inputSingleScan(hardware.joystick.joystick);
        touch_sample = inputSingleScan(hardware.touch.touch);
        hardware.touch.hold = touch_sample(1);
    end
    
    %store the joystick movement data
    hardware.joystick.movement.deflection_x = joystick_sample(1);
    hardware.joystick.movement.deflection_y = joystick_sample(2);

    if strcmp(hardware.eyetracker, 'missing')
        hardware.missing.eye = NaN;
    else
        disp('error-must code up eyetracker sampling');
    end
    if strcmp(hardware.lick, 'missing')
        hardware.missing.lick = NaN;
    else
        disp('error-must code up lick sampling');
    end
    
    hardware.joystick.movement.deflection_x = (hardware.joystick.movement.deflection_x + hardware.joystick.bias.x_offset) * - 1;
    hardware.joystick.movement.deflection_y = hardware.joystick.movement.deflection_y + hardware.joystick.bias.y_offset;

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
    
    hardware.touch.hold = NaN;
    hardware.missing.eye = NaN;
    hardware.missing.lick = NaN;
end
