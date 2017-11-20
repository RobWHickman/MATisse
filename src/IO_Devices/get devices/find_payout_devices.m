function hardware = find_payout_devices(hardware)

if hardware.testmode
    %add stuff here if possible to actually look for and find speakers
    hardware.outputs.reward_output.speakers = 'speakers';
else
    hardware.outputs.reward_output.solenoid = find_solenoid();
end