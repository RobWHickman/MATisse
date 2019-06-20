function results_addvals = generate_results_addvals(trial, addval_variables, results)
% get addvals from the results to previous trials
if trial < 2
    disp('padding with zero on first trial');
    results_addvals = repmat(0, 1, length(addval_variables));
else
    last_trial = results.full_output_table(height(results.full_output_table),:);
    
    % pull out the relevant variables from the table
    addval_table = last_trial(:,ismember(last_trial.Properties.VariableNames, addval_variables));

    % convert to a vector of values
    results_addvals = table2array(addval_table);
end

