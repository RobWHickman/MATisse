%quick function to move the fractal and the reversed bidspace to the
%opposite half of the screen if left is selected for the bundle half
function stimuli = reflect_stimuli(stimuli, hardware, modifiers, side)

%move the reversed bidspace over the other side
%the budget should always be on the opposite side to the bundle water
bidspace_reflector = hardware.screen.dimensions.width - stimuli.bidspace.position(1) - stimuli.bidspace.position(3);
fractal_reflector = hardware.screen.dimensions.width - stimuli.fractals.position(1) - stimuli.fractals.position(3);

if strcmp(side, 'right')
    %reflect the bundle and budget water reverses
    %if ~modifiers.fractals.no_fractals
        stimuli.bidspace.position = stimuli.bidspace.position + [bidspace_reflector, 0, bidspace_reflector, 0];
        stimuli.bidspace.reverse_texture_position = stimuli.bidspace.reverse_texture_position + [bidspace_reflector, 0, bidspace_reflector, 0];
        [bidspace_xcenter, bidspace_ycenter] = RectCenter(stimuli.bidspace.position);
        stimuli.bidspace.bidspace_bounding_box = CenterRectOnPointd(stimuli.bidspace.bidspace_frame, bidspace_xcenter, bidspace_ycenter);
    %end

    %first set the position of the hypothetical second fractal to opposite the first fractal
    if ~modifiers.budgets.no_budgets
        stimuli.fractals.position = stimuli.fractals.position + [fractal_reflector, 0, fractal_reflector, 0];
    end
elseif strcmp(side, 'left')
    if modifiers.fractals.no_fractals
        stimuli.bidspace.second_reverse_texture_position = stimuli.bidspace.second_reverse_texture_position + [bidspace_reflector, 0, bidspace_reflector, 0];
    end
end


