function results = time_trial(results, trial_point)

%set the systime for the start of the trial
if strcmp(trial_point, 'start')
    results.trial_results.date = datestr(now,'YYYY-MM-DD');
    results.trial_results.time = datestr(now,'HH:MM:SS.FFF');
elseif strcmp(trial_point, 'end')
    results.trial_results.finish = datestr(now,'HH:MM:SS.FFF');
end
