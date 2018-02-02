%quick function to move the fractal and the reversed bidspace to the
%opposite half of the screen if left is selected for the bundle half
function stimuli = reflect_bundle(stimuli, hardware)

%move the reversed bidspace over the other side
%the budget should always be on the opposite side to the bundle water
bidspace_reflector = results.single_trial.bundle_half * (hardware.screen.dimensions.width - stimuli.bidspace.reverse_texture_position(1) - stimuli.bidspace.reverse_texture_position(3));
budget_reflector = abs(results.single_trial.bundle_half - 1) * (hardware.screen.dimensions.width - stimuli.trial.reversed_bidspace_position(1) - stimuli.bidspace.reverse_texture_position(3));
%reflect the bundle and budget water reverses
stimuli.bidspace.reverse_texture_position = stimuli.bidspace.reverse_texture_position + [bidspace_reflector, 0, bidspace_reflector, 0];
stimuli.budget.reverse_texture_position = stimuli.bidspace.reverse_texture_position + [budget_reflector, 0, budget_reflector, 0];
%crop down the budget position to it's value
stimuli.budget.reverse_texture_position(2) = stimuli.budget.reverse_texture_position(4) - (stimuli.budget.reverse_texture_position * results.single_trial.budget_value);

%first set the position of the hypothetical second fractal to opposite the first fractal
if modifiers.budget.only_fractals
    fractal2_reflector = abs(results.single_trial.bundle_half - 1) * (hardware.screen.dimensions.width - stimuli.fractals.position(1) - stimuli.fractals.position(3));
    stimuli.fractals2.position = stimuli.fractals.position + [fractal2_reflector, 0, fractal2_reflector, 0];
end

%move the fractal over
fractal_reflector = results.single_trial.bundle_half * (hardware.screen.dimensions.width - stimuli.fractals.position(1) - stimuli.fractals.position(3));
stimuli.fractals.position = stimuli.fractals.position + [fractal_reflector, 0, fractal_reflector, 0];

