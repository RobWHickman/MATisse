%function to draw the third epoch- the fractal plus the bidding space
%takes the bidspace info and textures generated before the trials and also
%the trial selected fractal
function [] = draw_epoch_3(trial_fractal, trial_fractal_info, parameters, bidspace_texture, bidspace_bounding_box, bidspace_info, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, trial_fractal, [], trial_fractal_info.position, 0);
Screen('FrameRect', task_window, [parameters.screen.white], bidspace_bounding_box, bidspace_info.frame_width);
Screen('DrawTexture', task_window, bidspace_texture, [], bidspace_info.position, 0);
Screen('DrawingFinished', task_window);
