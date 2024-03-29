%function to find the devices that will be used to maniplate the task
%this will be either the joystick or the keyboard in either the x or y
%dimension
function hardware = find_external_inputs(parameters, hardware)

%for upstairs- not testmode
if ~parameters.break.testmode %&& ~parameters.break.gui_variables
    %clear the hardware in use
    daqreset();

    %only works for analog at the moment
    if strcmp(hardware.ni_inputs, 'analog')
        fprintf('finding analog ni devices');
        %analog version - deprecated
        hardware.joystick.joystick = analoginput('nidaq','Dev1');
        % add channels
        addchannel(hardware.joystick.joystick, 0:7);
        hardware.joystick.joystick.SampleRate = sampling_rate;
        hardware.joystick.joystick.SamplesPerTrigger = inf;
        hardware.joystick.joystick.UserData = zeros(1,3);
        %start the joystick
        start(hardware.joystick.joystick);
        
        %get the touch information
        dio = digitalio('nidaq','Dev1');
        
        behavIn1 = addline(dio, 0:7, 1, 'In');
        behavIn2 = addline(dio, 0:7, 2, 'In');

        set(behavIn1(2),'LineName','KT1')
        set(behavIn1(4),'LineName','KT2')

        set(behavIn1(8),'LineName','HandShakeIn')
        set(behavIn2, 'LineName', 'dirConnIn')

        dio.Tag = 'ModigInputDio';
        hardware.touch.touch = dio;
        hardware.touch.touch_error = 0;

        start(hardware.touch.touch);

    elseif strcmp(hardware.ni_inputs, 'digital')
        %get the joystick
        joystick = daq.createSession('ni');
        addAnalogInputChannel(joystick, 'Dev1','ai8','Voltage');
        addAnalogInputChannel(joystick, 'Dev1','ai9','Voltage');
        hardware.joystick.joystick = joystick;
        
        %get the touch sensor
        touch = daq.createSession('ni');
        addDigitalChannel(touch,'Dev1','Port1/Line1','InputOnly');
        hardware.touch.touch = touch;
        hardware.touch.touch_error = 0;
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
    
    %no touch input for testmode
    hardware.touch = NaN;
%elseif parameters.break.gui_variables
    
end

%no lick or eye data input as yet
hardware.lick = 'missing';
hardware.eyetracker = 'missing';