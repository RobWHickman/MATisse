%send handshake to getty
to_getty = daq.createSession('ni');
addDigitalChannel(to_getty,'Dev1','Port0/Line15','OutputOnly');
to_getty.Channels(1).Name = 'modig';
outputSingleScan(to_getty, 1);

%receive handshake from getty
from_getty = daq.createSession('ni');
addDigitalChannel(from_getty,'Dev1','Port1/Line7','InputOnly');
from_getty.Channels(1).Name = 'getty';
from_getty_sample = inputSingleScan(from_getty);



%the analog inputs used for the joystick
neurons = daq.createSession('ni');
addAnalogInputChannel(neurons, 'Dev1', 0:31, 'Voltage');
neuron_data = inputSingleScan(neurons);

for sample = 1:10000
   neuron_data = inputSingleScan(neurons);
   
   if sample == 1
       neuron_table = neuron_data;
   else
       neuron_table = vertcat(neuron_table, neuron_data);
   end
end

plot(neuron_table);
