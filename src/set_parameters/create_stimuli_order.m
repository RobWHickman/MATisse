function [combinations, parameters] = create_stimuli_order(modifiers, parameters)

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
    
    rownames = {'fractal', 'budget', 'side'};

else
    n_fractals = length(handles.stimuli.fractals.images);
    if ~strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM_FP')
        auctions = 2;
    else
        auctions = 1;
    end
    
    comb_length = n_fractals * auctions;
    combinations = [repmat(1:n_fractals, 1, comb_length/n_fractals); repelem(1:auctions, 1, comb_length/auctions)];
    
    rownames = {'fractal', 'auction'};
    end
end

parameters.trials.max_trials = ceil(parameters.trials.max_trials/comb_length) * comb_length
subblocks = parameters.trials.max_trials / comb_length;
for subblock = 1:subblocks
    if subblock == 1
        comb_vector = combinations(:, randperm(length(combinations)))
    else
        comb_vector = [comb_vector, combinations(:, randperm(length(combinations)))];
    end
end

comb_table = array2table(comb_vector,'RowNames',rownames);
%get rid of rows that are all equal to 1
comb_table = comb_table(find(~all(comb_vector == 1, 2)),:);


n_fractals = length(handles.stimuli.fractals.images);
n_budget_divisions = modifiers.budget.divisions;
n_sides = 2;

if strcmp(parameters.task.type, 'BC')
    if strcmp(results.single_trial.subtask, '
    
    
    subblock_length = 


%randomise order of fractals
fractals_vec = 1:modifiers.fractals.number;
for subblock = 1:(parameters.trials.max_trials/(modifiers.budget.divisions * modifiers.fractals.number))
    if subblock == 1
        fractals_vector = fractals_vec(randperm(modifiers.fractals.number));
    else
        fractals_vector = [fractals_vector, fractals_vec(randperm(modifiers.fractals.number))];
    end
end

fractals_vector = reshape(repmat(fractals_vector,modifiers.budget.divisions,1),1,[]);

%randomise divisions for each fractal
divs_vec = 1:modifiers.budget.divisions;
for subblock = 1:(parameters.trials.max_trials/modifiers.budget.divisions)
    if subblock == 1
        divisions_vector = divs_vec(randperm(modifiers.budget.divisions));
    else
        divisions_vector = [divisions_vector, divs_vec(randperm(modifiers.budget.divisions))];
    end
end

%combine
combinations = [fractals_vector; divisions_vector; repmat(0, 1, parameters.trials.max_trials)];

%add in a random side in the 3rd line
if strcmp(parameters.task.type, 'BC')
    %randomly choose sides for each combinations
    for division = 1:modifiers.budget.divisions
        for fractal = 1:modifiers.fractals.number
            index = find(combinations(2,:) == division & combinations(1,:) == fractal);
            if sides == 2
                side_vec = repmat([0 1], 1, length(index)/sides);
                side_vec = side_vec(randperm(length(index)));
                combinations(3,index) = side_vec;
            elseif sides < 1 || sides > 2
                warning('!more than two or less than one sides specified!');
            end
        end
    end
end

