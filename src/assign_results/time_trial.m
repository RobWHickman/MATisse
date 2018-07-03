function results = time_trial()

%set the systime for the start of the trial
systime = fix(clock);
results.trial_results.date = systime(1:3);
results.trial_results.time = systime(4:6);
