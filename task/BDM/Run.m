%BDM task function
function [results, parameters] = Run(parameters, stimuli, hardware, results, task_window)
%set initial trial values (see below)
%needed here for first trial
if parameters.total_trials < 1
    [parameters, results] = set_initial_trial_values(parameters, stimuli, hardware, results);
end

%pass_all_tests = 1; %for calibration

%% EPOCHS %%
%% the different epochs in the task if all checks are met %%
for frame = 1:(parameters.timings.Frames('epoch8') + parameters.timings.Delay('epoch8'))
    %draw the seventh epoch
    draw_epoch_8(hardware, task_window);
    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    [parameters, results] = set_initial_trial_values(parameters, stimuli, hardware, results);
    
    if parameters.total_trials > 0 && ~parameters.targeting.static
        stimuli.target_box = generate_target_box(parameters, stimuli, hardware, results.experiment_summary.correct);
    end
    
    if frame == 1
    %select the correct fractal for the trial and generate a texture
    stimuli = select_fractal(parameters, stimuli, task_window);

    %generate the reversed bidspace budget for if the monkey wins
    %stimuli = generate_reverse_bidspace(parameters, stimuli, task_window);
    end
    
    Screen('Flip', task_window);
end

% EPOCH 1 - fixation cross
for frame = 1:(parameters.timings.Frames('epoch1') + parameters.timings.Delay('epoch1'))
    %draw the first epoch
    draw_epoch_1(stimuli, hardware, task_window);
    %check if the monkey is fixating on the cross
    [parameters, results] = check_fixation(parameters, stimuli, results, hardware, task_window);
    
   % results.trial_results.target_box_position1 = stimuli.target_box.position(1);
   % results.trial_results.target_box_position2 = stimuli.target_box.position(2);
   % results.trial_results.target_box_position3 = stimuli.target_box.position(3);
   % results.trial_results.target_box_position4 = stimuli.target_box.position(4);
   % results.trial_results.target_value_shift = parameters.single_trial_values.target_value_shift;
   % results.trial_results.target_box_length = stimuli.target_box.length;
    results.trial_results.start_position = parameters.single_trial_values.starting_bid_value;

    Screen('Flip', task_window);
end

    if results.trial_values.task_checks.Requirement('targeted_offer') == 1
        results.trial_results.target_shift = parameters.single_trial_values.target_value_shift;
        results.trial_results.target_size = stimuli.target_box.length;
        results.trial_results.target_filled = parameters.targeting.filled;
    end
%continue with task if monkey fixates
if (results.trial_values.task_checks.Status('fixation') | ~results.trial_values.task_checks.Requirement('fixation')) &&...
        (results.trial_values.task_checks.Status('hold_joystick') | ~results.trial_values.task_checks.Requirement('hold_joystick'));
%if pass_all_tests

for frame = 1:(parameters.timings.Frames('epoch2') + parameters.timings.Delay('epoch2'))
    draw_epoch_2(stimuli, task_window);
    Screen('Flip', task_window);
end

    
for frame = 1:(parameters.timings.Frames('epoch3') + parameters.timings.Delay('epoch3'))
    draw_epoch_3(stimuli, hardware, task_window);
    Screen('Flip', task_window);
end

for frame = 1:(parameters.timings.Frames('epoch4') + parameters.timings.Delay('epoch4'))
    draw_epoch_4(parameters, stimuli, hardware, results, task_window);
    Screen('Flip', task_window);
end

for frame = 1:(parameters.timings.Frames('epoch5') + parameters.timings.Delay('epoch5'))
    draw_epoch_5(parameters, stimuli, hardware, results, task_window);
    [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli);
    
    %update the value of the bid
    results.trial_results.monkey_bid = (parameters.single_trial_values.starting_bid_value * (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4)) + results.trial_results.adjust) /...
        (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4));
    %stimuli = generate_reverse_bidspace(parameters, stimuli, task_window,results);%MARIUS
    %if there hasn't been any bid activity break out of the loop
    if results.trial_values.task_checks.Status('no_bid_activity') && results.trial_values.task_checks.Requirement('no_bid_activity')
        break
    end
    if results.trial_values.task_checks.Requirement('targeted_offer') == 1
        results = check_targeted_offer(parameters, results, stimuli);
    end
    Screen('Flip', task_window);
end

%pass all test = 1 %for testing
%only progress if there was bidding activity in the first x seconds
% ---------------- 02/08/18 NEW: Added minimum bid time 'hack'-----------
%bid_vec = results.trial_values.bidding_vector;
%min_bid_length = 0.2 * hardware.screen.refresh_rate;
%bid_length = length(find(bid_vec(~isnan(bid_vec))));
%if ~results.trial_values.task_checks.Status('no_bid_activity') | ~results.trial_values.task_checks.Requirement('no_bid_activity') | bid_length > min_bid_length
if ~results.trial_values.task_checks.Status('no_bid_activity') | ~results.trial_values.task_checks.Requirement('no_bid_activity') 
% ---------------- 02/08/18 END OF NEW SECTION -------------------------- 

%only progress if a bid has been finished (i.e. a sufficient pause at the
%end)
if results.trial_values.task_checks.Status('stabilised_offer') | ~results.trial_values.task_checks.Requirement('stabilised_offer')

%only progress if the bid was targeted properly (if no targeting this will
%default to true)
if results.trial_values.task_checks.Status('targeted_offer') | ~results.trial_values.task_checks.Requirement('targeted_offer')
%if pass_all_tests
    
for frame = 1:(parameters.timings.Frames('epoch6') + parameters.timings.Delay('epoch6'))
    %draw the result of the auction depending if monkey wins or not
    if(results.trial_results.monkey_bid > parameters.single_trial_values.computer_bid_value)
        %REVERSE FPA
        % if(results.trial_results.monkey_bid < parameters.single_trial_values.computer_bid_value)
        %END REVERSE FPA
            stimuli = generate_reverse_bidspace(parameters, stimuli, task_window, results);%MARIUS
            draw_epoch_6_win(parameters, stimuli, hardware, results, task_window);
            results.trial_results.win = 1;
    else
        draw_epoch_6_lose(parameters, stimuli, hardware, results, task_window);
        results.trial_results.win = 0;
    end
    
    %in the spare time assign the payouts for the next epoch
    results = assign_payouts(parameters, results);

    Screen('Flip', task_window);
end

for frame = 1:(parameters.timings.Frames('epoch7') + parameters.timings.Delay('epoch7'))
    %on first frame payout the budget
    if frame == 1
        if hardware.testmode
            results = sound_payout(hardware, results, 'budget');
        else
            results = release_liquid(parameters, hardware, results, 'budget');
        end
    %on last frame payout the reward
    elseif frame == (parameters.timings.Frames('epoch7') + parameters.timings.Delay('epoch7'))
        if hardware.testmode
            results = sound_payout(hardware, results, 'reward');
        else
            results = release_liquid(parameters, hardware, results, 'reward');
        end
    end
    
    draw_epoch_7(hardware, task_window);
    %set the final bid as the current bid at this point
    results.trial_results.monkey_final_bid = results.trial_results.monkey_bid;
    results.trial_results.task_failure = {NaN};
    
    Screen('Flip', task_window);
    results.trial_results.offer_value = parameters.single_trial_values.offer_value;

end


%% FAIL EPOCHS %%
%% if a check fails these error epochs will be shown %%
else
%if bid is not targeted
display('TARGETING FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(6:8)) + sum(parameters.timings.Delay(6:8)) + (3 * hardware.outputs.screen_info.hz))
    draw_error_epoch(hardware, task_window)
    results.trial_results.offer_value = parameters.single_trial_values.offer_value;
    results = assign_error_results(parameters, results);
    Screen('Flip', task_window);
end
end

else
%if bid finalisation fails
display('FINIALISATION FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(6:8)) + sum(parameters.timings.Delay(6:8)) + (3 * hardware.outputs.screen_info.hz))
    draw_error_epoch(hardware, task_window)
    results.trial_results.offer_value = parameters.single_trial_values.offer_value;
    results = assign_error_results(parameters, results);
    Screen('Flip', task_window);
end
end

else
%if bidding activity fails
display('BIDDING FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(5:8)) + sum(parameters.timings.Delay(5:8)) + ((3 - parameters.settings.bid_timeout) * hardware.outputs.screen_info.hz))
    draw_error_epoch(hardware, task_window)
    results.trial_results.offer_value = parameters.single_trial_values.offer_value;
    results = assign_error_results(parameters, results);
    Screen('Flip', task_window);
end
end

else
%if fixation fails
display('FIXATION FAIL');
sound_error_tone(hardware);
for frame = 1:(sum(parameters.timings.Frames(2:8)) + sum(parameters.timings.Delay(2:8)) + (3 * hardware.outputs.screen_info.hz))
    draw_error_epoch(hardware, task_window)
    results = assign_error_results(parameters, results);
    Screen('Flip', task_window);
end
end

%close textures
%make this into a function
Screen('Close', stimuli.trial.trial_fractal_texture)
%Screen('Close', stimuli.trial.reverse_bidspace_texture)


%%Set the data
results = assign_experiment_metadata(parameters, stimuli, hardware, results);
results = assign_outputs(results);
