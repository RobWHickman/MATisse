%function to make a small fixation cross in the center of the screen
%also creates a box around the fixation cross within which the monkey must
%look to progress the task
%for debugging this is done by clicking that box for now
function fixation = generate_fixation_cross(cross_length, cross_thickness, circle_radius, circle_color, eyetrack_scalar, hardware)
%neaten up variables
screen_info = hardware.outputs.screen_info;

%generate the fixation cross coordinates
fixation_cross_along = [-cross_length cross_length 0 0];
fixation_cross_up = [0 0 -cross_length cross_length];
fixation_cross = [fixation_cross_along; fixation_cross_up];

%generate the fixation circle coordinates
fixation_circle.x_pos = screen_info.width / 2;
fixation_circle.y_pos = screen_info.height / 2;
fixation_circle.radius = circle_radius;
fixation_circle = [(fixation_circle.x_pos-fixation_circle.radius) (fixation_circle.y_pos-fixation_circle.radius) (fixation_circle.x_pos+fixation_circle.radius) (fixation_circle.y_pos+fixation_circle.radius)];

%generate the fixation cross aesthetics
fixation_cross_info.thickness = cross_thickness;
fixation_cross_info.colour = [screen_info.white screen_info.white 0];
fixation_cross_info.position = [screen_info.width / 2, screen_info.height / 2];

%generate the fixation circle aesthetics
fixation_circle_info.color = circle_color;

%generate a surrounding box of twice the size
fixation_box = [(-cross_length * eyetrack_scalar) (-cross_length * eyetrack_scalar) (cross_length * eyetrack_scalar) (cross_length * eyetrack_scalar)];
fixation_box = CenterRectOnPointd(fixation_box, screen_info.width / 2, screen_info.height / 2);


%prep for output
fixation.fixation_cross = fixation_cross;
fixation.fixation_cross_info = fixation_cross_info;
fixation.fixation_circle = fixation_circle;
fixation.fixation_circle_info = fixation_circle_info;
fixation.fixation_box = fixation_box;
