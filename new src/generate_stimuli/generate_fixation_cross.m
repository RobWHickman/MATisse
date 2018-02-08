%function to make a small fixation cross in the center of the screen
%also creates a box around the fixation cross within which the monkey must
%look to progress the task
%for debugging this is done by clicking that box for now
function fixation = generate_fixation_cross(cross_length, cross_thickness, eyetrack_scalar, hardware)
%generate the fixation cross coordinates
fixation_cross_along = [-cross_length cross_length 0 0];
fixation_cross_up = [0 0 -cross_length cross_length];
fixation_cross = [fixation_cross_along; fixation_cross_up];

%generate the fixation cross aesthetics
fixation_cross_info.thickness = cross_thickness;
fixation_cross_info.colour = [hardware.screen.colours.white hardware.screen.colours.white 0];
fixation_cross_info.position = [hardware.screen.dimensions.width / 2, hardware.screen.dimensions.height / 2];

%generate a surrounding box of twice the size
fixation_box = [(-cross_length * eyetrack_scalar) (-cross_length * eyetrack_scalar) (cross_length * eyetrack_scalar) (cross_length * eyetrack_scalar)];
fixation_box = CenterRectOnPointd(fixation_box, hardware.screen.dimensions.width / 2, hardware.screen.dimensions.height / 2);

%prep for output
fixation.fixation_cross = fixation_cross;
fixation.fixation_cross_info = fixation_cross_info;
fixation.fixation_box = fixation_box;
