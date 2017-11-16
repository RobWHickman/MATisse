%function to check if the monkey is fixating on the cross
%returns a boolean that is true if they fixated and false if they did not
function [stationary, results] = check_joystick_stationary(parameters, hardware, results)
joystick_movement = peekdata(hardware.inputs.joystick, 4);
joystick_mean = -mean(joystick_movement(:,2));
if results.trial_values.task_checks.Status('hold_joystick')
   if abs(joystick_mean + hardware.inputs.settings.joystick_y_bias) > hardware.inputs.settings.joystick_sensitivity
       stationary = false;
   else
       stationary = true;
   end
else
    stationary = false;
end

%and update the 'fixation' vector
%how the joystick has moved during fixation
results.trial_values.fixation_vector = [results.trial_values.fixation_vector, {{mean(joystick_movement(:,2)), mean(joystick_movement(:,2))}}]; 