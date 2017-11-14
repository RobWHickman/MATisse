function [parameters, trial_values] = set_initial_trial_values(parameters, stimuli, hardware)
%initialise trial values
trial_values = [];

%get the offer value for the trial
display(stimuli);
display(stimuli.fractals);
trial_values.offer_value = randi(length(stimuli.fractals.fractal_info.number));

%generate a random bid to start at
trial_values.starting_bid_value = rand(1);
%generate a computer bid 
%change these for Marius- specifies the beta distribution controlling the
%computers random bids
A = 1;
B = 1;
trial_values.computer_bid_value = betarnd(A,B);

%generate the random delays on epochs
%matlab is stupid and won't allow random number generation between non
%integers, this is equivalent
parameters.timings.Delay = times(parameters.timings.PlusMinus * 2, rand(height(parameters.timings), 1)) - parameters.timings.PlusMinus;
%convert this into frames
parameters.timings.Delay = round(parameters.timings.Delay * hardware.outputs.screen_info.hz);

%the vectors to be grown for the fixation and bidding inputs
%fix the bidding vector but allow it to merge if the fixation fails
%probably not a huge problem in actual modig because will always be
%gathering data
placeholder = NaN;
%rep this for the number of frames
trial_values.bidding_vector = placeholder(ceil((1:parameters.timings.Frames('epoch4'))/parameters.timings.Frames('epoch4')));
trial_values.fixation_vector = [];

%output the trial values with the updated timings table using parent
parameters.single_trial_values = trial_values;

%also initialise the trial results
trial_values.frame_count = 0;
trial_values.y_adjust = 0;

