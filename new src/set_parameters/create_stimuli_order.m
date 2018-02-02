function combinations = create_stimuli_order(modifiers, parameters, sides)

%randomise order of fractals
fractals_vec = 1:modifiers.fractals.number;
for subblock = 1:(parameters.trials.total_trials/(modifiers.budget.divisions * modifiers.fractals.number))
    if subblock == 1
        fractals_vector = fractals_vec(randperm(modifiers.fractals.number));
    else
        fractals_vector = [fractals_vector, fractals_vec(randperm(modifiers.fractals.number))];
    end
end

fractals_vector = reshape(repmat(fractals_vector,modifiers.budget.divisions,1),1,[]);

%randomise divisions for each fractal
divs_vec = 1:modifiers.budget.divisions;
for subblock = 1:(parameters.trials.total_trials/modifiers.budget.divisions)
    if subblock == 1
        divisions_vector = divs_vec(randperm(modifiers.budget.divisions));
    else
        divisions_vector = [divisions_vector, divs_vec(randperm(modifiers.budget.divisions))];
    end
end

%combine
combinations = [fractals_vector; divisions_vector; repmat(0, 1, parameters.trials.total_trials)];

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

