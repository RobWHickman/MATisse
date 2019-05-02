%reset the daq object
%only need to do once at very start
daqreset;
clear all
close all

%find the solenoid
solenoid = daq.createSession('ni');
%make sure correct lines are set for all solenoids
%17:18 corresponds to 9:10 on Behaviour Out
addDigitalChannel(solenoid,'Dev1','Port0/Line17:18','OutputOnly');
empty_vec = zeros(2, 1)';

%PARAMETERS TO VARY
%which solenoid to open
solenoid_to_open = 2;
%put the bit for that solenoid in the vector
bit_vec = empty_vec;
bit_vec(solenoid_to_open) = 1;

%how long to open it
open_length = 0.21;
%how long to wait between jets 
%don't need to vary once you have a good amount
wait_length = .25;

%how many times to open it
repeat_opens = 75;

%OPEN THE SOLENOIDS
disp('CALIBRATING SOLENOID');
for repeat = 1:repeat_opens
    %open
    outputSingleScan(solenoid, bit_vec);
    %open time
    WaitSecs(open_length);
    %close
    outputSingleScan(solenoid, empty_vec);
    %wait enough that discrete pulses are sent
    WaitSecs(wait_length);
end

disp('done')