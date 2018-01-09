function combinations = create_stimuli_order(fractals, divisions, sides, total_trials)

if sides > 2
    display('warning: more than two sides requested');
end


%randomise order of fractals
fractals_vec = 1:fractals;
for subblock = 1:(total_trials/(divisions * fractals))
    if subblock == 1
        fractals_vector = fractals_vec(randperm(fractals));
    else
        fractals_vector = [fractals_vector, fractals_vec(randperm(fractals))];
    end
end

fractals_vector = reshape(repmat(fractals_vector,divisions,1),1,[]);

%randomise divisions for each fractal
divs_vec = 1:divisions;
for subblock = 1:(total_trials/divisions)
    if subblock == 1
        divisions_vector = divs_vec(randperm(divisions));
    else
        divisions_vector = [divisions_vector, divs_vec(randperm(divisions))];
    end
end

%combine
combinations = [fractals_vector; divisions_vector; repmat(0, 1, total_trials)];

%randomly choose sides for each combinations
for division = 1:divisions
    for fractal = 1:fractals
        index = find(combinations(2,:) == division & combinations(1,:) == fractal);
        side_vec = repmat([1 2], 1, length(index)/sides);
        side_vec = side_vec(randperm(length(index)));
        combinations(3,index) = side_vec;
    end
end
        