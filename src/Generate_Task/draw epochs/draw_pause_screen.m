%function to draw the seventh epoch- the final epoch with a light grey
%screen
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_pause_screen(hardware, task_window)

%fill with a lighter grey than other epochs
Screen('FillRect', task_window, hardware.outputs.screen_info.bg_col + (hardware.outputs.screen_info.white / 5))
Screen('DrawingFinished', task_window);
Screen('Flip', task_window);
end