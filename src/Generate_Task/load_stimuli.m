function stimuli = load_stimuli(parameters, hardware, task_window)
%get the stimuli
stimuli.settings.images_path = '../../images/';
stimuli.settings.fractal_images = 'RL*.jpg';
stimuli.settings.bidspace_images = 'hatched2.jpg';
stimuli.settings.bidspace_overhang = 20;

%load the fractals
%stimuli settings used for the file path and screen_info used to resize the
%fractals
stimuli.fractals = load_fractal_images(stimuli.settings, hardware.outputs.screen_info, parameters.task);
if ~strcmp(parameters.task, 'PAV')
%generate the bidspace
%the bar is also considered part of the bidspace for ease of storing
%variables
stimuli.bidspace = generate_bidspace(stimuli.settings, hardware.outputs.screen_info, task_window, parameters.task);
end
%generate a fixation cross
%get rid of magic numbers which correspond to:
%length, thickness, colour and surrounding box scalar
stimuli.fixation_cross = generate_fixation_cross(12, 4, 3, hardware);

%if need to generate a target box, do it here
%for a static target_box
%moved to run.m for generating a box that shrinks as monkey improves
if parameters.targeting.requirement == 1 && strcmp(parameters.task, 'BDM')
    stimuli.target_box = generate_target_box(parameters, stimuli, hardware, 0);
end
