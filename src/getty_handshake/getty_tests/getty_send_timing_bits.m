function getty_send_timing_bits(device, lines, bits)

%remove zero indexing
output_line = lines+1;

%create a null set of zeroes to reset channel
number_of_channels = length(device.Channels);
bit_vec = zeros(1, number_of_channels);
bit_vec(output_line) = bits;

disp('sending bit on');
disp(device);
disp('sending bit vector');
disp(bit_vec);
outputSingleScan(device, bit_vec);