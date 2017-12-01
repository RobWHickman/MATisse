%function to initialise the experiment to be run
%loads as much as possible without opening a task window
%gets information on the screen being used and task parameters (how many
%trials/ which monitor/ etc.)
function [parameters, stimuli, hardware, results, task_window] =  Generate(parameters, hardware)
if hardware.testmode
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'SkipSyncTests', 2);
end

%open a psychtoolbox screen for the task
%set it to black for now
[task_window, task_windowrect] = PsychImaging('OpenWindow', hardware.outputs.screen_info.screen_number, 0);
Screen('BlendFunction', task_window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%set psychtoolbox to be the computers priority
%Priority(MaxPriority(task_window));

%find all necessary devices
%task_window is needed to find the mouse
hardware = get_task_devices(hardware, task_window);

%load/ generate the stimuli for the task
stimuli = load_stimuli(parameters, hardware, task_window, 'BC');

%get the parameters for the task
parameters = get_all_parameters(parameters, hardware);

%iniatilise the results tables
%initialise the output table
results.full_output_table = [];
results.experiment_summary = [];
%start on 0 total water/juice
results.experiment_summary.total_budget = 0;
results.experiment_summary.total_reward = 0;
results.experiment_summary.correct = 0;

