function stimuli = load_stimuli(hardware, task_window)

%get the stimuli
stimuli.settings.images_path = '../../images/';
stimuli.settings.fractal_images = 'RA*.jpg';
stimuli.settings.bidspace_images = 'hatched2.jpg';
stimuli.settings.bidspace_overhang = 20;

%load the fractals
%stimuli settings used for the file path and screen_info used to resize the
%fractals
stimuli.fractals = load_fractal_images(stimuli.settings, hardware.outputs.screen_info);
%generate the bidspace
stimuli.bidspace = generate_bidspace(stimuli.settings, hardware.outputs.screen_info, task_window, 4);
%generate a fixation cross
%get rid of magic numbers which correspond to:
%length, thickness, colour and surrounding box scalar
stimuli.fixation_cross = generate_fixation_cross(7, 2, [1 1 1], 5, hardware.outputs.screen_info);
