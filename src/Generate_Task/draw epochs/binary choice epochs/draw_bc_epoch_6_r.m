function [] = draw_bc_epoch_6_r(stimuli, parameters, hardware, task_window)

%draw the textures and the frame
if isfield(parameters, 'binary_choice')
    if ~parameters.binary_choice.no_fractals
        Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
    end
end
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);

%add in the second bidspace in the equal refelcted position
position_reflector = hardware.outputs.screen_info.width - stimuli.bidspace.bidspace_info.position(1) - stimuli.bidspace.bidspace_info.position(3);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box + [position_reflector, 0, position_reflector, 0], stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position + [position_reflector, 0, position_reflector, 0], 0);

%draw the reversed bidspace for the bundle last
Screen('DrawTexture', task_window, stimuli.trial.reverse_bidspace_texture, [], stimuli.trial.reversed_bidspace_position , 0);
Screen('FillRect', task_window, [0 0 0 stimuli.occlusion_darkness], stimuli.trial.reversed_bidspace_position);

%and for the budget if required
%and for the budget if required
if parameters.binary_choice.random_budget
    if(parameters.single_trial_values.bundle_half == 1)
        Screen('DrawTexture', task_window, stimuli.trial.reverse_budget_texture, [], stimuli.trial.reversed_budget_position + [position_reflector, 0, position_reflector, 0], 0);
        Screen('FillRect', task_window, [0 0 0 stimuli.occlusion_darkness], stimuli.trial.reversed_budget_position + [position_reflector, 0, position_reflector, 0]);
    else
        Screen('DrawTexture', task_window, stimuli.trial.reverse_budget_texture, [], stimuli.trial.reversed_budget_position, 0);
        Screen('FillRect', task_window, [0 0 0 stimuli.occlusion_darkness], stimuli.trial.reversed_budget_position);
    end
end

%draw a rectangle over the left half of the screen
Screen('FillRect', task_window, [hardware.outputs.screen_info.white/2], [0, 0, hardware.outputs.screen_info.width/2, hardware.outputs.screen_info.height]);
