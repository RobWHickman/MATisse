%function to release liquid from a solenoid tap for a given number of
%seconds
%there are 4 solenoid taps, of which 3 are in use at the moment
function release_liquid(hardware, tap, tap_open_time)

if ~strcmp(hardware.solenoid.device.tag, 'SolenoidOutput')
    disp('solenoid not set!');
end

%chose which solenoid port to open (change to 1)
%there is a fourth solenoid but it isnt hooked up
if tap == 1 %water
    tap_open = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 2 %ulysses water reward tap
    tap_open = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 3 %vicer juice reward tap
    tap_open = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
else
    disp('no other tap found!');
end

%open the tap
putvalue(hardware.solenoid, tap_open)

%wait with the tap open
WaitSecs(tap_open_time);

%close the tap
reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
putvalue(hardware.outputs.reward_output, reset)