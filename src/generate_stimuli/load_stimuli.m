function stimuli = load_stimuli(parameters, hardware, stimuli, modifiers, task_window)
%get the stimuli location
%fractal name set via the GUI
modifiers.fractals.folder = '../decorators/images/';

%set the width/height of the screen from which the dimensions of the
%stimuli will be built
%neaten up variables
width = hardware.screen.dimensions.width;
height = hardware.screen.dimensions.height;

%load the fractals
%stimuli settings used for the file path and screen_info used to resize the
%fractals
stimuli.fractals = load_fractal_images(parameters, modifiers, width, height);

%in pavlovian learning tasks just the fractal (or fractal vs. fractal) is
%shown
if ~strcmp(parameters.task.type, 'PAV')
    %generate the bidspace
    %the bar is also considered part of the bidspace for ease of storing
    %variables
    stimuli.bidspace = generate_bidspace(parameters, modifiers, task_window, width, height);
    
    %generate lines over the bidspace to help with targeting
    stimuli.bidspace.lines = generate_bidspace_lines(stimuli, hardware, 'major');
end

% if parameters.targeting.requirement == 1 && strcmp(parameters.task, 'BDM')
%     stimuli.target_box = generate_target_box(parameters, stimuli, hardware, 0);
% end

%generate a fixation cross
%get rid of magic numbers which correspond to:
%length, thickness, colour and surrounding box scalar
stimuli.fixation_cross = generate_fixation_cross(12, 4, 3, hardware);
