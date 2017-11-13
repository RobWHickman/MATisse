%set the basic task parameters
function parameters = set_experiment_parameters(parameters)

%an upper limit on the number of correct trials to run
parameters.correct_trials = 200;

%set up the failure points for the task
%all default to false
task_checks = table({'fixation';'hold_joystick';'bid_activity';'targeted_offer'},...
    [false;false;false;false],...
    {'monkey_fixated_on_cross';'monkey_holding_joystick_still';'monkey_bidding_activity';'monkey_bid_targeted'},...
    'VariableNames',{'Test','Status','Description'});
parameters.task_checks = task_checks;

%various small extra settings
%how long the monkey has to make a bid before the timeout in s
parameters.settings.bid_timeout = 1;
