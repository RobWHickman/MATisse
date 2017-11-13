%function to initialise the experiment to be run
%loads as much as possible without opening a task window
%gets information on the screen being used and task parameters (how many
%trials/ which monitor/ etc.)
function [parameters, stimuli, hardware, results, task_window] =  Generate(hardware)
%find all necessary devices
hardware = get_task_devices(hardware);

%open a psychtoolbox screen for the task
[task_window, task_windowrect] = PsychImaging('OpenWindow', hardware.outputs.screen_info.number, hardware.outputs.screen_info.bg_col);
%set psychtoolbox to be the computers priority
%Priority(MaxPriority(task_window));

%get the basic parameters for the experiment
%parameters = set_experiment_parameters(hardware.inputs.settings.testmode);
%get the rest of the parameters
%timings- which need to be multiplied by the monitor refresh rate
%parameters.timings = get_intervals(hardware.outputs.screen_info);

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
stimuli.bidspace = generate_bidspace(stimuli.settings, hardware.outputs.screen_info, task_window);
%generate a fixation cross
%get rid of magic numbers which correspond to:
%length, thickness, colour and surrounding box scalar
stimuli.fixation_cross = generate_fixation_cross(7, 2, [1 1 1], 5, hardware.outputs.screen_info);

%iniatilise the results tables
%initialise the output table
results.full_output.full_output_table = [];
results.experiment_summary = [];
%start on 0 total water/juice
results.experiment_summary.total_water = 0;
results.experiment_summary.total_juice = 0;
