%function to grab the solenoid given the set up in 313
%doesnt maintain the handshake stuff- see Modig
function hardware = find_solenoid(hardware)
daqreset
solenoid = daq.createSession('ni');
addDigitalChannel(solenoid,'Dev1','Port0/Line9:11','OutputOnly');
tap_open = [0 1 0]; %tap1 water
tap_closed = [0 0 0];
outputSingleScan(solenoid, tap_open);

%prepare for output
hardware.solenoid.device = solenoid;