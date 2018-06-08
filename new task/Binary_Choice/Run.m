%BDM task function
function [results, parameters] = Run(parameters, stimuli, hardware, modifiers, results, task_window)

%% EPOCHS %%
%% the different epochs in the task if all checks are met %%
for frame = 1:parameters.timings.TrialTime('epoch8')
    %draw the seventh epoch
    if frame == 1 || frame == parameters.timings.TrialTime('epoch8')
        draw_ITI(hardware, task_window);
    end

    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    if frame == 1
        [parameters, results] = set_initial_trial_values(parameters, stimuli, modifiers, results);

        %select the correct fractal for the trial and generate a texture
        if ~modifiers.fractals.no_fractals
            stimuli.fractals = select_fractal(stimuli, results, task_window);
            if modifiers.budgets.no_budgets
                stimuli.second_fractal = select_fractal(stimuli, results, task_window);
            end
        end

        %generate the reversed bidspace budget for if the monkey wins
        if ~modifiers.budgets.no_budgets
            stimuli = generate_reverse_bidspace(parameters, results, stimuli, task_window);
        end
    end
    
    %if the last frame of the epoch, clear the buffer
    flip_screen(frame, parameters, task_window, 'epoch8');
end

% EPOCH 1 - fixation cross
for frame = 1:parameters.timings.TrialTime('epoch1')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('epoch1')
        draw_bc_epoch_1(stimuli, hardware, task_window);
    end
    
    %update the positions of the stimuli depending on which half of the
    %screen the bundle is on
    if frame == 2
        stimuli = reflect_bundle(stimuli, hardware);
    end
    
    %check if the monkey is fixating on the cross
    [parameters, results] = check_fixation(parameters, stimuli, results, hardware, task_window);
    
    flip_screen(frame, parameters, task_window, 'epoch1');
end

%continue with task if monkey fixates
if (parameters.task_checks.Status('fixation') || ~parameters.task_checks.Requirement('fixation')) &&...
        (parameters.task_checks.Status('hold_joystick') || ~parameters.task_checks.Requirement('hold_joystick'))

%if pass_all_tests
% EPOCH 2 - display fractal
for frame = 1:parameters.timings.TrialTime('epoch2')
    if frame == 1 || frame == parameters.timings.TrialTime('epoch2')
        draw_epoch_2(stimuli, parameters, task_window);
    end

    if frame == parameters.timings.TrialTime('epoch2')
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

% EPOCH 3 - display bidspaces
for frame = 1:parameters.timings.TrialTime('epoch3')
    if frame == 1 || frame == parameters.timings.TrialTime('epoch3')
        draw_bc_epoch_3(stimuli, parameters, hardware, task_window);
    end
    
    if frame == parameters.timings.TrialTime('epoch3')
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

% EPOCH 4 - show initial bid
for frame = 1:parameters.timings.TrialTime('epoch4')
    if frame == 1 || frame == parameters.timings.TrialTime('epoch4')
        draw_bc_epoch_4(stimuli, parameters, hardware, task_window);
    end
    if frame == parameters.timings.TrialTime('epoch4')
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

%if the monkey gets this far then the bid becomes 0 until updated
results.single_trial.monkey_bid = 0;
results.movement.stationary_frame_count = 0;

% EPOCH 5 - monkey bidding
for frame = 1:parameters.timings.TrialTime('epoch5')
    draw_bc_epoch_5(stimuli, parameters, hardware, results, task_window);
    [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli);
    
    %update the value of the bid
    results.trial_results.monkey_bid = results.trial_results.adjust / (hardware.outputs.screen_info.width /2);

    %if there hasn't been any bid activity break out of the loop
    if results.trial_values.task_checks.Status('no_bid_activity') && results.trial_values.task_checks.Requirement('no_bid_activity')
        break
    end
    if results.trial_values.task_checks.Requirement('targeted_offer') == 1
        results = check_targeted_offer(parameters, results, stimuli);
    end
    Screen('Flip', task_window);
end

%only progress if there was bidding activity in the first x seconds
if (~results.trial_values.task_checks.Status('no_bid_activity') || ~results.trial_values.task_checks.Requirement('no_bid_activity')) && (abs(results.trial_results.monkey_bid) > (0.5 - parameters.binary_choice.bundle_width/100)*2)
    
%only progress if a bid has been finished (i.e. a sufficient pause at the
%end)
if results.trial_values.task_checks.Status('stabilised_offer') || ~results.trial_values.task_checks.Requirement('stabilised_offer')

%if pass_all_tests
% EPOCH 6 - show result
for frame = 1:(parameters.timings.Frames('epoch6') + parameters.timings.Delay('epoch6'))
    %draw the result of the auction depending if monkey wins or not
    if(results.trial_results.monkey_bid > (0.5 - parameters.binary_choice.bundle_width/100) *2) %use the gui values here
        if frame == 1 | frame == (parameters.timings.Frames('epoch6') + parameters.timings.Delay('epoch6'))
            draw_bc_epoch_6_r(stimuli, parameters, hardware, task_window);
        end
        results.trial_results.win = 1;
    elseif(results.trial_results.monkey_bid < (parameters.binary_choice.bundle_width/100 - 0.5)*2)
        if frame == 1 | frame == (parameters.timings.Frames('epoch6') + parameters.timings.Delay('epoch6'))
            draw_bc_epoch_6_l(stimuli, parameters, hardware, task_window);
        end
        results.trial_results.win = 1;
    end
    
    %in the spare time assign the payouts for the next epoch
    results = assign_payouts(parameters, results);

    if frame == (parameters.timings.Frames('epoch6') + parameters.timings.Delay('epoch6'))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

% EPOCH 7 - payout
for frame = 1:(parameters.timings.Frames('epoch7') + parameters.timings.Delay('epoch7'))
    %on first frame payout the budget
    if frame == 1
        draw_epoch_7(hardware, task_window);
        if hardware.testmode
            results = sound_payout(hardware, results, 'budget');
        else
            results = release_liquid(parameters, hardware, results, 'budget');
        end
    %on last frame payout the reward
    elseif frame == (parameters.timings.Frames('epoch7') + parameters.timings.Delay('epoch7'))
        draw_epoch_7(hardware, task_window);
        if hardware.testmode
            results = sound_payout(hardware, results, 'reward');
        else
            results = release_liquid(parameters, hardware, results, 'reward');
        end
    end
    
    %set the final bid as the current bid at this point
    results.trial_results.monkey_final_bid = results.trial_results.monkey_bid;
    results.trial_results.task_failure = {NaN};
    
    if frame == (parameters.timings.Frames('epoch7') + parameters.timings.Delay('epoch7'))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end

%% FAIL EPOCHS %%
%% if a check fails these error epochs will be shown %%
else
%if bid finalisation fails
display('FINIALISATION FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(6:8)) + sum(parameters.timings.Delay(6:8)) + (3 * hardware.outputs.screen_info.hz))
    if frame == 1 | frame == (sum(parameters.timings.Frames(6:8)) + sum(parameters.timings.Delay(6:8)) + (3 * hardware.outputs.screen_info.hz))
        draw_error_epoch(hardware, task_window)
    end
    results = assign_error_results(parameters, results);
    if frame == (sum(parameters.timings.Frames(6:8)) + sum(parameters.timings.Delay(6:8)) + (3 * hardware.outputs.screen_info.hz))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end
end

else
%if bidding activity fails
display('BIDDING FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(5:8)) + sum(parameters.timings.Delay(5:8)) + ((3 - parameters.settings.bid_timeout) * hardware.outputs.screen_info.hz))
    if frame == 1 | frame == (sum(parameters.timings.Frames(5:8)) + sum(parameters.timings.Delay(5:8)) + ((3 - parameters.settings.bid_timeout) * hardware.outputs.screen_info.hz))
        draw_error_epoch(hardware, task_window)
    end
    results = assign_error_results(parameters, results);
    if frame == 1 | frame == (sum(parameters.timings.Frames(5:8)) + sum(parameters.timings.Delay(5:8)) + ((3 - parameters.settings.bid_timeout) * hardware.outputs.screen_info.hz))
        Screen('Flip', task_window, [], 0);
    else
        Screen('Flip', task_window, [], 1);
    end
end
end

else
%if fixation fails
display('FIXATION FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(2:8)) + sum(parameters.timings.Delay(2:8)) + (3 * hardware.outputs.screen_info.hz))
    if frame == 1 | frame == (parameters.timings.Frames('epoch8') + parameters.timings.Delay('epoch8'))
        draw_error_epoch(hardware, task_window)
    end
    results = assign_error_results(parameters, results);
    if frame == (sum(parameters.timings.Frames(2:8)) + sum(parameters.timings.Delay(2:8))  + (3 * hardware.outputs.screen_info.hz))
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
