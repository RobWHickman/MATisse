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
    
elseif strcmp(hardware.ni_inputs, 'digital')
    solenoid = daq.createSession('ni');
    addDigitalChannel(solenoid,'Dev1','Port0/Line12:14','OutputOnly');

    %prepare for output
    hardware.solenoid.device = solenoid;
end