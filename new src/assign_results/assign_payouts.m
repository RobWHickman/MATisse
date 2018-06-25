%small function to calculate the remaining budget and reward the monkey
%gets after an auction depending on whether it beats the computer or not
function results = assign_payouts(parameters, modifiers, results)
if strcmp(parameters.task, 'BDM')
    %if the monkey wins the auction
    if(parameters.single_trial_values.computer_bid_value < results.trial_results.monkey_bid)
    results.output.budget = (1 -  parameters.single_trial_values.computer_bid_value);
    results.output.reward = parameters.single_trial_values.offer_value;
    %if the computer wins the auction
    else
        results.output.budget = 1;
        results.output.reward = 0;
    end    

elseif strcmp(parameters.task, 'BC')
    %if the monkey chooses the bundle
    if((parameters.single_trial_values.bundle_half == 0 && (results.trial_results.monkey_bid > 0.5 - parameters.binary_choice.bundle_width/100) * 2) |...
            (parameters.single_trial_values.bundle_half == 1 && (results.trial_results.monkey_bid < parameters.binary_choice.bundle_width/100 - 0.5) * 2))
        results.trial_results.remaining_budget = 1 - parameters.single_trial_values.bundle_water;
        results.output.reward = parameters.single_trial_values.offer_value;
    else
        results.trial_results.remaining_budget = 1 - parameters.single_trial_values.budget_water;
        results.output.reward = 0;
    end

    if parameters.binary_choice.random_budget
        results.trial_results.budget_water_perc = parameters.single_trial_values.budget_water;
    end
    results.trial_results.offer_value = parameters.single_trial_values.offer_value;

    if parameters.binary_choice.no_fractals == 1
        results.trial_results.reward = 0;
    end

%for pavlovian trials, reward is always equal to offer value
elseif strcmp(parameters.task, 'PAV')
    %check if the fractal is probabilistic or not
    %payout will either be a reward of value or 0
    if~isnan(modifiers.fractals.p_fractals_indexes)
        if(ismember(results.single_trial.reward_value, modifiers.fractals.p_fractals_indexes))
            random_number_check = rand;
            if(random_number_check > modifiers.fractals.fractal_probability)
                results.output.reward = parameters.single_trial_values.offer_value;
            else
                results.output.reward = 0;
            end
        else
            results.output.reward = parameters.single_trial_values.offer_value;
        end
    else
        %if not probabilistic, just payout value
        results.output.reward = parameters.single_trial_values.offer_value;
    end
    results.output.budget = NaN;
end

