%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey wins i.e. if its bid is higher than
%that of the computer
function [] = draw_epoch_7(hardware, task_window)

Screen('FillRect', task_window, [hardware.outputs.screen_info.white/5, hardware.outputs.screen_info.white/5, hardware.outputs.screen_info.white/2]);