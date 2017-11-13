%function to draw the first epoch- the fixation cross
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_epoch_1(fixation_cross, fixation_cross_info, fixation_box, screen_info, task_window)
Screen('FillRect', task_window, screen_info.bg_col);
Screen('FillRect', task_window, screen_info.bg_col, fixation_box);
Screen('DrawLines', task_window, fixation_cross, fixation_cross_info.thickness, fixation_cross_info.colour, fixation_cross_info.position);
Screen('DrawingFinished', task_window);
