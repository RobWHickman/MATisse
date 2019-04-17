%function to find an attached joystick and set parameters for it
function joystick = find_joystick(session, sampling_rate)
%clear the hardware in use
daqreset();

if strcmp(session, 'analog')
    fprintf('finding analog ni devices');
    %analog version - deprecated
    joystick = analoginput('nidaq','Dev1');
    % add channels
    addchannel(joystick, 0:7);
    joystick.SampleRate = sampling_rate;
    joystick.SamplesPerTrigger = inf;
    joystick.UserData = zeros(1,3);
    %start the joystick
    start(joystick);

elseif strcmp(session, 'digital')
    %get the joystick
    joystick = daq.createSession('ni');
    addAnalogInputChannel(joystick, 'Dev1','ai8','Voltage');
    addAnalogInputChannel(joystick, 'Dev1','ai9','Voltage');
%         data=linspace(-1,1,5000)';
%         lh = addlistener(joystick,'DataRequired', ...
%             @(src,event) src.queueOutputData(data));
end
