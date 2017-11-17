%function to generate a table and a row at the end of each trial
%the table (full_output_table) has two parts: one shows the set up of the
%trial and the other shows the result (win/lose and the payouts)
%the row is the same but for just the last trial gone
%this can be removed if deemed uncessary and cluttering
function results = assign_outputs(results)

results.trial_values.fixation_vector = {[results.trial_values.fixation_vector]};

results.trial_values.bidding_vector = {[results.trial_values.bidding_vector]};

results.trial_values.task_checks = {[results.trial_values.task_checks]};

%add the trial results (assign results) to the full experimental data
if ~isempty(results.full_output_table)
    results.full_output_table.trial_values = vertcat(results.full_output_table.trial_values, struct2table(results.trial_values));
    results.full_output_table.trial_results = vertcat(results.full_output_table.trial_results, struct2table(results.trial_results));
else
    results.full_output_table.trial_values = struct2table(results.trial_values);
    results.full_output_table.trial_results = struct2table(results.trial_results);
end

%put the trial_results and trial_values in the last_trial field and remove
%them
results.last_trial.trial_values = results.trial_values;
results.last_trial.trial_results = results.trial_results;
results = rmfield(results,{'trial_values','trial_results'});

%get the data about the experiment progression to update the gui
results.experiment_summary.means = grpstats(results.full_output_table.trial_results.monkey_final_bid, results.full_output_table.trial_results.offer_value);
results.experiment_summary.correct = sum(~isnan(results.full_output_table.trial_results.win));
results.experiment_summary.error = sum(isnan(results.full_output_table.trial_results.win));
results.experiment_summary.percent_correct  = (results.experiment_summary.correct/ (results.experiment_summary.correct + results.experiment_summary.error)) * 100;
results.experiment_summary.rewarded = sum(results.full_output_table.trial_results.win == 1);
results.experiment_summary.not_rewarded = sum(results.full_output_table.trial_results.win == 0);

%update the amounts of liquid given out if a winning trial
if ~isnan(results.last_trial.trial_results.win)
    results.experiment_summary.total_budget = results.experiment_summary.total_budget + results.last_trial.trial_results.budget_liquid;
    if results.last_trial.trial_results.win == 1
        results.experiment_summary.total_reward = results.experiment_summary.total_reward + results.last_trial.trial_results.reward_liquid;
    end
end
