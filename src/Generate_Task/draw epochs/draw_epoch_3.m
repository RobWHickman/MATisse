%function to draw the third epoch- the fractal plus the bidding space
%takes the bidspace info and textures generated before the trials and also
%the trial selected fractal
function [] = draw_epoch_3(stimuli, hardware, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);
%Screen('DrawingFinished', task_window);
