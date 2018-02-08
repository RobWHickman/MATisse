%function to find the devices that will be used to maniplate the task
%this will be either the joystick or the keyboard in either the x or y
%dimension
function hardware = find_bidding_devices(parameters, hardware)

%which dimension ofthe screen is used for bidding?
%n.b. up/right is 'more'
if hardware.joystick.direction == 'y'
    %find the joystick
    if ~parameters.break.testmode
        %find the joystick
        hardware.joystick.device = find_joystick(200, 'analog');
        fprintf('found joystick');
    else
        hardware.joystick.device = 'keyboard';
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        hardware.keyboard.more_key = KbName('UpArrow');
        hardware.keyboard.less_key = KbName('DownArrow');
        fprintf('set keyboard');
    end
elseif hardware.joystick.direction == 'x'
    if hardware.testmode == 0
        %find the joystick
        hardware.joystick.device = find_joystick(200, 'analog');
        fprintf('found joystick');
    else
        hardware.joystick.device = 'keyboard';
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        hardware.keyboard.more_key = KbName('RightArrow');
        hardware.keyboard.less_key = KbName('LeftArrow');
        fprintf('set keyboard');
    end
end