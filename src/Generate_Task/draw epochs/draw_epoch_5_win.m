%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey wins i.e. if its bid is higher than
%that of the computer
function [] = draw_epoch_5_win(trial_fractal, trial_fractal_info, bidspace_texture, bidspace_bounding_box, reverse_bidspace_texture, screen_info, bidspace_info, parameters, task_window)

%draw the victory condition
%maintains fractal and reverses bidspace spent (under computer bid)
Screen('DrawTexture', task_window, trial_fractal, [], trial_fractal_info.position, 0);
Screen('FrameRect', task_window, [parameters.screen.white], bidspace_bounding_box, bidspace_info.frame_width);
Screen('DrawTexture', task_window, bidspace_texture, [], bidspace_info.position, 0);
Screen('DrawTexture', task_window, reverse_bidspace_texture, [], bidspace_info.reversed_position , 0);
Screen('DrawLine', task_window, [parameters.screen.white, 0, 0], bidspace_info.position(1) - screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, bidspace_info.position(3) +  screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, 5);
Screen('DrawLine', task_window, [0, parameters.screen.white, 0], bidspace_info.position(1) - screen_info.percent_y * 2, bidspace_info.computer_bid_position, bidspace_info.position(3) +  screen_info.percent_y * 2, bidspace_info.computer_bid_position     , 5);
Screen('DrawingFinished', task_window);
