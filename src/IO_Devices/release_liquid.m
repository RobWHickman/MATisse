%function to release liquid from a solenoid tap for a given number of
%seconds
%there are 4 solenoid taps, of which 3 are in use at the moment
function release_liquid(parameters, hardware, results, payout)

if payout == 'budget'
    amount = results.trial_results.remaining_budget;
    tap = 1;

elseif payout == 'reward'
    amount = results.trial_results.reward;
    if parameters.save_info.primate == 'Ulysses'
        tap = 2;
    elseif parameters.save_info.primate == 'Vicer'
        tap = 3;
    end
end
    
%calculate the amount of liquid to release
%in seconds (of open tap)
amount = amount * 2;

%chose which solenoid port to open (change to 1)
if tap == 1 %water
    tap_open = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 2 %water
    tap_open = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
elseif tap == 3 %vicer juice tap
    tap_open = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
else
    display('no other tap found!');
end

%open the tap
putvalue(hardware.outputs.solenoid, tap_open)

%wait with the tap open
WaitSecs(amount);

%close the tap
reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
putvalue(hardware.outputs.solenoid, reset)
