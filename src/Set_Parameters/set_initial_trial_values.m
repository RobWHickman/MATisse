function results = set_initial_trial_values(parameters, stimuli, modifiers, results)

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
        chosen_fractal = randi(height(stimuli.fractals.fractal_properties));
        disp(chosen_fractal);
        results.single_trial.reward_value = modifiers.fractals.vector(chosen_fractal);
        disp(results.single_trial.reward_value);
        results.single_trial.second_reward_value = NaN;
        if ~modifiers.fractals.set_prob
            results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
        else
            results.single_trial.reward_chance = modifiers.fractals.probability;
        end

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
        
        if parameters.task_checks.table.Requirement('targeted_offer')
            if stimuli.target_box.static
                results.single_trial.target_box_size = stimuli.target_box.startsize;
                
                shifts = 0:0.1:1;
                shifts = shifts(shifts > results.single_trial.target_box_size);
                results.single_trial.target_box_shift = 1 - shifts(randi(length(shifts)));
            else
                if parameters.trials.total_trials < 1
                    correct = 0;
                else
                    correct = results.experiment_summary.correct;
                end
                minimum_size = stimuli.bidspace.dimensions.height * 0.05;
                maximum_size = stimuli.bidspace.dimensions.height * stimuli.target_box.startsize;
                results.single_trial.target_box_size = ((maximum_size - minimum_size) - ((maximum_size - minimum_size) * (1/ (1 + exp(1) ^ (-(correct-50)/20))))) + minimum_size;
                results.single_trial.target_box_size = results.single_trial.target_box_size / stimuli.bidspace.dimensions.height;
                
                results.single_trial.target_box_shift = (rand() * results.single_trial.target_box_size);
            end
            
        else
            results.single_trial.target_box_shift = NaN;
            results.single_trial.target_box_size = NaN;
        end

        results.single_trial.primary_side = 'left';
        
    elseif strcmp(parameters.task.type, 'BC')
        %rewards
        if ~modifiers.fractals.no_fractals
            %rewards
            results.single_trial.reward_value = randsample(modifiers.fractals.vector, 1);

            if ~modifiers.fractals.set_prob
                results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
            else
                results.single_trial.reward_chance = modifiers.fractals.probability
            end
            %could probably be done neater elsewhere- make sure second
            %reward is init as NaN
            results.single_trial.second_reward_value = NaN;
            results.single_trial.second_reward_chance = NaN;

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
            if ~modifiers.fractals.set_prob
                results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
            else
                results.single_trial.reward_chance = modifiers.fractals.probability
            end
        end
        
        %bids
        results.single_trial.starting_bid = 0.5;
        results.single_trial.computer_bid = NaN;
        results.single_trial.target_box_shift = NaN;
        results.single_trial.target_box_size = NaN;
        if(round(rand))
            results.single_trial.primary_side = 'left';
        else
            results.single_trial.primary_side = 'right';
        end
        
    elseif strcmp(parameters.task.type, 'PAV')
        %only care about rewards for pavlovian
        results.single_trial.reward_value = randi(height(stimuli.fractals.fractal_properties));
        results.single_trial.second_reward_value = NaN;
        if ~modifiers.fractals.set_prob
            results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
        else
            results.single_trial.reward_chance = modifiers.fractals.probability;
        end
        results.single_trial.second_reward_chance = NaN;
        
        results.single_trial.budget_magnitude = NaN;
        results.single_trial.budget_value = NaN;
        results.single_trial.second_budget_value = NaN;
        results.single_trial.starting_bid = NaN;
        results.single_trial.computer_bid = NaN;
        results.single_trial.target_box_shift = NaN;
        results.single_trial.target_box_size = NaN;
        if modifiers.fractals.no_fractals
            results.single_trial.subtask = 'Blind_Pav';
            %for blind pavlovian with zero chance = blank task- set value
            %to 0
            results.single_trial.reward_value = 0;
        else
            results.single_trial.subtask = 'Pav';
        end
        results.single_trial.primary_side = 'left';
    end
    results.single_trial.ordered = 'random';
    
else
    
    %get the trial number (the column of the table to select parameters
    %from)
    if ~isfield(results.block_results, 'completed')
        trial_number = 1;
    else
        trial_number = results.block_results.correct + 1;
    end
   
    combinations_column = parameters.trials.combinations(:, trial_number);
    struct_table = array2table(transpose(table2array(combinations_column)));
    struct_table.Properties.VariableNames = combinations_column.Properties.RowNames;
    
    all_fields = {'subtask', 'reward_value', 'second_reward_value', 'reward_chance', 'second_reward_chance', 'budget_magnitude', 'budget_value', 'second_budget_value', 'starting_bid', 'computer_bid', 'primary_side', 'target_box_size', 'target_box_shift'};
    missing = ~ismember(all_fields, struct_table.Properties.VariableNames);
    missing_table = array2table(1:length(find(missing)));
    missing_table.Properties.VariableNames = all_fields(find(missing));
    missing_table{1,:} = NaN;
    
    struct_table = horzcat(struct_table, missing_table);
    
    results.single_trial = table2struct(struct_table);
    results.single_trial.ordered = 'ordered';
    
    results.single_trial.budget_magnitude = modifiers.budget.magnitude;
    if ~modifiers.fractals.set_prob
        results.single_trial.reward_chance = stimuli.fractals.fractal_properties.probability(results.single_trial.reward_value);
    else
        results.single_trial.reward_chance = modifiers.fractals.probability;
    end

    
    if strcmp(parameters.task.type, 'BDM')
        if strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM')
            results.single_trial.subtask = 'BDM';
        elseif strcmp(modifiers.specific_tasks.BDM.contingency, 'FP')
            results.single_trial.subtask = 'FP';
        elseif strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM_FP')
            auctions = {'BDM', 'FP'};
            results.single_trial.subtask = auctions(results.single_trial.subtask);
        end
        
        %need to set up target box for BDM task
        if parameters.task_checks.table.Requirement('targeted_offer')
            if stimuli.target_box.static
                results.single_trial.target_box_size = stimuli.target_box.startsize;
                
                shifts = 0:0.1:1;
                shifts = shifts(shifts > results.single_trial.target_box_size);
                results.single_trial.target_box_shift = 1 - shifts(randi(length(shifts)));
            else
                if parameters.trials.total_trials < 1
                    correct = 0;
                else
                    correct = results.experiment_summary.correct;
                end
                minimum_size = stimuli.bidspace.dimensions.height * 0.05;
                maximum_size = stimuli.bidspace.dimensions.height * stimuli.target_box.startsize;
                results.single_trial.target_box_size = ((maximum_size - minimum_size) - ((maximum_size - minimum_size) * (1/ (1 + exp(1) ^ (-(correct-50)/20))))) + minimum_size;
                results.single_trial.target_box_size = results.single_trial.target_box_size / stimuli.bidspace.dimensions.height;
                
                results.single_trial.target_box_shift = (rand() * results.single_trial.target_box_size);
            end
        end

    elseif strcmp(parameters.task.type, 'BC')
        results.single_trial.starting_bid = 0.5;
        sides = {'left', 'right'};
        results.single_trial.primary_side = sides(results.single_trial.primary_side);
        
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
    elseif strcmp(parameters.task.type, 'PAV')
        if modifiers.fractals.no_fractals
            results.single_trial.subtask = 'Blind_Pav';
        else
            results.single_trial.subtask = 'Pav';
        end
    end
end

%set themangitude (ml of juice) of the reward
if ~isnan(results.single_trial.reward_value) && results.single_trial.reward_value > 0
    results.single_trial.reward_magnitude = stimuli.fractals.fractal_properties.magnitude(results.single_trial.reward_value);
else
    results.single_trial.reward_magnitude = NaN;
end
if ~isnan(results.single_trial.second_reward_value)
    results.single_trial.second_reward_magnitude = stimuli.fractals.fractal_properties.magnitude(results.single_trial.second_reward_value);
else
    results.single_trial.second_reward_magnitude = NaN;
end


%set the task failure to false at the start of the task
results.single_trial.task_failure = false;
            
