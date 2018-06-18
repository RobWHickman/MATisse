function joystick = sample_joystick(ni_devices, joystick)


%check if in testmode or not
if(strcmp(joystick.device, 'keyboard')
    %joystick_sample = KbCheck(:,3)
    [keyIsDown, secs, keyCode] = KbCheck;
    
    if keyCode(joystick.keyboard.more_key)
        joystick.movement.deflection_y = 1;
    elseif keyCode(joystick.keyboard.less_key)
         joystick.movement.deflection_y = -1;
    end
    
    joystick.movement.movement_y = joystick.movement.deflection_y;
    joystick.movement.movement_x = joystick.movement.deflection_x;

else
    %sample the ni connected devices
    joystick_sample = peekdata(ni_devices, 4);
    %take only the joystick channels

    %find the relevant direction channel
    joystick.movement.deflection_y = mean(joystick_sample(:,2));
    joystick.movement.deflection_x = mean(joystick_sample(:,1));

    %include the offset in the movement score
    joystick.movement.movement_y = joystick.movement.deflection_y + joystick.bias.y_offset;
    joystick.movement.movement_x = joystick.movement.deflection_x + joystick.bias.x_offset;
end