function getty_send_bits(device, lines, bits, solenoids)
if nargin == 3
    %get the current state of the solenoids
    solenoid_scan = [0,0];
else
    solenoid_scan = inputSingleScan(solenoids);
end

%remove zero indexing
output_line = lines+1;

%create a null set of zeroes to reset channel
number_of_channels = length(device.Channels);
bit_vec = zeros(1, number_of_channels);

%magic numbers but should be maintained
solenoid_bits = [17, 18];
bit_vec(solenoid_bits) = solenoid_scan;

%add in the sent bit
bit_vec(output_line) = bits;

outputSingleScan(device, bit_vec);