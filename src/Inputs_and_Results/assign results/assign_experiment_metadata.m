function results = assign_experiment_metadata(parameters, stimuli, hardware, results)
%double check to make sure only runs on first trial
if parameters.total_trials < 1
    %get the set up for the experiment
    %only runs on first trial
    %basically saves everything - maybe cut down at some point/ clean up
    results.experiment_metadata.parameters = parameters;
    results.experiment_metadata.hardware = hardware;
    results.experiment_metadata.stimuli = stimuli;
    
end