%function to draw the seventh epoch- the final epoch with a light grey
%screen
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_error_epoch(hardware, task_window)

%fill with a lighter grey than other epochs
Screen('FillRect', task_window, [hardware.screen.colours.white, 0, 0])
