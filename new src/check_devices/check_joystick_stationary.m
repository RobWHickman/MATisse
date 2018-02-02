%function to check if the monkey is fixating on the cross
%returns a boolean that is true if they fixated and false if they did not
function [parameters, results] = check_joystick_stationary(parameters, hardware, results)
joystick_movement = peekdata(hardware.joystick.device, 4);
joystick_mean_y = mean(joystick_movement(:,2));
joystick_mean_x = mean(joystick_movement(:,1));

%check if the joystick voltage is subthreshold in either dimension
if abs(joystick_mean_y + str2double(hardware.joystick.bias.y_bias)) > hardware.joystick.sensitivity.centered ||...
    abs(joystick_mean_x + str2double(hardware.joystick.bias.x_bias)) > hardware.joystick.sensitivity.centered
   parameters.task_checks.Status('hold_joystick') = 0;
else
   parameters.task_checks.Status('hold_joystick') = 1;
end

%and update the 'fixation' vector
%how the joystick has moved during fixation
results.trial_values.fixation_vector = [results.trial_values.fixation_vector, {{mean(joystick_movement(:,2)), mean(joystick_movement(:,2))}}]; 