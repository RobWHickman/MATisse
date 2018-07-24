function [] = draw_fractaloffer_epoch(stimuli, modifiers, hardware, task_window, task)

Screen('FillRect', task_window, hardware.screen.colours.grey);

if strcmp(task, 'PAV')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
elseif strcmp(task, 'BDM')
    Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
elseif strcmp(task, 'BC')
    if ~modifiers.fractals.no_fractals
        Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);
    end
    
    if modifiers.specific_tasks.binary_choice.bundles && ~modifiers.budgets.no_budgets
        Screen('DrawTexture', task_window, stimuli.bidspace.texture, [], stimuli.bidspace.position, 0);
        Screen('DrawTexture', task_window, stimuli.bidspace.reverse_texture, [], stimuli.bidspace.reverse_texture_position, 0);
        Screen('FrameRect', task_window, [hardware.screen.colours.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.dimensions.bounding_width);
    end
end