%function to draw the fifth epoch- the result of the bidding
%this function is called if the monkey wins i.e. if its bid is higher than
%that of the computer
function [] = draw_epoch_6_win(parameters, stimuli, hardware, results, task_window)

%draw the victory condition
%maintains fractal and reverses bidspace spent (under computer bid)
%draw the textures and the frame
Screen('DrawTexture', task_window, stimuli.trial.trial_fractal_texture, [], stimuli.fractals.fractal_info.fractal_position, 0);
Screen('FrameRect', task_window, [hardware.outputs.screen_info.white], stimuli.bidspace.bidspace_bounding_box, stimuli.bidspace.bidspace_info.bounding_width);
Screen('DrawTexture', task_window, stimuli.bidspace.bidspace_texture, [], stimuli.bidspace.bidspace_info.position, 0);
Screen('DrawTexture', task_window, stimuli.trial.reverse_bidspace_texture, [], stimuli.trial.reversed_bidspace_position , 0);

vertical_position_monkey_bid = (results.trial_results.monkey_bid * (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4))) + stimuli.bidspace.bidspace_info.position(4);
round(vertical_position_monkey_bid);
vertical_position_computer_bid = (parameters.single_trial_values.computer_bid_value * (stimuli.bidspace.bidspace_info.position(2) - stimuli.bidspace.bidspace_info.position(4))) + stimuli.bidspace.bidspace_info.position(4);
round(vertical_position_computer_bid); %+y_adjust

%draw the bidding line as a line
% Screen('DrawLine', task_window, stimuli.bidspace.bidspace_info.bidding_colour,...
%     stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position,...
%     stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position, 6.5);
% Screen('DrawLine', task_window, [0, hardware.outputs.screen_info.white, 0],...
%     stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position_computer_bid,...
%     stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position_computer_bid, 6.5);

%draw the bidding line as a rect
Screen('FillRect', task_window, stimuli.bidspace.bidspace_info.bidding_colour,...
    [stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position_monkey_bid - (stimuli.bidspace.bidspace_info.bidding_thickness + stimuli.bidspace.bidspace_info.bidding_growth),...
    stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position_monkey_bid + (stimuli.bidspace.bidspace_info.bidding_thickness + stimuli.bidspace.bidspace_info.bidding_growth)]);
Screen('FillRect', task_window, [0, hardware.outputs.screen_info.white, 0],...
    [stimuli.bidspace.bidspace_info.position(1) - hardware.outputs.screen_info.percent_y * 5, vertical_position_computer_bid - stimuli.bidspace.bidspace_info.bidding_thickness,...
    stimuli.bidspace.bidspace_info.position(3) +  hardware.outputs.screen_info.percent_y * 5, vertical_position_computer_bid + stimuli.bidspace.bidspace_info.bidding_thickness]);

Screen('DrawingFinished', task_window);
