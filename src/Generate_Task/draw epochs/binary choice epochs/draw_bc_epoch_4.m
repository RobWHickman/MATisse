function [] = draw_bc_epoch_4(stimuli, parameters, hardware, task_window)
%draw the textures and the frame
if isfield(parameters, 'binary_choice')
    if ~parameters.binary_choice.no_fractals
        Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
    end
end
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);

%add in the second bidspace in the equal refelcted position
position_reflector = hardware.outputs.screen_info.width - stimuli.bidspace.bidspace_info.position(1) - stimuli.bidspace.bidspace_info.position(3);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box + [position_reflector, 0, position_reflector, 0], stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position + [position_reflector, 0, position_reflector, 0], 0);

%draw the reversed bidspace for the bundle last
Screen('DrawTexture', task_window, stimuli.trial.reverse_bidspace_texture, [], stimuli.trial.reversed_bidspace_position , 0);
Screen('FillRect', task_window, [0 0 0 stimuli.trial.cover_rect_darkness], stimuli.trial.reversed_bidspace_position);

%and for the budget if required
if parameters.binary_choice.random_budget
    Screen('DrawTexture', task_window, stimuli.trial.reverse_budget_texture, [], stimuli.trial.reversed_budget_position + [position_reflector, 0, position_reflector, 0], 0);
    Screen('FillRect', task_window, [0 0 0 stimuli.trial.cover_rect_darkness], stimuli.trial.reversed_budget_position + [position_reflector, 0, position_reflector, 0]);
end

%create the bidding circle as an oval in a rect
%center it on the current bid (0 for this epoch)
bidding_circle = [0 0 50 50];
maxDiameter = max(bidding_circle) * 1.01;
centered_bidding_circle = CenterRectOnPointd(bidding_circle, hardware.outputs.screen_info.width/2, hardware.outputs.screen_info.height/2);
%dark purple for the ianctive epoch
bidding_circle_colour = [hardware.outputs.screen_info.white/2, 0 hardware.outputs.screen_info.white/2];

%draw the bidding circle
Screen('FillOval', task_window, bidding_circle_colour, centered_bidding_circle, maxDiameter);
