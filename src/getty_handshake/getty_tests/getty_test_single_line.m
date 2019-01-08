daqreset;
bits_out = daq.createSession('ni');
addDigitalChannel(bits_out,'Dev1','Port0/Line18','OutputOnly');
getty_send_bits(bits_out, 0, 1);
