function results = assign_error_results(parameters, results, failure)

%set the final bid as NaN (as not completed)
results.trial_results.remaining_budget = NaN;
results.trial_results.reward = NaN;
results.trial_results.computer_bid = NaN;
results.trial_results.offer_value = parameters.single_trial_values.offer_value;
results.trial_results.win = NaN;
results.trial_results.budget_liquid = NaN;
results.trial_results.reward_liquid = NaN;

results.trial_results.monkey_final_bid = NaN;

%set the failure point as the point at which the monkey failed the task
if strcmp(failure, 'fixation')
    results.trial_results.task_failure = {'no_fixation'};

elseif strcmp(failure, 'joystick')
    results.trial_results.task_failure = {'joystick_not_stationary'};

elseif strcmp(failure, 'bidding')
    results.trial_results.task_failure = {'no_bid'};

elseif strcmp(failure, 'finalisation')
    results.trial_results.task_failure = {'unfinished_bidding'};

elseif strcmp(failure, 'targeting')
    results.trial_results.task_failure = {'non_targeted_bidding'};
    
end
