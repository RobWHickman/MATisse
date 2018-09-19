function [hardware] = sample_inputs(parameters, hardware, measure_frames)

if parameters.break.testmode
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
    
else
    if hardware.ni_inputs == 'analog'
        ni_sample = peekdata(hardware.ni_devices, measure_frames);

        %find the relevant direction channel
        hardware.joystick.movement.deflection_y = mean(joystick_sample(:,2)) + joystick.bias.y_offset;
        hardware.joystick.movement.deflection_x = mean(joystick_sample(:,1)) + joystick.bias.x_offset;

        %no eye tracker yet
        hardware.eyetracker.movement = NaN;
        %no lick yet
        hardware.solenoid.lick = NaN;
    elseif hardware.ni_inputs == 'digital'
        joy_data = inputSingleScan(joystick);
        
        %find the relevant direction channel
        hardware.joystick.movement.deflection_y = joy_data(2) + joystick.bias.y_offset;
        hardware.joystick.movement.deflection_x = joy_data(1) + joystick.bias.x_offset;

        touch_input = inputSingleScan(touch);
        hardware.touch.hold = touch_input(1);

        joystick_sample = [joy_x, joy_y, touch_input];
end
    