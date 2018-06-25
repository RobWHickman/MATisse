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
stimuli = load_stimuli(parameters, hardware, task_window);

%get the parameters for the task
parameters = get_all_parameters(parameters, hardware);

%set the max number of trials for the task
if strcmp(parameters.task, 'BDM')
        parameters.max_trials = parameters.max_trials + (stimuli.fractals.fractal_info.number - mod(parameters.max_trials, stimuli.fractals.fractal_info.number));
elseif strcmp(parameters.task, 'BC')
    %round up to the nearest whole divisor of divisions * fractals
    parameters.max_trials = parameters.max_trials + ((parameters.binary_choice.divisions * stimuli.fractals.fractal_info.number)...
        - mod(parameters.max_trials, (parameters.binary_choice.divisions * stimuli.fractals.fractal_info.number)));
    parameters.max_trials = parameters.max_trials + mod(parameters.max_trials, 2 * (parameters.binary_choice.divisions * stimuli.fractals.fractal_info.number));
end

if parameters.random_stim == 0
    stimuli.combinations = create_stimuli_order(stimuli.fractals.fractal_info.number, parameters.binary_choice.divisions, 2, parameters.max_trials);
    stimuli.combination_order = 1:parameters.max_trials;
end