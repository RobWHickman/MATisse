%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey wins i.e. if its bid is higher than
%that of the computer
function [] = draw_payout_epoch(parameters, modifiers, results, stimuli, hardware, task_window, task, payout)


if strcmp(task, 'BDM')
    Screen('FillRect', task_window, hardware.screen.colours.grey);
    if strcmp(results.outputs.results, 'win')
    elseif strcmp(results.outputs.results, 'lose')
    end

elseif strcmp(task, 'BC')
    bidspace_reflector = hardware.screen.dimensions.width - stimuli.bidspace.position(1) - stimuli.bidspace.position(3);
    draw_bidding_epoch(parameters, stimuli, modifiers, hardware, results, task_window, parameters.task.type)
    
    if results.trial_results.monkey_bid < 0.5
        Screen('FillRect', task_window, [hardware.screen.colours.grey], [hardware.screen.dimensions.width/2, 0, hardware.screen.dimensions.width, hardware.screen.dimensions.height]);
    else
        Screen('FillRect', task_window, [hardware.screen.colours.grey], [0, 0, hardware.screen.dimensions.width/2, hardware.screen.dimensions.height]);
    end
    
    if strcmp(payout, 'budget')
    elseif strcmp(payout, 'reward')
        Screen('FillRect', task_window, [hardware.screen.colours.grey], stimuli.bidspace.initial_position +...
            [-10, -10, -bidspace_reflector + 10, 10]);
    end

elseif strcmp(task, 'PAV')
    Screen('FillRect', task_window, hardware.screen.colours.grey);
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
end