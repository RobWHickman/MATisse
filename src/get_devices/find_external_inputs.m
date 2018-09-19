%function to find the devices that will be used to maniplate the task
%this will be either the joystick or the keyboard in either the x or y
%dimension
function hardware = find_external_inputs(parameters, hardware)
%clear the hardware in use
daqreset();

%for upstairs- not testmode
if ~parameters.break.testmode
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
        hardware.joystick.touch = dio;
        hardware.joystick.touch_perc = 0.4;

        start(hardware.joystick.touch);

    elseif strcmp(hardware.ni_inputs, 'digital')
        %get the joystick
        joystick = daq.createSession('ni');
        addAnalogInputChannel(joystick, 'Dev1',0,'Voltage');
        addAnalogInputChannel(joystick, 'Dev1',1,'Voltage');
%         data=linspace(-1,1,5000)';
%         lh = addlistener(joystick,'DataRequired', ...
%             @(src,event) src.queueOutputData(data));
        hardware.joystick.joystick = joystick;
        startBackground(hardware.joystick.joystick);
        
        %get the touch sensor
        touch = daq.createSession('ni');
        addDigitalChannel(touch,'Dev1','Port1/Line1','InputOnly');
        hardware.joystick.touch = touch;
        startBackground(hardware.joystick.touch);
        hardware.joystick.touch_perc = 0.4;
        hardware.joystick.touch_error = 0;
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
end

%no lick or eye data input as yet
hardware.lick = NaN;
hardware.eyetracker = NaN;