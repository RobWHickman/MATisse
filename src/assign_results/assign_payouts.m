%small function to calculate the remaining budget and reward the monkey
%gets after an auction depending on whether it beats the computer or not
function results = assign_payouts(parameters, modifiers, stimuli, results)
if ~ strcmp(parameters.task.type, 'Pavlovian')
    results.trial_results.monkey_bid = results.single_trial.starting_bid + results.movement.total_movement;
else
    results.trial_results.monkey_bid = NaN;
end

if strcmp(parameters.task.type, 'BDM')
    %if the monkey wins the auction
    if(results.single_trial.starting_bid < results.trial_results.monkey_bid)
        results.outputs.results = 'win';
        results.outputs.reward = results.single_trial.reward_value;
        if strcmp(results.single_trial.subtask, 'BDM')
            results.outputs.budget = (1 -  parameters.single_trial_values.computer_bid_value);
        elseif strcmp(results.single_trial.subtask, 'FP')
            results.outputs.budget = (1 -  results.trial_results.monkey_bid);
        end
    %if the computer wins the auction
    else
        results.outputs.results = 'lose';
        results.outputs.budget = 1;
        results.outputs.reward = 0;
    end    

elseif strcmp(parameters.task.type, 'BC')
    if strcmp(results.single_trial.subtask, 'binary_choice') || strcmp(results.single_trial.subtask, 'bundle_choice')
        if (strcmp(results.single_trial.primary_side, 'right') && results.trial_results.monkey_bid * 100 > modifiers.specific_tasks.binary_choice.bundle_width) ||...
                (strcmp(results.single_trial.primary_side, 'left') && results.trial_results.monkey_bid * 100 < 100 - modifiers.specific_tasks.binary_choice.bundle_width)
            results.outputs.results = 'fractal_chosen';
            results.outputs.reward = results.single_trial.reward_value;
            
            if strcmp(results.single_trial.subtask, 'binary_choice')
                results.outputs.budget = 0;
            elseif strcmp(results.single_trial.subtask, 'bundle_choice')
                results.outputs.budget = results.single_trial.second_budget_value;
            end
                
        else
            results.outputs.budget = 1;
            results.outputs.results = 'budget_chosen';
            results.outputs.reward = 0;
        end
    elseif strcmp(results.single_trial.subtask, 'binary_fractal_choice')
        results.outputs.results = 'fractal_chosen';
        results.outputs.budget = 0;
    elseif strcmp(results.single_trial.subtask, 'binary_budget_choice')
        results.outputs.results = 'budget_chosen';
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
                results.outputs.results = 'Paid Pavlovian';
            else
                results.outputs.reward = 0;
                results.outputs.results = 'Unpaid Pavlovian';
            end
        else
            results.outputs.reward = results.single_trial.reward_value;
            results.outputs.results = 'Paid Pavlovian';
        end
    else
        %if not probabilistic, just payout value
        results.outputs.reward = results.single_trial.reward_value;
    end
    results.outputs.budget = 0;
end

