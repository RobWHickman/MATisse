function [] = draw_epoch_4(parameters, stimuli, hardware, results, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);
%draw the bidding bar
vertical_position = (parameters.single_trial_values.starting_bid_value * (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4))) + stimuli.bidspace.bidspace_info.position(4);
round(vertical_position);

%draw the targeting box if the value for the test if false
if ~results.trial_values.task_checks.Status('targeted_offer')
    Screen('FillRect', task_window, stimuli.target_box.colour',...
        [stimuli.target_box.position(1), stimuli.target_box.position(2) + parameters.single_trial_values.target_value_shift,...
        stimuli.target_box.position(3), stimuli.target_box.position(4) + parameters.single_trial_values.target_value_shift]);
end

%the stationary bidding bar
%draw the bidding line as a line
% Screen('DrawLine', task_window, [hardware.outputs.screen_info.white/2, 0, 0],...
%     stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position,...
%     stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position, 6.5);

%draw the bidding line as a rect
Screen('FillRect', task_window, [0, 0, 0],... %black before bidding starts
    [stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position - stimuli.bidspace.bidspace_info.bidding_thickness,...
    stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position + stimuli.bidspace.bidspace_info.bidding_thickness]);
