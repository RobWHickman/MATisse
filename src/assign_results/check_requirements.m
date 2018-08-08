function results = check_requirements(parameters, results)

if any(parameters.task_checks.table.Status & parameters.task_checks.table.Requirement)
    disp('TASK FAILURE:');
    disp(parameters.task_checks.table.Description(find(parameters.task_checks.table.Status & parameters.task_checks.table.Requirement)));
    
    %set the task_failure to 1
    results.single_trial.task_failure = true;
else
    results.single_trial.task_failure = false;
end