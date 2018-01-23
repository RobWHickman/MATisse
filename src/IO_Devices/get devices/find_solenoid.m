%function to grab the solenoid given the set up in 313
%doesnt maintain the handshake stuff- see Modig
function hardware = find_solenoid(hardware)
%find the device
%legacy code for MATLAB 2014- uses session-based interfaces now
    %look at find_joystick for inspiration
solenoid = digitalio('nidaq','Dev1');
%add the output lines
addline(solenoid, 0:31, 0,'Out'); 
solenoid.Tag = 'SolenoidOutput';     

%descrition for each port
vector =   {'PreTrial', '', 'PostTrial', '', 'unassigned', 'unassigned', 'unassigned', 'unassigned', 'unassigned', 'Juice3', 'Juice1', 'Juice2', 'Lick1', 'unassigned', 'Neuron', 'EMG'};            
x = 1:16;
for pos = x
    solenoid.Line(pos).LineName = vector{pos};
end

%prepare for output
hardware.solenoid.device = solenoid;