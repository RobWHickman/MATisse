function results = time_trial(results, trial_point)

%set the systime for the start of the trial
if strcmp(trial_point, 'start')
    %also get the date to keep track of blocks when analysing in group
    results.trial_results.date = datestr(now,'yyyy-dd-mm');
    results.trial_results.time = datestr(now,'HH:MM:SS.FFF');
elseif strcmp(trial_point, 'end')
    results.trial_results.finish = datestr(now,'HH:MM:SS.FFF');
end
