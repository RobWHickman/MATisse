%BDM task function
function [results, parameters] = Run(parameters, stimuli, hardware, modifiers, results, task_window)

%% EPOCHS %%
%% the different epochs in the task if all checks are met %%
%inter trial interval
for frame = 1:parameters.timings.TrialTime('ITI')
    %draw the seventh epoch
    if frame == 1 || frame == parameters.timings.TrialTime('ITI')
        draw_ITI(hardware, task_window);
    end

    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    if frame == 1
        [parameters, results] = set_initial_trial_values(parameters, stimuli, modifiers, results);

        %select the correct fractal for the trial and generate a texture
        if ~modifiers.fractals.no_fractals
            stimuli.fractals.texture = select_fractal(stimuli, results, task_window);
        end
    else
        %do samply stuff
    end
    
    %if the last frame of the epoch, clear the buffer
    flip_screen(frame, parameters, task_window, 'ITI');
end

%set the systime for the start of the trial
results = time_trial(results, 'start');

%fixation epoch
for frame = 1:parameters.timings.TrialTime('fixation')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('fixation')
        draw_fixation_epoch(stimuli, hardware, task_window, parameters.task.type);
    end
    
    %sample the joystick
    %joystick = sample_joystick(ni_devices, joystick);
    
    %check if the monkey is fixating on the cross
    %parameters = check_joystick_stationary(parameters, joystick);
    if parameters.task_checks.Status('hold_joystick') == 0
        break
    end
    
    flip_screen(frame, parameters, task_window, 'fixation');
end

%display fractal
for frame = 1:parameters.timings.TrialTime('fractal_offer')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('fractal_offer')
        draw_fractaloffer_epoch(stimuli, hardware, task_window, parameters.task.type)
    end
    
    flip_screen(frame, parameters, task_window, 'fractal_offer');
end

%display fractal
for frame = 1:parameters.timings.TrialTime('bidding')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('bidding')
        draw_bidding_epoch(stimuli, hardware, task_window, parameters.task.type)
    end
    
    
    flip_screen(frame, parameters, task_window, 'bidding');
end

%assign the payouts
%wins every time on the pavlovian task
results.trial_results.win = 1;
results.trial_results.task_error = NaN;
results = assign_payouts(parameters, modifiers, results);

%assign results and payout
for frame = 1:parameters.timings.TrialTime('reward_payout')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('reward_payout')
        draw_payout_epoch(stimuli, hardware, task_window, parameters.task.type)
    end
    
    %payout the results on the last frame
    if frame == parameters.timings.TrialTime('reward_payout')
        results = payout_results(parameters, modifiers, hardware, results, 'reward');
    end
     
    flip_screen(frame, parameters, task_window, 'reward_payout');
end

for frame = 1:parameters.timings.TrialTime('budget_payout')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('budget_payout')
        draw_payout_epoch(stimuli, hardware, task_window, parameters.task.type)
    end
    
    %payout the results on the last frame
    if frame == parameters.timings.TrialTime('budget_payout')
        results = payout_results(parameters, modifiers, hardware, results, 'budget');
    end
     
    flip_screen(frame, parameters, task_window, 'budget_payout');
end

draw_ITI(hardware, task_window);
Screen('Flip', task_window, [], 0)
%output the results of the trial to save and update the GUI
results = time_trial(results, 'end');
results = output_results(results, parameters);
results = set_trial_metadata(parameters, stimuli, hardware, modifiers, results);


