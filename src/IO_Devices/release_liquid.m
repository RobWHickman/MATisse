%function to release liquid from a solenoid tap for a given number of
%seconds
%there are 4 solenoid taps, of which 3 are in use at the moment
function results = release_liquid(parameters, hardware, results, payout)
%calibration results
%follows equation y = mx + c
%y = amount of water, x is the length of the tap opening
m = 1; %m is the gradient of the calibration curve
c = 0; %c is the addec onstant of the calibration curve

if payout == 'budget'
    results.trial_results.budget_liquid = results.trial_results.remaining_budget * 1; %change this when converting from %budget into amounts
    tap_open_time = (results.trial_results.budget_liquid - c) / m;
    tap = 1;

elseif payout == 'reward'
    results.trial_results.reward_liquid = results.trial_results.reward * 1; %change this when converting from %budget into amounts
    tap_open_time = (results.trial_results.reward_liquid - c) / m;
    if parameters.save_info.primate == 'Ulysses'
        tap = 2;
    elseif parameters.save_info.primate == 'Vicer'
        tap = 3;
    end
end
    
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
WaitSecs(tap_open_time);

%close the tap
reset = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
putvalue(hardware.outputs.solenoid, reset)
