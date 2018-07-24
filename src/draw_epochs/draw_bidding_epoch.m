function [] = draw_bidding_epoch(stimuli, modifiers, hardware, results, task_window, task)

Screen('FillRect', task_window, hardware.screen.colours.grey);

current_bid_position = results.single_trial.starting_bid + results.movement.total_movement;

if strcmp(task, 'PAV')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
elseif strcmp(task, 'BDM')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
    Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.dimensions.bounding_width);
    Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position, 0);

elseif strcmp(task, 'BC')
    bidspace_reflector = hardware.screen.dimensions.width - stimuli.bidspace.position(1) - stimuli.bidspace.position(3);
    fractal_reflector = hardware.screen.dimensions.width - stimuli.fractals.position(1) - stimuli.fractals.position(3);

    %draw the fractals
    if ~strcmp(results.single_trial.subtask, 'binary_budget_choice')
        Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
        if strcmp(results.single_trial.subtask, 'binary_fractal_choice')
            Screen('DrawTexture', task_window, stimuli.fractals.second_texture, [], stimuli.fractals.position + [fractal_reflector, 0, fractal_reflector, 0], 0);
        end
    end
    
    if ~strcmp(results.single_trial.subtask, 'binary_fractal_choice')
        if ~strcmp(results.single_trial.subtask, 'binary_choice')
            Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position, 0);
            Screen('DrawTexture', task_window, stimuli.bidspace.reverse_texture, [], stimuli.bidspace.reverse_texture_position, 0);
            Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.dimensions.bounding_width);
        end
        
        Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.position + [bidspace_reflector, 0, bidspace_reflector, 0], stimuli.bidspace.dimensions.bounding_width);
        Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position + [bidspace_reflector, 0, bidspace_reflector, 0], 0);
        if isfield(stimuli.bidspace, 'second_reverse_texture')
            Screen('DrawTexture', task_window, stimuli.bidspace.second_reverse_texture, [], stimuli.bidspace.second_reverse_texture_position, 0);
        end
    end
    
    %create the bidding circle as an oval in a rect
    %center it on the current bid (0 for this epoch)
    bidding_circle = [0 0 50 50];
    maxDiameter = max(bidding_circle) * 1.01;
    centered_bidding_circle = CenterRectOnPointd(bidding_circle, hardware.screen.dimensions.width * current_bid_position, hardware.screen.dimensions.height/2);
    %purple for the active epoch
    bidding_circle_colour = [hardware.screen.colours.white, 0 hardware.screen.colours.white];

    %draw the bidding circle
    Screen('FillOval', task_window, bidding_circle_colour, centered_bidding_circle, maxDiameter);
end