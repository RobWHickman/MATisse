%function to find the devices that will be used to maniplate the task
%this will be either the joystick or the keyboard in either the x or y
%dimension
function hardware = find_external_inputs(parameters, hardware)
%clear the hardware in use
daqreset();

%for upstairs- not testmode
if ~parameters.break.testmode
    %only works for analog at the moment
    if hardware.ni_inputs == 'analog'
        fprintf('finding analog ni devices');
        %analog version - deprecated
        hardware.ni_devices = analoginput('nidaq','Dev1');
        % add channels
        addchannel(hardware.ni_devices, 0:7);
        hardware.ni_devices.SampleRate = sampling_rate;
        hardware.ni_devices.SamplesPerTrigger = inf;
        hardware.ni_devices.UserData = zeros(1,3);
        %start the joystick
        start(hardware.ni_devices);
    else
        %clear the hardware in use
        daqreset();

        joystick = daq.createSession('ni');
        joystick.Rate=20;
        joystick.DurationInSeconds = 1/screen_refresh;
        addAnalogInputChannel(joystick, 'Dev1',0,'Voltage');
        addAnalogInputChannel(joystick, 'Dev1',1,'Voltage');
        hardware.joystick = joystick;

        touch = daq.createSession('ni');
        addDigitalChannel(touch,'Dev1','Port1/Line1','InputOnly');
        hardware.touch = touch;
    end
else
    if hardware.joystick.direction == 'x'
        %set the keys for inputs into the task
        KbName('UnifyKeyNames');
        hardware.joystick.keyboard.more_key = KbName('RightArrow');
        hardware.joystick.keyboard.less_key = KbName('LeftArrow');
        fprintf('set keyboard');
    elseif hardware.joystick.direction == 'y'
        KbName('UnifyKeyNames');
        hardware.joystick.keyboard.more_key = KbName('UpArrow');
        hardware.joystick.keyboard.less_key = KbName('DownArrow');
        fprintf('set keyboard');
    end
end