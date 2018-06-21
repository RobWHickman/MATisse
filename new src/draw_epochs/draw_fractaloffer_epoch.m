function [] = draw_fractaloffer_epoch(stimuli, hardware, task_window, task)

Screen('FillRect', task_window, hardware.screen.colours.grey);
Screen('DrawTexture', task_window, stimuli.fractals.texture, [], stimuli.fractals.position, 0);