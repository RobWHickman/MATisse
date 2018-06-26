%small function to calculate the remaining budget and reward the monkey
%gets after an auction depending on whether it beats the computer or not
function results = assign_payouts(parameters, modifiers, results)
if strcmp(parameters.task.type, 'BDM')
    %if the monkey wins the auction
    if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
    results.outputs.budget = (1 -  parameters.single_trial_values.computer_bid_value);
    results.outputs.reward = results.single_trial.reward_value;
    %if the computer wins the auction
    else
        results.outputs.budget = 1;
        results.outputs.reward = 0;
    end    

elseif strcmp(parameters.task.type, 'BC')
    %if the monkey chooses the bundle
    if((parameters.single_trial_values.bundle_half == 0 && (results.trial_results.monkey_bid > 0.5 - parameters.binary_choice.bundle_width/100) * 2) |...
            (parameters.single_trial_values.bundle_half == 1 && (results.trial_results.monkey_bid < parameters.binary_choice.bundle_width/100 - 0.5) * 2))
        results.outputs.budget = 1 - parameters.single_trial_values.bundle_water;
        results.outputs.reward = parameters.single_trial_values.offer_value;
    else
        results.outputs.budget = 1 - parameters.single_trial_values.budget_water;
        results.outputs.reward = 0;
    end

    if parameters.binary_choice.random_budget
        results.trial_results.budget_water_perc = parameters.single_trial_values.budget_water;
    end
    results.trial_results.offer_value = results.single_trial.reward_value;

    if parameters.binary_choice.no_fractals == 1
        results.outputs.reward = 0;
    end

%for pavlovian trials, reward is always equal to offer value
elseif strcmp(parameters.task.type, 'PAV')
    %check if the fractal is probabilistic or not
    %payout will either be a reward of value or 0
    if~isnan(modifiers.fractals.p_fractals_indexes)
        if(results.single_trial.reward_chance ~= 1)
            random_number_check = rand;
            if(random_number_check > results.single_trial.reward_chance)
                results.outputs.reward = results.single_trial.reward_value;
            else
                results.outputs.reward = 0;
            end
        else
            results.outputs.reward = results.single_trial.reward_value;
        end
    else
        %if not probabilistic, just payout value
        results.outputs.reward = results.single_trial.reward_value;
    end
    results.outputs.budget = NaN;
end

