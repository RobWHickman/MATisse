%function to draw the first epoch- the fixation cross
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_epoch_1(stimuli, hardware, task_window)
Screen('FillRect', task_window, hardware.outputs.screen_info.bg_col);
Screen('FillRect', task_window, hardware.outputs.screen_info.bg_col, stimuli.fixation_cross.fixation_box);
Screen('DrawLines', task_window, stimuli.fixation_cross.fixation_cross, stimuli.fixation_cross.fixation_cross_info.thickness,...
    stimuli.fixation_cross.fixation_cross_info.colour, stimuli.fixation_cross.fixation_cross_info.position);
Screen('DrawingFinished', task_window);
