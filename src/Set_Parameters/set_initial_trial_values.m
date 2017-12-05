function [parameters, results] = set_initial_trial_values(parameters, stimuli, hardware, results)
%get the offer value for the trial
single_trial_values.offer_value = randi(stimuli.fractals.fractal_info.number);

if strcmp(parameters.task, 'BDM')
    %generate a random bid to start at
    single_trial_values.starting_bid_value = rand(1);
    %generate a computer bid 
    %change these for Marius- specifies the beta distribution controlling the
    %computers random bids
    A = 1;
    B = 1;
    single_trial_values.computer_bid_value = betarnd(A,B);
%for binary choice, instead generate the value of the fractal water budget
elseif strcmp(parameters.task, 'BC')
    single_trial_values.bundle_water = randi(10)/10;
    %define which half contains the bundle
    screen_halves = ["left", "right"];
    single_trial_values.bundle_half = screen_halves(2); 
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
    single_trial_values.target_value_shift = rand() * ((stimuli.bidspace.bidspace_info.position(4) - stimuli.target_box.length) - stimuli.bidspace.bidspace_info.position(2));
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

