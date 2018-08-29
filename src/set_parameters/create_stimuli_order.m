function comb_table = create_stimuli_order(modifiers, parameters, stimuli)

if strcmp(parameters.task.type, 'BC')
    if ~modifiers.fractals.no_fractals
        n_fractals = length(handles.stimuli.fractals.images);
    else
        n_fractals = 1;
    end
    if ~modifiers.budgets.no_budgets
        n_budgets = modifiers.budget.divisions;
    else
        n_budgets = 1;
    end
    
    sides = 2;
    
    comb_length = n_fractals * n_budgets * sides;
    combinations = [repmat(1:n_fractals, 1, comb_length/n_fractals);...
        repelem(1:n_budgets, 1, comb_length/n_budgets);...
        repmat(repelem(1:sides, 1, comb_length/(n_fractals*sides)), 1, comb_length/(n_budgets*sides))];
    
    rownames = {'reward_value', 'budget_value', 'primary_side'};

else
    n_fractals = length(stimuli.fractals.images);
    if ~strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM_FP')
        auctions = 2;
    else
        auctions = 1;
    end
    
    comb_length = n_fractals * auctions;
    combinations = [repmat(1:n_fractals, 1, comb_length/n_fractals); repelem(1:auctions, 1, comb_length/auctions)];
    
    rownames = {'reward_value', 'subtask'};
end

parameters.trials.max_trials = ceil(parameters.trials.max_trials/comb_length) * comb_length;
subblocks = parameters.trials.max_trials / comb_length;
for subblock = 1:subblocks
    if subblock == 1
        comb_vector = combinations(:, randperm(length(combinations)));
    else
        comb_vector = [comb_vector, combinations(:, randperm(length(combinations)))];
    end
end

comb_table = array2table(comb_vector,'RowNames',rownames);
%get rid of rows that are all equal to 1
comb_table = comb_table(find(~all(comb_vector == 1, 2)),:);
