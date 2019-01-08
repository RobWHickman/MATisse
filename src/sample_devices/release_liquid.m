%function to release liquid from a solenoid tap for a given number of
%seconds
%there are 4 solenoid taps, of which 3 are in use at the moment
function release_liquid(parameters, hardware, tap, tap_open_time)

if strcmp(hardware.ni_inputs, 'analog')
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
    
elseif strcmp(hardware.ni_inputs, 'digital')
    if tap == 1 %water
        tap_open = [0 1 0];
        tap_to_open = 13;
    elseif tap == 2 %ulysses water reward tap
        tap_open = [0 0 1];
        tap_to_open = 14;
    elseif tap == 3 %vicer juice reward tap
        tap_open = [1 0 0];
        tap_to_open = 12;
    else
        disp('no other tap found!');
    end

    tap_closed = [0 0 0];
    
    %outputSingleScan(hardware.solenoid.device, tap_open);
    
    if(tap_open_time > 0)
        getty_send_bits(parameters.getty.bits, tap_to_open, 1)

        %wait with the tap open
        WaitSecs(tap_open_time);
    
        %outputSingleScan(hardware.solenoid.device, tap_closed);
        getty_send_bits(parameters.getty.bits, tap_to_open, 0)
    end
end