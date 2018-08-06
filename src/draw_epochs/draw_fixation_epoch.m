%function to draw the first epoch- the fixation cross
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_fixation_epoch(stimuli, hardware, task_window, task)
Screen('FillRect', task_window, stimuli.background_colour);
Screen('FillRect', task_window, stimuli.background_colour, stimuli.fixation_cross.fixation_box);
Screen('DrawLines', task_window, stimuli.fixation_cross.fixation_cross, stimuli.fixation_cross.fixation_cross_info.thickness,...
    stimuli.fixation_cross.fixation_cross_info.colour, stimuli.fixation_cross.fixation_cross_info.position);
%Screen('DrawingFinished', task_window);
