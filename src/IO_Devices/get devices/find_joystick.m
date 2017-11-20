%function to find an attached joystick and set parameters for it
function joystick = find_joystick(sampling_rate, session_version)
%clear the hardware in use
daqreset();

if nargin == 0
    sampling_rate = 200;
end

if session_version == 'analog'
    %analog version - deprecated
    joystick = analoginput('nidaq','Dev1');
    % add channels
    addchannel(joystick, [0 1 2 3]);
    joystick.SampleRate = sampling_rate;
    joystick.SamplesPerTrigger = inf;
    joystick.UserData = zeros(1,3);
    %start the joystick
    start(joystick);
else
    %add session stuff here
    joystick = daq.createSession('ni');
    addAnalogOutputChannel(joystick,'Dev1',0,'Voltage');
    joystick.IsContinuous = true;
    joystick.Rate=10000;
    data=linspace(-1,1,5000)';
    lh = addlistener(joystick,'DataRequired', ...
        @(src,event) src.queueOutputData(data));
    queueOutputData(joystick,data) 
    startBackground(joystick); 
end
