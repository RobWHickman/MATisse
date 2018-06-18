%function to check if the monkey is fixating on the cross
%returns a boolean that is true if they fixated and false if they did not
function parameters = check_joystick_stationary(parameters, joystick)

%check if the joystick voltage is subthreshold in either dimension
if abs((joystick.movement.movement_y) || abs(joystick.movement.movement_x)) > joystick.sensitivity.centered
   parameters.task_checks.Status('hold_joystick') = 0;
else
   parameters.task_checks.Status('hold_joystick') = 1;
end
