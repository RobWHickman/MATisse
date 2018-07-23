function [hardware] = sample_ni(hardware, ni_devices, measure_frames)

if parameters.break.testmode
    [keyIsDown, secs, keyCode] = KbCheck;
    
    if keyCode(hardware.joystick.keyboard.more_key)
        hardware.joystick.movement.deflection_y = 1;
    elseif keyCode(hardware.joystick.keyboard.less_key)
         hardware.joystick.movement.deflection_y = -1;
    end
    
    %no eye tracker for testmode
    hardware.eyetracker.movement = NaN;
else
    ni_sample = peekdata(ni_devices, measure_frames);
    
    %find the relevant direction channel
    hardware.joystick.movement.deflection_y = mean(joystick_sample(:,2));
    hardware.joystick.movement.deflection_x = mean(joystick_sample(:,1));

    %include the offset in the movement score
    hardware.joystick.movement.movement_y = joystick.movement.deflection_y + joystick.bias.y_offset;
    hardware.joystick.movement.movement_x = joystick.movement.deflection_x + joystick.bias.x_offset;

    %no eye tracker yet
    hardware.eyetracker.movement = NaN;
end
    