%small function to generate sounds to indicate the payouts for a trial- the
%remaining budget or the reward
%used in testmode where there is no solenoid corrected 
function results = sound_payout(hardware, results, payout)

%calibration results
%follows equation y = mx + c
%y = amount of water, x is the length of the tap opening
m = 1; %m is the gradient of the calibration curve
c = 0; %c is the addec onstant of the calibration curve

%define if to payout for budget or reward
if payout == 'budget'
    results.trial_results.budget_liquid = results.trial_results.remaining_budget * 1; %change this when converting from %budget into amounts
    tap_open_time = (results.trial_results.budget_liquid - c) / m;
    tone_frequency = 440;

elseif payout == 'reward'
    results.trial_results.reward_liquid = results.trial_results.reward / 6; %change this when converting from %budget into amounts
    tap_open_time = (results.trial_results.reward_liquid - c) / m;
    tone_frequency = 880;
end

%if the output is set as speakers produce a tone
if isfield(hardware.outputs.reward_output, 'speakers')
    %produce the tone
    error_tone = sin(2*pi*tone_frequency*(0:1/8000:tap_open_time));

    %sound the tone
    sound(error_tone);

else
    display('no sound output devices found for payout!');
end
