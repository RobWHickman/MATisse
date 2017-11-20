%small function to produce a tone
%used to 'punish' the monkey for failing the task
%no variables as always the same tone regardless of error type
function sound_error_tone(hardware)

%check if speakers are set as the error output
%useful if find a way to check if speakers are actually connected, for now
%mostly useless
if isfield(hardware.outputs.error_output, 'speakers') 
    %frequency of the error tone
    tone_frequency = 261.6; %middle C

    %produce the tone
    error_tone = sin(2*pi*tone_frequency*(0:1/8000:0.75));

    %sound the tone
    sound(error_tone);

else
    display('no sound output devices found for error indication!');
end
