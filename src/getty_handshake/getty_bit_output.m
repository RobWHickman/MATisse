function bits_out = getty_bit_output()

%this will clear everything- good for tests but not in production!!
daqreset;

%only digital input for now as draft
bits_out = daq.createSession('ni');
addDigitalChannel(bits_out,'Dev1','Port0/Line8:11','OutputOnly');
addDigitalChannel(bits_out,'Dev1','Port0/Line15','OutputOnly');