%BDM task function
function [results, parameters] = Run(parameters, stimuli, hardware, results, task_window)
%set initial trial values (see below)
%needed here for first trial
if parameters.total_trials < 1
    [parameters, results] = set_initial_trial_values(parameters, stimuli, hardware, results);
end

%% EPOCHS %%
%% the different epochs in the task if all checks are met %%
for frame = 1:(parameters.timings.Frames('epoch4') + parameters.timings.Delay('epoch4'))
    %draw the seventh epoch
    if frame == 1 | frame == (parameters.timings.Frames('epoch4') + parameters.timings.Delay('epoch4'))
        draw_epoch_8(hardware, task_window);
    end
    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    if frame == 1
    [parameters, results] = set_initial_trial_values(parameters, stimuli, hardware, results);
    stimuli = select_fractal(parameters, stimuli, task_window);
    end
    
    if frame == (parameters.timings.Frames('epoch4') + parameters.timings.Delay('epoch4'))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

% EPOCH 1 - fixation cross
for frame = 1:(parameters.timings.Frames('epoch1') + parameters.timings.Delay('epoch1'))
    %draw the first epoch
    if frame == 1 | frame == (parameters.timings.Frames('epoch1') + parameters.timings.Delay('epoch1'))
        draw_epoch_1(stimuli, hardware, task_window);
    end
    %check if the monkey is fixating on the cross
    [parameters, results] = check_fixation(parameters, stimuli, results, hardware, task_window);
    if frame == (parameters.timings.Frames('epoch1') + parameters.timings.Delay('epoch1'))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

%continue with task if monkey fixates
if (results.trial_values.task_checks.Status('fixation') | ~results.trial_values.task_checks.Requirement('fixation')) &&...
        (results.trial_values.task_checks.Status('hold_joystick') | ~results.trial_values.task_checks.Requirement('hold_joystick'));

    %if pass_all_tests
% EPOCH 2 - display fractal
for frame = 1:(parameters.timings.Frames('epoch2') + parameters.timings.Delay('epoch2'))
    if frame == 1 | frame == (parameters.timings.Frames('epoch2') + parameters.timings.Delay('epoch2'))
        draw_pav_epoch_2(stimuli, parameters, task_window);
    end
    if frame == (parameters.timings.Frames('epoch2') + parameters.timings.Delay('epoch2'))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

%wins every time on the pavlovian task
results.trial_results.win = 1;
results = assign_payouts(parameters, results);

% EPOCH 3 - payout
for frame = 1:(parameters.timings.Frames('epoch3') + parameters.timings.Delay('epoch3'))
    %on first frame payout the budget
    if frame == 1
        if hardware.testmode
            results = sound_payout(hardware, results, 'reward');
        else
            results = release_liquid(parameters, hardware, results, 'reward');
        end
    end
    display('flipping');
    draw_pav_epoch_2(stimuli, parameters, task_window);
    Screen('Flip', task_window);
end

%% FAIL EPOCHS %%
%% if a check fails these error epochs will be shown %%
else
%if fixation fails
display('FIXATION FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(2:4)) + sum(parameters.timings.Delay(2:8)) + (3 * hardware.outputs.screen_info.hz))
    if frame == 1 | frame == (parameters.timings.Frames('epoch1') + parameters.timings.Delay('epoch1'))
        draw_error_epoch(hardware, task_window)
    end
    results = assign_error_results(parameters, results);
    if frame == (sum(parameters.timings.Frames(2:4)) + sum(parameters.timings.Delay(2:8))  + (3 * hardware.outputs.screen_info.hz))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end
end

%close textures
%make this into a function
%Screen('Close', stimuli.trial.trial_fractal_texture)
%Screen('Close', stimuli.trial.reverse_bidspace_texture)

%%Set the data
results = assign_experiment_metadata(parameters, stimuli, hardware, results);
results = assign_outputs(results);


