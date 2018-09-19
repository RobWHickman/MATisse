function movement = initialise_movement(parameters)

total_frames = sum(parameters.timings.TrialTime);

bidding_vector = zeros(1, total_frames);
behave_vector = NaN(1, total_frames);

epochs = repelem(parameters.timings, 1, parameters.timings);
trial = 