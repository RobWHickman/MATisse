function results_addvals = generate_results_addvals(trial, addval_variables, results_table)
% get addvals from the results to previous trials
if trial < 2
    disp('padding with zero on first trial');
    results_addvals = repmat(0, 1, length(addval_variables));
else
    last_trial = results_table(height(results_table),:);
    
    % pull out the relevant variables from the table
    addval_table = last_trial(:,ismember(last_trial.Properties.VariableNames, addval_variables));

    % convert to a vector of values
    results_addvals = table2array(addval_table);
    
    %multiply by 100 to get rid of decimals
    results_addvals = results_addvals*100;
end

