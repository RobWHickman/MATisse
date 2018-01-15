%function to generate a table and a row at the end of each trial
%the table (full_output_table) has two parts: one shows the set up of the
%trial and the other shows the result (win/lose and the payouts)
%the row is the same but for just the last trial gone
%this can be removed if deemed uncessary and cluttering
function results = assign_outputs(results)

results.trial_values.fixation_vector = {[results.trial_values.fixation_vector]};

results.trial_values.bidding_vector = {[results.trial_values.bidding_vector]};

results.trial_values.task_checks = {[results.trial_values.task_checks]};

%order the struct
results.trial_results = orderfields(results.trial_results);

%edit the struct
%go back and clean this up in assignment at some point
results.trial_results = rmfield(results.trial_results, 'monkey_bid');
if strcmp(results.experiment_metadata.parameters.task, 'BC')
    results.trial_results = rmfield(results.trial_results, 'remaining_budget');
end

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
if ~strcmp(results.experiment_metadata.parameters.task, 'PAV')
    results.experiment_summary.means = grpstats(results.full_output_table.trial_results.monkey_final_bid, results.full_output_table.trial_results.offer_value);
    results.experiment_summary.correct = sum(~isnan(results.full_output_table.trial_results.win));
    results.experiment_summary.error = sum(isnan(results.full_output_table.trial_results.win));
    results.experiment_summary.percent_correct  = (results.experiment_summary.correct/ (results.experiment_summary.correct + results.experiment_summary.error)) * 100;
    if strcmp(results.experiment_metadata.parameters.task, 'BC')
        results.experiment_summary.rewarded = sum(results.full_output_table.trial_results.reward > 0);
        results.experiment_summary.not_rewarded = sum(results.full_output_table.trial_results.reward == 0);
    elseif strcmp(results.experiment_metadata.parameters.task, 'BDM')
        results.experiment_summary.rewarded = sum(results.full_output_table.trial_results.win == 1);
        results.experiment_summary.not_rewarded = sum(results.full_output_table.trial_results.win == 0);
    end
elseif strcmp(results.experiment_metadata.parameters.task, 'PAV')
    results.experiment_summary.rewarded = size(results.full_output_table.trial_results,1);
    results.experiment_summary.not_rewarded = NaN;
    results.experiment_summary.correct = size(results.full_output_table.trial_results,1);
    results.experiment_summary.error = NaN;
    results.experiment_summary.percent_correct = NaN;
    results.experiment_summary.means = [sum(results.full_output_table.trial_results.reward == 1), sum(results.full_output_table.trial_results.reward == 2), sum(results.full_output_table.trial_results.reward == 3)];
end

%for the binary choice task, how many times has the monkey gone left/right
if strcmp(results.experiment_metadata.parameters.task, 'BC') && ~isfield(results.experiment_summary, 'right')
   results.experiment_summary.right = 0;
   results.experiment_summary.left = 0;
elseif strcmp(results.experiment_metadata.parameters.task, 'BDM') && ~isfield(results.experiment_summary, 'right')
   results.experiment_summary.right = NaN;
   results.experiment_summary.left = NaN;
end

if ~strcmp(results.experiment_metadata.parameters.task, 'PAV')
if results.last_trial.trial_results.monkey_final_bid > (0.5 - results.experiment_metadata.parameters.binary_choice.bundle_width/100) *2 &&...
        strcmp(results.experiment_metadata.parameters.task, 'BC')
    results.experiment_summary.right = results.experiment_summary.right + 1;
elseif results.last_trial.trial_results.monkey_final_bid < (results.experiment_metadata.parameters.binary_choice.bundle_width/100 - 0.5) * 2 &&...
        strcmp(results.experiment_metadata.parameters.task, 'BC')
    results.experiment_summary.left = results.experiment_summary.left + 1;
end


%update the amounts of liquid given out if a winning trial
if ~isnan(results.last_trial.trial_results.win)
    results.experiment_summary.total_budget = results.experiment_summary.total_budget + results.last_trial.trial_results.budget_liquid;
    if results.last_trial.trial_results.win == 1
        results.experiment_summary.total_reward = results.experiment_summary.total_reward + results.last_trial.trial_results.reward_liquid;
    end
end
elseif strcmp(results.experiment_metadata.parameters.task, 'PAV')
    results.experiment_summary.total_reward = results.experiment_summary.total_reward + results.last_trial.trial_results.reward_liquid;
end
