function results = assign_error_results(results, parameters)

results.outputs.budget = NaN;
results.outputs.reward = NaN;
results.outputs.paid = NaN;
results.outputs.budget_liquid = 0;
results.outputs.reward_liquid = 0;

%if monkey did not get to make a bid 
if ~isfield(results.trial_results, 'monkey_bid')
    results.trial_results.monkey_bid = NaN;
end

results.outputs.results = strcat('fail_',...
    string(parameters.task_checks.table.Description(min(find(parameters.task_checks.table.Status & parameters.task_checks.table.Requirement)))));