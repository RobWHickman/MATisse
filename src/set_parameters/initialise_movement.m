function movement = initialise_movement(parameters)

movement.bidding_vector = zeros(1, parameters.timings.TrialTime('bidding'));
movement.total_movement = 0;
movement.stationary_count = 0;
movement.stabilised = 0;
movement.limited_bidding = 0;
