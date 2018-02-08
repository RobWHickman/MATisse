function joystick = check_joystick(hardware)

joystick.movement = peekdata(hardware.inputs.joystick, 4);
%the multiplier to make moving the joystick harder/easier in a specific
%direction
joystick.manual_bias = hardware.joystick.bias.manual_bias;
if hardware.inputs.settings.direction == 'y'
    joystick.movement = mean(joystick.movement(:,2));
    joystick.offset = str2num(hardware.joystick.bias.y_offset);
    axis_multiplier = -1;
elseif hardware.inputs.settings.direction == 'x'
    joystick.movement = mean(joystick.movement(:,1));
    joystick.offset = str2num(hardware.joystick.bias.x_offset);
    axis_multiplier = -1;
end

%take how far the joystick is moved forward into account (or dont)
if hardware.inputs.settings.joystick_velocity
    joystick.impetus_r = (joystick.movement + joystick.offset) / (0.6 * joystick.manual_bias); %0.6 is pretty much the max you can move it in any direction
    joystick.impetus_l = (joystick.movement + joystick.offset) / (0.6 / joystick.manual_bias); %0.6 is pretty much the max you can move it in any direction
else
    joystick.impetus_l = 1 * joystick.manual_bias;
    joystick.impetus_r = -1 / joystick.manual_bias;
end
