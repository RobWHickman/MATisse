%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey wins i.e. if its bid is higher than
%that of the computer
function [] = draw_payout_epoch(parameters, modifiers, results, stimuli, hardware, task_window, task, payout)

if ~strcmp(task, 'PAV')
    bidspace_reflector = hardware.screen.dimensions.width - stimuli.bidspace.initial_position(1) - stimuli.bidspace.initial_position(3);
end

if strcmp(task, 'BDM')
    Screen('FillRect', task_window, stimuli.background_colour);
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
    Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.dimensions.bounding_width);
    Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position, 0);

    if strfind(results.outputs.results, 'win')
        Screen('DrawTexture', task_window, stimuli.bidspace.reverse_texture, [], stimuli.bidspace.reverse_texture_position , 0);
    elseif strcmp(results.outputs.results, 'lose')
        Screen('FillRect', task_window, stimuli.background_colour, [0, 0, hardware.screen.dimensions.width/2, hardware.screen.dimensions.height]);
    end
    
    Screen('FillRect', task_window, [hardware.screen.colours.white, 0 hardware.screen.colours.white],...
        [stimuli.bidspace.position(1) - modifiers.budget.overhang, (stimuli.bidspace.position(4) - 25) - (results.trial_results.monkey_bid * stimuli.bidspace.dimensions.height),...
        stimuli.bidspace.position(3) + modifiers.budget.overhang, (stimuli.bidspace.position(4) + 25) - (results.trial_results.monkey_bid * stimuli.bidspace.dimensions.height)]);
    
    Screen('FillRect', task_window, [0 hardware.screen.colours.white, 0],...
        [stimuli.bidspace.position(1) - modifiers.budget.overhang, (stimuli.bidspace.position(4) - 25) - (results.single_trial.computer_bid * stimuli.bidspace.dimensions.height),...
        stimuli.bidspace.position(3) + modifiers.budget.overhang, (stimuli.bidspace.position(4) + 25) - (results.single_trial.computer_bid * stimuli.bidspace.dimensions.height)]);
    
    
    if strcmp(payout, 'budget')
    elseif strcmp(payout, 'reward')
        Screen('FillRect', task_window, stimuli.background_colour, [stimuli.bidspace.position(1) - modifiers.budget.overhang, 0,...
            stimuli.bidspace.position(3) + modifiers.budget.overhang, hardware.screen.dimensions.height]);
    end

elseif strcmp(task, 'BC')
    draw_bidding_epoch(parameters, stimuli, modifiers, hardware, results, task_window, parameters.task.type)
    
    if results.trial_results.monkey_bid < 0.5
        Screen('FillRect', task_window, stimuli.background_colour, [hardware.screen.dimensions.width/2, 0, hardware.screen.dimensions.width, hardware.screen.dimensions.height]);
    else
        Screen('FillRect', task_window, stimuli.background_colour, [0, 0, hardware.screen.dimensions.width/2, hardware.screen.dimensions.height]);
    end
    
    if strcmp(payout, 'budget')
    elseif strcmp(payout, 'reward') && strcmp(results.single_trial.subtask, 'bundle_choice')
        Screen('FillRect', task_window, stimuli.background_colour, stimuli.bidspace.initial_position +...
            [-10, -10, bidspace_reflector + 10, 10]);
    end

elseif strcmp(task, 'PAV')
    Screen('FillRect', task_window, hardware.screen.colours.grey);
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
end