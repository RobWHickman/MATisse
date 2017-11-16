function [] = draw_epoch_5(parameters, stimuli, hardware, results, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.trial.trial_fractal_position, 0);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);
%draw the bidding bar
vertical_position = (results.trial_values.current_bid * (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4))) + stimuli.bidspace.bidspace_info.position(4);
round(vertical_position); %+y_adjust

Screen('DrawLine', task_window, stimuli.bidspace.bidspace_info.bidding_colour,...
    stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position,...
    stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position, 6.5);
Screen('DrawingFinished', task_window);
