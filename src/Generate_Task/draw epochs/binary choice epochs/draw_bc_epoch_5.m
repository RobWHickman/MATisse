function [] = draw_bc_epoch_5(stimuli, hardware, results, task_window)

%draw the textures and the frame
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);

%add in the second bidspace in the equal refelcted position
position_reflector = hardware.outputs.screen_info.width - stimuli.bidspace.bidspace_info.position(1) - stimuli.bidspace.bidspace_info.position(3);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box + [position_reflector, 0, position_reflector, 0], stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position + [position_reflector, 0, position_reflector, 0], 0);

%create the bidding circle as an oval in a rect
%center it on the current bid (0 for this epoch)
bidding_circle = [0 0 50 50];
maxDiameter = max(bidding_circle) * 1.01;
centered_bidding_circle = CenterRectOnPointd(bidding_circle, hardware.outputs.screen_info.width/2 + (hardware.outputs.screen_info.width/2 * results.trial_results.monkey_bid), hardware.outputs.screen_info.height/2);
%purple for the active epoch
bidding_circle_colour = [hardware.outputs.screen_info.white, 0 hardware.outputs.screen_info.white];

%draw the bidding circle
Screen('FillOval', task_window, bidding_circle_colour, centered_bidding_circle, maxDiameter);

Screen('DrawingFinished', task_window);