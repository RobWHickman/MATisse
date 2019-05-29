%%
%clear everything
clear all;
close all;
daqreset;
clc;

%HANDSHAKE BIT FROM GETTY
hs_from_getty = daq.createSession('ni');
addDigitalChannel(hs_from_getty,'Dev1','Port1/Line7','InputOnly');
hs_from_getty.Channels(1).Name = 'getty';

%HARD TRIGGER TO GETTY
%and all other bits to getty as well
bits_out = daq.createSession('ni');
addDigitalChannel(bits_out,'Dev1','Port0/Line23','OutputOnly');
%set down for start
outputSingleScan(bits_out, 0)


%% get handshake from getty
%break after two mins
%e.g. if everything crashes
tic;
while toc < 50
    %is handshake up
   shake_in_value = inputSingleScan(hs_from_getty);
    if shake_in_value
        disp('HANDSHAKE FROM GETTY RECEIVED!!!!!');
        break
    end
end

if ~shake_in_value
    disp('never saw handshake from getty :(');
end

%% hard trigger to getty
%set the hard trigger up
outputSingleScan(bits_out, 1)
disp('hard trigger is up');
pause(1)
% set the hardtrigger down
outputSingleScan(bits_out, 0)
disp('hard trigger is down');

