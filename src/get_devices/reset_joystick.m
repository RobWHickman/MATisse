function joystick = reset_joystick(joystick)

%reset thejoysticks movement from the previous trial
joystick.movement.stationary_count = 0; 
joystick.movement.joy_movement = 0;