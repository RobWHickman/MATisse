function bits_out = getty_bit_output()

%this will clear everything- good for tests but not in production!!
daqreset;

%only digital input for now as draft
bits_out.fractal_display = daq.createSession('ni');
addDigitalChannel(bits_out.fractal_display,'Dev1','Port0/Line8','OutputOnly');

bits_out.timing_out2 = daq.createSession('ni');
addDigitalChannel(bits_out.timing_out2,'Dev1','Port0/Line9','OutputOnly');

bits_out.timing_out3 = daq.createSession('ni');
addDigitalChannel(bits_out.timing_out3,'Dev1','Port0/Line10','OutputOnly');

bits_out.timing_out4 = daq.createSession('ni');
addDigitalChannel(bits_out.timing_out4,'Dev1','Port0/Line11','OutputOnly');

bits_out.juice_out = daq.createSession('ni');
addDigitalChannel(bits_out.juice_out,'Dev1','Port0/Line12','OutputOnly');

bits_out.juice_out2 = daq.createSession('ni');
addDigitalChannel(bits_out.juice_out,'Dev1','Port0/Line14','OutputOnly');

bits_out.water_out = daq.createSession('ni');
addDigitalChannel(bits_out.juice_out,'Dev1','Port0/Line13','OutputOnly');

bits_out.timing_out5 = daq.createSession('ni');
addDigitalChannel(bits_out.timing_out5,'Dev1','Port0/Line15','OutputOnly');

bits_out.trigger_out = daq.createSession('ni');
addDigitalChannel(bits_out.trigger_out,'Dev1','Port0/Line22','OutputOnly');

bits_out.shake_out = daq.createSession('ni');
addDigitalChannel(bits_out.shake_out,'Dev1','Port0/Line23','OutputOnly');
