%function to find the devices that will be used to maniplate the task
%this will be either the joystick or the keyboard in either the x or y
%dimension
function hardware = find_bidding_devices(parameters, hardware)

%which dimension ofthe screen is used for bidding?
%n.b. up/right is 'more' (this might need to c
    %find the joystick
    if parameters.modification.testmode == 0
        %find the joystick
        handles.hardware.joystick.device = find_joystick(200, 'analog');
        display('found joystick');
    else
        handles.hardware.joystick.device = 'keyboard';
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        handles.hardware.keyboard.more_key = KbName('UpArrow');
        handles.hardware.keyboard.less_key = KbName('DownArrow');
        display('set keyboard');
    end
elseif handles.hardware.joystick.direction == 'x'
    if hardware.testmode == 0
        %find the joystick
        handles.hardware.joystick.device = find_joystick(200, 'analog');
        display('found joystick');
    else
        handles.hardware.joystick.device = 'keyboard';
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        handles.hardware.keyboard.more_key = KbName('RightArrow');
        handles.hardware.keyboard.less_key = KbName('LeftArrow');
        display('set keyboard');
    end
end

