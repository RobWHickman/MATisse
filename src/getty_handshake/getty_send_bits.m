function getty_send_bits(device, lines, bits)

%remove zero indexing
lines = lines+1;

%create a null set of zeroes to reset channel
number_of_channels = length(device.Channels);
null_bits = zeros(1, number_of_channels);

%initialise a set of bits to send
%fill these in with the specified bits
send_bits = null_bits;
for bit = 1:length(lines)
    line = lines(bit);
    send_bits(line) = bits;
end

outputSingleScan(device, send_bits);

%for testing- probably want to delete in production
WaitSecs(2);

%set all bits back to null ??
outputSingleScan(device, null_bits);


