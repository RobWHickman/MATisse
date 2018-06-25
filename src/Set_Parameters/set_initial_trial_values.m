function [parameters, results] = set_initial_trial_values(parameters, stimuli, hardware, results)
%get the offer value for the trial
if parameters.random_stim == 1 || strcmp(parameters.task, 'PAV')
    if isfield(parameters, 'binary_choice')
        if ~parameters.binary_choice.no_fractals
            single_trial_values.offer_value = randi(stimuli.fractals.fractal_info.number);
        else
            single_trial_values.offer_value = 0;
        end

        if parameters.binary_choice.random_budget
            single_trial_values.budget_water = Sample(0:(1/parameters.binary_choice.divisions):1-(1/parameters.binary_choice.divisions));
        else
            single_trial_values.budget_water = 0;
        end
    end
    %MARIUS
     if strcmp(parameters.task, 'BDM')
         single_trial_values.offer_value = randi(stimuli.fractals.fractal_info.number);
     end
    %MARIUS%
    if strcmp(parameters.task, 'BDM')
        %generate a random bid to start at
        single_trial_values.starting_bid_value = rand(1); %START RANDOMLY
        %single_trial_values.starting_bid_value = randi(2,1,1)-1; %START AT
        %TOP/BOTTOM
        %single_trial_values.starting_bid_value = 0; %START AT BOTTOM
        %generate a computer bid 
        %change these for Marius- specifies the beta distribution controlling the
        %computers  uniformly random bids
        %A = 1;
        %B = 1;
        %generate peaked distributions with means at 0.1, 0.5 and 0.8 -
        %which correspond with BCb values for 0.25, 0.375, 0.5 mL
        if single_trial_values.offer_value == 1
            A = 1;
            B = 9;
        elseif single_trial_values.offer_value == 2
            A = 10;
            B = 10;
        elseif single_trial_values.offer_value == 3
            A = 10;
            B = 10;
        end
        single_trial_values.computer_bid_value  = betarnd(A,B);
    %for binary choice, instead generate the value of the fractal water budget
    elseif strcmp(parameters.task, 'BC')
        single_trial_values.bundle_water = Sample(0:(1/parameters.binary_choice.divisions):1-(1/parameters.binary_choice.divisions));
        %define which half contains the bundle
        screen_halves = [1, 0];
        single_trial_values.bundle_half = screen_halves(randi(2)); 
    end
    
    %for the pavlovian task generate the fractal on the fly
    if strcmp(parameters.task, 'PAV')
       single_trial_values.offer_value = randi(stimuli.fractals.fractal_info.number);
    end
    
else
     if strcmp(parameters.task, 'BC')
        single_trial_values.offer_value = stimuli.combinations(1,stimuli.combination_order(results.experiment_summary.correct+1));
    end
    
     if strcmp(parameters.task, 'BDM')
         single_trial_values.offer_value = stimuli.combinations(1,stimuli.combination_order(results.experiment_summary.correct+1));
        %generate a random bid to start at
        single_trial_values.starting_bid_value = rand(1); % RANDOM
        %single_trial_values.starting_bid_value = 0; BOTTOM
        %single_trial_values.starting_bid_value = randi(2,1,1)-1; %TOP &
        %BOTTOM
        %single_trial_values.starting_bid_value = stimuli.combinations(3,stimuli.combination_order(results.experiment_summary.correct+1));
        %generate a computer bid 
        %change these for Marius- specifies the beta distribution controlling the
        %computers random bids
        single_trial_values.computer_bid_value = stimuli.combinations(2,stimuli.combination_order(results.experiment_summary.correct+1));
    %for binary choice, instead generate the value of the fractal water budget
     end
    
    if strcmp(parameters.task, 'BC')
      single_trial_values.bundle_water = 1 - stimuli.combinations(2,stimuli.combination_order(results.experiment_summary.correct+1)) / parameters.binary_choice.divisions;
      single_trial_values.bundle_half = stimuli.combinations(3,stimuli.combination_order(results.experiment_summary.correct+1));
      if parameters.binary_choice.random_budget
          single_trial_values.budget_water = Sample(0:(1/parameters.binary_choice.divisions):1-(1/parameters.binary_choice.divisions));
      elseif parameters.binary_choice.pegged_budget
          single_trial_values.budget_water = single_trial_values.bundle_water + parameters.binary_choice.pegged_difference;
          if single_trial_values.budget_water > 1
              single_trial_values.budget_water = 1-(1/parameters.binary_choice.divisions);
          elseif single_trial_values.budget_water < 0
              single_trial_values.budget_water = 0;
          end
      else
          single_trial_values.budget_water = 0;
      end
    end
end
    
%generate the random delays on epochs
%matlab is stupid and won't allow random number generation between non
%integers, this is equivalent
parameters.timings.Delay = times(parameters.timings.PlusMinus * 2, rand(height(parameters.timings), 1)) - parameters.timings.PlusMinus;
%convert this into frames
parameters.timings.Delay = round(parameters.timings.Delay * hardware.outputs.screen_info.hz);

%generate the random value for the target box
%shifts the box down from the top of the bidspace by x amount
if parameters.targeting.requirement == 1
    %single_trial_values.target_value_shift = rand() * ((stimuli.bidspace.bidspace_info.position(4) - stimuli.target_box.length) - stimuli.bidspace.bidspace_info.position(2));
    single_trial_values.target_value_shift = (randi([0 20],1,1)/20) * ((stimuli.bidspace.bidspace_info.position(4) - stimuli.target_box.length) - stimuli.bidspace.bidspace_info.position(2));
end

%output the trial values with the updated timings table using parent
parameters.single_trial_values = single_trial_values;

%the vectors to be grown for the fixation and bidding inputs
%fix the bidding vector but allow it to merge if the fixation fails
%probably not a huge problem in actual modig because will always be
%gathering data
trial_values.bidding_vector = [];
trial_values.fixation_vector = [];

%also initialise the trial results
trial_values.stationary_frame_count = 0;
trial_results.adjust = 0;
%assume bid is NA until bidding phase
trial_results.monkey_bid = NaN;

%set the trial values for the task checks from the parameters master table
trial_values.task_checks = parameters.task_checks;

%set the trial_values and trial_results to results
results.trial_values = trial_values;
results.trial_results = trial_results;

