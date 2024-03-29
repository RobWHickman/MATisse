function comb_table = create_stimuli_order(modifiers, parameters, stimuli)

if strcmp(parameters.task.type, 'BC')
    if ~modifiers.fractals.no_fractals
        n_fractals = length(stimuli.fractals.images);
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
        repelem((1:n_budgets)/n_budgets, 1, comb_length/n_budgets);...
        repmat(repelem(1:sides, 1, comb_length/(n_fractals*sides)), 1, comb_length/(n_budgets*sides))];
    
    rownames = {'reward_value', 'second_budget_value', 'primary_side'};

elseif strcmp(parameters.task.type, 'BDM')
    n_fractals = length(stimuli.fractals.images);
    if strcmp(modifiers.specific_tasks.BDM.contingency, 'BDM_FP')
        auctions = 2;
    else
        auctions = 1;
    end
    
    comb_length = n_fractals * auctions;
    
    %the targeting parameters
    if parameters.task_checks.table.Requirement('targeted_offer')
        if stimuli.target_box.static
            target_size = stimuli.target_box.startsize;
        else
        end
        
    else
        target_size = 1;
        target_start = 1;
    end

    combinations = [repmat(1:n_fractals, 1, comb_length/n_fractals); repelem(1:auctions, 1, comb_length/auctions)];
    
    rownames = {'reward_value', 'subtask'};
elseif strcmp(parameters.task.type, 'PAV')
    n_fractals = length(stimuli.fractals.images);
    
    comb_length = n_fractals;
    combinations = 1:n_fractals;
    rownames = {'reward_value'};
end

parameters.trials.max_trials = ceil(parameters.trials.max_trials/comb_length) * comb_length;
subblocks = parameters.trials.max_trials / comb_length;
for subblock = 1:subblocks
    if subblock == 1
        x = randperm(size(combinations, 2));
        comb_vector = combinations(:, randperm(size(combinations, 2)));
    else
        comb_vector = [comb_vector, combinations(:, randperm(size(combinations, 2)))];
    end
end

if strcmp(parameters.task.type, 'BDM')
    if strcmp(modifiers.specific_tasks.bdm.bid_start, 'random')
        %uniformly random starting positons
        starts = rand(1, length(comb_vector));
    elseif strcmp(modifiers.specific_tasks.bdm.bid_start, 'top_bottom')
        starts = repelem(0:1, floor(length(comb_vector)/2));
        %shuffle vector
        starts = starts(randperm(length(starts)));
        
        %if comb_length is odd add one extra start
        %if mod(comb_length, 2)
        %    starts = [starts, round(rand)];
        %end
    else
        starts = 1;
    end
    
    %the computer bids- consider changing if using distributions
    computer = rand(1, length(comb_vector));
    
    comb_vector = [comb_vector; starts; computer];
    rownames = {'reward_value', 'subtask', 'starting_bid', 'computer_bid'};
    
    
    if modifiers.fractals.reduce_high
        high_val_trials = find(comb_vector(1,:) == max(n_fractals));
        remove_trials = datasample(high_val_trials, length(high_val_trials)/modifiers.fractals.high_reduction);
        comb_vector(:,remove_trials) = [];
    end
    
    disp(comb_vector);
    disp('n max trials');
    disp(length(find(comb_vector(1,:) == max(n_fractals))));
end

comb_table = array2table(comb_vector,'RowNames',rownames);
%get rid of rows that are all equal to 1
comb_table = comb_table(find(~all(comb_vector == 1, 2)),:);
