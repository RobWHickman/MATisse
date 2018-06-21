function [parameters, results] = set_initial_trial_values(parameters, stimuli, modifiers, results)

%get the offer values for the trial
%follow a predetermined order from create_stimuli_order()
%pavlovian task should always be fully random
if ~parameters.trials.random_stimuli || ~strcmp(parameters.task.type, 'PAV')
    %choose the offer from the number of correct trials so far +1 (i.e. the
    %next trial to get correct)
    results.single_trial.reward_value = parameters.trials.combinations(1,results.trials.correct+1);
    results.single_trial.reward_liquid = modifiers.fractals.magnitude_vector(results.single_trial.reward_value);
    %for BDM just select a a computer bid, and a starting point for the bid
    %will also maybe add in distributions at some point (is in GUI)
    if strcmp(parameters.task.type, 'BDM')
        %both the monkeys and the computers (starting) bids will be at a
        %divisor of the water budget bar
        results.single_trial.starting_bid_value = parameters.trials.combinations(2,parameters.trials.combinations(results.trials.correct+1)) / modifiers.budget.divisions;
        results.single_trial.computer_bid = 1 / randi(modifiers.budget.divisions);
    elseif strcmp(parameters.task.type, 'BC')
        %always start bid at 0 for BC
        results.single_trial.starting_bid_value = 0;
        results.single_trial.bundle_value = parameters.trials.combinations(2,parameters.trials.combinations(results.trials.correct+1)) / modifiers.budget.divisions;
        results.single_trial.bundle_water = modifiers.budget.magnitude * results.single_trial.bundle_value;
        results.single_trial.bundle_half = parameters.trials.combinations(3,parameters.trials.combinations(results.trials.correct+1));
    elseif strcmp(parameters.task.type, 'PAV')
        results.single_trial.starting_bid_value = NaN;
    end
else
    %randomly choose a reward value
    results.single_trial.reward_value = randi(modifiers.fractals.number);
    results.single_trial.reward_liquid = modifiers.fractals.magnitude_vector(results.single_trial.reward_value);
    if strcmp(parameters.task.type, 'BDM')
        results.single_trial.starting_bid_value = rand();
        results.single_trial.computer_bid = rand();
    elseif strcmp(parameters.task.type, 'BC')
        results.single_trial.bundle_value = randi(modifiers.budget.divisions) / modifiers.budget.divisions;
        results.single_trial.bundle_water = modifiers.budget.magnitude * results.single_trial.bundle_value;
        %randomly chose either 1 or -1
        results.single_trial.bundle_half = Sample([-1, 1]);
    end
end

%for the binary choice also need to set the value of the budget water
if strcmp(parameters.task.type, 'BC')
    %if the budget appears
    if ~modifiers.budgets.no_budgets
        if modifiers.budget.random
            %if random just find a random divide
            results.single_trial.budget_value = randi(modifiers.budget.divisions) / modifiers.budget.divisions;
        elseif modifiers.budget.pegged
            %a positive peg difference will result in a greater budget
            %value (a more appealing budget)
            results.single_trial.budget_value = results.single_trial.bundle_value + budget.peg_difference;
            %make sure this value is not greater than 1 or less than zero
            if results.single_trial.budget_value > 1
                results.single_trial.budget_value = 1;
            elseif results.single_trial.budget_value < 0
                results.single_trial.budget_value = 0;
            end
        else
           %offer a whole budget
           results.single_trial.budget_value = 1; 
        end
    else
        %find the value and liquid amounts for the second offer when only
        %choosing between fractals
        results.single_trial.second_reward_value = results.single_trial.reward_value;
        while results.single_trial.second_reward_value == results.single_trial.reward_value
            results.single_trial.second_reward_value = randi(modifiers.fractals.number);
        end
        results.single_trial.second_reward_liquid = modifiers.fractals.magnitude_vector(results.single_trial.second_reward_value);
    end
    %work out how much water this amounts to
    results.single_trial.budget_liquid = modifiers.budget.magnitude * results.single_trial.budget_value;
end
    
%work out the time per epoch for the trial
%randomly generate a -1 or 1 and then randomly times the Variance and
%rand() by this
parameters.timings.TrialTime = round(parameters.timings.Frames +...
    times(parameters.timings.Variance', times(rand(height(parameters.timings),1)', randsample([-1 1], height(parameters.timings), 1)))');

%generate the random value for the target box
%shifts the box down from the top of the bidspace by x amount
if parameters.task_checks.Requirement('targeted_offer') == 1
    stimuli.target_box.trial_shift = rand() * ((stimuli.target_box.position(4) - stimuli.target_box.length) - stimuli.bidspace.position(2));
end

%the vectors to be grown for the fixation and bidding inputs
%fix the bidding vector but allow it to merge if the fixation fails
%probably not a huge problem in actual modig because will always be
%gathering data
results.movement.bidding_vector = [];
results.movement.fixation_vector = [];

%also initialise the trial results
results.movement.stationary_frame_count = 0;
results.movement.adjust = results.single_trial.starting_bid_value;
%assume bid is NA until bidding phase
results.single_trial.monkey_bid = NaN;

