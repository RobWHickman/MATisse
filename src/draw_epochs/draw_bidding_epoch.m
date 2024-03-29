function [] = draw_bidding_epoch(parameters, stimuli, modifiers, hardware, results, task_window, task)

Screen('FillRect', task_window, stimuli.background_colour);
current_bid_position = results.single_trial.starting_bid + nansum(results.behaviour_table.stimuli_movement(find(strcmp(results.behaviour_table.epoch, 'bidding')),:));
bidding_colour = [hardware.screen.colours.white, 0 hardware.screen.colours.white];

if strcmp(task, 'PAV')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
elseif strcmp(task, 'BDM')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
    Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.dimensions.bounding_width);
    Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position, 0);
    
    %draw the targeting box if the value for the test if false
    if parameters.task_checks.table.Requirement('targeted_offer')
        %Screen('BlendFunction', task_window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        if parameters.task_checks.table.Status('targeted_offer')
            %if the box should be filled or not
            if stimuli.target_box.filled
                Screen('FillRect', task_window, stimuli.target_box.colour, stimuli.target_box.position);
            elseif ~stimuli.target_box.filled
                Screen('FrameRect', task_window, stimuli.target_box.colour, stimuli.target_box.position, 12);
            end
        elseif ~parameters.task_checks.table.Status('targeted_offer')
            if stimuli.target_box.filled
                Screen('FillRect', task_window, [0 hardware.screen.colours.white 0], stimuli.target_box.position);
            elseif ~stimuli.target_box.filled
                Screen('FrameRect', task_window, [0 hardware.screen.colours.white 0], stimuli.target_box.position, 12);
            end
        end
    end

    if parameters.task_checks.table.Status('stabilised_offer') && modifiers.bidding.stabilisation_transform
        Screen('FillRect', task_window, bidding_colour,...
            stimuli.bidspace.position(1) - modifiers.budget.overhang, vertical_position - (stimuli.bidspace.bidspace_info.bidding_thickness + stimuli.bidspace.bidspace_info.bidding_growth),...
            stimuli.bidspace.position(3) +  modifiers.budget.overhang, vertical_position + (stimuli.bidspace.bidspace_info.bidding_thickness + stimuli.bidspace.bidspace_info.bidding_growth));
    else
        Screen('FillRect', task_window, bidding_colour,...
            [stimuli.bidspace.position(1) - modifiers.budget.overhang, (stimuli.bidspace.position(4) - 25) - (current_bid_position * stimuli.bidspace.dimensions.height),...
            stimuli.bidspace.position(3) + modifiers.budget.overhang, (stimuli.bidspace.position(4) + 25) - (current_bid_position * stimuli.bidspace.dimensions.height)]);
    end

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
            if stimuli.reverse_shadow
                Screen('FillRect', task_window, [0 0 0 stimuli.reverse_shadow_strength], stimuli.bidspace.reverse_texture_position);
            end
            Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.dimensions.bounding_width);
        end
        
        Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box + [bidspace_reflector, 0, bidspace_reflector, 0], stimuli.bidspace.dimensions.bounding_width);
        Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position + [bidspace_reflector, 0, bidspace_reflector, 0], 0);
        if isfield(stimuli.bidspace, 'second_reverse_texture')
            Screen('DrawTexture', task_window, stimuli.bidspace.second_reverse_texture, [], stimuli.bidspace.second_reverse_texture_position, 0);
            if stimuli.reverse_shadow
                Screen('FillRect', task_window, [0 0 0 stimuli.reverse_shadow_strength], stimuli.bidspace.second_reverse_texture_position);
            end
        end
    end
    
    %create the bidding circle as an oval in a rect
    %center it on the current bid (0 for this epoch)
    bidding_circle = [0 0 50 50];
    maxDiameter = max(bidding_circle) * 1.01;
    centered_bidding_circle = CenterRectOnPointd(bidding_circle, hardware.screen.dimensions.width * current_bid_position, hardware.screen.dimensions.height/2);

    %draw the bidding circle
    Screen('FillOval', task_window, bidding_colour, centered_bidding_circle, maxDiameter);
end