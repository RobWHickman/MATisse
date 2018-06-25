function data = eye_track(seconds, channels)
%connect (or whatever) matlab to the ni box
    ai = analoginput('nidaq','Dev1');

%the single ended vs differential thing
%default is differential
    %ai.InputType = 'SingleEnded'

%add a channel(s) to read from
%generally single for debugging atm tho does work with multiple
    addchannel(ai, channels)

%sample rate and # samples to collect from the ni box
%e.g. for five seconds read what the joystick is sending to the homemade
%box which relays it to the ni box then in theory into matlab
    ai.SampleRate = 800;
    ai.SamplesPerTrigger = ai.SampleRate * seconds;
%dont actually know exactly what this does
    ai.TriggerType = 'Immediate';

%start the connection (or equivalent?)
    start(ai);

%get the data and plot it
    [d,t] = getdata(ai);
    plot(t,d);

%stop the box
    stop(ai);

%reset matlabs dar connections
%so function can be run again
    daqreset
end
  

