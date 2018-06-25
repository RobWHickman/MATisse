function combinations = create_stimuli_order(task, fractals, divisions, sides, starts, total_trials)

if sides > 2
    display('warning: more than two sides requested');
end


if strcmp(task, 'BC')
    %randomise order of fractals
    fractals = 3; %might need to delete this for marius
    fractals_vec = 1:fractals;
    %overwrite for adding ends to 3 middle fractals
    for subblock = 1:round(total_trials/(divisions * fractals))
        if subblock == 1
            fractals_vector = fractals_vec(randperm(fractals));
        else
            fractals_vector = [fractals_vector, fractals_vec(randperm(fractals))];
        end
    end

    fractals_vector = reshape(repmat(fractals_vector,divisions,1),1,[]);
elseif strcmp(task, 'BDM')
    fractals_vec = [];
    for block = 1:10
    %for block = 1:6
        %block_vec = [repmat(2:4, 1, 10), repmat([1,5], 1, 2)]; %ulysses
        %block_vec = repmat(1:3, 1, 10); %vicer
        block_vec = repmat(1:5, 1, 10); %uly2
        fractals_vec = repmat(1:fractals, 1, total_trials/fractals);
        block_vec = block_vec(randperm(length(block_vec)));
        fractals_vec = [fractals_vec, block_vec];
    end
end

if strcmp(task, 'BC')
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
            side_vec = repmat([0 1], 1, length(index)/sides);
            side_vec = side_vec(randperm(length(index)));
            combinations(3,index) = side_vec;
        end
    end
    %Ulysses mid block stuff
    combinations(1,:) = combinations(1,:) + 1;
    
    vec = [1,5];
    extras = repmat(vec(randperm(2)), 5,1);
    extras = [extras(:,1)',extras(:,2)'];
    extra_sides = round(rand(1,10));
    divs = 1:10;
    extra_divs = divs(randperm(length(divs)));
    
    extra_combinations = [extras; extra_divs; extra_sides];
    
    subblock1 = combinations(:,1:60);
    subblock2 = combinations(:,61:120);
    subblock3 = combinations(:,121:180);
    subblock4 = combinations(:,181:240);
    
    combinations = [extra_combinations, subblock1, extra_combinations, subblock2, extra_combinations, subblock3, extra_combinations, subblock4];

elseif strcmp(task, 'BDM')
    if strcmp(starts, 'beta')
        dist1 = betarnd(1, 1, [1, total_trials / fractals]);
        dist2 = betarnd(10, 10, [1, total_trials / fractals]);
        dist3 = betarnd(10, 10, [1, total_trials / fractals]);
        comp_bid = [dist1, dist2, dist3];
        
        %sort by the order of fractals
        [~,fractal_order] = sort(fractals_vec);
        [~,sorting_order] = sort(fractal_order);
        comp_bid = comp_bid(sorting_order);
    else
        comp_bid = rand(1,length(fractals_vec));
        starts = rand(1,length(fractals_vec));
        %starts = repmat([0,1], 1, length(fractals_vec)/2); %random
        %starts = repmat([repmat(0, 1, 34), repmat(1, 1, 34)], 1, 5); %uly
        %starts = repmat([repmat(0, 1, 30), repmat(1, 1, 30)], 1, 5);
        %%vicer
    end
    combinations = [fractals_vec; comp_bid; starts];
end
