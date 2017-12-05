%quick function to move the fractal and the reversed bidspace to the
%opposite half of the screen if left is selected for the bundle half
function stimuli = reflect_bundle(stimuli, hardware)

%move the reversed bidspace over the other side
bidspace_reflector = hardware.outputs.screen_info.width - stimuli.trial.reversed_bidspace_position(1) - stimuli.trial.reversed_bidspace_position(3);
stimuli.trial.reversed_bidspace_position = stimuli.trial.reversed_bidspace_position + [bidspace_reflector, 0, bidspace_reflector, 0];

%move the fractal over
fractal_reflector = hardware.outputs.screen_info.width - stimuli.fractals.fractal_info.fractal_position(1) - stimuli.fractals.fractal_info.fractal_position(3);
stimuli.fractals.fractal_info.fractal_position = stimuli.fractals.fractal_info.fractal_position + [fractal_reflector, 0, fractal_reflector, 0];
