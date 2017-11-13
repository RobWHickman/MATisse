%function to draw the seventh epoch- the final epoch with a light grey
%screen
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_epoch_7(screen_info, parameters, task_window)

%fill with a lighter grey than other epochs
Screen('FillRect', task_window, screen_info.bg_col + (parameters.screen.white / 5))
Screen('DrawingFinished', task_window);
end