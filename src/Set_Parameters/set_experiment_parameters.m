%set the basic task parameters
function parameters = set_experiment_parameters(hardware_settings)

%an upper limit on the number of correct trials to run
parameters.correct_trials = 5;

%set up the failure points for the task
%all default to false
task_checks = table([false;false;false;false],...
    {'monkey_fixated_on_cross';'monkey_holding_joystick_still';'monkey_bidding_activity';'monkey_bid_targeted'},...
    'VariableNames',{'Status','Description'},...
    'RowNames',{'fixation';'hold_joystick';'bid_activity';'targeted_offer'});
parameters.task_checks = task_checks;

%various small extra settings
%how long the monkey has to make a bid before the timeout in s
parameters.settings.bid_timeout = 1;
parameters.settings.max_pause = 1;

%if in testmode, don't check for hold_joystick
if hardware_settings.testmode
    task_checks.Status('hold_joystick') = true;
end
   