%function to draw the third epoch- the fractal plus the bidding space
%takes the bidspace info and textures generated before the trials and also
%the trial selected fractal
function [] = draw_epoch_35(trial_fractal, trial_fractal_info, parameters, bidspace_texture, bidspace_bounding_box, bidspace_info, screen_info, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, trial_fractal, [], trial_fractal_info.position, 0);
Screen('FrameRect', task_window, [parameters.screen.white], bidspace_bounding_box, bidspace_info.frame_width);
Screen('DrawTexture', task_window, bidspace_texture, [], bidspace_info.position, 0);
%draw the bidding bar
%Screen('DrawLine', task_window, bidspace_info.bidding_colour, bidspace_info.position(1) - screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, bidspace_info.position(3) +  screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, 5);
Screen('DrawLine', task_window, [parameters.screen.white/2, 0, 0], bidspace_info.position(1) - screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, bidspace_info.position(3) +  screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, 5);
Screen('DrawingFinished', task_window);
