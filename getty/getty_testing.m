%send handshake to getty
getty_out = daq.createSession('ni');
addDigitalChannel(getty_out,'Dev1','Port0/Line0:15','OutputOnly');
outputSingleScan(getty_out, [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]);
outputSingleScan(getty_out, [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);

%receive handshake from getty
modig_in = daq.createSession('ni');
addDigitalChannel(modig_in,'Dev1','Port1/Line0:7','InputOnly');
modig_in_sample = inputSingleScan(modig_in);