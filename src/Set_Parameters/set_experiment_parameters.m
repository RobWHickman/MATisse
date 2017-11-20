%set the basic task parameters
function parameters = set_experiment_parameters(parameters, hardware)

%an upper limit on the number of correct trials to run
parameters.correct_trials = 5;

%set up the failure points for the task
%all default to false
task_checks = table([false;false;false;false;true],...
    {'monkey_fixated_on_cross';'monkey_holding_joystick_still';'monkey_bidding_activity';'monkey_bid_stabilised';'monkey_bid_targeted'},...
    'VariableNames',{'Status','Description'},...
    'RowNames',{'fixation';'hold_joystick';'no_bid_activity';'stabilised_offer';'targeted_offer'});

%various small extra settings
%how long the monkey has to make a bid before the timeout in s
parameters.settings.bid_timeout = 1;
parameters.settings.max_pause = 2;

%if in testmode, don't check for hold_joystick
if hardware.testmode
    task_checks.Status('hold_joystick') = true;
end
%if in targeting mode change the targeted_offer to false
if isfield(parameters, 'targeting')
    task_checks.Status('targeted_offer') = false;
end
parameters.task_checks = task_checks;
