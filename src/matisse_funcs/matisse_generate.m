%function to initialise the experiment to be run
%loads as much as possible without opening a task window
%gets information on the screen being used and task parameters (how many
%trials/ which monitor/ etc.)
function [parameters, hardware, stimuli, task_window] =  matisse_generate(parameters, hardware, stimuli, modifiers, task_window)

if nargin < 5
    disp('initial generation');
    %skip sync tests when just testing out code
        Screen('Preference', 'SkipSyncTests', 1);
        Screen('Preference', 'SkipSyncTests', 2);

    %open a psychtoolbox screen for the task
    %set it to black for now
   [task_window, task_windowrect] = PsychImaging('OpenWindow', hardware.screen.number, 0);
   Screen('BlendFunction', task_window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    %set psychtoolbox to be the computers priority
    %Priority(MaxPriority(task_window));

%find all necessary devices
%task_window is needed to find the mouse
hardware = get_task_devices(parameters, hardware, task_window);
else
    hardware = get_task_devices(parameters, hardware, task_window);
end

%load/ generate the stimuli for the task
stimuli = load_stimuli(parameters, hardware, stimuli, modifiers, task_window);

%get the parameters for the task
parameters = get_all_parameters(parameters, hardware);

%set the max number of trials for the task
%round up to the nearest whole divisor of divisions * fractals
parameters.trials.max_trials = parameters.trials.max_trials + ((modifiers.budget.divisions * modifiers.fractals.number)...
    - mod(parameters.trials.max_trials, (modifiers.budget.divisions * modifiers.fractals.number)));
parameters.trials.max_trials = parameters.trials.max_trials + mod(parameters.trials.max_trials, 2 * (modifiers.budget.divisions * modifiers.fractals.number));

%should the order be generated on the fly and fully randomly
%might not result in even numbers of trial per combination and increase
%task switching
if parameters.trials.random_stimuli == 0
    parameters.trials.combinations = create_stimuli_order(modifiers, parameters, stimuli);
end

%set the free reward key
KbName('UnifyKeyNames');
free_reward = [KbName('f')];
%RestrictKeysForKbCheck(free_reward);
ListenChar(2);

%if nargin < 5
    %if parameters.getty.on
        parameters.getty.bits = getty_bit_output();
        parameters.getty.shake_in = daq.createSession('ni');
        addDigitalChannel(parameters.getty.shake_in,'Dev1','Port1/Line7','InputOnly');
    %end
%end