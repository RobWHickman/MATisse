%small function to calculate the remaining budget and reward the monkey
%gets after an auction depending on whether it beats the computer or not
function results = assign_payouts(parameters, results)
if strcmp(parameters.task, 'BDM')
%if the monkey wins the auction
if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
    results.trial_results.remaining_budget = (1 -  parameters.single_trial_values.computer_bid_value);
    results.trial_results.reward = parameters.single_trial_values.offer_value;
%if the computer wins the auction
else
    results.trial_results.remaining_budget = 1;
    results.trial_results.reward = 0;
end    

%also chuck in the computer bid as a field to be analysed later
results.trial_results.computer_bid = parameters.single_trial_values.computer_bid_value;
results.trial_results.offer_value = parameters.single_trial_values.offer_value;

elseif strcmp(parameters.task, 'BC')
%if the monkey chooses the bundle
if((parameters.single_trial_values.bundle_half == 0 && (results.trial_results.monkey_bid > 0.5 - parameters.binary_choice.bundle_width/100) * 2) |...
        (parameters.single_trial_values.bundle_half == 1 && (results.trial_results.monkey_bid < parameters.binary_choice.bundle_width/100 - 0.5) * 2))
    results.trial_results.remaining_budget = 1 - parameters.single_trial_values.bundle_water;
    results.trial_results.reward = parameters.single_trial_values.offer_value;
else
    results.trial_results.remaining_budget = 1 - parameters.single_trial_values.budget_water;
    results.trial_results.reward = 0;
end

%also chuck in the bundle info as a field to be analysed later
results.trial_results.bundle_position = parameters.single_trial_values.bundle_half;
results.trial_results.bundle_water_perc = parameters.single_trial_values.bundle_water;
if parameters.binary_choice.random_budget
    results.trial_results.budget_water_perc = parameters.single_trial_values.budget_water;
end
results.trial_results.offer_value = parameters.single_trial_values.offer_value;
end

