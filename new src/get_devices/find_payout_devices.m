%function to find devices used to indicate how the rewarded should be given
%to the monkey (via the juice through solenoid if upstairs, or via speakers
%downstairs for testing)
%also indexes the solenoid ports so they can be used later in the task
function hardware = find_payout_devices(parameters, hardware)

if parameters.break.testmode
    %add stuff here if possible to actually look for and find speakers
    hardware.solenoid.device = 'speakers';
else
    hardware = find_solenoid(hardware);
    fprintf('found solenoid');
end