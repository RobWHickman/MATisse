function behave_table = initialise_behaviour(parameters)

total_frames = sum(parameters.timings.TrialTime);

movement_vector = zeros(1, total_frames);
behave_vector = NaN(1, total_frames);

epochs = repelem(parameters.timings.Properties.RowNames', 1, parameters.timings.TrialTime');
trial = repmat(parameters.trials.total_trials, length(epochs), 1);

frames = [];
for epoch = 1:length(parameters.timings.Properties.RowNames)
    frames = [frames, 1:parameters.timings.TrialTime(epoch)];
end

behave_table = table(trial,epochs',frames',behave_vector',behave_vector',behave_vector',behave_vector',behave_vector',movement_vector',...
    'VariableNames',{'trial','epoch','frame','joy_x','joy_y','touch','eye','lick','movement'});

%remove the frames for ITI epochs
noniti_frames = logical(~strcmp(behave_table.epoch, 'ITI'));
behave_table = behave_table(noniti_frames,:);