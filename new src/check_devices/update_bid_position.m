function [results, stimuli] = update_bid_position(hardware, results, parameters, stimuli)
%if using testmode look for keystrokes
if hardware.testmode
    [keyIsDown, secs, keyCode] = KbCheck;
else
    joystick_movement = peekdata(hardware.inputs.joystick, 4);
    %the multiplier to make moving the joystick harder/easier in a specific
    %direction
    joystick_manual_bias = hardware.joystick.bias.manual_bias;
    if hardware.inputs.settings.direction == 'y'
        joystick_movement = mean(joystick_movement(:,2));
        joystick_offset = str2num(hardware.joystick.bias.y_offset);
        axis_multiplier = -1;
    elseif hardware.inputs.settings.direction == 'x'
        joystick_movement = mean(joystick_movement(:,1));
        joystick_offset = str2num(hardware.joystick.bias.x_offset);
        axis_multiplier = -1;
    end
    
    %take how far the joystick is moved forward into account (or dont)
    if hardware.inputs.settings.joystick_velocity
        joystick_impetus_r = (joystick_movement + joystick_offset) / 0.6; %0.6 is pretty much the max you can move it in any direction
        joystick_impetus_l = (joystick_movement + joystick_offset) / 0.6; %0.6 is pretty much the max you can move it in any direction
    else
        joystick_impetus_l = 1;
        joystick_impetus_r = -1;
    end
end

%set the limits for the bidding
%also set the bid multiplier (this is 1 for y axis (BDM) and -1 for the x
%axis (BC) because of how PTB sets up the screen coords
if strcmp(parameters.task, 'BDM')
    bidding_limits = [stimuli.bidspace.position(2), stimuli.bidspace.position(4)];
    initial_bid_position = stimuli.bidspaceposition(4) - ...
    (stimuli.bidspace.dimensions.height * results.single_trial.starting_bid_value);
elseif strcmp(parameters.task, 'BC')
    bidding_limits = [0, hardware.outputs.screen_info.width];
    initial_bid_position = hardware.screen.dimensions.width/2;
end
%move all this above into a separate functionto be run on the first frame

%set the default movement for the frame to zero
frame_adjust = 0;
output_frame_adjust = 0;

%update the bid position using arrow keys
if (~parameters.task_checks.Status('no_bid_activity') || ~parameters.task_checks.Requirement('no_bid_activity')) &&...
        (~parameters.task_checks.Status('stabilised_offer') || ~parameters.task_checks.Requirement('stabilised_offer'))
    if parameters.modification.testmode
        if keyIsDown == 0
            results = stationary_behaviour(parameters, hardware, results); %CODE THIS UP
        elseif keyCode(hardware.inputs.keyboard.more_key) &&...
                initial_bid_position + results.movement.adjust > limits(1)
            %reset the count
            results.trial_values.stationary_frame_count = 0;
            %work out how 
            frame_adjust = adjust_position(hardware, results, bidding_limits, 'more'); %CODE THIS UP
        elseif keyCode(hardware.inputs.keyboard.less_key) &&...
                initial_bid_position + results.trial_results.adjust < limits(2)
            results.trial_values.stationary_frame_count = 0;
            frame_adjust = adjust_position(hardware, results, bidding_limits, 'less');            
        

