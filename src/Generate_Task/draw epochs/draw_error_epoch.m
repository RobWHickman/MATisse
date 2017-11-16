function [] = draw_error_epoch(hardware, task_window)

Screen('FillRect', task_window, [hardware.outputs.screen_info.white/2, hardware.outputs.screen_info.white/5, hardware.outputs.screen_info.white/5]);
Screen('DrawingFinished', task_window);
