%function to find an attached joystick and set parameters for it
function ni_devices = find_nibox(sampling_rate, session_version)
%clear the hardware in use
daqreset();



if nargin == 0
    sampling_rate = 200;
end

if session_version == 'analog'
    %analog version - deprecated
    ni_devices = analoginput('nidaq','Dev1');
    % add channels
    addchannel(ni_devices, 0:7);
    ni_devices.SampleRate = sampling_rate;
    ni_devices.SamplesPerTrigger = inf;
    ni_devices.UserData = zeros(1,3);
    %start the joystick
    start(ni_devices);
else
    %add session stuff here
    ni_devices = daq.createSession('ni');
    addAnalogOutputChannel(ni_devices,'Dev1',0,'Voltage');
    ni_devices.IsContinuous = true;
    ni_devices.Rate=10000;
    data=linspace(-1,1,5000)';
    lh = addlistener(ni_devices,'DataRequired', ...
        @(src,event) src.queueOutputData(data));
    queueOutputData(ni_devices,data) 
    startBackground(ni_devices); 
end
