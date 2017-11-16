%BDM task
%will run the task outlined in the set parameters
function [results, parameters] = Run(parameters, stimuli, hardware, results, task_window)
%set initial trial values (see below)
%needed here for first trial
if parameters.total_trials < 1
    [parameters, results.trial_values] = set_initial_trial_values(parameters, stimuli, hardware);
end

for frame = 1:(parameters.timings.Frames('epoch8') + parameters.timings.Delay('epoch8'))
    %draw the seventh epoch
    draw_epoch_8(hardware, task_window);
    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    [parameters, results.trial_values] = set_initial_trial_values(parameters, stimuli, hardware);

    %select the correct fractal for the trial and generate a texture
    stimuli = select_fractal(parameters, stimuli, hardware, task_window);

    %generate the reversed bidspace budget for if the monkey wins
    stimuli = generate_reverse_bidspace(parameters, stimuli, task_window);
    Screen('Flip', task_window);
end

% EPOCH 1 - fixation cross
for frame = 1:(parameters.timings.Frames('epoch1') + parameters.timings.Delay('epoch1'))
    %draw the first epoch
    draw_epoch_1(stimuli, hardware, task_window);
    %check if the monkey is fixating on the cross
    [parameters, results] = check_fixation(parameters, stimuli, results, hardware, task_window);
    Screen('Flip', task_window);
end

%continue with task if monkey fixates
if true(results.trial_values.task_checks.Status('fixation') & results.trial_values.task_checks.Status('hold_joystick'))
for frame = 1:(parameters.timings.Frames('epoch2') + parameters.timings.Delay('epoch2'))
    draw_epoch_2(stimuli, task_window);
    Screen('Flip', task_window);
end
    
for frame = 1:(parameters.timings.Frames('epoch3') + parameters.timings.Delay('epoch3'))
    draw_epoch_3(stimuli, hardware, task_window);
    Screen('Flip', task_window);
end

for frame = 1:(parameters.timings.Frames('epoch4') + parameters.timings.Delay('epoch4'))
    draw_epoch_4(parameters, stimuli, hardware, task_window);
    Screen('Flip', task_window);
end

for frame = 1:(parameters.timings.Frames('epoch5') + parameters.timings.Delay('epoch5'))
    draw_epoch_5(parameters, stimuli, hardware, results, task_window);
    [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli);
    if results.trial_values.task_checks.Status('no_bid_activity')
        break
    end
    Screen('Flip', task_window);
end

%only progress if there was bidding activity in the first x seconds
if ~results.trial_values.task_checks.Status('no_bid_activity')

%only progress if a bid has been finished (i.e. a sufficient pause at the
%end)
if results.trial_values.task_checks.Status('targeted_offer')
for frame = 1:(parameters.timings.Frames('epoch6') + parameters.timings.Delay('epoch6'))
    %draw the result of the auction depending if monkey wins or not
    if(results.trial_values.current_bid > parameters.single_trial_values.computer_bid_value)
        draw_epoch_6_win(parameters, stimuli, hardware, results, task_window);
    else
        draw_epoch_6_lose(parameters, stimuli, hardware, results, task_window);
    end
    Screen('Flip', task_window);

    %calculate budgets/rewards
    %results.trial_values = assign_results(results);
    %generate beeps to indicate outcomes
    %hardware.outputs.sound = assign_beeps(trial_values);
end

for frame = 1:(parameters.timings.Frames('epoch7') + parameters.timings.Delay('epoch7'))
    draw_epoch_7(hardware, task_window);
    Screen('Flip', task_window);
end

%FAIL EPOCHS
else
%if bidding activity fails
for frame = 1:(sum(parameters.timings.Frames(5:8)) + sum(parameters.timings.Delay(5:8)) + ((3 - parameters.settings.bid_timeout) * hardware.outputs.screen_info.hz))
    display('BIDDING FAIL');
    draw_error_epoch(hardware, task_window)
    Screen('Flip', task_window);
end
end

else
%if bid finalisation fails
for frame = 1:(sum(parameters.timings.Frames(6:8)) + sum(parameters.timings.Delay(6:8)) + (3 * hardware.outputs.screen_info.hz))
    display('FINIALISATION FAIL');
    draw_error_epoch(hardware, task_window)
    Screen('Flip', task_window);
end
end
    
else
%if fixation fails
for frame = 1:(sum(parameters.timings.Frames(2:8)) + sum(parameters.timings.Delay(2:8)) + (3 * hardware.outputs.screen_info.hz))
    display('FIXATION FAIL');
    draw_error_epoch(hardware, task_window)
    Screen('Flip', task_window);
end
end