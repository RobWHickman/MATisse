function results = assign_error_results(parameters, results)

%set the final bid as NaN (as not completed)
results.trial_results.win = NaN;
results.trial_results.remaining_budget = NaN;
results.trial_results.reward = NaN;
%only use computer bids in auctions/ bundle info for BC
if strcmp(parameters.task, 'BDM')
    results.trial_results.computer_bid = NaN;
elseif strcmp(parameters.task, 'BC')
    results.trial_results.bundle_position = parameters.single_trial_values.bundle_half;
    results.trial_results.bundle_water_perc = parameters.single_trial_values.bundle_water;
    if parameters.binary_choice.random_budget
        results.trial_results.budget_water_perc = parameters.single_trial_values.budget_water;
    end
end
results.trial_results.offer_value = parameters.single_trial_values.offer_value;
results.trial_results.budget_liquid = NaN;
results.trial_results.reward_liquid = NaN;

results.trial_results.monkey_final_bid = NaN;

%set the failure point as the point at which the monkey failed the task
if ~results.trial_values.task_checks.Status('fixation') && results.trial_values.task_checks.Requirement('fixation')
    results.trial_results.task_failure = {'no_fixation'};

elseif ~results.trial_values.task_checks.Status('hold_joystick') && results.trial_values.task_checks.Requirement('hold_joystick')
    results.trial_results.task_failure = {'joystick_not_stationary'};

elseif results.trial_values.task_checks.Status('no_bid_activity')
    results.trial_results.task_failure = {'no_bid'};

elseif ~results.trial_values.task_checks.Status('stabilised_offer') && results.trial_values.task_checks.Requirement('stabilised_offer')
    results.trial_results.task_failure = {'unfinished_bidding'};

elseif ~results.trial_values.task_checks.Status('targeted_offer') && results.trial_values.task_checks.Requirement('targeted_offer')
    results.trial_results.task_failure = {'non_targeted_bidding'};
    
else
    results.trial_results.task_failure = {'undefined error - probably missed both choices'};
    %bidding error - fix this
end    