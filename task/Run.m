%BDM task function
function [results, parameters] = Run(parameters, stimuli, hardware, modifiers, results, task_window)

%generate the task timings
if parameters.trials.truncated_times
    times = generate_truncated_times(parameters);
    parameters.timings.TrialTime = rot90(round(times), 3);
else
    parameters.timings.TrialTime = parameters.timings.Frames +...
        times(parameters.timings.Variance', times(rand(height(parameters.timings),1)', randsample([-1 1], height(parameters.timings), 1)))';
end

%% EPOCHS %%
%% the different epochs in the task if all checks are met %%
%inter trial interval
for frame = 1:parameters.timings.TrialTime('ITI')
    %draw the seventh epoch
    if frame == 1 || frame == parameters.timings.TrialTime('ITI')
        draw_ITI(stimuli, task_window);
    end

    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    if frame == 1
        results = set_initial_trial_values(parameters, stimuli, modifiers, results);
        results.behaviour_table = initialise_behaviour(parameters);
        
        %reset the status of all task checks
        parameters.task_checks.table.Status = zeros(length(parameters.task_checks.table.Status), 1);

        %select the correct fractal for the trial and generate a texture
        if ~modifiers.fractals.no_fractals
            stimuli.fractals.texture = select_fractal(stimuli, results.single_trial.reward_value, task_window);
        end
        if strcmp(parameters.task.type, 'BC') && modifiers.budgets.no_budgets 
            stimuli.fractals.second_texture = select_fractal(stimuli, results.single_trial.second_reward_value, task_window);
        end
        
        if (strcmp(parameters.task.type, 'BDM') || strcmp(parameters.task.type, 'BC')) && ~ strcmp(results.single_trial.subtask, 'FP')
            stimuli = generate_reverse_bidspace(parameters, results, stimuli, modifiers, task_window);
            
            if parameters.task_checks.table.Requirement('targeted_offer')
                stimuli = generate_target_box(modifiers, stimuli, hardware, results);
            end
        end
      
        if(strcmp(results.single_trial.primary_side, 'right'))
            stimuli = reflect_stimuli(stimuli, hardware, modifiers);
            disp('reflected stuff');
        end
    else
        %do samply stuff
    end
    
    %if the last frame of the epoch, clear the buffer
    flip_screen(frame, parameters, task_window, 'ITI');
end

%set the systime for the start of the trial
results = time_trial(results, 'start');

% %fixation epoch
if ~results.single_trial.task_failure
for frame = 1:parameters.timings.TrialTime('fixation')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('fixation')
        draw_fixation_epoch(stimuli, hardware, task_window, parameters.task.type);
    end
    
    %sample the input devices
    hardware = sample_input_devices(parameters, hardware);
    [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, 'fixation');   

    %parameters = check_joystick_stationary(parameters, joystick);
    if parameters.task_checks.table.Status('joystick_centered') && parameters.task_checks.table.Requirement('joystick_centered')
        results.single_trial.task_failure = true;
        break
    end
    
    if parameters.task_checks.table.Status('touch_joystick') && parameters.task_checks.table.Requirement('touch_joystick')
        results.single_trial.task_failure = true;
        break
    end
    
    flip_screen(frame, parameters, task_window, 'fixation');
end
results = check_requirements(parameters, results);
end

%display fractal
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('fractal_offer')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('fractal_offer')
        draw_fractaloffer_epoch(stimuli, modifiers, hardware, task_window, parameters.task.type)
    end
    
    [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, 'fractal_offer');
    
    %check if the monkey is fixating on the cross
    if parameters.task_checks.table.Status('joystick_centered') && parameters.task_checks.table.Requirement('joystick_centered')
        results.single_trial.task_failure = true;
        break
    end
    
    flip_screen(frame, parameters, task_window, 'fractal_offer');
end
results = check_requirements(parameters, results);
end

%bidding phase
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
%results.movement = initialise_movement(parameters);
for frame = 1:parameters.timings.TrialTime('bidding')
    
    [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, 'bidding');
    
    if ~strcmp(parameters.task.type, 'PAV') && ~results.movement.stabilised
        [results, hardware] = update_bid_position(hardware, results, parameters, stimuli);
        results.movement.bidding_vector(frame) = hardware.joystick.movement.stimuli_movement;
        results.movement.total_movement = results.movement.total_movement + hardware.joystick.movement.stimuli_movement;
    else
        results.movement.bidding_vector(frame) = NaN;
    end
    
    if(all(results.movement.bidding_vector == 0) && results.movement.stationary_count > round(parameters.task_checks.bid_latency * hardware.screen.refresh_rate))
        parameters.task_checks.table.Status('no_bid_activity') = 1;
        break
    end
    
    if any(results.movement.bidding_vector ~= 0)
        if results.movement.stationary_count > round(parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate)
            results.movement.stabilised = 1;
            parameters.task_checks.table.Status('stabilised_offer') = 0;
        else
            parameters.task_checks.table.Status('stabilised_offer') = 1;
        end
    end
    
    %cut out the task if there is not enough time for monkey to stabilise
    if parameters.task_checks.table.Status('stabilised_offer') &&...
            frame + round(parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate) > parameters.timings.TrialTime('bidding')
        break
    end
    
    if parameters.task_checks.table.Requirement('targeted_offer')
        parameters = check_targeted_offer(parameters, results, stimuli);
    end
    
    draw_bidding_epoch(parameters, stimuli, modifiers, hardware, results, task_window, parameters.task.type)
    flip_screen(frame, parameters, task_window, 'bidding');
end
results = check_requirements(parameters, results);
end


%generate the reverse bidspace for the first price auctions
%might affect timings- be careful for electrophys
if strcmp(parameters.task.type, 'BDM') && strcmp(results.single_trial.subtask, 'FP') &&...
        results.single_trial.starting_bid + results.movement.total_movement > results.single_trial.computer_bid
    disp('reversing bidspace');
    stimuli = generate_reverse_bidspace(parameters, results, stimuli, modifiers, task_window);
end    

%paayout the budget and then reward
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('budget_payout')
    %draw the first epoch
    if frame == 1% || frame == parameters.timings.TrialTime('budget_payout')
        %assign the payouts
        results = assign_payouts(parameters, modifiers, stimuli, results);
        
        draw_payout_epoch(parameters, modifiers, results, stimuli, hardware, task_window, parameters.task.type, 'budget')
    end
    %payout the results on the last frame
    if frame == parameters.timings.TrialTime('budget_payout')
        results = payout_results(stimuli, parameters, modifiers, hardware, results, 'budget');
    end
     
    flip_screen(frame, parameters, task_window, 'budget_payout');
end
results = check_requirements(parameters, results);
end
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('reward_payout')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('reward_payout')
        draw_payout_epoch(parameters, modifiers, results, stimuli, hardware, task_window, parameters.task.type, 'reward')
    end
    
    %payout the results on the last frame
    if frame == parameters.timings.TrialTime('reward_payout')
        results = payout_results(stimuli, parameters, modifiers, hardware, results, 'reward');
    end
     
    flip_screen(frame, parameters, task_window, 'reward_payout');
end
results = check_requirements(parameters, results);
end

if results.single_trial.task_failure && ~strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('error_timeout')
    if frame == 1 || frame == parameters.timings.TrialTime('error_timeout')
        draw_error_epoch(hardware, task_window)
    end
    
    if frame == 2
        results = assign_error_results(results, parameters);
    end
    
    flip_screen(frame, parameters, task_window, 'error_timeout');
end    
results = check_requirements(parameters, results);
end

draw_ITI(stimuli, task_window);
Screen('Flip', task_window, [], 0)
%output the results of the trial to save and update the GUI
results = time_trial(results, 'end');
results = output_results(results, parameters, hardware);
results = set_trial_metadata(parameters, stimuli, hardware, modifiers, results);


