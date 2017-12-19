%function to draw the first epoch- the fixation cross
%takes the fixation cross, its info and the fixation box generated before
%the trials start running
function [] = draw_epoch_1(stimuli, hardware, task_window,parameters)
Screen('FillRect', task_window, hardware.outputs.screen_info.bg_col);
Screen('FillRect', task_window, hardware.outputs.screen_info.bg_col, stimuli.fixation_cross.fixation_box);
if strcmp(parameters.task_type,'base')
    Screen('DrawLines', task_window, stimuli.fixation_cross.fixation_cross, stimuli.fixation_cross.fixation_cross_info.thickness,...
        stimuli.fixation_cross.fixation_cross_info.colour, stimuli.fixation_cross.fixation_cross_info.position);
elseif strcmp(parameters.task_type,'first')
    %draws a fixation_circle
    Screen('FillOval',task_window,stimuli.fixation_circle.fixation_circle_info.color, stimuli.fixation_circle.fixation_circle)
%select the fixation shape for each trial depending on the randomly
%generated auction_type
elseif strcmp(parameters.task_type,'12price')
        if parameters.single_trial_values.auction_type == 1
            %draws a fixation circle
            Screen('FillOval',task_window,stimuli.fixation_circle.fixation_circle_info.color, stimuli.fixation_circle.fixation_circle)
        elseif parameters.single_trial_values.auction_type == 2
            %draws a fixation cross
            Screen('DrawLines', task_window, stimuli.fixation_cross.fixation_cross, stimuli.fixation_cross.fixation_cross_info.thickness,...
                stimuli.fixation_cross.fixation_cross_info.colour, stimuli.fixation_cross.fixation_cross_info.position); 
        end
end
Screen('DrawingFinished', task_window);
