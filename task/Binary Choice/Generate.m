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

%iniatilise the results tables
%initialise the output table
results.full_output_table = [];
results.experiment_summary = [];
%start on 0 total water/juice
results.experiment_summary.total_budget = 0;
results.experiment_summary.total_reward = 0;
results.experiment_summary.correct = 0;

%set the max number of trials for the task
if strcmp(parameters.task, 'BDM')
        parameters.max_trials = parameters.max_trials + (stimuli.fractals.fractal_info.number - mod(parameters.max_trials, stimuli.fractals.fractal_info.number));
elseif strcmp(parameters.task, 'BC')
    %round up to the nearest whole divisor of divisions * fractals
    parameters.max_trials = parameters.max_trials + ((parameters.binary_choice.divisions * stimuli.fractals.fractal_info.number)...
        - mod(parameters.max_trials, (parameters.binary_choice.divisions * stimuli.fractals.fractal_info.number)));
    parameters.max_trials = parameters.max_trials + mod(parameters.max_trials, 2 * (parameters.binary_choice.divisions * stimuli.fractals.fractal_info.number));
end

%if trial values are going to be pseudo random generate all of the
%combinations here
% if parameters.random_stim == 0
%     fractal_values = [1:stimuli.fractals.fractal_info.number];
%     if strcmp(parameters.task, 'BDM')
%         combinations = fractal_values;
%     elseif strcmp(parameters.task, 'BC')
%         bundle_water_values = [0:(1/parameters.binary_choice.divisions):1-(1/parameters.binary_choice.divisions)];
%         %should the bundle be on the left or the right
%         sides = [0, 1];
%         combinations = CombVec(fractal_values, bundle_water_values, sides);
%     end
% 
%     %export the combinations
%     stimuli.combinations = combinations;
%     %generate the list of the order these will be selected
%     possible_combinations = [1:length(combinations)];
%     possible_combinations = repmat(possible_combinations, 1, parameters.max_trials / length(combinations));
%     possible_combinations = possible_combinations(randperm(parameters.max_trials));
%     stimuli.combination_order = possible_combinations;
% end

if parameters.random_stim == 0
    stimuli.combinations = create_stimuli_order(parameters.task, stimuli.fractals.fractal_info.number, parameters.binary_choice.divisions, 2, 'na', parameters.max_trials);
    stimuli.combination_order = 1:parameters.max_trials;
end