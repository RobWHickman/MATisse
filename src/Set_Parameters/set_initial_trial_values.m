function [parameters, results] = set_initial_trial_values(parameters, stimuli, modifiers, results)
%get the offer values for the trial
%follow a predetermined order from create_stimuli_order()
if parameters.trials.random_stimuli
    
    if strcmp(parameters.task.type, 'BC')
        if modifiers.specific_tasks.binary_choice.bundles
            results.single_trial.subtask = 'bundle_choice';
        else
            if modifiers.budgets.no_budgets
                results.single_trial.subtask = 'binary_fractal_choice';
            elseif modifiers.fractals.no_fractals
                results.single_trial.subtask = 'binary_budget_choice';
            else
                results.single_trial.subtask = 'binary_choice';
            end
        end
    elseif strcmp(parameters.task.type, 'BDM')
        if strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM')
            results.single_trial.subtask = 'BDM';
        elseif strcmp(modifiers.specific_tasks.BDM.contingency, 'FP')
            results.single_trial.subtask = 'FP';
        elseif strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM_FP')
            if round(rand)
                results.single_trial.subtask = 'BDM';
            else
                results.single_trial.subtask = 'FP';
            end
        end
    else
        results.single_trial.subtask = NaN;
    end
    
    if strcmp(parameters.task.type, 'BDM')
        %rewards
        results.single_trial.reward_value = randi(height(stimuli.fractals.fractal_properties));
        results.single_trial.second_reward_value = NaN;
        results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
        results.single_trial.second_reward_chance = NaN;
        
        %budgets
        results.single_trial.budget_magnitude = modifiers.budget.magnitude;
        results.single_trial.budget_value = 1;
        results.single_trial.second_budget_value = NaN;
        
        %bids
        if strcmp(modifiers.specific_tasks.bdm.bid_start, 'random')
            results.single_trial.starting_bid = rand();
        elseif strcmp(modifiers.specific_tasks.bdm.bid_start, 'top_bottom')
            results.single_trial.starting_bid = randi([0,1]);
        elseif strcmp(modifiers.specific_tasks.bdm.bid_start, 'bottom')
            results.single_trial.starting_bid = 0;
        elseif strcmp(modifiers.specific_tasks.bdm.bid_start, 'top')
            results.single_trial.starting_bid = 1;
        end
        results.single_trial.computer_bid = rand();
        
        %task
        
        results.single_trial.primary_side = 'left';
        
    elseif strcmp(parameters.task.type, 'BC')
        %rewards
        if ~modifiers.fractals.no_fractals
            results.single_trial.reward_value = randi(height(stimuli.fractals.fractal_properties));
            results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
        %if no fractals then no reward values
        else
            results.single_trial.reward_value = NaN;
            results.single_trial.second_reward_value = NaN;
            results.single_trial.reward_chance = NaN;
            results.single_trial.second_reward_chance = NaN;
            
        end
        
        %budgets
        if ~modifiers.budgets.no_budgets
            results.single_trial.budget_magnitude = modifiers.budget.magnitude;
            if modifiers.specific_tasks.binary_choice.bundles
                results.single_trial.second_budget_value = randi(modifiers.budget.divisions) / modifiers.budget.divisions;
                if modifiers.budget.random
                    results.single_trial.budget_value = rand();
                elseif modifiers.budget.pegged
                    %a positive peg difference will result in a greater budget
                    %value (a more appealing budget)
                    results.single_trial.budget_value = results.single_trial.second_budget_value + modifiers.budget.peg_difference;
                    %make sure this value is not greater than 1 or less than zero
                    if results.single_trial.budget_value > 1
                        results.single_trial.budget_value = 1;
                    elseif results.single_trial.budget_value < 0
                        results.single_trial.budget_value = 0;
                    end
                else
                    results.single_trial.budget_value = 1;
                end
            %if canonical style binary choice tasks    
            else
                results.single_trial.budget_value = randi(modifiers.budget.divisions) / modifiers.budget.divisions;
                %if a binary choice between budgets
                if ~modifiers.fractals.no_fractals
                    results.single_trial.second_budget_value = NaN;
                else
                    results.single_trial.second_budget_value = randi(modifiers.budget.divisions) / modifiers.budget.divisions;
                    while(results.single_trial.second_budget_value == results.single_trial.budget_value)
                        results.single_trial.second_budget_value = randi(modifiers.budget.divisions) / modifiers.budget.divisions;
                    end
                end
            end
        %if no budgets in choice
        else
            results.single_trial.budget_magnitude = NaN;
            results.single_trial.budget_value = NaN;
            results.single_trial.second_budget_value= NaN;
            
            %second reward cannot equal first reward
            results.single_trial.second_reward_value = randi(height(stimuli.fractals.fractal_properties));
            while(results.single_trial.reward_value == results.single_trial.second_reward_value)
                results.single_trial.second_reward_value = randi(height(stimuli.fractals.fractal_properties));
            end
            results.single_trial.second_reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
        end
        
        %bids
        results.single_trial.starting_bid = 0.5;
        results.single_trial.computer_bid = NaN;
        if(round(rand))
            results.single_trial.primary_side = 'left';
        else
            results.single_trial.primary_side = 'right';
        end
        
    elseif strcmp(parameters.task.type, 'PAV')
        %only care about rewards for pavlovian
        results.single_trial.reward_value = randi(height(stimuli.fractals.fractal_properties));
        results.single_trial.second_reward_value = NaN;
        results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
        results.single_trial.second_reward_chance = NaN;
        
        results.single_trial.budget_magnitude = NaN;
        results.single_trial.budget_value = NaN;
        results.single_trial.second_budget_value = NaN;
        results.single_trial.starting_bid = NaN;
        results.single_trial.computer_bid = NaN;
        results.single_trial.subtask = 'Pavlovian';
        results.single_trial.primary_side = 'left';
    end
    results.single_trial.ordered = 'random';
    
else
    results.single_trial.reward_value = 1;
    results.single_trial.second_reward_value = 1;
    results.single_trial.reward_chance = 1;
    results.single_trial.budget_magnitude = 1;
    results.single_trial.budget_value = 1;
    results.single_trial.second_budget_value = 1;
    results.single_trial.starting_bid = 1;
    results.single_trial.computer_bid = 1;
    results.single_trial.ordered = 'ordered';
end

%set the task failure to false at the start of the task
results.single_trial.task_failure = false;
            
