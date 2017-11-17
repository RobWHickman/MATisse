%small function to produce a tone
%used to 'punish' the monkey for failing the task
function sound_error_tone(hardware)

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
