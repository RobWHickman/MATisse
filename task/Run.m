%BDM task function
function [results, parameters] = Run(parameters, stimuli, hardware, modifiers, results, task_window)

%generate the task timings
%truncated times have a flat hazard rate
if parameters.trials.truncated_times
    times = generate_truncated_times(parameters);
    parameters.timings.TrialTime = rot90(round(times), 3);
else
    %otherwise just randomly sample from within the variation
    parameters.timings.TrialTime = parameters.timings.Frames +...
        times(parameters.timings.Variance', times(rand(height(parameters.timings),1)', randsample([-1 1], height(parameters.timings), 1)))';
end

%% EPOCHS %%
%% the different epochs in the task if all checks are met %%
%inter trial interval
for frame = 1:parameters.timings.TrialTime('ITI')

    %get trial values for the offer, computer bid and random monkey bid
    %start position
    %also the random delays at the end of epochs 3 and 7
    if frame == 1
        results = set_initial_trial_values(parameters, stimuli, modifiers, results);
        
        %set up the background colours for the task
        if modifiers.background.colours
            %set the background for the task
            if strcmp(parameters.task.type, 'BDM')
                if strcmp(results.single_trial.subtask, 'FP')
                    stimuli.background_colour = [hardware.screen.colours.grey, 0, hardware.screen.colours.grey];
                elseif strcmp(results.single_trial.subtask, 'BDM')
                    stimuli.background_colour = [hardware.screen.colours.grey, hardware.screen.colours.grey, 0];
                end
            elseif strcmp(parameters.task.type, 'BC')
                stimuli.background_colour = [0, hardware.screen.colours.grey, hardware.screen.colours.grey];
            end
        else
            %else set to grey
            stimuli.background_colour = hardware.screen.colours.grey;
        end
        
        %set a table for the behavioural inputs on each frame to be held
        results.behaviour_table = initialise_behaviour(parameters);
        
        %reset the status of all task checks
        parameters.task_checks.table.Status = zeros(length(parameters.task_checks.table.Status), 1);
        %reset the joystick stationary count for the new trial
        hardware.joystick.movement.stationary_count = 0;

        %select the correct fractal for the trial and generate a texture
        if ~modifiers.fractals.no_fractals
            stimuli.fractals.texture = select_fractal(stimuli, results.single_trial.reward_value, task_window);
        end
        if strcmp(parameters.task.type, 'BC') && modifiers.budgets.no_budgets 
            stimuli.fractals.second_texture = select_fractal(stimuli, results.single_trial.second_reward_value, task_window);
        end
        
        %generate the reverse bidspace for the task if possible to save on
        %later processing
        if (strcmp(parameters.task.type, 'BDM') || strcmp(parameters.task.type, 'BC')) && ~ strcmp(results.single_trial.subtask, 'FP')
            stimuli = generate_reverse_bidspace(parameters, results, stimuli, modifiers, task_window);
            
            %generate the target box if needed
            if parameters.task_checks.table.Requirement('targeted_offer')
                stimuli = generate_target_box(modifiers, stimuli, hardware, results);
            end
        end
        
        %if the side of stimuli (the fractal side) is the right then flip
        %everything over
        %only for binary choice paradigms
        if(strcmp(results.single_trial.primary_side, 'right'))
            stimuli = reflect_stimuli(stimuli, hardware, modifiers);
            disp('reflected stuff');
        end
    else
        %currently we don't sample behaviour in the ITI
        %could be worth changing
    end
    
    %Getty Handshake on final frame
    if frame == parameters.timings.TrialTime('ITI')
%         %Matisse offers its hand to Getty 
%         MATisse_offer1 = outputSingleScan();
% 
%         Getty_offer1 = 0;
%         while(~Getty_offer1)
%             Getty_offer1 = inputSingleScan();
%         end
% 
%         %format the data from the last trial to be sent to GETTY
%         if parameters.trials.total_trials > 0
%             previous_trial = height(results.full_output_table);
%             table_row = results.full_output_table(previous_trial,:);
% 
%             %set the key as the trial number for the previous trial
%             %GETTY must respond with this to confirm it has received the
%             %data
%             key = table_row(:,width(results.full_output_table));
% 
%             %handshake before data transmission
%             MATisse_offer2 = outputSingleScan();
% 
%             %send data to GETTY
% 
%             %receive offer from GETTY
%             Getty_offer2 = 0;
%             while(~Getty_offer2)
%                 Getty_offer2 = inputSingleScan();
%             end
% 
%             %check that the second GETTY handshake matches this key
%             if Getty_offer2 ~= key
%                 fprintf('Getty handshake does not match key!');
%             end
% 
%         %otherwise simply handshake again
%         else
%             MATisse_offer2 = outputSingleScan();
% 
%             Getty_offer2 = 0;
%             while(~Getty_offer2)
%                 Getty_offer2 = inputSingleScan();
%             end
%         end

        %if the last frame of the epoch, clear the buffer
        flip_screen(frame, parameters, task_window, 'ITI');
    end
    
    %draw the seventh epoch
    if frame == 1 || frame == parameters.timings.TrialTime('ITI')
        draw_ITI(stimuli, task_window);
    end
end

%set the systime for the start of the trial
results = time_trial(results, 'start');

% %fixation epoch
%only continue to epochs if no task failure or a pavlovian paradigm task
%can never fail trials on pavlovian tasks
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('fixation')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('fixation')
        draw_fixation_epoch(stimuli, hardware, task_window, parameters.task.type);
    end
    
    %sample the input devices and munge into behaviour table
    hardware = sample_input_devices(parameters, hardware);
    [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, 'fixation');  

    %check that joystick fulfils the two constant checks
    %JCW and that monkey is touching top of joystick
    if parameters.task_checks.table.Status('joystick_centered') && parameters.task_checks.table.Requirement('joystick_centered')
        break
    end
    if parameters.task_checks.table.Status('touch_joystick') && parameters.task_checks.table.Requirement('touch_joystick')
        break
    end
    
    %clear the screen and draw the task
    flip_screen(frame, parameters, task_window, 'fixation');
end
%check that the monkey hasn't violated any conditions at the end of the
%epoch
results = check_requirements(parameters, results);
end

%display fractal
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('fractal_offer')
    %draw the first epoch
    if frame == 1 || frame == parameters.timings.TrialTime('fractal_offer')
        draw_fractaloffer_epoch(stimuli, modifiers, hardware, task_window, parameters.task.type)
    end
    
    %sample behaviour
    hardware = sample_input_devices(parameters, hardware);
    [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, 'fractal_offer'); 
    
    %check if the monkey is behaving
    if parameters.task_checks.table.Status('joystick_centered') && parameters.task_checks.table.Requirement('joystick_centered')
        break
    end
    if parameters.task_checks.table.Status('touch_joystick') && parameters.task_checks.table.Requirement('touch_joystick')
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
    disp(frame)
    
    %sample behaviour
    hardware = sample_input_devices(parameters, hardware);
    [parameters, hardware, results] = munge_epoch_inputs(parameters, hardware, results, frame, 'bidding');
    
    if ~strcmp(parameters.task.type, 'PAV') && parameters.task_checks.table.Status('stabilised_offer')
        [results, hardware] = update_bid_position(hardware, results, parameters, stimuli);
    end
    
    %get the vector of all movement to simplify munging lines below
    movement_vec = results.behaviour_table.stimuli_movement(find(strcmp(results.behaviour_table.epoch, 'bidding')),:);
   
    %if no bid is made error
    %latest frame is a simplification of the time by which the monkey must
    %move the joystick
    latest_frame = round(parameters.task_checks.bid_latency * hardware.screen.refresh_rate);
    if (all(movement_vec(~isnan(movement_vec)) == 0) &&...
            frame > latest_frame)
        parameters.task_checks.table.Status('no_bid_activity') = 1;
        break
    else
        parameters.task_checks.table.Status('no_bid_activity') = 0;
    end

    %if the monkey moves then stops stabilise the bid
    %monkey will no longer be able to update position and no stimuli
    %movement will be recorded
    %n.b. 1 refers to error condition (unstabilised), not that bid is stabilised
    if any(movement_vec ~= 0)
        if (hardware.joystick.movement.stationary_count > round(parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate) &&...
                frame > latest_frame)
            parameters.task_checks.table.Status('stabilised_offer') = 0;
        else
            parameters.task_checks.table.Status('stabilised_offer') = 1;
        end
    end
    
    
    %cut out the task if there is not enough time for monkey to stabilise
    %the bid
    if parameters.task_checks.table.Status('stabilised_offer') &&...
            frame + (round(parameters.task_checks.finalisation_pause * hardware.screen.refresh_rate) - hardware.joystick.movement.stationary_count) > parameters.timings.TrialTime('bidding')
        disp('did not stabilise!')
        break
    end
    
    %check if the monkey's bid is within the target box
    if parameters.task_checks.table.Requirement('targeted_offer')
        parameters = check_targeted_offer(parameters, results, stimuli);
    end
    
    %check if the monkey has failed the touch check
    %needs to check for at least X% of the last Y frames
    %usually 40% of the last 10 frames
    if parameters.task_checks.table.Status('touch_joystick') && parameters.task_checks.table.Requirement('touch_joystick')
        break
    end
    
    %draw the task after all the checks and flip the screen
    draw_bidding_epoch(parameters, stimuli, modifiers, hardware, results, task_window, parameters.task.type)
    flip_screen(frame, parameters, task_window, 'bidding');
end
results = check_requirements(parameters, results);
end


%generate the reverse bidspace for the first price auctions
%might affect timings- be careful for electrophys
if strcmp(parameters.task.type, 'BDM') && strcmp(results.single_trial.subtask, 'FP') &&...
        results.single_trial.starting_bid + nansum(results.behaviour_table.stimuli_movement(find(strcmp(results.behaviour_table.epoch, 'bidding')),:)) > results.single_trial.computer_bid
    disp('reversing bidspace');
    stimuli = generate_reverse_bidspace(parameters, results, stimuli, modifiers, task_window);
end    

%paayout the budget and then reward
%same 'epoch' but split in two for ease of parsing
%for pavlovian tasks, this is just filler
if ~results.single_trial.task_failure || strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('budget_payout')
    
    %in first frame assign payouts and draw epoch
    if frame == 1
        %assign the payouts
        results = assign_payouts(parameters, modifiers, stimuli, results);
        draw_payout_epoch(parameters, modifiers, results, stimuli, hardware, task_window, parameters.task.type, 'budget')
    end
    
    %payout the budget results on the last frame
    if frame == parameters.timings.TrialTime('budget_payout')
        results = payout_results(stimuli, parameters, modifiers, hardware, results, 'budget');
    end
     
    flip_screen(frame, parameters, task_window, 'budget_payout');
end
results = check_requirements(parameters, results);
end

%then finally pay out the reward (if any)
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

%if any errors have occured task will jump to here
%displays plain red screen
%no error output (e.g. sound) yet but can be implemented
if results.single_trial.task_failure && ~strcmp(parameters.task.type, 'PAV')
for frame = 1:parameters.timings.TrialTime('error_timeout')
    if frame == 1 || frame == parameters.timings.TrialTime('error_timeout')
        draw_error_epoch(hardware, task_window)
    end
    
    if frame == 2
        %munge to make sur error results row lines up with those from
        %succesful trials
        results = assign_error_results(results, parameters);
    end
    
    flip_screen(frame, parameters, task_window, 'error_timeout');
end    
end

%get the time of the end of the task to match up with neuro data
results = time_trial(results, 'end');

%draw the ITI again to output the results from the trial briefly
draw_ITI(stimuli, task_window);
Screen('Flip', task_window, [], 0)
%output the results of the trial to save and update the GUI
results = output_results(results, parameters, hardware);
results = set_trial_metadata(parameters, stimuli, hardware, modifiers, results);


