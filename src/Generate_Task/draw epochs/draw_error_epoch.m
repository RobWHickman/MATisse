%draws the screen for the error epochs
%regardless of error type
%just a blank screen (error tone will sound at same time)
function [] = draw_error_epoch(hardware, task_window)

Screen('FillRect', task_window, [hardware.outputs.screen_info.white, hardware.outputs.screen_info.white, hardware.outputs.screen_info.white]);