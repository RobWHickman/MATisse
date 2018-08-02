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
        
       results = pay_notpay(results);    
       
        if strcmp(results.single_trial.subtask, 'BDM')
            results.outputs.budget = (1 -  results.single_trial.computer_bid);
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
            
            results = pay_notpay(results); 

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
    results.outputs.results = 'pavlovian';
    results = pay_notpay(results); 
    
    results.outputs.budget = 0;
end

