%small function to generate sounds to indicate the payouts for a trial- the
%remaining budget or the reward
%used in testmode where there is no solenoid corrected 
function sound_payout(results, payout)

sound_duration = 0.5; %0.5s

%define if to payout for budget or reward
if strcmp(payout, 'budget')
    freq_top = 130.813; %C3
    freq_bottom = 55; %A1
    
    output_freq = (results.outputs.budget * (freq_top - freq_bottom)) + freq_bottom;

elseif strcmp(payout, 'reward')
    freq_top = 1046.5; %C6
    freq_bottom = 440; %A4
    
    output_freq = (results.outputs.budget * (freq_top - freq_bottom)) + freq_bottom;
    
elseif strcmp(payout, 'error')
    freq_top = 1046.5; %C6
    freq_bottom = 55; %A1
    
    %sample randomly from this range
    output_freq = (rand * (freq_top - freq_bottom)) + freq_bottom;
end

Fs = 8192; % sampling frequency
t = 0:1/Fs:sound_duration;
%generate the sound wave
y = sin(2 * pi * output_freq * t);

sound(y,Fs)
    