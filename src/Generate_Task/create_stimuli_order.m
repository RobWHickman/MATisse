function combinations = create_stimuli_order(fractals, divisions, sides, total_trials)

if sides > 2
    display('warning: more than two sides requested');
end


%fractals
fractals_vec = 1:fractals;
for subblock = 1:(total_trials/(divisions * fractals))
    if subblock == 1
        fractals_vector = fractals_vec(randperm(fractals));
    else
        fractals_vector = [fractals_vector, fractals_vec(randperm(fractals))];
    end
end

fractals_vector = reshape(repmat(fractals_vector,divisions,1),1,[]);

%divisions
divs_vec = 1:divisions;
for subblock = 1:(total_trials/divisions)
    if subblock == 1
        divisions_vector = divs_vec(randperm(divisions));
    else
        divisions_vector = [divisions_vector, divs_vec(randperm(divisions))];
    end
end

%sides
sides_vec = reshape(repmat(1:sides, total_trials/sides,1),1,[]);
sides_vec = sides_vec(randperm(total_trials));
%FIX THIS
sides_vec = sides_vec - 1;

%combine
combinations = [fractals_vector; divisions_vector; sides_vec];
