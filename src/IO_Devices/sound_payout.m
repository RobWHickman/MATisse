function sound_payout(hardware, results, payout)

if payout == 'budget'
    amount = results.trial_results.remaining_budget;
    octave = 3;

elseif payout == 'reward'
    %normalise otherwise gets very high
    amount = 1 + (results.trial_results.reward/ 6);
    octave = 3;
end

if isfield(hardware.outputs.reward_output, 'speakers')
    %frequency of the error tone
    tone_frequency = 100; %middle C

    %produce the tone
    error_tone = sin(2*pi*tone_frequency*octave*amount*(0:1/8000:0.75));

    %sound the tone
    sound(error_tone);

else
    display('no sound output devices found for payout!');
end
