%function to grab the solenoid given the set up in 313
%doesnt maintain the handshake stuff- see Modig
function hardware = find_solenoid(hardware)

if strcmp(hardware.ni_inputs, 'analog')
    %find the device
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
    
if strcmp(hardware.ni_inputs, 'digital')
    solenoid = daq.createSession('ni');
    addDigitalChannel(solenoid,'Dev1','Port0/Line9:11','OutputOnly');
    % tap_open = [0 1 0]; %tap1 water
    % tap_closed = [0 0 0];
    % outputSingleScan(solenoid, tap_open);

    %prepare for output
    hardware.solenoid.device = solenoid;
end