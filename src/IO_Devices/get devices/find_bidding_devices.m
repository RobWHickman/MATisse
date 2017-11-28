%small function to find the devices that will be used to maniplate the task
%this will be either the joystick or the keyboard in either the x or y
%dimension
function hardware = find_bidding_devices(hardware)

%which dimension ofthe screen is used for bidding?
%n.b. up/right is 'more' (this might need to change for PTB)
if hardware.inputs.settings.direction == 'y'
    if hardware.testmode == 0
        %find the joystick
        hardware.inputs.joystick = find_joystick(200, 'analog');
        hardware.devices.bidding = 'JOYSTICK_Y';
        display('found joystick');
    else
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        hardware.inputs.keyboard.more_key = KbName('UpArrow');
        hardware.inputs.keyboard.less_key = KbName('DownArrow');
        hardware.devices.bidding = 'KEYBOARD_UD';
        display('set keyboard');
    end
elseif hardware.inputs.settings.direction == 'x'
    if hardware.testmode == 0
        %find the joystick
        hardware.inputs.joystick = find_joystick(200, 'analog');
        hardware.devices.bidding = 'JOYSTICK_X';
        display('found joystick');
    else
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        hardware.inputs.keyboard.more_key = KbName('RightArrow');
        hardware.inputs.keyboard.less_key = KbName('LeftArrow');
        hardware.devices.bidding = 'KEYBOARD_LR';
        display('set keyboard');
    end
end

%set the joystick parameters if not already (they should be set by the GUI)
if ~isfield(hardware.inputs.settings, 'joystick_scalar')
    hardware.inputs.settings.joystick_scalar = 8; %also defines keyboard sensitivity
end
if ~isfield(hardware.inputs.settings, 'joystick_sensitivity')
    hardware.inputs.settings.joystick_sensitivity = 0.01;
end
