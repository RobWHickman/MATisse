function [] = draw_epoch_2(stimuli, task_window)
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.trial.trial_fractal_position, 0);
Screen('DrawingFinished', task_window);
