function epoch_times = generate_truncated_times(parameters)

%get the epoch times that are allowed to vary
max_jitter = parameters.timings.Variance;
variable_times = find(max_jitter);

%get the variability and average frames for these epochs
av_frames = parameters.timings.Frames(variable_times);
max_jitter = max_jitter(variable_times);

if ~isempty(max_jitter)
    %randomly increase or decrease epoch times
    for multiplier = 1:length(max_jitter)
        more_less(multiplier,:) = (round(rand(1, 1)) * 2) - 1;
    end

    %generate lambda 
    %half values will be further from the mean epoch time than log(max_jitter)
    lambda = -log(0.5)./(max_jitter/2);
    %generte random jitter
    random_jitter = rand(length(max_jitter), 1);

    extra_frames = (log(1 - random_jitter) ./ -lambda);

    for epoch = 1:length(max_jitter)
        if extra_frames(epoch) > max_jitter(epoch)
            extra_frames(epoch) = max_jitter(epoch);
        end
    end

    epoch_frames = av_frames + (extra_frames .* more_less);
end

for epoch = 1:height(parameters.timings)
    if any(epoch == variable_times)
        epoch_times(epoch) = epoch_frames(find(epoch == variable_times));
    else
        epoch_times(epoch) = parameters.timings.Frames(epoch);
    end
end


