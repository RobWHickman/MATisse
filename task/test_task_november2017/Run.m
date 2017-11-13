%BDM task
%will run the task outlined in the set parameters
function results = Run()
%set initial trial values (see below)
%needed here for first trial
if trial == 1
    trial_values = set_initial_trial_values(fractals, parameters, bidspace_info, screen_info);
end

%   SET UP TRIAL
% EPOCH 7 - end trial and set values for new trial
%we start with the final epoch during which everything is set for the
%coming trial
for frame = 1:(parameters.timings.epoch7.frames )%+ trial_values.epoch7_delay)
    %draw the seventh epoch
    draw_epoch_7(screen_info, parameters, task_window);
    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    trial_values = set_initial_trial_values(fractals, parameters, bidspace_info, screen_info);

    %save the real screen positions of these bids into the bidspace info
    bidspace_info.monkey_bid_position = screen_info.height - trial_values.starting_bid_value - 270;
    bidspace_info.computer_bid_position = screen_info.height - trial_values.computer_bid_value - 270;

    %select the correct fractal for the trial and generate a texture
    [trial_fractal, trial_fractal_info] = select_fractal(fractals, screen_info, task_window, trial_values);

    %reset the bidspace for the new trial
    bidspace_info = reset_bidspace(bidspace_info, parameters);
    %generate the reversed bidspace budget for if the monkey wins
    [reverse_bidspace_texture, bidspace_info] = generate_reverse_bidspace(reverse_bidspace, bidspace_info, trial_values, task_window);
    Screen('Flip', task_window);
end

% EPOCH 1 - fixation cross
for frame = 1:(parameters.timings.epoch1.frames)
    %draw the first epoch
    draw_epoch_1(fixation_cross, fixation_cross_info, fixation_box, screen_info, task_window);
    %check if the monkey is fixating on the cross
    [trial_values.fixation, trial_values.fixation_vector] = check_monkey_fixation(parameters, trial_values, fixation_box, task_window);
    trial_values.stationary = check_joystick_stationary(parameters, trial_values, testmode);
    Screen('Flip', task_window);
end

%continue with task if monkey fixates
if true(trial_values.fixation & trial_values.stationary)
% EPOCH 2 - display fractal
for frame = 1:parameters.timings.epoch2.frames
    Screen('DrawTexture', task_window, trial_fractal, [], trial_fractal_info.position, 0);
    Screen('Flip', task_window);
end

% EPOCH 3 - display bidspace
for frame = 1:(parameters.timings.epoch3.frames)
    draw_epoch_3(trial_fractal, trial_fractal_info, parameters, bidspace_texture, bidspace_bounding_box, bidspace_info, task_window);
    Screen('Flip', task_window );
end

% EPOCH 3.5 - display bidspace and bid bar
for frame = 1:(parameters.timings.epoch35.frames + trial_values.epoch3_delay)
    draw_epoch_35(trial_fractal, trial_fractal_info, parameters, bidspace_texture, bidspace_bounding_box, bidspace_info, screen_info, task_window);
    Screen('Flip', task_window );
end

% EPOCH 4 - monkey bid input
%wipe the NaN bidding vector to allow it to grow with actual values
trial_values.bidding_vector = [];
for frame = 1:(parameters.timings.epoch4.frames)
    draw_epoch_4(trial_fractal, trial_fractal_info, parameters, bidspace_texture, bidspace_bounding_box, bidspace_info, screen_info, task_window);
    %allow the monkey to manipulate the bidding bar
    %will freeze if left unmoved for a second
    [bidspace_info, trial_values] = update_bid_position(parameters, bidspace_info, trial_values, testmode); %the 1 is the sensitivity threshold- put it in parameters somewhere
    
    Screen('Flip', task_window);
end

% EPOCH 5 - display auction result
for frame = 1:(parameters.timings.epoch5.frames)
    %draw the result of the auction depending if monkey wins or not
    if(trial_values.computer_bid_perc < trial_values.bid_value_perc)
        draw_epoch_5_win(trial_fractal, trial_fractal_info, bidspace_texture, bidspace_bounding_box, reverse_bidspace_texture, screen_info, bidspace_info, parameters, task_window);
    else
        draw_epoch_5_lose(bidspace_texture, bidspace_bounding_box, screen_info, bidspace_info, parameters, task_window);
    end
    Screen('Flip', task_window);

    %calculate budgets/rewards
    trial_values = assign_results(trial_values);
    %generate beeps to indicate outcomes
    [budget_tone, reward_tone] = assign_beeps(trial_values);
end

% EPOCH 6 - pay out budget and reward
%start by sounding budget tone
%sound(budget_tone, 8000);
for frame = 1:(parameters.timings.epoch6.frames)
    %wait for prescribed amount of time
    Screen('DrawingFinished', task_window);
    Screen('Flip', task_window);
end
%sound the reward payout
%sound(reward_tone, 8000);

%   END EVERYTHING
%end the success conditions (if task was failed)
end

%get the summary statistics for the experiment
%about 4ms of dead space here
[full_output, experiment_summary]  = assign_outputs(trial_values, bidspace_info, parameters, screen_info, full_output, experiment_summary);

% %if the trial number is equal to the total trials for the experiment, close
% %the screen
% if trial == parameters.total_trials
%     sca;
% end

%end the trial
end
