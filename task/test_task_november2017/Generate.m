%function to initialise the experiment to be run
%loads as much as possible without opening a task window
%gets information on the screen being used and task parameters (how many
%trials/ which monitor/ etc.)
function [parameters, stimuli, hardware, results, task_window] =  Generate(hardware)
%open a psychtoolbox screen for the task
%set it to black for now
[task_window, task_windowrect] = PsychImaging('OpenWindow', hardware.outputs.screen_info.screen_number, 0);
%set psychtoolbox to be the computers priority
%Priority(MaxPriority(task_window));

%find all necessary devices
%task_window is needed to find the mouse
hardware = get_task_devices(hardware, task_window);

%load/ generate the stimuli for the task
stimuli = load_stimuli(hardware, task_window);

%get the parameters for the task
parameters = get_all_parameters(hardware);

%iniatilise the results tables
%initialise the output table
results.full_output_table = [];
results.experiment_summary = [];
%start on 0 total water/juice
results.experiment_summary.total_water = 0;
results.experiment_summary.total_juice = 0;
results.experiment_summary.correct = 0;

