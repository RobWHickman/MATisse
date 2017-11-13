%function to initialise the experiment to be run
%loads as much as possible without opening a task window
%gets information on the screen being used and task parameters (how many
%trials/ which monitor/ etc.)
function [full_output, experiment_summary, parameters, fractals, fractal_info, bidspace_texture, reverse_bidspace, bidspace_info, bidspace_bounding_box, fixation_cross, fixation_cross_info, fixation_box, screen_info, task_window] =  Generate(hardware)

%initialise the output table
full_output.full_output_table = [];
experiment_summary = [];
%start on 0 total water/juice
experiment_summary.total_water = 0;
experiment_summary.total_juice = 0;

%get the basic parameters for the experiment
parameters = set_experiment_parameters(parameters);
%load the timings table
timings = load('interval_times.mat');
parameters.timings = timings.interval_times;

%load the fractals
[fractals, fractal_info] = load_fractal_images(parameters.paths.images_folder, parameters.paths.fractal_images);
%get screen information
screen_info = get_screen_information(experimental_monitor);
%get the rest of the parameters
%timings
parameters.timings = get_intervals(screen_info);

%open a psychtoolbox screen for the task
[task_window, task_windowrect] = PsychImaging('OpenWindow', screen_info.task_monitor, screen_info.bg_col);
%set psychtoolbox to be the computers priority
%Priority(MaxPriority(task_window));

%   BUILD EXPERIMENTAL OBJECTS
%generate the bidspace
[bidspace_texture, reverse_bidspace, bidspace_info, bidspace_bounding_box] = generate_bidspace(parameters, screen_info, task_window, 20);
%generate a fixation cross
[fixation_cross, fixation_cross_info, fixation_box] = generate_fixation_cross(7, 2, [parameters.screen.white], 5, screen_info);
