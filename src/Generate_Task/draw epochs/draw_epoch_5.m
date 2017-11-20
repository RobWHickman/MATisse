function [] = draw_epoch_5(parameters, stimuli, hardware, results, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.trial.trial_fractal_position, 0);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);
%draw the bidding bar
vertical_position = (results.trial_results.monkey_bid * (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4))) + stimuli.bidspace.bidspace_info.position(4);
round(vertical_position);

Screen('DrawLine', task_window, stimuli.bidspace.bidspace_info.bidding_colour,...
    stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position,...
    stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position, 6.5);

%draw the targeting box if the value for the test if false
if parameters.targeting
    Screen('BlendFunction', task_window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    if ~results.trial_values.task_checks.Status('targeted_offer')
    Screen('FillRect', task_window, stimuli.target_box.colour', stimuli.target_box.position);
    elseif results.trial_values.task_checks.Status('targeted_offer')
    Screen('FillRect', task_window, [0 1 0 0.5]', stimuli.target_box.position);
    end
end

Screen('DrawingFinished', task_window);
