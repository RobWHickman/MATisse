%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey loses i.e. if its bid is lower than
%that of the computer
function [] = draw_epoch_5_lose(bidspace_texture, bidspace_bounding_box, screen_info, bidspace_info, parameters, task_window)

%draw the victory condition
%removes fractal and leaves bidspace unchanged
Screen('FrameRect', task_window, [parameters.screen.white], bidspace_bounding_box, bidspace_info.frame_width);
Screen('DrawTexture', task_window, bidspace_texture, [], bidspace_info.position, 0);
Screen('DrawLine', task_window, [parameters.screen.white, 0, 0], bidspace_info.position(1) - screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, bidspace_info.position(3) +  screen_info.percent_y * 2, bidspace_info.monkey_bid_position + bidspace_info.y_adjust, 5);
Screen('DrawLine', task_window, [0, parameters.screen.white, 0], bidspace_info.position(1) - screen_info.percent_y * 2, bidspace_info.computer_bid_position, bidspace_info.position(3) +  screen_info.percent_y * 2, bidspace_info.computer_bid_position, 5);
Screen('DrawingFinished', task_window);
