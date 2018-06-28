function results = set_trial_metadata(parameters, stimuli, hardware, modifiers, results)

%save the metadata for the trial
metadata.parameters = parameters;
metadata.stimuli = stimuli;
metadata.hardware = hardware;
metadata.modifiers = modifiers;
results.experiment_metadata.last_trial = metadata;

%save trial with trial number
last_trial = strcat('trial_', num2str(results.block_results.completed));
[results.experiment_metadata.(last_trial)] = results.experiment_metadata.last_trial;

%delete the last trial field
results.experiment_metadata = rmfield(results.experiment_metadata, 'last_trial');
